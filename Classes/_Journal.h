// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Journal.h instead.

#import <CoreData/CoreData.h>



@interface JournalID : NSManagedObjectID {}
@end

@interface _Journal : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (JournalID*)objectID;



@property (nonatomic, retain) NSNumber *journalID;

@property short journalIDValue;
- (short)journalIDValue;
- (void)setJournalIDValue:(short)value_;

//- (BOOL)validateJournalID:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *id;

@property short idValue;
- (short)idValue;
- (void)setIdValue:(short)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *journalType;

//- (BOOL)validateJournalType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *user_id;

@property short user_idValue;
- (short)user_idValue;
- (void)setUser_idValue:(short)value_;

//- (BOOL)validateUser_id:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *notes;

//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





+ (NSArray*)fetchAllJournals:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchAllJournals:(NSManagedObjectContext*)moc_ error:(NSError**)error_;


@end

@interface _Journal (CoreDataGeneratedAccessors)

@end
