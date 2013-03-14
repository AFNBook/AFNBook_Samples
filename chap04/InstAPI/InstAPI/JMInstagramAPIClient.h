//
//  JMInstagramAPIClient.h
//  InstAPI
//
//  Created by Jorge Maroto Garcia on 14/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPClient.h>

@interface JMInstagramAPIClient : AFHTTPClient

+ (JMInstagramAPIClient *)sharedClient;

@end