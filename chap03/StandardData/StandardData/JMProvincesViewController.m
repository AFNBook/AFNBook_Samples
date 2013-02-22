//
//  JMProvincesViewController.m
//  StandardData
//
//  Created by Jorge Maroto Garcia on 22/2/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMProvincesViewController.h"
#import "JMProvince.h"
#import "UIImageView+AFNetworking.h"

@interface JMProvincesViewController ()
    @property (weak, nonatomic) IBOutlet UITableView *tableProvinces;
@end

@implementation JMProvincesViewController

-(void)viewDidLoad{
    NSAssert(self.provinces, @"Needed array provinces");
    
    [super viewDidLoad];
}

#pragma mark - Table Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.provinces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    JMProvince *province = self.provinces[indexPath.row];
    cell.textLabel.text = province.name;
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:province.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    return cell;
}
@end