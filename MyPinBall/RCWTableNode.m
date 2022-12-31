/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWTableNode.h"
#import "RCWCatagory.h"

@implementation RCWTableNode {
   
}

+ (instancetype)table:(CGSize)size
{
    BOOL isiPhone4S = NO;
    BOOL isiPhone5 = NO;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( screenHeight < screenWidth ){
        screenHeight = screenWidth;
    }
    
    if( screenHeight > 480 && screenHeight < 667 ){
        isiPhone5 = YES;
        //NSLog(@"iPhone 5/5s");
    } else if ( screenHeight > 480 && screenHeight < 736 ){
        //NSLog(@"iPhone 6");
    } else if ( screenHeight > 480 ){
        //NSLog(@"iPhone 6 Plus");
    } else {
        isiPhone4S = YES;
        //NSLog(@"iPhone 4/4s");
    }
    
    RCWTableNode *table = [self node];
    SKShapeNode *bounds = [SKShapeNode node];
    bounds.strokeColor = [SKColor clearColor];
    bounds.lineWidth = 1.0f;
    [table addChild:bounds];
    int h = size.height;//880
    int h2 = size.height-100; //780
    int h3 = size.height-180; //700
    int h4 = size.height-220; //620
     UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        h = size.height;//880
        h2 = size.height-150; //780
        h3 = size.height-230; //700
        h4 = size.height-270; //620
        [bezierPath moveToPoint: CGPointMake(0.5, -10)];
        
        [bezierPath addCurveToPoint:CGPointMake(1, h3)
                      controlPoint1:CGPointMake(0.5, -10)
                      controlPoint2:CGPointMake(1, h4)];
        [bezierPath addCurveToPoint:CGPointMake(384, h)
                      controlPoint1:CGPointMake(1, h2)
                      controlPoint2:CGPointMake(90, h)];
        [bezierPath addCurveToPoint:CGPointMake(size.width-1, h3)
                      controlPoint1:CGPointMake(size.width*0.9, h)
                      controlPoint2:CGPointMake(size.width-1, h2)];
        [bezierPath addCurveToPoint:CGPointMake(size.width-0.5, -10)
                      controlPoint1:CGPointMake(size.width-1, h4)
                      controlPoint2:CGPointMake(size.width-0.5, -10)];
    }
    else {
        h = size.height;//880
        h2 = size.height-100; //780
        h3 = size.height-180; //700
        h4 = size.height-220; //620
        [bezierPath moveToPoint: CGPointMake(0.5, -10)];
        
        [bezierPath addCurveToPoint:CGPointMake(1, h3)
                      controlPoint1:CGPointMake(0.5, -10)
                      controlPoint2:CGPointMake(1, h4)];
        [bezierPath addCurveToPoint:CGPointMake(160.5, h)
                      controlPoint1:CGPointMake(1, h2)
                      controlPoint2:CGPointMake(45.86, h)];
        [bezierPath addCurveToPoint:CGPointMake(size.width-1, h3)
                      controlPoint1:CGPointMake(275.14, h)
                      controlPoint2:CGPointMake(size.width-1, h2)];
        [bezierPath addCurveToPoint:CGPointMake(size.width-0.5, -10)
                      controlPoint1:CGPointMake(size.width-1, h4)
                      controlPoint2:CGPointMake(size.width-0.5, -10)];
    }
   


    bounds.path = bezierPath.CGPath;
    bounds.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:bezierPath.CGPath];


    int dis = 0;
    if (isiPhone4S == YES) {
        dis = size.height*0.66;
    }
    else if (isiPhone5 == YES) {
        dis = size.height*0.74;
    }
    else {
        dis = size.height*0.73;

    }
    
    int xp;
    if (isiPhone4S == YES) {
        xp = size.width-26;
    }
    else {
        xp = size.width-28;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        xp = size.width-48;
    }
    
    SKShapeNode *bounds2 = [SKShapeNode node];
    bounds2.name = @"RightBottom";
    bounds2.strokeColor = [SKColor clearColor];
    bounds2.lineWidth = 6.0f;
    [table addChild:bounds2];
    UIBezierPath* bezierPath2 = [UIBezierPath bezierPath];
    [bezierPath2 moveToPoint:CGPointMake(xp,0)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         [bezierPath2 addLineToPoint:CGPointMake(xp, 90)];
    }
    else {
         [bezierPath2 addLineToPoint:CGPointMake(xp, 65)];
    }
    bounds2.path = bezierPath2.CGPath;
    bounds2.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:bezierPath2.CGPath];
    bounds2.physicsBody.categoryBitMask = RCWCategoryWall;
    bounds2.physicsBody.collisionBitMask = 0;
    
    
    SKShapeNode *bounds3 = [SKShapeNode node];
     bounds3.name = @"RightUpper";
    bounds3.strokeColor = [SKColor clearColor];
    bounds3.lineWidth = 6.0f;
    [table addChild:bounds3];
    UIBezierPath* bezierPath3 = [UIBezierPath bezierPath];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        dis+=56;
        [bezierPath3 moveToPoint:CGPointMake(xp,130)];
        [bezierPath3 addLineToPoint:CGPointMake(xp, dis-60)];
        [bezierPath3 addCurveToPoint:CGPointMake(xp-110, dis+128)
                       controlPoint1:CGPointMake(xp, dis)
                       controlPoint2:CGPointMake(xp, dis+70)];

    }
    else {
        if (isiPhone4S == YES) {
            bounds3.lineWidth = 8.0f;
            [bezierPath3 moveToPoint:CGPointMake(xp,100)];
            [bezierPath3 addLineToPoint:CGPointMake(xp, dis-40)];
            [bezierPath3 addCurveToPoint:CGPointMake(xp-60, dis+98)
                           controlPoint1:CGPointMake(xp, dis)
                           controlPoint2:CGPointMake(xp, dis+70)];
        }
        else {
            [bezierPath3 moveToPoint:CGPointMake(xp,90)];
            [bezierPath3 addLineToPoint:CGPointMake(xp, dis-40)];
            [bezierPath3 addCurveToPoint:CGPointMake(xp-66, dis+80)
                           controlPoint1:CGPointMake(xp, dis)
                           controlPoint2:CGPointMake(xp, dis+66)];
        }
    }
    
   
    
    

    
    bounds3.path = bezierPath3.CGPath;
    bounds3.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:bezierPath3.CGPath];
    bounds3.physicsBody.categoryBitMask = RCWCategoryWall;
    bounds3.physicsBody.collisionBitMask = 0;
    
    return table;
}



- (void)followPositionOfBall:(RCWPinballNode *)ball
{
    CGRect frame = [self calculateAccumulatedFrame];
    CGFloat sceneHeight = self.scene.size.height;
    CGFloat cameraY = ball.position.y - sceneHeight/2;
    CGFloat maxY = frame.size.height - sceneHeight;
    CGFloat minY = 0;
    if (cameraY < minY) { cameraY = minY; }
    else if (cameraY > maxY) { cameraY = maxY; }
    self.position = CGPointMake(0, 0-cameraY);
    //NSLog(@"followPositionOfBall = %.f %.f",self.position.x,self.position.y);
}

@end
