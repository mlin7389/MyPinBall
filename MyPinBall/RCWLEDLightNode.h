//
//  RCWLEDLightNode.h
//  PinBall
//
//  Created by MartyLin on 1/18/15.
//  Copyright (c) 2015 Rubber City Wizards. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface RCWLEDLightNode : SKSpriteNode
+ (instancetype) LEDLight:(CGSize) size WithID:(int) index;
-(void) SpringLight:(int) index;
@end
