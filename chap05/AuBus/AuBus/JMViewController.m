//
//  JMViewController.m
//  AuBus
//
//  Created by Jorge Maroto Garcia on 27/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <ElementParser/ElementParser.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MKMapView+ZoomLevel.h>

#import "NSString+AFNetworking.h"
#import "JMAnnotation.h"
#import "JMArrival.h"

#define uBUS @"http://www.auvasa.es/parada.asp"

@interface JMViewController (){
    int lineNumber;
}

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@property (nonatomic,strong) NSMutableArray *arrivals;
@end

@implementation JMViewController
- (IBAction)valueChanged:(UIStepper *)sender {
    [self loadBusLine:(int)sender.value];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self loadBusLine:(int)self.stepper.value];
}

-(void)loadBusLine:(int)line{
    lineNumber = line;
    
    NSString *urlLine = [NSString stringWithFormat:@"%@?codigo=%i",uBUS, lineNumber];
    
    NSURL *url = [NSURL URLWithString:urlLine];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:operation.responseData encoding:NSASCIIStringEncoding];
        [self parse:html line:lineNumber];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error.localizedDescription);
    }];
    
    [op start];
}

-(void)parse:(NSString *)html line:(int)line{
    self.arrivals = [NSMutableArray array];
    
    DocumentRoot *document = [Element parseHTML:html];
    
    NSArray *elements = [document selectElements:@"#sidebartiempos table.style36"];
    for (Element *element in elements){
        NSArray *busElements = [element selectElements:@"td"];
        
        JMArrival *arrivalTmp = [[JMArrival alloc] init];
        arrivalTmp.line = ((Element *)busElements[0]).contentsText;
        arrivalTmp.name = ((Element *)busElements[1]).contentsText;
        arrivalTmp.time = ((Element *)busElements[2]).contentsText;
        
        [self.arrivals addObject:arrivalTmp];
    }
    
    NSArray *scripts = [document selectElements:@"script"];
    for (Element *script in scripts){
        NSString *scriptSource = ((Element *)script).contentsText;

        if ([scriptSource rangeOfString:@"var myLatlng"].location != NSNotFound){
            [self getCoordinates:scriptSource line:line];
        }
    }
    [self.table reloadData];
}

-(void)getCoordinates:(NSString *)scriptSource line:(int)line{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"google.maps.LatLng(.*);"
                                  options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch =
        [regex firstMatchInString:scriptSource
                          options:0 range:NSMakeRange(0, [scriptSource length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [scriptSource substringWithRange:accessTokenRange];
            accessToken = [accessToken
                           stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            accessToken = [accessToken removeString:@"\""];
            accessToken = [accessToken removeString:@"("];
            accessToken = [accessToken removeString:@")"];
            
            NSArray *listItems = [accessToken componentsSeparatedByString:@", "];
            CLLocationDegrees lon = [listItems[0] floatValue];
            CLLocationDegrees lat = [listItems[1] floatValue];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lon, lat);
            
            JMAnnotation *annotation = [[JMAnnotation alloc] initWithCoordinate:coordinate line:line];
            [self.map addAnnotation:annotation];
            
            [self.map setCenterCoordinate:coordinate zoomLevel:15 animated:YES];
        }
    }
}


#pragma mark - Table Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrivals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    JMArrival *arrival = self.arrivals[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Line %@ - %@ min.", arrival.line, arrival.time];
    cell.detailTextLabel.text = arrival.name;
    
    return cell;
}

@end