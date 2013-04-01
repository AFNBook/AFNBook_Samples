//
//  JMAnnotation.m
//  AuBus
//
//  Created by Jorge Maroto Garcia on 29/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "JMAnnotation.h"

@implementation JMAnnotation

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord line:(int)line{
    self = [super init];
    if (!self) return nil;
    
    _line = line;
    _coordinate = coord;
    return self;
}

-(NSString *)title{
    return [NSString stringWithFormat:@"Stop %i", self.line];
}
@end