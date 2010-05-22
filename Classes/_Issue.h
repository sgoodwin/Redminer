// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Issue.h instead.

#import <CoreData/CoreData.h>


@class Project;

@interface IssueID : NSManagedObjectID {}
@end

@interface _Issue : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (IssueID*)objectID;



@property (nonatomic, retain) NSString *subject;

//- (BOOL)validateSubject:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *id;

@property short idValue;
- (short)idValue;
- (void)setIdValue:(short)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *assigned_to_id;

@property short assigned_to_idValue;
- (short)assigned_to_idValue;
- (void)setAssigned_to_idValue:(short)value_;

//- (BOOL)validateAssigned_to_id:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *desc;

//- (BOOL)validateDesc:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *done_ratio;

@property short done_ratioValue;
- (short)done_ratioValue;
- (void)setDone_ratioValue:(short)value_;

//- (BOOL)validateDone_ratio:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Project* project;
//- (BOOL)validateProject:(id*)value_ error:(NSError**)error_;




+ (NSArray*)fetchAllIssues:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchAllIssues:(NSManagedObjectContext*)moc_ error:(NSError**)error_;


@end

@interface _Issue (CoreDataGeneratedAccessors)

@end
