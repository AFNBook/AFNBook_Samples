//
//  JMListUser.m
//  InstAPI
//
//  Created by Jorge Maroto Garcia on 14/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMListUser.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "JMInstagramAPIClient.h"
#import "JMPhoto.h"

@interface JMListUser()

    @property (nonatomic, strong) NSArray *photos;
    @property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation JMListUser

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *path = [NSString stringWithFormat:@"users/%@/media/recent", self.idUser];
    [[JMInstagramAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.photos = responseObject[@"data"];
        [self.table reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

#pragma mark - Table Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *photoDict = [self.photos objectAtIndex:indexPath.row];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:photoDict[@"images"][@"thumbnail"][@"url"]] placeholderImage:[UIImage imageNamed:@"icon.png"]];

    if ([photoDict[@"filter"] isKindOfClass:[NSNull class]])
        cell.textLabel.text = @"No filter";
    else
        cell.textLabel.text = photoDict[@"filter"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"photo" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSDictionary *photoDict = [self.photos objectAtIndex:self.table.indexPathForSelectedRow.row];
    JMPhoto *photo = segue.destinationViewController;

    if ([photoDict[@"filter"] isKindOfClass:[NSNull class]])
        photo.title = @"No filter";
    else
        photo.title = photoDict[@"filter"];

    photo.url = photoDict[@"link"];
}

@end