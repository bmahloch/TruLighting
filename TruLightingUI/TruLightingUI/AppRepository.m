//
//  AppRepository.m
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "AppRepository.h"
#import "LightingUnit.h"
#import "HueLightingUnit.h"

@interface AppRepository ()

- (NSString *)documentsDirectory;
- (NSURL *)applicationDocumentsDirectory;

@end

@implementation AppRepository

#pragma mark - Properties

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Public Methods

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
        return _managedObjectModel;

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSMutableArray *)getHueBridges
{
    NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:DATA_FILE_HUE_CONFIGURATION];

    if([[NSFileManager defaultManager] fileExistsAtPath:path])
        return [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    return [[NSMutableArray alloc] init];
}

- (void)getAllLightingUnits:(void(^)(NSMutableArray *))success failure:(void(^)(NSError *))failure
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:ENTITY_LIGHTING_UNIT];
    NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:DATA_KEY_LIGHTING_UNIT_NAME ascending:YES];
    
    [fetch setSortDescriptors:@[sortName]];
    
    NSError *error = nil;
    NSMutableArray *result = [[self.managedObjectContext executeFetchRequest:fetch error:&error] mutableCopy];
    
    if(error)
        failure(error);
    else
        success(result);
}

- (void)getHueLightingUnitsForApiKey:(NSString *)apiKey success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure;
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:ENTITY_HUE_LIGHTING_UNIT];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", DATA_KEY_HUE_API_KEY, apiKey];
    
    fetch.predicate = predicate;
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if(error)
        failure(error);
    else
        success(result);
}

- (id)createEntity:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

- (void)save:(void(^)(void))success failure:(void (^)(NSError *))failure
{
    NSError *error = nil;
    
    [self.managedObjectContext save:&error];
    
    if(error)
        failure(error);
    else
        success();
}

- (BOOL)saveHueBridge:(NSDictionary *)bridge withApiKey:(NSString *)apiKey
{
    [bridge setValue:apiKey forKey:DATA_KEY_HUE_API_KEY];
    
    NSMutableArray *existingBridges = [[AppContext sharedContext].repository getHueBridges];
    NSInteger index = -1;
    
    for(int i = 0; i < existingBridges.count; i++)
    {
        NSDictionary *existingBridge = [existingBridges objectAtIndex:i];
        
        if([[existingBridge valueForKey:DATA_KEY_HUE_API_KEY] isEqualToString:apiKey])
            index = i;
    }
    
    if(index >= 0)
        [existingBridges replaceObjectAtIndex:index withObject:bridge];
    else
        [existingBridges addObject:bridge];
    
    NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:DATA_FILE_HUE_CONFIGURATION];
    
    return [existingBridges writeToFile:path atomically:YES];
}

#pragma mark - Private Methods

- (NSString *)documentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
