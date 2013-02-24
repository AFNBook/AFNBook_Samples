//
//  JMViewController.m
//  StandardData
//
//  Created by Jorge Maroto Garcia on 21/2/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMCommunitiesViewController.h"
#import "AFNetworking.h"

#import "JMComunity.h"
#import "JMProvince.h"

#import "JMProvincesViewController.h"

@interface JMCommunitiesViewController ()   
    @property (weak, nonatomic) IBOutlet UITableView *tableComunities;

    @property (nonatomic, strong) NSMutableArray *comunities;
    @property (nonatomic, strong) JMComunity *tmpComunity;
    @property (nonatomic, strong) JMProvince *tmpProvince;
    @property (nonatomic, strong) NSMutableString *tmpContent;
@end

@implementation JMCommunitiesViewController

NSString * const sampleXML = @"http://afnbook.herokuapp.com/provincias.xml";

- (void)viewDidLoad{
    self.comunities = [NSMutableArray array];
    
    [super viewDidLoad];
}

- (IBAction)readXML {
    NSURL *url = [NSURL URLWithString:sampleXML];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation
                                        XMLParserRequestOperationWithRequest:request
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                                            XMLParser.delegate = self;
                                            [XMLParser parse];
                                        } failure:nil];
    [operation start];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    self.comunities = [NSMutableArray array];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.tableComunities reloadData];
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    self.tmpContent = [NSMutableString string];
    
    if ([elementName isEqualToString:@"comunidad"]){
        self.tmpComunity = [[JMComunity alloc] init];
        self.tmpComunity.name = attributeDict[@"name"];
    }else if ([elementName isEqualToString:@"provincia"]){
        self.tmpProvince = [[JMProvince alloc] init];        
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.tmpContent appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"comunidad"]){
        
        [self.comunities addObject:self.tmpComunity];
        
    }else if ([elementName isEqualToString:@"image_comunidad"]){
        
        self.tmpComunity.image = self.tmpContent;
        
    }else if ([elementName isEqualToString:@"provincia"]){
        
        [self.tmpComunity.provinces addObject:self.tmpProvince];

    }else if ([elementName isEqualToString:@"name"]){
    
        self.tmpProvince.name = self.tmpContent;
        
    }else if ([elementName isEqualToString:@"image"]){
        
        self.tmpProvince.image = self.tmpContent;
        
    }

}



#pragma mark - Table Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comunities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    JMComunity *comunity = self.comunities[indexPath.row];
    cell.textLabel.text = comunity.name;

    [cell.imageView setImageWithURL:[NSURL URLWithString:comunity.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showProvinces" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showProvinces"]){
        JMProvincesViewController *provincesVC = (JMProvincesViewController *)segue.destinationViewController;
        NSInteger rowSelected = self.tableComunities.indexPathForSelectedRow.row;
        JMComunity *comunitySelected = self.comunities[rowSelected];
        
        provincesVC.title = comunitySelected.name;
        provincesVC.provinces = comunitySelected.provinces;
    }
}

@end