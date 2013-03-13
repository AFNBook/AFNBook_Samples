//
//  JMWebView.m
//  GitHub
//
//  Created by Jorge Maroto Garcia on 13/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMWebView.h"

@interface JMWebView()
    @property (weak, nonatomic) IBOutlet UIWebView *webview;
@end

@implementation JMWebView

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
@end
