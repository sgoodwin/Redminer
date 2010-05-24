// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Issue.h instead.

#import <CoreData/CoreData.h>


@class Note;
@class Project;

@interface IssueID : NSManagedObjectID {}
@end

@interface _Issue : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (IssueID*)objectID;



@property (nonatomic, retain) NSString *tracker;

//- (BOOL)validateTracker:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *priority;

//- (BOOL)validatePriority:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *desc;

//- (BOOL)validateDesc:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *id;

@property short idValue;
- (short)idValue;
- (void)setIdValue:(short)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *category;

//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *subject;

//- (BOOL)validateSubject:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *assigned_to;

//- (BOOL)validateAssigned_to:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *updated;

@property BOOL updatedValue;
- (BOOL)updatedValue;
- (void)setUpdatedValue:(BOOL)value_;

//- (BOOL)validateUpdated:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *done_ratio;

@property short done_ratioValue;
- (short)done_ratioValue;
- (void)setDone_ratioValue:(short)value_;

//- (BOOL)validateDone_ratio:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* notes;
- (NSMutableSet*)notesSet;



@property (nonatomic, retain) Project* project;
//- (BOOL)validateProject:(id*)value_ error:(NSError**)error_;




+ (NSArray*)fetchUpdatedIssues:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchUpdatedIssues:(NSManagedObjectContext*)moc_ error:(NSError**)error_;



+ (NSArray*)fetchAllIssues:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchAllIssues:(NSManagedObjectContext*)moc_ error:(NSError**)error_;


@end

@interface _Issue (CoreDataGeneratedAccessors)

- (void)addNotes:(NSSet*)value_;
- (void)removeNotes:(NSSet*)value_;
- (void)addNotesObject:(Note*)value_;
- (void)removeNotesObject:(Note*)value_;

@end
