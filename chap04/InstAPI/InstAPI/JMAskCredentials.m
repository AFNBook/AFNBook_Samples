//
//  JMAskCredentials.m
//  InstAPI
//
//  Created by Jorge Maroto Garcia on 14/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMAskCredentials.h"
#import "JMAppDelegate.h"

NSString * const kClientID = @"f68621ad1bd44bbf90818fe6851644cb";
NSString * const kCallbackURL = @"tactilapp.com";

@interface JMAskCredentials()

    @property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation JMAskCredentials
-(void)viewDidLoad{
    
    NSString *oauthURL = @"https://api.instagram.com/oauth/authorize";
    
    NSString *authURL = [NSString stringWithFormat:@"%@/?client_id=%@&redirect_uri=http://%@&response_type=token", oauthURL, kClientID, kCallbackURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:authURL]];
    
    [self.web loadRequest:req];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
        
    if ([request.URL.host isEqualToString:kCallbackURL]
        && request.URL.fragment){
        NSString *anchor = request.URL.fragment;
        NSRange range = [anchor rangeOfString:@"access_token="];
        
        if (range.length != 0){
        
            NSString *token = [anchor substringFromIndex:range.location + range.length];
            JMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            delegate.token = token;
            [self close:self];
            
            return NO;
            
        }
        
    }
    
    return YES;
}



- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
