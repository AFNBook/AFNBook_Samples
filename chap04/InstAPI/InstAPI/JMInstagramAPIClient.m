//
//  JMInstagramAPIClient.m
//  InstAPI
//
//  Created by Jorge Maroto Garcia on 14/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMInstagramAPIClient.h"
#import "JMAppDelegate.h"

#import <AFNetworking/AFJSONRequestOperation.h>


@implementation JMInstagramAPIClient

NSString * const kAPIURL = @"https://api.instagram.com/v1/";

+ (JMInstagramAPIClient *)sharedClient {
    static JMInstagramAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JMInstagramAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIURL]];
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


-(void)getPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    JMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (delegate.token)
        [param setValue:delegate.token forKey:@"access_token"];
    
    [super getPath:path parameters:param success:success failure:failure];
}
@end
