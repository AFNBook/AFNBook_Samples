//
//  JMViewController.m
//  InstAPI
//
//  Created by Jorge Maroto Garcia on 13/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMViewController.h"

#import "JMInstagramAPIClient.h"
#import "JMAppDelegate.h"
#import "JMListUser.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface JMViewController ()

    @property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
    @property (weak, nonatomic) IBOutlet UITableView *table;
    @property (nonatomic, strong) NSArray *following;

@end

@implementation JMViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"My Friends";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    JMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.token){
        self.tokenLabel.text = delegate.token;
        [self loadFriends:self];
    }
}

- (IBAction)loadFriends:(id)sender {
    JMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if (!delegate.token){
        [self performSegueWithIdentifier:@"askCredencials" sender:self];
    }else{
        [[JMInstagramAPIClient sharedClient]
         getPath:@"users/self/followed-by"
         parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             self.following = responseObject[@"data"];
             [self.table reloadData];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"%@", error);
             
         }];
    }
}


#pragma mark - Table Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.following.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictUser = [self.following objectAtIndex:indexPath.row];
    cell.textLabel.text = dictUser[@"username"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:dictUser[@"profile_picture"]] placeholderImage:[UIImage imageNamed:@"icon.png"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"mediaUser" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"mediaUser"]){
        NSDictionary *dictUser = [self.following objectAtIndex:self.table.indexPathForSelectedRow.row];
        JMListUser *listUser = segue.destinationViewController;
        listUser.title = dictUser[@"username"];
        listUser.idUser = dictUser[@"id"];
    }
}
@end