// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Project.h instead.

#import <CoreData/CoreData.h>


@class Issue;
@class Journal;

@interface ProjectID : NSManagedObjectID {}
@end

@interface _Project : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ProjectID*)objectID;



@property (nonatomic, retain) NSNumber *id;

@property short idValue;
- (short)idValue;
- (void)setIdValue:(short)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *desc;

//- (BOOL)validateDesc:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* issues;
- (NSMutableSet*)issuesSet;



@property (nonatomic, retain) NSSet* activity;
- (NSMutableSet*)activitySet;




+ (NSArray*)fetchAllProjects:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchAllProjects:(NSManagedObjectContext*)moc_ error:(NSError**)error_;


@end

@interface _Project (CoreDataGeneratedAccessors)

- (void)addIssues:(NSSet*)value_;
- (void)removeIssues:(NSSet*)value_;
- (void)addIssuesObject:(Issue*)value_;
- (void)removeIssuesObject:(Issue*)value_;

- (void)addActivity:(NSSet*)value_;
- (void)removeActivity:(NSSet*)value_;
- (void)addActivityObject:(Journal*)value_;
- (void)removeActivityObject:(Journal*)value_;

@end
