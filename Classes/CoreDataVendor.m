//
//  CoreDataVendor.m
//  LifeLoc
//
//  Created by Samuel Goodwin on 3/22/10.
//  Copyright 2010 ID345. All rights reserved.
//

#import "CoreDataVendor.h"


static NSManagedObjectModel *managedObjectModel = nil;

@implementation CoreDataVendor

+ (NSPersistentStoreCoordinator*)getPersistentStoreCoordinator{
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Redminer.sqlite"]];
	//NSLog(@"Store URL: %@", storeUrl);
	
	NSError *error = nil;
	NSPersistentStoreCoordinator*  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	return [persistentStoreCoordinator autorelease];
}

/**
 Returns the path to the application's Documents directory.
 */
+ (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)applicationCachesDirectory{
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
+ (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

+ (NSManagedObjectContext *)newManagedObjectContext{
	NSManagedObjectContext *managedObjectContext = nil;
	NSPersistentStoreCoordinator *coordinator = [self getPersistentStoreCoordinator];
    if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	return managedObjectContext;
}

+ (void)deletePersistentStores{
	NSError *error = nil;
	NSPersistentStoreCoordinator *persistentStoreCoordinator = [self getPersistentStoreCoordinator];
	for(NSPersistentStore *store in [persistentStoreCoordinator persistentStores]){
		error = nil;
		NSURL *storeURL = store.URL;
		if([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]){
			NSLog(@"Removing store at URL: %@", storeURL);
			[persistentStoreCoordinator removePersistentStore:store error:&error];
			if(error){
				NSLog(@"Error removing store: %@, %@, %@", store, [error localizedDescription], [error localizedFailureReason]); 
			}
			error = nil;
			BOOL result = [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
			if(!result){
				NSLog(@"Error deleting %@, %@, %@", storeURL.path, [error localizedDescription], [error localizedRecoveryOptions]);
			}
		}
	}
}
@end
