#import "_Note.h"

@interface Note : _Note {}
// Custom logic goes here.

+ (void)checkNote:(Note*)n ForDups:(NSManagedObjectContext*)moc_;
- (NSString*)htmlString;
@end
