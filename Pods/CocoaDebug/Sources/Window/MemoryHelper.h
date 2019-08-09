//
//  Example
//  man
//
//  Created by man on 11/11/2018.
//  Copyright © 2018 man. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryHelper : NSObject

+ (instancetype)shared;

- (NSString *)appUsedMemoryAndPercentage;
- (NSString *)appUsedMemoryAndFreeMemory;

@end
