//
//  RCWInfoViewController.m
//  PinBall
//
//  Created by MartyLin on 1/20/15.
//  Copyright (c) 2015 Rubber City Wizards. All rights reserved.
//
@import AVFoundation;
@import MessageUI;

#import "RCWInfoViewController.h"
#import "MainCenter.h"
@interface RCWInfoViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *audioButton;
@property (weak, nonatomic) IBOutlet UILabel *label_level1;
@property (weak, nonatomic) IBOutlet UILabel *label_level2;
@property (weak, nonatomic) IBOutlet UILabel *label_level3;
@property (weak, nonatomic) IBOutlet UILabel *label_level4;
@property (weak, nonatomic) IBOutlet UILabel *label_level5;
@property (weak, nonatomic) IBOutlet UILabel *label_level6;

@end

@implementation RCWInfoViewController {
  
}

- (IBAction)goStar:(id)sender {
    NSString *productid = @"960269212";
    [[UIApplication sharedApplication] openURL:([NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", productid]])];
}

- (IBAction)feedback:(id)sender {
    NSArray *toAddress = [NSArray arrayWithObject:@"servicespot@icloud.com"];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:@"Class PinBall"];
    [mc setToRecipients:toAddress];
    [mc setMessageBody:@"" isHTML:NO];
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label_level1.text = [NSString stringWithFormat:@"%ld",(long)[[MainCenter share] GetLevelScore:Level_1]];
    self.label_level2.text = [NSString stringWithFormat:@"%ld",(long)[[MainCenter share] GetLevelScore:Level_2]];
    self.label_level3.text = [NSString stringWithFormat:@"%ld",(long)[[MainCenter share] GetLevelScore:Level_3]];
    self.label_level4.text = [NSString stringWithFormat:@"%ld",(long)[[MainCenter share] GetLevelScore:Level_4]];
    self.label_level5.text = [NSString stringWithFormat:@"%ld",(long)[[MainCenter share] GetLevelScore:Level_5]];
    self.label_level6.text = [NSString stringWithFormat:@"%ld",(long)[[MainCenter share] GetLevelScore:Level_6]];
    
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
    
    if ([[MainCenter share] AudioOn]) {
        self.audioButton.alpha = 1.0f;
    }
    else{
        self.audioButton.alpha = 0.5f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)audioOnOFF:(id)sender {
    
    if (self.audioButton.alpha == 0.5f) {
        [[MainCenter share] SetAudioOFF:NO];
        self.audioButton.alpha = 1.0f;
    }
    else {
        [[MainCenter share] SetAudioOFF:YES];
        self.audioButton.alpha = 0.5f;
    }

}

-(BOOL) prefersStatusBarHidden {
    return YES;
}

-(void) viewDidAppear:(BOOL)animated {
 
  
}

@end
