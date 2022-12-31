//
//  RCWPinNode.m
//  PhysicsBall
//
//  Created by MartyLin on 1/14/15.
//  Copyright (c) 2015 Rubber City Wizards. All rights reserved.
//

#import "RCWPinNode.h"
#import "RCWCatagory.h"
@implementation RCWPinNode
+ (instancetype)pinRadius:(int) Radius position:(CGPoint) pos {
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( screenHeight < screenWidth ){
        screenHeight = screenWidth;
    }
    BOOL isiPhone4S = NO;
    if( screenHeight > 480 && screenHeight < 667 ){
        //NSLog(@"iPhone 5/5s");
    } else if ( screenHeight > 480 && screenHeight < 736 ){
        //NSLog(@"iPhone 6");
    } else if ( screenHeight > 480 ){
        //NSLog(@"iPhone 6 Plus");
    } else {
        isiPhone4S = YES;
        //NSLog(@"iPhone 4/4s");
    }
    
    
    RCWPinNode *pin;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        pin = [RCWPinNode spriteNodeWithImageNamed:@"needlePad"];
        pin.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:Radius*2.6];
    }
    else {
        if (isiPhone4S) {
            pin = [RCWPinNode spriteNodeWithImageNamed:@"needle"];
            pin.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:Radius*1.2];
        }
        else {
            pin = [RCWPinNode spriteNodeWithImageNamed:@"needle"];
            pin.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:Radius];
        }
       
        
    }
    pin.physicsBody.dynamic = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        pin.physicsBody.restitution = 0.55f;
    }
    else{
        pin.physicsBody.restitution = 0.5f;
    }
    pin.size = CGSizeMake(14, 24);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        pin.size = CGSizeMake(pin.size.width*2.8, pin.size.height*2.8);
    }

    pin.physicsBody.categoryBitMask = RCWCategoryPin;
    pin.physicsBody.collisionBitMask = 0;
    pin.anchorPoint = CGPointMake(0.5,0.2);
    pin.position = CGPointMake(pos.x, pos.y);
    return pin;
}


@end
