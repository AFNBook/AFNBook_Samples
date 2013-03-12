//
//  JMViewController.m
//  GitHub
//
//  Created by Jorge Maroto Garcia on 12/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMViewController.h"

#import "JMGitHubAPIClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface JMViewController ()

    @property (weak, nonatomic) IBOutlet UITextField *nickname;
    @property (weak, nonatomic) IBOutlet UIImageView *avatar;
    @property (weak, nonatomic) IBOutlet UILabel *name;
    @property (weak, nonatomic) IBOutlet UILabel *company;
    @property (weak, nonatomic) IBOutlet UILabel *location;
    @property (weak, nonatomic) IBOutlet UIButton *reposButton;
    @property (weak, nonatomic) IBOutlet UIButton *followersButton;
    @property (weak, nonatomic) IBOutlet UIButton *followingButton;

@end

@implementation JMViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)loadUser {
    NSString *urlWithUser = [NSString stringWithFormat:@"users/%@", self.nickname.text];
    [[JMGitHubAPIClient sharedClient]
         getPath:urlWithUser
         parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self loadInfo:responseObject];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         }
    ];
}


- (IBAction)loadRepos {
}
- (IBAction)loadFollowers {
}
- (IBAction)loadFollowing {
}

-(void)loadInfo:(NSDictionary *)responseDict{
    [self.avatar setImageWithURL:[NSURL URLWithString:responseDict[@"avatar_url"]]];
    self.name.text = responseDict[@"name"];
    self.company.text = responseDict[@"company"];
    self.location.text = responseDict[@"location"];
    
    NSString *repoStr = [NSString stringWithFormat:@"%@", responseDict[@"public_repos"]];
    NSString *followingStr = [NSString stringWithFormat:@"%@", responseDict[@"following"]];
    NSString *followersStr = [NSString stringWithFormat:@"%@", responseDict[@"followers"]];
    
    [self.reposButton setTitle:repoStr forState:UIControlStateNormal];
    [self.followingButton setTitle:followingStr forState:UIControlStateNormal];
    [self.followersButton setTitle:followersStr forState:UIControlStateNormal];
}

@end
