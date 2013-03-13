//
//  JMRepoList.m
//  GitHub
//
//  Created by Jorge Maroto Garcia on 12/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMRepoList.h"

#import "JMGitHubAPIClient.h"
#import "JMWebView.h"

static NSString * const kWebSegue      = @"loadWeb";

@interface JMRepoList()

    @property (nonatomic, strong) NSArray *repos;

@end

@implementation JMRepoList

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *path = [NSString stringWithFormat:@"users/%@/repos", self.nickname];
    
    [[JMGitHubAPIClient sharedClient]
        getPath:path
        parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            self.repos = responseObject;
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"ERROR: %@", error.localizedDescription);
            
        }
     ];
}

#pragma mark - Table Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSDictionary *repoDict = [self.repos objectAtIndex:indexPath.row];
    
    cell.textLabel.text = repoDict[@"full_name"];
    cell.detailTextLabel.text = repoDict[@"description"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:kWebSegue sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    JMWebView *webView = segue.destinationViewController;
    
    NSDictionary *repoDict = [self.repos objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    webView.url = repoDict[@"html_url"];
}

@end
