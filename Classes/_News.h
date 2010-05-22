// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to News.h instead.

#import <CoreData/CoreData.h>



@interface NewsID : NSManagedObjectID {}
@end

@interface _News : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NewsID*)objectID;





+ (NSArray*)fetchAllNews:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchAllNews:(NSManagedObjectContext*)moc_ error:(NSError**)error_;


@end

@interface _News (CoreDataGeneratedAccessors)

@end
