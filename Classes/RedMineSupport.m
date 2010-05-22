//
//  RedMineSupport.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "RedMineSupport.h"
#import "Project.h"
#import "User.h"
#import "JSON.h"
#import "News.h"
#import "Journal.h"
#import "Issue.h"
#import "NSArrayAdditions.h"
#import "CoreDataVendor.h"

@interface RedMineSupport(PrivateMethods)
- (void)getIssues;
- (void)getProjects;
- (void)getNews;
- (void)getActivity;
- (void)getUsers;

- (NSArray*)arrayFromData:(NSData*)data;
@end

@implementation RedMineSupport
@synthesize key = _key;
@synthesize host = _host;
@synthesize moc = _moc;

- (void)refresh{
	[self getProjects];
	
	NSError *err = nil;
	[[self moc] save:&err];
	if(!!err){
		NSLog(@"Failed to save managed object context in redmine support: %@, %@, %@", [err localizedDescription], [err localizedRecoveryOptions], [err localizedFailureReason]);
	}
}

- (NSArray*)issues{
	return [Issue fetchAllIssues:[self moc]];
}

- (NSArray*)projects{
	return [Project fetchAllProjects:[self moc]];
}

- (NSArray*)news{
	return [News fetchAllNews:[self moc]];
}

- (NSArray*)activity{
	return [Journal fetchAllJournals:[self moc]];
}

- (NSArray*)issuesInProject:(Project*)project{
	return [[project issues] allObjects];
}

- (NSArray*)users{
	return [User fetchAllUsers:[self moc]];
}

- (void)getIssues{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/issues.json?key=%@", self.host, self.key];
	//NSLog(@"Requesting issues");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPShouldHandleCookies:YES];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	[self arrayFromData:data];
	return;
}

- (void)getNews{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/news.json?key=%@", self.host, self.key];
	//NSLog(@"Requesting news");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPShouldHandleCookies:YES];
	
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	[self arrayFromData:data];
	return;
}

- (void)getActivityForProject:(Project*)project{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/projects/%@/activity.json?key=%@", self.host, project.id, self.key];
	//NSLog(@"Requesting Activity %@", requestString);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	//[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPShouldHandleCookies:YES];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	NSArray *results = [self arrayFromData:data];
	for(id object in results){
		if([object isKindOfClass:[Issue class]]){
			[project addIssuesObject:object];
			NSLog(@"added issue");
		}
		if([object isKindOfClass:[Journal class]]){
			[project addActivityObject:object];
			NSLog(@"added activity");
		}
	}
	return;
}


- (void)getProjects{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/projects.json?key=%@", self.host, self.key];
	//NSLog(@"Requesting projects");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	[self arrayFromData:data];
	return;
}

- (NSManagedObjectContext*)moc{
	if(!_moc)
		_moc = [CoreDataVendor newManagedObjectContext];
	return _moc;
}

- (void)getIssuesInProject:(Project*)project{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/issues.json?key=%@&project_id=%@", self.host, self.key, project.id];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	//NSLog(@"Requesting Issues in project %@", project);
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	NSArray *issues = [self arrayFromData:data];
	[project setIssues:[NSSet setWithArray:issues]];
	return;
}

- (void)getUsers{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/users.json?key=%@", self.host, self.key];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	//NSLog(@"Requesting Users");
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	[self arrayFromData:data];
	return;
}

#pragma mark -
#pragma mark Instance method creation;
- (NSArray*)arrayFromData:(NSData*)data{
	NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	id array = [string JSONValue];
	NSArray *value = nil;
	if(!!array && [array isKindOfClass:[NSArray class]]){
		value = [(NSArray*)array collectWithBlock:^(NSDictionary *value){
			for(NSString *aKey in [value allKeys]){
				//NSLog(@"Looking for class of key: %@", aKey);
				Class aClass = NSClassFromString([aKey capitalizedString]);
				if(!!aClass){
					id object = [aClass fromJSONDictionary:[value valueForKey:aKey] toManagedObjectContext:[self moc] fromSupport:self];
					return object;
				}else{
					User *object = [User fromJSONDictionary:value toManagedObjectContext:[self moc] fromSupport:self];
					return object;
				}
			}
			return nil;
		}];
	}else if(!!array && [array isKindOfClass:[NSDictionary class]]){
		for(NSString *aKey in [(NSDictionary*)array allKeys]){
			Class aClass = NSClassFromString([aKey capitalizedString]);
			if(!!aClass){
				value = [NSArray arrayWithObject:[aClass fromJSONDictionary:[value valueForKey:aKey] toManagedObjectContext:[self moc] fromSupport:self]];
			}
		}
	}else if(!array){
		NSLog(@"No array from: %@", string);
	}else{
		NSLog(@"Don't know what to do with: %@", array);
	}
	
	//NSLog(@"Saving my changes %@", [[self moc] insertedObjects])
	return value;
}
@end
