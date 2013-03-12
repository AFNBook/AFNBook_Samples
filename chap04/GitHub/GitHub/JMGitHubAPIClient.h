//
//  JMGitHubAPIClient.h
//  GitHub
//
//  Created by Jorge Maroto Garcia on 12/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFHTTPClient.h>

@interface JMGitHubAPIClient : AFHTTPClient

+ (JMGitHubAPIClient *)sharedClient;

@end
