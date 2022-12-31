/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/

@import GameKit;

#import "RCWViewController.h"
#import "RCWMyScene.h"
#import "MainCenter.h"
@interface RCWViewController()  <GKGameCenterControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_level;
@property (weak, nonatomic) IBOutlet UILabel *label_skill_value;
@property (weak, nonatomic) IBOutlet UILabel *label_skill_title;
@property (weak, nonatomic) IBOutlet UILabel *label_point_title;
@property (weak, nonatomic) IBOutlet UILabel *label_point_value;
@property (weak, nonatomic) IBOutlet UIButton *GameCenterButton;
@property (weak, nonatomic) IBOutlet UILabel *ContinuousLabel;
@end



@implementation RCWViewController {
    RCWMyScene * scene;
}



- (IBAction)LeveTap:(UIButton *)sender {
    GameLevel level = (GameLevel)sender.tag;
    [[MainCenter share] setCurrentLevel:level];
    [[MainCenter share] SaveData];
    [scene ChangedLevel:level];
    self.label_level.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"level", nil),(long)[[MainCenter share] currentLevel]+1];
      self.ContinuousLabel.text = [NSString stringWithFormat:@"%ld",(long)[[[[MainCenter share] AchievementsDic] objectForKey:[[MainCenter share] GetLevelString:[[MainCenter share] currentLevel]]] integerValue]];
}

-(void) UpdateMainView:(NSNotification *) notification {
    self.label_skill_value.text = [NSString stringWithFormat:@"%@",[[MainCenter share] Skill]];
    self.label_point_value.text = [NSString stringWithFormat:@"%@",[[MainCenter share] Point]];
    self.label_level.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"level", nil),(long)[[MainCenter share] currentLevel]+1];
    BOOL isJackPot = [(NSNumber *)notification.object boolValue];
    if (isJackPot) {
        [self reportAchievements];
    }
    [self reportScore];
    
    self.ContinuousLabel.text = [NSString stringWithFormat:@"%ld",(long)[[[[MainCenter share] AchievementsDic] objectForKey:[[MainCenter share] GetLevelString:[[MainCenter share] currentLevel]]] integerValue]];
}

-(void) viewWillAppear:(BOOL)animated {
    [self initGameCenter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    self.label_skill_title.text = NSLocalizedString(@"skill", nil);
    self.label_point_title.text = NSLocalizedString(@"point", nil);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateMainView:) name:@"UpdateMainView" object:nil];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    //skView.showsPhysics = YES;
    // Create and configure the scene.
    scene = [RCWMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(BOOL) prefersStatusBarHidden {
    return YES;
}

#pragma mark -
#pragma mark GameCneter
#pragma mark -

-(void) initGameCenter {
    if ([[MainCenter share] gameCenterEnabled] == NO) {
        [self authenticateLocalPlayer];
    }
    //else if ([[MainCenter share] leaderboards] == nil) {
       /* [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
            if (error != nil) {
                NSLog(@"leaderboards = %@", [error localizedDescription]);
            }
            else{
                NSLog(@"leaderboards = %@",[leaderboards description]);
                [[MainCenter share] setLeaderboards:leaderboards];
            }
        }];*/
    //}
}

-(void)authenticateLocalPlayer{
    // Instantiate a GKLocalPlayer object to use for authenticating a player.
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                [[MainCenter share] setGameCenterEnabled:YES];
                  //NSLog(@"LocalPlayer = authenticated Success");
                /*[GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"leaderboards = %@", [error localizedDescription]);
                    }
                    else{
                        NSLog(@"leaderboards = %@",[leaderboards description]);
                        [[MainCenter share] setLeaderboards:leaderboards];
                    }
                }];*/
                
            }
            else{
               // NSLog(@"LocalPlayer = authenticated failed");
                [[MainCenter share] setGameCenterEnabled:NO];
            }
        }
    };
}


-(void)reportScore {
    if ([[MainCenter share] gameCenterEnabled] == NO) {
        return;
    }
    
    NSString *_leaderboardIdentifier = @"";
    switch ([[MainCenter share] currentLevel]) {
        case Level_1:
            _leaderboardIdentifier = IDENTIFIER_LEVEL1;
            break;
        case Level_2:
            _leaderboardIdentifier = IDENTIFIER_LEVEL2;
            break;
        case Level_3:
            _leaderboardIdentifier = IDENTIFIER_LEVEL3;
            break;
        case Level_4:
            _leaderboardIdentifier = IDENTIFIER_LEVEL4;
            break;
        case Level_5:
            _leaderboardIdentifier = IDENTIFIER_LEVEL5;
            break;
        case Level_6:
            _leaderboardIdentifier = IDENTIFIER_LEVEL6;
            break;
    }
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    score.value = [[MainCenter share] LevelPercent:[[MainCenter share] currentLevel]]* 10000;
    
    GKScore *scoreDef = [[GKScore alloc] initWithLeaderboardIdentifier:IDENTIFIER_DEFAULT];
    scoreDef.value = [[[MainCenter share] Point] integerValue];

    GKScore *scoreAvg = [[GKScore alloc] initWithLeaderboardIdentifier:IDENTIFIER_AVERAGE];
    scoreAvg.value = [[[MainCenter share] Skill] doubleValue] * 100;
    NSLog(@"Report scores: \n %@",[@[score,scoreDef,scoreAvg] description]);
    [GKScore reportScores:@[score,scoreDef,scoreAvg] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            //NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void) reportAchievements {
    
    NSString *level = [[MainCenter share] GetLevelString:[[MainCenter share] currentLevel]];
    
    NSMutableArray *achievementsArr = [NSMutableArray new];
    for (int i=10;i<=100;i+=10) {
        //Level01_10
        NSString *identifierID = [NSString stringWithFormat:@"PinBall_%@_%d",level,i];
        GKAchievement *arc = [[GKAchievement alloc] initWithIdentifier:identifierID];
        NSInteger count =  [[[[MainCenter share] AchievementsDic] objectForKey:level] integerValue];
        if (count == 0) {
            arc.percentComplete = 0;
        }
        else{
            arc.percentComplete = (double)count/(double)i * 100.0;
            if (arc.percentComplete > 100.0) {
                arc.percentComplete = 100.0;
            }
        }
       // NSLog(@"[%@]. %.2f",identifierID,arc.percentComplete);
        [achievementsArr addObject:arc];
    }
   // NSLog(@"%@",[achievementsArr description]);
 
    [GKAchievement reportAchievements:[NSArray arrayWithArray:achievementsArr] withCompletionHandler:^(NSError *error){
        if (error != nil) {
            //NSLog(@"Achievement report error : %@",[error description]);
        }
    }];
}


-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    
    if ([[MainCenter share] gameCenterEnabled] == NO) {
        return;
    }
    
    // Init the following view controller object.
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    // Set self as its delegate.
    gcViewController.gameCenterDelegate = self;
    
    // Depending on the parameter, show either the leaderboard or the achievements.
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = IDENTIFIER_DEFAULT;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    // Finally present the view controller.
    [self presentViewController:gcViewController animated:YES completion:nil];
}

#pragma mark - GKGameCenterControllerDelegate method implementation

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
