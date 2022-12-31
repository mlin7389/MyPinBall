//
//  RCWLEDShapeNode.m
//  PinBall
//
//  Created by MartyLin on 1/19/15.
//  Copyright (c) 2015 Rubber City Wizards. All rights reserved.
//

#import "RCWLEDShapeNode.h"
#import "RCWCatagory.h"

@implementation RCWLEDShapeNode

+ (instancetype) LEDLight:(CGSize) size
{
    RCWLEDShapeNode *fireNode = [self shapeNodeWithCircleOfRadius:size.width/3];
    fireNode.isTurnOn = YES;
    fireNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:size.width/3];
    fireNode.physicsBody.categoryBitMask = RCWCategoryLED;
    fireNode.physicsBody.collisionBitMask = 0;
    fireNode.physicsBody.dynamic = NO;
    fireNode.strokeColor = [UIColor clearColor];
    return fireNode;
}

@end
