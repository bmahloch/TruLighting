//
//  AppRepository.h
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HueConfiguration;

@interface AppRepository : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSMutableArray *)getHueBridges;
- (void)getAllLightingUnits:(void(^)(NSMutableArray *))success failure:(void(^)(NSError *))failure;
- (void)getHueLightingUnitsForApiKey:(NSString *)apiKey success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure;

- (id)createEntity:(NSString *)entityName;

- (void)save:(void(^)(void))success failure:(void(^)(NSError *))failure;
- (BOOL)saveHueBridge:(NSDictionary *)bridge withApiKey:(NSString *)apiKey;

@end
