//
//  JMViewController.m
//  HelloWorld
//
//  Created by Jorge Maroto Garcia on 13/2/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface JMViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *urlField;
    @property (weak, nonatomic) IBOutlet UIWebView *webView;

    @property (strong, nonatomic) NSMutableData *data;
    @property (strong, nonatomic) NSOperationQueue *queue;
@end

@implementation JMViewController

NSString * const sampleURL = @"http://afnbook.herokuapp.com/date.php";
- (void)viewDidLoad{
    self.queue = [[NSOperationQueue alloc] init];
    self.urlField.text = sampleURL;
    [super viewDidLoad];
}


#pragma mark - Methods for request

- (IBAction)requestWithNSURLConnectionDelegate {
    NSURL *url = [NSURL URLWithString:self.urlField.text];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];

    [NSURLConnection connectionWithRequest:req delegate:self];
}

- (IBAction)requestWithNSURLConnectionBlock:(id)sender {
NSURL *url = [NSURL URLWithString:self.urlField.text];
NSURLRequest *req = [NSURLRequest requestWithURL:url];

[NSURLConnection sendAsynchronousRequest:req queue:self.queue
   completionHandler:^(NSURLResponse *response, NSData *data, NSError *errorConnection) {
       
       if (!errorConnection){
           NSString *responseString = [[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding];
           [self.webView loadHTMLString:responseString baseURL:nil];
       }else{
           NSString *errorString = errorConnection.localizedDescription;
           [self.webView loadHTMLString:errorString baseURL:nil];
       }
       
       [self.urlField resignFirstResponder];
       
   } // completionHandler
];
}


- (IBAction)requestWithAFN {
    NSURL *url = [NSURL URLWithString:self.urlField.text];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *stringResponse = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        [self.webView loadHTMLString:stringResponse baseURL:nil];
        
    }   // successBlock
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       [self.webView loadHTMLString:error.localizedDescription baseURL:nil];
        
    }
    ];
    
    [operation start];
    
    [self.urlField resignFirstResponder];
}


#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection
    didReceiveResponse:(NSURLResponse *)response{
    self.data = [NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.webView loadHTMLString:error.localizedDescription baseURL:nil];
    [self.urlField resignFirstResponder];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *responseString = [[NSString alloc] initWithData:self.data
                                                     encoding:NSUTF8StringEncoding];
    [self.webView loadHTMLString:responseString baseURL:nil];
    [self.urlField resignFirstResponder];
}
@end
