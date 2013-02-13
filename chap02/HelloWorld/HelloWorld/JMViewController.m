//
//  JMViewController.m
//  HelloWorld
//
//  Created by Jorge Maroto Garcia on 13/2/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMViewController.h"

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


- (IBAction)requestWithNSURLConnectionDelegate {
    assert(self.urlField.text.length > 3);
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlField.text]];
    NSURLConnection *con = [NSURLConnection connectionWithRequest:req delegate:self];
    assert(con != nil);
    
    [self.urlField resignFirstResponder];
}

- (IBAction)requestWithNSURLConnectionBlock:(id)sender {
    assert(self.urlField.text.length > 3);
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlField.text]];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *errorConnection) {
                               if (!errorConnection){
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   [self.webView loadHTMLString:responseString baseURL:nil];
                               }else{
                                   NSString *errorString = errorConnection.localizedDescription;
                                   [self.webView loadHTMLString:errorString baseURL:nil];
                               }
                               [self.urlField resignFirstResponder];
                           }];
}


- (IBAction)requestWithAFN {
    [self.urlField resignFirstResponder];
}


#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    
    NSLog(@"Status Code: %d", httpResponse.statusCode);
    
    if ((httpResponse.statusCode / 100) != 2) {
        [self.webView loadHTMLString:[NSString stringWithFormat:@"HTTP error %zd", (ssize_t) httpResponse.statusCode] baseURL:nil];
    } else {
        NSLog(@"Content-Type: %@", httpResponse.MIMEType);
        [self.webView loadHTMLString:@"Loading..." baseURL:nil];
    }
    
    self.data = [NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.webView loadHTMLString:error.localizedDescription baseURL:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *responseString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    [self.webView loadHTMLString:responseString baseURL:nil];
}
@end