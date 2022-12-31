//
//  RCWLEDLightNode.m
//  PinBall
//
//  Created by MartyLin on 1/18/15.
//  Copyright (c) 2015 Rubber City Wizards. All rights reserved.
//

#import "RCWLEDLightNode.h"

@implementation RCWLEDLightNode


+ (instancetype) LEDLight:(CGSize) size WithID:(int) index
{
    RCWLEDLightNode *fireNode;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        fireNode = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"LED%dPad",index]];
    }
    else {
        fireNode = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"LED%d",index]];
    }
    fireNode.size = size;
    fireNode.anchorPoint = CGPointMake(0.5,0);
    return fireNode;
}

-(void) SpringLight:(int) index {
    SKAction *_animate = nil;
    NSString *LED1Name = @"LED1";
    NSString *LED2Name = @"LED2";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        LED1Name = @"LED1Pad";
        LED2Name = @"LED2Pad";
    }

    if (index % 2 == 0) {
        _animate = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:LED1Name],[SKTexture textureWithImageNamed:LED2Name]] timePerFrame:0.1 resize:NO restore:YES];
    }
    else {
        _animate = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:LED2Name],[SKTexture textureWithImageNamed:LED1Name]] timePerFrame:0.1 resize:NO restore:YES];
    }
    SKAction *animate = [SKAction repeatActionForever:_animate];
    [self runAction:animate];
}


@end
