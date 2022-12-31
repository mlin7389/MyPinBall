/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWPinballNode.h"
#import "RCWCatagory.h"
@implementation RCWPinballNode

+ (instancetype)ball 
{
    int Radius = 9;
    CGFloat sideSize = 20;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        sideSize = 36;
        Radius = 18;
    }
    RCWPinballNode *node = [self spriteNodeWithImageNamed:@"ball"];

    node.size = CGSizeMake(sideSize, sideSize);
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:Radius];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        node.physicsBody.restitution = 0.2;
        node.physicsBody.friction = 0.01;
        node.physicsBody.angularDamping = 0.5;
    }
    else {
        node.physicsBody.restitution = 0.2;
        node.physicsBody.friction = 0.01;
        node.physicsBody.angularDamping = 0.5;
    }
    node.physicsBody.contactTestBitMask =
    RCWCategoryPlunger | RCWCategoryPin | RCWCategoryWall | RCWCategoryBottom | RCWCategoryLED | RCWCategoryTick;
    node.physicsBody.collisionBitMask =
    RCWCategoryPlunger | RCWCategoryPin | RCWCategoryWall | RCWCategoryBottom;
    node.physicsBody.categoryBitMask = RCWCategoryBall;
    return node;
}

@end
