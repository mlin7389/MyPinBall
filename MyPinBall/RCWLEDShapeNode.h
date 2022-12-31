//
//  RCWLEDShapeNode.h
//  PinBall
//
//  Created by MartyLin on 1/19/15.
//  Copyright (c) 2015 Rubber City Wizards. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface RCWLEDShapeNode : SKShapeNode
+ (instancetype) LEDLight:(CGSize) size;
@property BOOL isTurnOn;
@end
