//
//  JMGitHubAPIClient.m
//  GitHub
//
//  Created by Jorge Maroto Garcia on 12/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMGitHubAPIClient.h"

#import <AFNetworking/AFJSONRequestOperation.h>

static NSString * const kAFGitHubAPIBaseURLString = @"https://api.github.com/";
@implementation JMGitHubAPIClient


+ (JMGitHubAPIClient *)sharedClient {
    static JMGitHubAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JMGitHubAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFGitHubAPIBaseURLString]];
    });
    
    return _sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (!self) return nil;
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
