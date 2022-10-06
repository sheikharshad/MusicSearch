//
//  MockingURLSessionConfiguration.swift
//  MarketPlaceTests
//
//  Created by Arshad shaikh on 05/10/2022.
//
// Purpose :- This class is used to call the swizzling only @ once

#import <Foundation/Foundation.h>
#import <MusicSearchTests-Swift.h>
@interface MockingURLSessionConfiguration : NSObject

@end

@implementation MockingURLSessionConfiguration

+ (void)load {
    [NSURLSessionConfiguration swizzleDefaultSessionConfiguration];
}

@end
