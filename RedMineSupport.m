//
//  RedMineSupport.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "RedMineSupport.h"
#import "Project.h"
#import "JSON.h"

@interface RedMineSupport(PrivateMethods)
- (NSArray*)arrayFromData:(NSData*)data;
@end

@implementation RedMineSupport
@synthesize key, host;

- (NSArray*)issues{
	// http://67.23.14.25/redmine/issues.json?key=7ded331bf46dbd35a351dbd4b861cbca09aa7cb0
	NSString *requestString = [NSString stringWithFormat:@"http://%@/issues.json?key=%@", self.host, self.key];
	NSLog(@"Request issues: %@", requestString);
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
	NSLog(@"Request news: %@", requestString);
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
	NSLog(@"Request activity: %@", requestString);
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
	NSLog(@"Request projects: %@", requestString);
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
	NSArray *array = [string JSONValue];
	if(!!array){
		NSLog(@"JSON results: %@", array);
	}else{
		NSLog(@"Raw string response: %@", string);
	}
	return array;
}

@end
