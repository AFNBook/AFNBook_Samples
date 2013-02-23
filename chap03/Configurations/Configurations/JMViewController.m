//
//  JMViewController.m
//  Configurations
//
//  Created by Jorge Maroto Garcia on 23/2/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <EDColor/UIColor+Hex.h>

@interface JMViewController ()
    @property (weak, nonatomic) IBOutlet UITextView *textView;
    @property (weak, nonatomic) IBOutlet UIButton *buttonBlack;
    @property (weak, nonatomic) IBOutlet UIButton *buttonWhite;
@end

@implementation JMViewController

NSString * const blackURL = @"http://afnbook.herokuapp.com/theme_black.plist";
NSString * const whiteURL = @"http://afnbook.herokuapp.com/theme_white.plist";

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)blackTheme {
    [self loadThemeURL:blackURL];
}
- (IBAction)whiteTheme {
    [self loadThemeURL:whiteURL];
}

-(void)loadThemeURL:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFPropertyListRequestOperation *properties = [AFPropertyListRequestOperation
                  propertyListRequestOperationWithRequest:request
                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id propertyList) {
                      
                      [self updateViewWithTheme:(NSDictionary *)propertyList];
                      
                  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id propertyList) {
                      
                         NSLog(@"ERROR: %@\n%@", error.localizedDescription, propertyList);
                      
                 }];
    
    [properties start];
}

-(void)updateViewWithTheme:(NSDictionary *)config{
    // Background
    self.view.backgroundColor = [UIColor colorWithHexString:config[@"background"][@"color"]];
    
    // Buttons
    UIColor *buttonBC = [UIColor colorWithHexString:config[@"buttons"][@"background_color"]];
    NSString *buttonFontFamily = config[@"buttons"][@"font"][@"family"];
    UIColor *buttonFontColor =  [UIColor colorWithHexString:config[@"buttons"][@"font"][@"color"]];
    CGFloat buttonFontSize = ((NSNumber *)config[@"buttons"][@"font"][@"size"]).floatValue;
    
    self.buttonBlack.backgroundColor = buttonBC;
    self.buttonBlack.titleLabel.font = [UIFont fontWithName:buttonFontFamily size:buttonFontSize];
    self.buttonBlack.titleLabel.textColor = buttonFontColor;
    
    self.buttonWhite.backgroundColor = buttonBC;
    self.buttonWhite.titleLabel.font = [UIFont fontWithName:buttonFontFamily size:buttonFontSize];
    self.buttonWhite.titleLabel.textColor = buttonFontColor;
    
    // TextView
    NSString *textFontFamily = config[@"textview"][@"font"][@"family"];
    CGFloat textFontSize = ((NSNumber *)config[@"textview"][@"font"][@"size"]).floatValue;
    UIColor *textColor = [UIColor colorWithHexString:config[@"textview"][@"font"][@"color"]];
    
    self.textView.textColor = textColor;
    self.textView.font = [UIFont fontWithName:textFontFamily size:textFontSize];
}
@end
