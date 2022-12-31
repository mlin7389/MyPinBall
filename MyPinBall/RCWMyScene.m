/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
@import AVFoundation;

#import "RCWCatagory.h"
#import "RCWLEDShapeNode.h"
#import "RCWLEDLightNode.h"
#import "RCWMyScene.h"
#import "RCWPinballNode.h"
#import "RCWPlungerNode.h"
#import "RCWTableNode.h"
#import "RCWPinNode.h"
@interface RCWMyScene () <SKPhysicsContactDelegate>
@property (nonatomic, weak) UITouch *plungerTouch;
@end



@implementation RCWMyScene {
    NSArray *hitSounts;
    SKAction *hitWall;
    SKAction *hitPlunger;
    SKAction *LEDLight;
    SKAction *LEDChange;
    SKAction *Jackpot;
    SKAction *Nogo;
    SKSpriteNode *ScoreNode;
    BOOL isiPhone4S;
    BOOL isiPhone5;
    BOOL _StartingLight;
    BOOL _GetScored;
    BOOL _PassTick;
    NSMutableArray *ScoreTextureArr;
    int RADIUS;
}
#pragma mark - 
#pragma mark Contact
#pragma mark -



- (void)didBeginContact:(SKPhysicsContact *)contact
{
   if (contact.bodyA.categoryBitMask == RCWCategoryPin ||
       contact.bodyB.categoryBitMask == RCWCategoryPin) {
       _PassTick = NO;
       
       NSInteger fromNumber = 0;
       NSInteger toNumber = [hitSounts count]-1;
       NSInteger value =  (arc4random()%(toNumber-fromNumber))+fromNumber;
       SKAction *hitSount = [hitSounts objectAtIndex:value];
       [self RunAudioAction:self WithAction:hitSount];
       RCWPinballNode *node;
       if (contact.bodyA.categoryBitMask == RCWCategoryPin) {
           node = (RCWPinballNode *)contact.bodyA.node;
       }
       else if (contact.bodyB.categoryBitMask == RCWCategoryPin) {
           node = (RCWPinballNode *)contact.bodyB.node;
       }
      
      
       
       
       float an = M_PI / (100 - contact.collisionImpulse * 10);
       if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
           if (fabs(an) > 0.03) {
               an = 0.03;
           }
       }
       else {
           if (fabs(an) > 0.15) {
               an = 0.15;
           }
       }
       float timer = 0.05f;
       SKAction *k1 = [SKAction rotateByAngle:an duration:timer];
       SKAction *k2 = [SKAction rotateByAngle:-an duration:timer];
       SKAction *k3 = [SKAction rotateByAngle:an duration:timer];
       SKAction *k4 = [SKAction rotateByAngle:-an duration:timer];
       SKAction *k5 = [SKAction rotateByAngle:0 duration:timer];
       SKAction *all = [SKAction sequence:@[k1,k2,k3,k4,k5]];
       //[self RunAudioAction:node WithAction:all];
       [node runAction:all];
   }
   else if (contact.bodyA.categoryBitMask == RCWCategoryPlunger ||
              contact.bodyB.categoryBitMask == RCWCategoryPlunger) {
       [self RunAudioAction:self WithAction:hitPlunger];
       //AutoPlay
       // RCWPinballNode *ball = (id)[self childNodeWithName:@"//ball"];
       //RCWPlungerNode *plunger = (id)[self childNodeWithName:@"//plunger"];
       //[plunger grabWithTouch:nil holdingBall:ball inWorld:self.physicsWorld];
       //[plunger AutoPop:self.physicsWorld];
   }
   else if (contact.bodyA.categoryBitMask == RCWCategoryWall ||
              contact.bodyB.categoryBitMask == RCWCategoryWall) {
       [self RunAudioAction:self WithAction:hitWall];
   }
   else if (contact.bodyA.categoryBitMask == RCWCategoryLED ||
            contact.bodyB.categoryBitMask == RCWCategoryLED) {
       if (_GetScored == NO) {
           
           _GetScored = YES;
           _PassTick = NO;
           RCWLEDShapeNode *node;
           if (contact.bodyA.categoryBitMask == RCWCategoryLED) {
               node = (RCWLEDShapeNode *)contact.bodyA.node;
           }
           else if (contact.bodyB.categoryBitMask == RCWCategoryLED) {
               node = (RCWLEDShapeNode *)contact.bodyB.node;
           }
           if (node.isTurnOn == YES) {
               [self RunAudioAction:self WithAction:Jackpot];
               [[MainCenter share] isJackpot:YES];
               [self showScore];
           }
           else {
               [self RunAudioAction:self WithAction:Nogo];
               [[MainCenter share] isJackpot:NO];
           }
           
           [self updateView:node.isTurnOn];
       }
   }
   else if (contact.bodyA.categoryBitMask == RCWCategoryBottom || contact.bodyB.categoryBitMask == RCWCategoryBottom) {
       [self RunAudioAction:self WithAction:hitWall];
   }
   else if (contact.bodyA.categoryBitMask == RCWCategoryTick || contact.bodyB.categoryBitMask == RCWCategoryTick) {
       if (_PassTick == NO) {
           _PassTick = YES;
           [self performSelector:@selector(GetRandomLightTmp) withObject:nil afterDelay:0.5f];
       }
       
   }
}

#pragma mark -
#pragma mark Touch
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    RCWPinballNode *ball = (id)[self childNodeWithName:@"//ball"];
    RCWPlungerNode *plunger = (id)[self childNodeWithName:@"//plunger"];
    if (self.plungerTouch == nil && [plunger isInContactWithBall:ball]) {
        UITouch *touch = [touches anyObject];
        self.plungerTouch = touch;
        [plunger grabWithTouch:touch holdingBall:ball inWorld:self.physicsWorld];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches containsObject:self.plungerTouch]) {
        RCWPlungerNode *plunger = (id)[self childNodeWithName:@"//plunger"];
        [plunger letGoAndLaunchBallInWorld:self.physicsWorld];
    }
}

#pragma mark - 
#pragma mark Comm
#pragma mark -

-(void) DectecedDevice {
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
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        RADIUS = 5;
        [self DectecedDevice];
        [self setUpScene];
        [self setAudio];
        [self GetRandomLight:NO isInitTime:YES];
        [self updateView:NO];
        
        ScoreNode = [SKSpriteNode spriteNodeWithImageNamed:@"Score1"];
        ScoreNode.position = CGPointMake(self.size.width/2, self.size.height/3*2);
        ScoreNode.alpha = 0.0f;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            ScoreNode.size = CGSizeMake(508, 401);
        }
        else {
            ScoreNode.size = CGSizeMake(245, 193);
        }
        
        ScoreTextureArr = [NSMutableArray new];
        for (int i=0;i<10;i++){
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [ScoreTextureArr addObject:
                 [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Score%dPad",i+1]]];
            }
            else {
                [ScoreTextureArr addObject:
                 [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Score%d",i+1]]];
            }
        }
        [self addChild:ScoreNode];
    }
    return self;
}


#pragma mark - 
#pragma mark Set init
#pragma mark -

-(void) setAudio {
    NSMutableArray *_audios = [NSMutableArray new];
    for (int i=1;i<=6;i++) {
        SKAction *hitSount = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"PIN%d.wav",i] waitForCompletion:NO];
        [_audios addObject:hitSount];
    }
    hitSounts = [NSArray arrayWithArray:_audios];
    hitWall = [SKAction playSoundFileNamed:@"WALL1.aif" waitForCompletion:NO];
    hitPlunger = [SKAction playSoundFileNamed:@"WALL2.aif" waitForCompletion:NO];
    LEDLight = [SKAction playSoundFileNamed:@"LED2.wav" waitForCompletion:NO];
    LEDChange = [SKAction playSoundFileNamed:@"LED1.wav" waitForCompletion:NO];
    Jackpot = [SKAction playSoundFileNamed:@"JACKPOT.wav" waitForCompletion:NO];
    Nogo = [SKAction playSoundFileNamed:@"NOGO.wav" waitForCompletion:NO];
}

-(float) SetPin {
    
    
    int row = 8;
    int xOffset = 38;
    BOOL offset = NO;
    int xPos;
    int yPos = self.size.height * row/10.0;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        xOffset = 98;
        row = 10;
        yPos = 850;
        xPos = RADIUS*11+2;
    }
    else {
        xPos = RADIUS*8+2;
        if (isiPhone4S == YES) {
            row = 6;
        }
    }
    
    int index = 0;
    NSMutableArray *pins = [NSMutableArray new];
    
    if (isiPhone4S == YES) {
        for (int i=0;i<=2;i++) {
            RCWPinNode *pin1 = [RCWPinNode pinRadius:RADIUS position:
                                CGPointMake(120+i*xOffset, self.size.height-60)];
            index++;
            pin1.name = [NSString stringWithFormat:@"Pin%d",index];
            [self addChild:pin1];
        }
        
        RCWPinNode *pin2 = [RCWPinNode pinRadius:RADIUS position:
                            CGPointMake(32, self.size.height-100)];
        index++;
        pin2.name = [NSString stringWithFormat:@"Pin%d",index];
        [self addChild:pin2];
        
        RCWPinNode *pin3 = [RCWPinNode pinRadius:RADIUS position:
                            CGPointMake(24, self.size.height-90)];
        index++;
        pin3.name = [NSString stringWithFormat:@"Pin%d",index];
        [self addChild:pin3];

    }
    
    for (int j=1;j<=row;j++){
        int count = offset == YES ? 8 : 7;
        int start_xPos = xPos;
        for (int i=0;i<count;i++){
            RCWPinNode *pinA = [RCWPinNode pinRadius:RADIUS position:CGPointMake(xPos, yPos)];
            index++;
            pinA.name = [NSString stringWithFormat:@"Pin%d",index];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                if (j == 2 && i == 0) {
                    RCWPinNode *pin1 = [RCWPinNode pinRadius:RADIUS position:CGPointMake(xPos-8, yPos+25)];
                    index++;
                    pin1.name = [NSString stringWithFormat:@"Pin%d",index];
                    [self addChild:pin1];
                    //RCWPinNode *pin2 = [RCWPinNode pinRadius:RADIUS position:CGPointMake(xPos-5, yPos+40)];
                    //[self addChild:pin2];
                }
               // pin.position = CGPointMake(pin.position.x+10, pin.position.y);
            }
              xPos+=xOffset;
            
            if (j == row) {
                [pins addObject:pinA];
            }
            
            if (j % 2 == 0 && i == count-1) {
                if (!(j == 2 && isiPhone4S == YES)) {
                    int k = 0;
                    if (j == 2 && i == count-1) {
                        k=3;
                    }
                    
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
 
                        RCWPinNode *pin = [RCWPinNode pinRadius:RADIUS position:CGPointMake(xPos-xOffset+RADIUS-k, yPos+RADIUS*3)];
                        index++;
                        pin.name = [NSString stringWithFormat:@"Pin%d",index];
                        [self addChild:pin];
                    }
                    else {
                        if (!(j == 2 && isiPhone4S == YES)) {
                            RCWPinNode *pin = [RCWPinNode pinRadius:RADIUS position:CGPointMake(xPos-xOffset+RADIUS-k, yPos+RADIUS*2)];
                            index++;
                            pin.name = [NSString stringWithFormat:@"Pin%d",index];
                            [self addChild:pin];
                        }
                        else{
                            RCWPinNode *pin = [RCWPinNode pinRadius:RADIUS position:CGPointMake(xPos-xOffset+RADIUS-k, yPos+RADIUS*2)];
                            index++;
                            pin.name = [NSString stringWithFormat:@"Pin%d",index];
                            [self addChild:pin];
                        }
                    }
                    
                }
                
            }
            if (!((j == 1 && i == 0) || (j==1 && i==count-1))) {
                [self addChild:pinA];
            }
           
            
        }
        
        if (j % 2 == 0) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
               
            }
            else {
                if (!(j == 2 && isiPhone4S == YES)) {
                    RCWPinNode *pin = [RCWPinNode pinRadius:RADIUS position:CGPointMake(start_xPos-RADIUS, yPos+RADIUS*2)];
                    index++;
                    pin.name = [NSString stringWithFormat:@"Pin%d",index];
                    [self addChild:pin];
                }
            }
        }
        
      
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (offset) {
                offset = NO;
                xPos = RADIUS*10.5;
            }
            else {
                offset = YES;
                xPos = RADIUS*2;
            }
            yPos -= 60;
        }
        else {
            if (offset) {
                offset = NO;
                xPos = RADIUS*5+2;
            }
            else {
                offset = YES;
                xPos = RADIUS*2+2;
            }
            yPos -= xOffset;
        }
    }
    SKSpriteNode *p = [pins objectAtIndex:0];
    xPos = p.position.x;
    yPos = p.position.y;
    for (int j=0;j<4;j++){
        for (int i=0;i<[pins count];i++) {
            SKSpriteNode *p = [pins objectAtIndex:i];
            RCWPinNode *pin = [RCWPinNode pinRadius:RADIUS position:CGPointMake(p.position.x,yPos)];
            index++;
            pin.name = [NSString stringWithFormat:@"Pin%d",index];
            [self addChild:pin];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            yPos-=RADIUS*4+2;
        }
        else {
            yPos-=RADIUS*2+2;
        }
        
    }
    
   

    return yPos;
}

-(void) SetBottom:(NSInteger) yPos {
    
    int widthOffset = 28;
    int heightOffset = 65;
    float yp = yPos-RADIUS*2-6;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        widthOffset = 48;
        heightOffset = 90;
        yp = yPos-30;
    }
    
    
    SKShapeNode *bounds = [SKShapeNode node];
    bounds.strokeColor = [SKColor clearColor];
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:CGPointMake(0, yp)];
    [line addLineToPoint:CGPointMake(self.size.width-widthOffset, heightOffset)];
    bounds.path = line.CGPath;
    bounds.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:line.CGPath];
    bounds.physicsBody.categoryBitMask = RCWCategoryBottom;
    
    [self addChild:bounds];
    
    
    SKShapeNode *TickNode = [SKShapeNode node];
    TickNode.strokeColor = [SKColor clearColor];
    TickNode.lineWidth = 1.0;
    NSInteger posY = yPos-RADIUS*2+10;
    UIBezierPath *TickNodeline = [UIBezierPath bezierPath];
    [TickNodeline moveToPoint:CGPointMake(0, posY)];
    [TickNodeline addLineToPoint:CGPointMake(self.size.width-widthOffset, posY)];
    TickNode.path = TickNodeline.CGPath;
    TickNode.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:TickNodeline.CGPath];
    TickNode.physicsBody.categoryBitMask = RCWCategoryTick;
    TickNode.physicsBody.collisionBitMask = 0;
    
    [self addChild:TickNode];
}

-(NSInteger) setLEDLight:(NSInteger)yPos {
     RCWTableNode *table = (id)[self childNodeWithName:@"//table"];
    int xPOS1 = 31;
    int offset = 0;
    int sizeWidth = 20;
    float heightOffset = 2.5;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        sizeWidth = 50;
        heightOffset = 1.6;
        xPOS1 = 58;
    }
    
    for (int i=1;i<=7;i++) {
        RCWLEDLightNode *node = [RCWLEDLightNode LEDLight:CGSizeMake(sizeWidth, sizeWidth) WithID:2];
        node.position = CGPointMake(xPOS1, yPos+node.size.height*heightOffset);
        node.name = [NSString stringWithFormat:@"LED%d",i];
        
        RCWLEDShapeNode *invisiableNode = [RCWLEDShapeNode LEDLight:node.size];
        if (isiPhone4S == YES) {
             invisiableNode.position = CGPointMake(xPOS1, yPos+node.size.height*1.4);
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             invisiableNode.position = CGPointMake(xPOS1, yPos+node.size.height);
        }
        else {
             invisiableNode.position = CGPointMake(xPOS1, yPos+node.size.height*1.4);
        }
        invisiableNode.name = [NSString stringWithFormat:@"LEDS%d",i];
        
        [table addChild:invisiableNode];
        [table addChild:node];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            xPOS1 += 96 + offset;
            offset+=1;
          
        }
        else {
            xPOS1 += 12 + 26;
        }
    }
    return xPOS1;
}

- (void)setUpScene
{
    self.backgroundColor = [SKColor whiteColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.physicsWorld.gravity = CGVectorMake(0, -5.8);
    }
    else {
        self.physicsWorld.gravity = CGVectorMake(0, -3.8);
    }
    
    self.physicsWorld.contactDelegate = self;
    SKSpriteNode *bg;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg_Pad"];
    }
    else {
        if (isiPhone4S == NO) {
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg.jpg"];
        }
        else {
            bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg.jpg"];
        }
    }
    bg.size = self.size;
    bg.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:bg];
    
  
    RCWTableNode *table = [RCWTableNode table:self.size];
    table.name = @"table";
    table.position = CGPointMake(0, 0);
    [self addChild:table];

    
    RCWPlungerNode *plunger = [RCWPlungerNode plunger];
    plunger.name = @"plunger";
    plunger.position = CGPointMake(self.size.width - plunger.size.width/2 - 4,
                                   plunger.size.height / 2);
    [plunger initSound];
    [table addChild:plunger];
 
    
    RCWPinballNode *ball = [RCWPinballNode ball];
    ball.name = @"ball";
    ball.position = CGPointMake(plunger.position.x,
                                plunger.position.y + plunger.size.height);
    
  
    
    NSInteger yPos = [self SetPin];

    [self SetBottom:yPos];
    
    NSInteger xPos = [self setLEDLight:yPos];

    ball.position = CGPointMake(xPos-20, yPos-50);
    [table addChild:ball];
 
   
    
    
   
}


#pragma mark -
#pragma mark Others
#pragma mark -

- (void)didSimulatePhysics
{
    RCWTableNode *table = (id)[self childNodeWithName:@"table"];
    RCWPlungerNode *plunger = (id)[table childNodeWithName:@"plunger"];
    if (self.plungerTouch) {
        [plunger translateToTouch:self.plungerTouch];
    }
}

-(void) GetRandomLightTmp {
    [self GetRandomLight:NO isInitTime:NO];
}

-(void) GetRandomLight:(BOOL)ChangeLevel isInitTime:(BOOL) initTime{
    RCWTableNode *table = (id)[self childNodeWithName:@"table"];
    RCWLEDLightNode *led_Node;

    for (int i=1;i<=7;i++) {
        led_Node = (id)[table childNodeWithName:[NSString stringWithFormat:@"LED%d",i]];
        if (_StartingLight == NO) {
            [led_Node SpringLight:i];
        }
        else {
            [led_Node removeAllActions];
        }
    }
    
    if (_StartingLight == NO) {
        if (initTime == NO) {
            if (ChangeLevel) {
                [self RunAudioAction:self WithAction:LEDChange];
            }
            else {
                [self RunAudioAction:self WithAction:LEDLight];
            }
        }
        _StartingLight = YES;
        double interval = 1.20f;  // 間隔多久執行一次 (秒)
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(timerEvent:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else {
        _StartingLight = NO;
        [self randomLight];
    }
 
}

-(void) randomLight {
    MainCenter *center = [MainCenter share];
    int turnOnCount = 0;
    switch (center.currentLevel) {
        case Level_1:
            turnOnCount = 6;
            break;
        case Level_2:
            turnOnCount = 5;
            break;
        case Level_3:
            turnOnCount = 4;
            break;
        case Level_4:
            turnOnCount = 3;
            break;
        case Level_5:
            turnOnCount = 2;
            break;
        case Level_6:
            turnOnCount = 1;
            break;
    }
    
    NSMutableArray *arr = [NSMutableArray new];
    for (int i=1;i<=7;i++) {
        if (Level_1 == center.currentLevel) {
            [arr addObject:[NSNumber numberWithBool:YES]];
        }
        else {
            [arr addObject:[NSNumber numberWithBool:NO]];
        }
    }
    if (center.currentLevel == Level_1) {
        turnOnCount = 0;
        NSInteger fromNumber = 1;
        NSInteger toNumber = 7;
        NSInteger value =  (arc4random()%(toNumber-fromNumber))+fromNumber;
        [arr replaceObjectAtIndex:value-1 withObject:[NSNumber numberWithBool:NO]];
    }
    else {
        while (turnOnCount > 0 && center.currentLevel != Level_1) {
            NSInteger fromNumber = 1;
            NSInteger toNumber = 7;
            NSInteger value =  (arc4random()%(toNumber-fromNumber))+fromNumber;
            BOOL isTurnOn = [[arr objectAtIndex:value-1] boolValue];
            if (isTurnOn == NO) {
                [arr replaceObjectAtIndex:value-1 withObject:[NSNumber numberWithBool:YES]];
                turnOnCount--;
            }
        }
    }
    RCWTableNode *table = (id)[self childNodeWithName:@"table"];
    for (int i=1;i<=[arr count];i++) {
        RCWLEDLightNode *led_Node = (id)[table childNodeWithName:[NSString stringWithFormat:@"LED%d",i]];
        RCWLEDShapeNode *led_Shape = (id)[table childNodeWithName:[NSString stringWithFormat:@"LEDS%d",i]];
        BOOL isTurnOn = [[arr objectAtIndex:i-1] doubleValue];
        if (isTurnOn == YES) {
            led_Node.texture = [SKTexture textureWithImageNamed:@"LED1"];
            led_Shape.isTurnOn = YES;
        }
        else {
            led_Node.texture = [SKTexture textureWithImageNamed:@"LED2"];
           led_Shape.isTurnOn = NO;
        }
        
    }
    _GetScored = NO;
}

-(void) timerEvent:(NSTimer *) timer {
    [self GetRandomLight:NO isInitTime:NO];
}

-(void) updateView:(BOOL) isJackPot {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMainView" object:[NSNumber numberWithBool:isJackPot]];
}

-(void) ChangedLevel:(GameLevel) level {
    [[MainCenter share] setCurrentLevel:level];
    [self GetRandomLight:YES isInitTime:NO];
}

-(void) showScore {
    NSInteger score = [[MainCenter share] GetLevelScore:[[MainCenter share] currentLevel]];
    ScoreNode.texture = [ScoreTextureArr objectAtIndex:score-1];
    SKAction *action1 = [SKAction fadeInWithDuration:0.3f];
    SKAction *action2 = [SKAction fadeOutWithDuration:1.0f];
    SKAction *action3 = [SKAction sequence:@[action1,action2]];
    [ScoreNode runAction:action3];
    
}

-(void) RunAudioAction:(id) obj WithAction:(SKAction *) action {
    if ([[MainCenter share] AudioOn]) {
        [obj runAction:action];
    }
}

@end
