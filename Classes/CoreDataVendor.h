//
//  CoreDataVendor.h
//  LifeLoc
//
//  Created by Samuel Goodwin on 3/22/10.
//  Copyright 2010 ID345. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoreDataVendor : NSObject {
}

+ (NSManagedObjectContext *)newManagedObjectContext;
+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)applicationCachesDirectory;
+ (NSPersistentStoreCoordinator*)getPersistentStoreCoordinator;
+ (NSManagedObjectModel *)managedObjectModel;
+ (void)deletePersistentStores;
@end
