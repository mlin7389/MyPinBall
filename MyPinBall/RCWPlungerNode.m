/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWCatagory.h"
#import "RCWPlungerNode.h"
#import "MainCenter.h"
@interface RCWPlungerNode ()
@property (nonatomic) CGFloat yTouchDelta;
@property (nonatomic, strong) SKPhysicsJointFixed *jointToBall;

@end

@implementation RCWPlungerNode {
    SKAction *ak3;
}

+ (instancetype)plunger
{
    RCWPlungerNode *plunger = [self node];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        plunger.size = CGSizeMake(42, 84);
    }
    else {
        plunger.size = CGSizeMake(20, 60);
    }

    SKSpriteNode *stick;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        stick = [SKSpriteNode spriteNodeWithImageNamed:@"PlungerPad"];
    }
    else {
        stick = [SKSpriteNode spriteNodeWithImageNamed:@"Plunger"];
    }
    stick.name = @"stick";
    stick.size = plunger.size;
    stick.position = CGPointMake(0, 0);
    stick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:plunger.size];
    stick.physicsBody.dynamic = NO;
    stick.physicsBody.restitution = 0.2;
    stick.physicsBody.categoryBitMask = RCWCategoryPlunger;
    stick.physicsBody.collisionBitMask = 0;
    [plunger addChild:stick];
    

    return plunger;
}

- (BOOL)isInContactWithBall:(RCWPinballNode *)ball
{
    SKNode *stick = [self childNodeWithName:@"stick"];
    NSArray *contactedBodies = stick.physicsBody.allContactedBodies;
    return [contactedBodies containsObject:ball.physicsBody];
}

- (void)grabWithTouch:(UITouch *)touch
          holdingBall:(RCWPinballNode *)ball
              inWorld:(SKPhysicsWorld *)world
{
    CGPoint touchPoint = [touch locationInNode:self];
    SKNode *stick = [self childNodeWithName:@"stick"];

    self.yTouchDelta = stick.position.y - touchPoint.y;

    CGPoint jointPoint = [self convertPoint:stick.position toNode:self.scene];

    self.jointToBall = [SKPhysicsJointFixed jointWithBodyA:stick.physicsBody
                                                     bodyB:ball.physicsBody
                                                    anchor:jointPoint];

    [world addJoint:self.jointToBall];
    //SKAction *ak2 = [SKAction playSoundFileNamed:@"E002.WAV" waitForCompletion:YES];
    //[self runAction:ak2];
}

- (void)translateToTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInNode:self];
    SKNode *stick = [self childNodeWithName:@"stick"];

    CGFloat newY = point.y + self.yTouchDelta;
    CGFloat plungerHeight = self.size.height;

    CGFloat upperY = 0;
    CGFloat lowerY = upperY - plungerHeight + 10;

    if (newY > upperY) {
        newY = upperY;
    } else if (newY < lowerY) {
        newY = lowerY;
    }

    stick.position = CGPointMake(0, newY);
 

}

- (void)letGoAndLaunchBallInWorld:(SKPhysicsWorld *)world
{
    SKNode *stick = [self childNodeWithName:@"stick"];

    CGFloat returnY = 0;
    CGFloat distancePulled = returnY - stick.position.y;
     NSLog(@"%.f %.f %.f", returnY,stick.position.y,distancePulled);
    CGFloat forceToApply = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        forceToApply = MAX(20, distancePulled * 2);
    }
    else {
       forceToApply =  MAX(3, distancePulled / 3);
    }

    SKAction *move = [SKAction moveToY:returnY duration:0.02];
    SKAction *launchBall = [SKAction runBlock:^{
        [world removeJoint:self.jointToBall];
        SKPhysicsBody *ballBody = self.jointToBall.bodyB;
        [ballBody applyImpulse:CGVectorMake(0, forceToApply)];
        self.jointToBall = nil;
    }];
    SKAction *all = [SKAction sequence:@[move, launchBall]];
    [stick runAction:all];
    if (ak3 != nil && [[MainCenter share] AudioOn]) {
        [self runAction:ak3];
    }
    
   
    
}

-(void) initSound {
     ak3 = [SKAction playSoundFileNamed:@"plugger.wav" waitForCompletion:YES];
}



-(void) AutoPop:(SKPhysicsWorld *)world{

  
    
    SKNode *stick = [self childNodeWithName:@"stick"];
    
   
    CGFloat returnY = 0;

    float forceToApply = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        forceToApply = 130;
    }
    else {
        forceToApply = 16;
    }
    SKAction *move = [SKAction moveToY:returnY duration:0.02];
    SKAction *launchBall = [SKAction runBlock:^{
        [world removeJoint:self.jointToBall];
        SKPhysicsBody *ballBody = self.jointToBall.bodyB;
        [ballBody applyImpulse:CGVectorMake(0, forceToApply)];
        self.jointToBall = nil;
    }];
    SKAction *all = [SKAction sequence:@[move, launchBall]];
    [stick runAction:all];
    if (ak3 != nil && [[MainCenter share] AudioOn]) {
        [self runAction:ak3];
    }
}
@end
