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
#import "NSArrayAdditions.h"

@interface RedMineSupport(PrivateMethods)
- (NSArray*)arrayFromData:(NSData*)data;
@end

@implementation RedMineSupport
@synthesize key, host;

- (NSArray*)issues{
	// http://67.23.14.25/redmine/issues.json?key=7ded331bf46dbd35a351dbd4b861cbca09aa7cb0
	NSString *requestString = [NSString stringWithFormat:@"http://%@/issues.json?key=%@", self.host, self.key];
	NSLog(@"Requesting issues");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPShouldHandleCookies:YES];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return nil;
	}
	
	return [self arrayFromData:data];
}

- (NSArray*)news{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/news.json?key=%@", self.host, self.key];
	NSLog(@"Requesting news");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPShouldHandleCookies:YES];
	
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return nil;
	}
	
	return [self arrayFromData:data];
}

- (NSArray*)activity{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/activity.json?key=%@", self.host, self.key];
	NSLog(@"Requesting Activity");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	//[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPShouldHandleCookies:YES];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return nil;
	}
	return [self arrayFromData:data];
}


- (NSArray*)projects{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/projects.json?key=%@", self.host, self.key];
	NSLog(@"Requesting projects");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return nil;
	}
	
	return [self arrayFromData:data];
}

- (NSArray*)issuesInProject:(Project*)project{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/issues.json?key=%@&project_id=%@", self.host, self.key, project.id];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	NSLog(@"Requesting Issues in project %@", project);
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return nil;
	}
	
	return [self arrayFromData:data];
}

- (NSArray*)users{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/users.json?key=%@", self.host, self.key];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	NSLog(@"Requesting Users");
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return nil;
	}
	return [self arrayFromData:data];
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
				NSLog(@"Looking for class of key: %@", aKey);
				Class aClass = NSClassFromString([aKey capitalizedString]);
				if(!!aClass){
					id object = [aClass fromJSONDictionary:[value valueForKey:aKey]];
					return object;
				}else{
					User *object = [User fromJSONDictionary:value];
					return object;
				}
			}
			return nil;
		}];
	}else if(!!array && [array isKindOfClass:[NSDictionary class]]){
		for(NSString *aKey in [(NSDictionary*)array allKeys]){
			Class aClass = NSClassFromString([aKey capitalizedString]);
			if(!!aClass){
				value = [NSArray arrayWithObject:[aClass fromJSONDictionary:[value valueForKey:aKey]]];
			}
		}
	}else if(!array){
		NSLog(@"No array from: %@", string);
	}else{
		NSLog(@"Don't know what to do with: %@", array);
	}
	NSLog(@"Value: %@", value);
	return value;
}

@end
