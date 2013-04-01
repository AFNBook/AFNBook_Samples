//
//  NSString+AFNetworking.m
//  AuBus
//
//  Created by Jorge Maroto Garcia on 30/3/13.
//  Copyright (c) 2013 Tactilapp.com. All rights reserved.
//

#import "NSString+AFNetworking.h"

@implementation NSString (AFNetworking)

-(NSString *)removeString:(NSString *)str{
    return [self stringByReplacingOccurrencesOfString:str withString:@""];
}

@end