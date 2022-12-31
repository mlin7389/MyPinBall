//
//  MPRankViewController.m
//  MyPinBall
//
//  Created by MartyLin on 1/20/15.
//
//
@import GameKit;
#import "MainCenter.h"
#import "MPRankViewController.h"

@interface MPRankViewController () <GKGameCenterControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_TotalScore;
@property (weak, nonatomic) IBOutlet UILabel *label_TotalAverage;
@property (weak, nonatomic) IBOutlet UILabel *label_Level1;
@property (weak, nonatomic) IBOutlet UILabel *label_Level2;
@property (weak, nonatomic) IBOutlet UILabel *label_Level3;
@property (weak, nonatomic) IBOutlet UILabel *label_Level4;
@property (weak, nonatomic) IBOutlet UILabel *label_Level5;
@property (weak, nonatomic) IBOutlet UILabel *label_Level6;
@property (weak, nonatomic) IBOutlet UILabel *label_Level1_subtitle;
@property (weak, nonatomic) IBOutlet UILabel *label_Level2_subtitle;
@property (weak, nonatomic) IBOutlet UILabel *label_Level3_subtitle;
@property (weak, nonatomic) IBOutlet UILabel *label_Level4_subtitle;
@property (weak, nonatomic) IBOutlet UILabel *label_Level5_subtitle;
@property (weak, nonatomic) IBOutlet UILabel *label_Level6_subtitle;

@end

@implementation MPRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIImage *image;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        image = [UIImage imageNamed:@"infoBackPad"];
    }
    else {
        image = [UIImage imageNamed:@"infoBack"];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    self.label_TotalScore.text = [[MainCenter share] Point];
    self.label_TotalAverage.text = [[MainCenter share] Skill];
    

    NSArray *arrLabel = @[
                      self.label_Level1,
                      self.label_Level2,
                      self.label_Level3,
                      self.label_Level4,
                      self.label_Level5,
                      self.label_Level6
                      ];
    NSArray *arrSubTitle = @[
                     self.label_Level1_subtitle,
                     self.label_Level2_subtitle,
                     self.label_Level3_subtitle,
                     self.label_Level4_subtitle,
                     self.label_Level5_subtitle,
                     self.label_Level6_subtitle
                     ];
    
    for (int i=0;i<=5;i++) {
        UILabel *label = [arrLabel objectAtIndex:i];
         UILabel *label_Subtitle = [arrSubTitle objectAtIndex:i];
        double lv = [[MainCenter share] LevelPercent:(GameLevel)i]*100;
        label.text = [NSString stringWithFormat:@"%.2f%%",lv];
        if (lv != 0) {
            label_Subtitle.text = @"";
            label_Subtitle.frame = CGRectMake(label_Subtitle.frame.origin.x, label_Subtitle.frame.origin.y, label_Subtitle.frame.size.width, 6);
            label_Subtitle.layer.borderColor = [[UIColor orangeColor] CGColor];
            label_Subtitle.layer.borderWidth = 1.0f;
            
            CGRect TempRect = label_Subtitle.frame;
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor orangeColor];
            view.frame = CGRectMake(TempRect.origin.x, TempRect.origin.y, lv*2.9 , TempRect.size.height);
            [self.view addSubview:view];
        }
        else {
            label_Subtitle.text = [NSString stringWithFormat:NSLocalizedString(@"subtitle", nil),[[MainCenter share] GetLevelLimitTimes:(GameLevel)i]];
        }
    }
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) prefersStatusBarHidden {
    return YES;
}

- (IBAction)LevelTap:(UIButton *)sender {
    if ([[MainCenter share] gameCenterEnabled] == YES) {
     [self showLeaderboard:IDENTIFIER_DEFAULT];
    }
    else {
        [self authenticateLocalPlayer];
    }
/*
    if ([[MainCenter share] gameCenterEnabled] == YES) {
        if (sender.tag == 1) {
            [self showLeaderboard:IDENTIFIER_LEVEL1];
        }
        else if (sender.tag == 2) {
            [self showLeaderboard:IDENTIFIER_LEVEL2];
        }
        else if (sender.tag == 3) {
            [self showLeaderboard:IDENTIFIER_LEVEL3];
        }
        else if (sender.tag == 4) {
            [self showLeaderboard:IDENTIFIER_LEVEL4];
        }
        else if (sender.tag == 5) {
            [self showLeaderboard:IDENTIFIER_LEVEL5];
        }
        else if (sender.tag == 6) {
            [self showLeaderboard:IDENTIFIER_LEVEL6];
        }
        else if (sender.tag == 7) {
            [self showLeaderboard:IDENTIFIER_DEFAULT];
        }
        else if (sender.tag == 8) {
            [self showLeaderboard:IDENTIFIER_AVERAGE];
        }
    }
 */
}



#pragma mark -
#pragma mark GameCneter
#pragma mark -

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
                NSLog(@"LocalPlayer = authenticated failed");
                [[MainCenter share] setGameCenterEnabled:NO];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", nil) message:NSLocalizedString(@"message", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    };
}


-(void)showLeaderboard:(NSString *) Identifier{
    if ([[MainCenter share] gameCenterEnabled] == NO) {
        return;
    }
    
    // Init the following view controller object.
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    // Set self as its delegate.
    gcViewController.gameCenterDelegate = self;
    gcViewController.leaderboardIdentifier = nil;
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    //gcViewController.leaderboardIdentifier = Identifier;
    
    // Finally present the view controller.
    [self presentViewController:gcViewController animated:YES completion:nil];
}

#pragma mark - GKGameCenterControllerDelegate method implementation

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
