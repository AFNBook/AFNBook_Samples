//
//  JMFollowingList.m
//  GitHub
//
//  Created by Jorge Maroto Garcia on 13/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMFollowingList.h"

#import "JMGitHubAPIClient.h"
#import "JMWebView.h"

#import <AFNetworking/UIImageView+AFNetworking.h>


static NSString * const kWebSegue = @"loadWeb";

@interface JMFollowingList()

    @property (nonatomic, retain) NSArray *following;

@end


@implementation JMFollowingList

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *path = [NSString stringWithFormat:@"users/%@/following", self.nickname];
    
    [[JMGitHubAPIClient sharedClient]
     getPath:path
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         self.following = responseObject;
         [self.tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"ERROR: %@", error.localizedDescription);
         
     }
     ];
}


#pragma mark - Table Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.following.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *followersDict = [self.following objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:followersDict[@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"icon.png"]];
    cell.textLabel.text = followersDict[@"login"];
    cell.detailTextLabel.text = followersDict[@"html_url"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:kWebSegue sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    JMWebView *webView = segue.destinationViewController;
    
    NSDictionary *followersDict = [self.following objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    webView.url = followersDict[@"html_url"];
}

@end