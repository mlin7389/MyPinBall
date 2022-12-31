//
//  MPAppDelegate.m
//  MyPinBall
//
//  Created by MartyLin on 1/20/15.
//
//

@import AVFoundation;

#import "MPAppDelegate.h"

@implementation MPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeDefault error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            NSString *productid = @"960269212";
            [[UIApplication sharedApplication] openURL:([NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", productid]])];
        }
        else if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DoNotShowReview"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    BOOL DoNotShowReview = [[NSUserDefaults standardUserDefaults] boolForKey:@"DoNotShowReview"];
    if (DoNotShowReview == NO) {
        NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"RunIndex"];
        if (index % 3 == 0 && index != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Review1",nil) message:NSLocalizedString(@"Review2",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Review3",nil) otherButtonTitles:NSLocalizedString(@"Review4",nil),NSLocalizedString(@"Review5",nil), nil];
            [alert setDelegate:self];
            alert.tag = 2;
            [alert show];
        }
        index += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"RunIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
