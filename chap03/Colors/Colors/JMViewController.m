//
//  JMViewController.m
//  Colors
//
//  Created by Jorge Maroto Garcia on 24/2/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <EDColor/UIColor+Hex.h>

@interface JMViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableColors;
@property (strong, nonatomic) NSArray *colors;
@end

@implementation JMViewController
NSString * const colorsURL = @"http://afnbook.herokuapp.com/colors.json";

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:colorsURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.colors = ((NSDictionary *)JSON)[@"colorsArray"];
        [self.tableColors reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", error.localizedDescription);
    }];
    [operation start];
}

#pragma mark - Table Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.colors[indexPath.row][@"colorName"];
    cell.textLabel.textColor = [UIColor colorWithHexString:self.colors[indexPath.row][@"hexValue"]];
    return cell;
}
@end