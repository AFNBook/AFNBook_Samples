//
//  JMViewController.h
//  ASIHTTPtoAFN
//
//  Created by Jorge Maroto Garcia on 22/4/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation+ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"

@interface JMViewController : UIViewController<ASIHTTPRequestDelegate>

@end