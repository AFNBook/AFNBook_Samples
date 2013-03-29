//
//  JMAnnotation.h
//  AuBus
//
//  Created by Jorge Maroto Garcia on 29/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface JMAnnotation : NSObject<MKAnnotation>
    @property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
    @property (nonatomic, assign) int line;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord line:(int)line;
@end
