// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.h instead.

#import <CoreData/CoreData.h>


@class Issue;

@interface NoteID : NSManagedObjectID {}
@end

@interface _Note : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NoteID*)objectID;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *id;

@property short idValue;
- (short)idValue;
- (void)setIdValue:(short)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *updated;

@property BOOL updatedValue;
- (BOOL)updatedValue;
- (void)setUpdatedValue:(BOOL)value_;

//- (BOOL)validateUpdated:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *notes;

//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Issue* issue;
//- (BOOL)validateIssue:(id*)value_ error:(NSError**)error_;



@end

@interface _Note (CoreDataGeneratedAccessors)

@end
