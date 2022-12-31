//
//  RCWCatagory.h
//  PinBall
//
//  Created by MartyLin on 1/15/15.
//  Copyright (c) 2015 Rubber City Wizards. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(uint32_t, RCWCollisionCategory) {
    RCWCategoryBall      = 1 << 0,
    RCWCategoryPin       = 1 << 1,
    RCWCategoryWall      = 1 << 2,
    RCWCategoryTick     = 1 << 3,
    RCWCategoryPlunger   = 1 << 4,
    RCWCategoryBottom   = 1 << 5,
    RCWCategoryLED   = 1 << 6,
};
@interface RCWCatagory : NSObject


@end
