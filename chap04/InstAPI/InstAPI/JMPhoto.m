//
//  JMPhoto.m
//  InstAPI
//
//  Created by Jorge Maroto Garcia on 14/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMPhoto.h"

@interface JMPhoto()

    @property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation JMPhoto

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

@end