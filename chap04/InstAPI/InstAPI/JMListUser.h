//
//  JMListUser.h
//  InstAPI
//
//  Created by Jorge Maroto Garcia on 14/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMListUser : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *idUser;

@end