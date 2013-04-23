//
//  JMViewController.m
//  ASIHTTPtoAFN
//
//  Created by Jorge Maroto Garcia on 22/4/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMViewController.h"

@interface JMViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *urlField;
    @property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation JMViewController

- (IBAction)loadURL:(id)sender {
    NSURL *url = [NSURL URLWithString:self.urlField.text];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString *responseString = request.responseString;
    // if you are managing binary data, you need to use
    // responseString = request.responseData;
    [self.webView loadHTMLString:responseString baseURL:nil];
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"ERROR: %@", request.error.localizedDescription);
}
@end