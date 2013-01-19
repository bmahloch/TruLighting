//
//  ServiceManager.m
//  SimpleSheets
//
//  Created by Brian Mahloch on 9/17/12.
//  Copyright (c) 2012 Skyline Technologies. All rights reserved.
//
#import <CommonCrypto/CommonHMAC.h>
#import "ServiceManager.h"
#import "NSData+Extensions.h"
#import "TIHueLightingUnit.h"

@interface ServiceManager()

- (NSMutableURLRequest *)getRequestForUrl:(NSString *)url method:(NSString *)method contentType:(NSString *)contentType username:(NSString *)username password:(NSString *)password;
- (void)executeRequest:(NSMutableURLRequest *)request success:(void(^)(id))successBlock failure:(void(^)(NSInteger, NSMutableArray *))failureBlock;
- (BOOL)deserializeData:(NSData *)data intoResult:(id *)result;
- (BOOL)serializeEntity:(id)entity intoData:(NSData **)data;

@end

static ServiceManager *_defaultManager;

@implementation ServiceManager

#pragma mark - Public Methods

+ (ServiceManager *)defaultManager
{
    if(_defaultManager == nil)
        _defaultManager = [[ServiceManager alloc] init];
    
    return _defaultManager;
}

- (void)setLightingUnit:(TIHueLightingUnit *)unit withState:(NSMutableDictionary *)state
{
    NSString *url = [NSString stringWithFormat:@"http://%@/api/%@/lights/%d/state", unit.ipAddress, unit.apiKey, unit.lightId];
    NSMutableURLRequest *request = [self getRequestForUrl:url method:kHttpMethodPut contentType:kContentTypeJson username:nil password:nil];
    NSData *data = nil;
    
    if(![self serializeEntity:state intoData:&data])
    {
        LogError(@"State dictionary is invalid, cannot be serialized");
    }
    else
    {
        [request setHTTPBody:data];
    
        [self executeRequest:request success:^(NSDictionary *result){
            
            LogInfo(@"Successful state update: %@", result);
            
        }failure:^(NSInteger status, NSMutableArray *errors) {
            
            LogError(@"State update failed: %d - %@", status, errors);
            
        }];
    }
}

- (void)connectToHueHost:(NSString *)ip authorization:(NSDictionary *)authorization completionBlock:(void(^)(bool, NSMutableArray *))completion;
{
    NSString *url = [NSString stringWithFormat:@"http://%@/api", ip];
    NSMutableURLRequest *request = [self getRequestForUrl:url method:kHttpMethodPost contentType:kContentTypeJson username:nil password:nil];
    NSData *data = nil;
    
    if(![self serializeEntity:authorization intoData:&data])
    {
        LogError(@"Authorization dictionary is invalid, cannot be serialized");
    }
    else
    {
        [request setHTTPBody:data];
        
        [self executeRequest:request success:^(NSMutableArray *result) {
           
            bool success = YES;
            NSMutableArray *messages = [NSMutableArray array];
            
            for(NSDictionary *item in result)
            {
                for(NSString *key in [item allKeys])
                {
                    if([key isEqualToString:@"error"])
                        success = NO;
                    
                    [messages addObject:[[item valueForKey:key] valueForKey:@"description"]];
                }
            }
            
            completion(success, messages);
            
        }failure:^(NSInteger status, NSMutableArray *errors) {
            
            completion(NO, errors);
            
        }];
    }
}

- (void)getStatusOfHueHost:(NSString *)ip apiKey:(NSString *)apiKey success:(void(^)(NSDictionary *))success failure:(void(^)(NSMutableArray *))failure
{
    NSString *url = [NSString stringWithFormat:@"http://%@/api/%@", ip, apiKey];
    NSMutableURLRequest *request = [self getRequestForUrl:url method:kHttpMethodGet contentType:kContentTypeJson username:nil password:nil];
    
    [self executeRequest:request success:success failure:^(NSInteger status, NSMutableArray *errors){
        
        LogError(@"Hue status request failed: %d - %@", status, errors);
        
        failure(errors);
        
    }];
}

#pragma mark - Private Methods

- (NSMutableURLRequest *)getRequestForUrl:(NSString *)url method:(NSString *)method contentType:(NSString *)contentType username:(NSString *)username password:(NSString *)password
{
    NSURL *address = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:address cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    [request setHTTPMethod:method];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:contentType forHTTPHeaderField:@"Accept"];
    
    if(username && password)
        [request setValue:[self getHMAC:username password:password] forHTTPHeaderField:@"Authorization"];
    
    return request;
}

- (void)executeRequest:(NSMutableURLRequest *)request success:(void(^)(id))successBlock failure:(void(^)(NSInteger statusCode, NSMutableArray *errors))failureBlock
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger httpStatus = [httpResponse statusCode];
        id result = nil;
        
        if(error)
        {
            LogError(@"Http request error: %@", [error localizedDescription]);
            
            if([error code] == NSURLErrorUserCancelledAuthentication)  // authentication failed
            {
                if(![self deserializeData:data intoResult:&result])
                    result = [[NSMutableArray alloc] initWithObjects:kAuthorizationError, nil];
            }
            else
                result = [[NSMutableArray alloc] initWithObjects:kCommunicationError, nil];
            
            dispatch_async(kMainQueue, ^(){
                failureBlock(kHttpStatusCodeAuthentication, result);
            });
        }
        else 
        {
            LogInfo(@"%d - %@", httpStatus, [NSHTTPURLResponse localizedStringForStatusCode:httpStatus]);
            
            if(![self deserializeData:data intoResult:&result])
            {
                dispatch_async(kMainQueue, ^(){
                    failureBlock(httpStatus, [[NSMutableArray alloc] initWithObjects:kParsingResponseError, nil]);
                });
            }
            else
            {
                switch(httpStatus)
                {
                    case kHttpStatusCodeOK:
                    {
                        dispatch_async(kMainQueue, ^(){
                            successBlock(result); 
                        });
                        
                        break;
                    }
                    default:
                    {
                        dispatch_async(kMainQueue, ^(){
                            failureBlock(httpStatus, result);
                        });
                        
                        break;
                    }
                }
            }
        }
    }]; 
}

- (NSString *)getHMAC:(NSString *)username password:(NSString *)password
{
    static NSDateFormatter *formatter;
    
    if (formatter == nil) 
    {
        formatter = [[NSDateFormatter alloc] init];
        
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [formatter setDateFormat:@"MM/dd/yyyy HH-mm"];
    }
    
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    NSData *key = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [[NSString stringWithFormat:@"%@:%@", username, timestamp] dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, [key bytes], [key length], [data bytes], [data length], cHMAC);
    
    NSString *hash = [[NSData dataWithBytes:cHMAC length:sizeof(cHMAC)] base64Encoding];
    NSData *token = [[NSString stringWithFormat:@"%@:%@:%@", username, timestamp, hash] dataUsingEncoding:NSUTF8StringEncoding];
    
    return [token base64Encoding];
}

- (NSString *)cacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (void)scrubNulls:(id)obj
{
    if([obj isKindOfClass:[NSArray class]])
    {
        for(NSMutableDictionary *childDict in (NSArray *)obj)
            [self scrubNulls:childDict];
    }
    else 
    {
        if([obj isKindOfClass:[NSDictionary class]])
        {
            for(NSString *key in [obj allKeys])
            {
                id value = [obj objectForKey:key];
                
                if([value isKindOfClass:[NSMutableDictionary class]] || [value isKindOfClass:[NSArray class]])
                    [self scrubNulls:value];
                
                if ([value isKindOfClass:[NSNull class]])
                    [obj removeObjectForKey:key];
            }
        }
    }
    
}

- (BOOL)deserializeData:(NSData *)data intoResult:(id *)result
{
    NSError *jsonError = nil;
    
    if(data.length > 0)
    {
        *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:&jsonError];
        
        if(jsonError)
        {
            LogError(@"json parsing error: %@", [jsonError localizedDescription]);
            
            return NO;
        }
        else
            [self scrubNulls:*result];
    }
    
    return YES;
}

- (BOOL)serializeEntity:(id)entity intoData:(NSData **)data;
{
    NSError *jsonError = nil;
    *data = [NSJSONSerialization dataWithJSONObject:entity options:0 error:&jsonError];
    
    if(jsonError)
    {
        LogError(@"POST Error: %@", [jsonError localizedDescription]);
        return NO;
    }
    
    return YES;
}

@end
