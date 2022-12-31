//
//  RCWCenter.h
//  PinBall
//
//  Created by MartyLin on 1/19/15.
//  Copyright (c) 2015 Rubber City Wizards. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *SETTING_CurrentLevel = @"CurrentLevel";
static NSString *SETTING_PlayCount = @"PlayCountDic";
static NSString *SETTING_JackpotCount = @"JackpotCountDic";
static NSString *SETTING_AchievementCounts = @"AchievementsDic";


static NSString *IDENTIFIER_DEFAULT = @"MyPinBallTotalScore";
static NSString *IDENTIFIER_AVERAGE = @"MyPinBallTotalAverage";
static NSString *IDENTIFIER_LEVEL1 = @"MyPinBall.Level.1";
static NSString *IDENTIFIER_LEVEL2 = @"MyPinBall.Level.2";
static NSString *IDENTIFIER_LEVEL3 = @"MyPinBall.Level.3";
static NSString *IDENTIFIER_LEVEL4 = @"MyPinBall.Level.4";
static NSString *IDENTIFIER_LEVEL5 = @"MyPinBall.Level.5";
static NSString *IDENTIFIER_LEVEL6 = @"MyPinBall.Level.6";


typedef enum {
    Level_1 = 0,
    Level_2 = 1,
    Level_3 = 2,
    Level_4 = 3,
    Level_5 = 4,
    Level_6 = 5
}GameLevel;

@interface MainCenter : NSObject
@property GameLevel currentLevel;
@property (nonatomic,strong) NSMutableDictionary *JackpotCountDic;
@property (nonatomic,strong) NSMutableDictionary *PlayCountDic;
@property (nonatomic,strong) NSMutableDictionary *AchievementsDic;
@property (nonatomic,strong) NSDictionary *levelLimitDic;
@property (nonatomic,strong) NSDictionary *levelPrecentDic;
@property BOOL gameCenterEnabled;
//@property (nonatomic,strong) NSArray *leaderboards;

+(id)share;
-(NSString *) GetLevelString:(GameLevel) level;
-(void) isJackpot:(BOOL) jackpot;
-(NSString *) Skill;
-(NSString *) Point;
-(void) SaveData;
-(NSInteger) GetLevelScore:(GameLevel) level;
-(void) SetAudioOFF:(BOOL) audioOFF;
-(BOOL) AudioOn;
-(double) LevelPercent:(GameLevel) level;
-(NSInteger) GetLevelLimitTimes:(GameLevel) level;
@end
