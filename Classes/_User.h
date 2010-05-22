// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>



@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;



@property (nonatomic, retain) NSNumber *id;

@property short idValue;
- (short)idValue;
- (void)setIdValue:(short)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





+ (NSArray*)fetchAllUsers:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchAllUsers:(NSManagedObjectContext*)moc_ error:(NSError**)error_;


@end

@interface _User (CoreDataGeneratedAccessors)

@end
