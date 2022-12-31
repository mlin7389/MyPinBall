//
//  RCWSettingViewController.m
//  MyPinBall
//
//  Created by MartyLin on 1/21/15.
//
//

#import "RCWSettingViewController.h"

@interface RCWSettingViewController () <UINavigationBarDelegate>
@property (nonatomic,weak) IBOutlet UITextField *txt1;
@property (nonatomic,weak) IBOutlet UITextField *txt2;
@property (nonatomic,weak) IBOutlet UITextField *txt3;
@property (nonatomic,weak) IBOutlet UITextField *txt4;
@property (nonatomic,weak) IBOutlet UITextField *txt5;
@property (nonatomic,weak) IBOutlet UITextField *txt6;
@end

@implementation RCWSettingViewController {
    NSArray *arr;
}

-(UIBarPosition) positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

-(IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)Save:(id)sender {
    
    for (int i=0;i<6;i++){
        UITextField *text = [arr objectAtIndex:i];
        GameLevel level = (GameLevel)i;
        NSString *key = [[MainCenter share] GetLevelString:level];
        
        NSArray *content = [text.text componentsSeparatedByString:@"."];
        [[[MainCenter share] PlayCountDic] setObject:[content firstObject] forKey:key];
        [[[MainCenter share] JackpotCountDic] setObject:[content objectAtIndex:1] forKey:key];
        [[[MainCenter share] AchievementsDic] setObject:[content lastObject] forKey:key];
        [[MainCenter share] SaveData];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMainView" object:[NSNumber numberWithBool:YES]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[[[MainCenter share] JackpotCountDic] description]);
    NSLog(@"%@",[[[MainCenter share] PlayCountDic] description]);
    NSLog(@"%@",[[[MainCenter share] AchievementsDic] description]);
    
    arr = @[self.txt1,self.txt2,self.txt3,self.txt4,self.txt5,self.txt6];
    
    for (int i=0;i<6;i++){
        UITextField *text = [arr objectAtIndex:i];
        GameLevel level = (GameLevel)i;
        NSString *key = [[MainCenter share] GetLevelString:level];
        NSNumber *a1 = [[[MainCenter share] PlayCountDic] objectForKey:key];
        NSNumber *a2 = [[[MainCenter share] JackpotCountDic] objectForKey:key];
        NSNumber *a3 = [[[MainCenter share] AchievementsDic] objectForKey:key];
        text.text= [NSString stringWithFormat:@"%@.%@.%@",a1,a2,a3];
    }
    //arr = @[,self.txt2,self.txt3,self.txt4,self.txt5,self.txt6];
    
    self.txt1.text = @"37.31.1";
    self.txt2.text = @"53.33.81";
    self.txt3.text = @"72.66.8";
    self.txt4.text = @"86.48.12";
    self.txt5.text = @"95.70.5";
    self.txt6.text = @"66.33.8";
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
