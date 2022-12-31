//
//  RCWCenter.m
//  PinBall
//
//  Created by MartyLin on 1/19/15.
//  Copyright (c) 2015 Rubber City Wizards. All rights reserved.
//

#import "MainCenter.h"



@implementation MainCenter  {

    BOOL _AudioPOff;
}


-(id) init {
    self = [super init];
    if (self) {
        _AudioPOff =  [[NSUserDefaults standardUserDefaults] boolForKey:@"AudioOFF"];
        
        self.currentLevel = (GameLevel)[[NSUserDefaults standardUserDefaults] integerForKey:SETTING_CurrentLevel];
        self.JackpotCountDic= [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTING_JackpotCount]];
        self.PlayCountDic= [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTING_PlayCount]];

          self.AchievementsDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTING_AchievementCounts]];
        
 
        
        if ([self.JackpotCountDic count] != 6) {
            self.JackpotCountDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                     [self GetLevelString:Level_1]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_2]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_3]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_4]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_5]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_6]:[NSNumber numberWithInteger:0],
                                     }];
            self.PlayCountDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                     [self GetLevelString:Level_1]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_2]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_3]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_4]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_5]:[NSNumber numberWithInteger:0],
                                     [self GetLevelString:Level_6]:[NSNumber numberWithInteger:0],
                                     }];
            self.AchievementsDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   [self GetLevelString:Level_1]:[NSNumber numberWithInteger:0],
                                                                                   [self GetLevelString:Level_2]:[NSNumber numberWithInteger:0],
                                                                                   [self GetLevelString:Level_3]:[NSNumber numberWithInteger:0],
                                                                                   [self GetLevelString:Level_4]:[NSNumber numberWithInteger:0],
                                                                                   [self GetLevelString:Level_5]:[NSNumber numberWithInteger:0],
                                                                                   [self GetLevelString:Level_6]:[NSNumber numberWithInteger:0],
                                                                                   }];
            [self SaveData];
        }
    
 
        self.levelLimitDic = @{
                              [self GetLevelString:Level_1]:[NSNumber numberWithInteger:5],
                              [self GetLevelString:Level_2]:[NSNumber numberWithInteger:5],
                              [self GetLevelString:Level_3]:[NSNumber numberWithInteger:5],
                              [self GetLevelString:Level_4]:[NSNumber numberWithInteger:5],
                              [self GetLevelString:Level_5]:[NSNumber numberWithInteger:5],
                              [self GetLevelString:Level_6]:[NSNumber numberWithInteger:5],
                              };
        self.levelPrecentDic = @{
                          [self GetLevelString:Level_1]:[NSNumber numberWithDouble:0.1],
                          [self GetLevelString:Level_2]:[NSNumber numberWithDouble:0.1],
                          [self GetLevelString:Level_3]:[NSNumber numberWithDouble:0.15],
                          [self GetLevelString:Level_4]:[NSNumber numberWithDouble:0.15],
                          [self GetLevelString:Level_5]:[NSNumber numberWithDouble:0.2],
                          [self GetLevelString:Level_6]:[NSNumber numberWithDouble:0.3],
                          };
     
        self.levelLimitDic = @{
                               [self GetLevelString:Level_1]:[NSNumber numberWithInteger:5],
                               [self GetLevelString:Level_2]:[NSNumber numberWithInteger:5],
                               [self GetLevelString:Level_3]:[NSNumber numberWithInteger:5],
                               [self GetLevelString:Level_4]:[NSNumber numberWithInteger:5],
                               [self GetLevelString:Level_5]:[NSNumber numberWithInteger:5],
                               [self GetLevelString:Level_6]:[NSNumber numberWithInteger:5],
                               };
        
       
    }
    return self;
}


+(id) share {
    static MainCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (center == nil) {
            center = [MainCenter new];
        }
    });
    return center;
}

-(void) isJackpot:(BOOL) jackpot {
    
    NSString *CurrentLevelString = [self GetLevelString:self.currentLevel];
    NSInteger count = [[self.AchievementsDic objectForKey:CurrentLevelString] integerValue];
    if (jackpot == YES) {
        count++;
    }
    else {
        count = 0;
    }
    [self.AchievementsDic setObject:[NSNumber numberWithInteger:count] forKey:CurrentLevelString];

     double JackpotCount = [[self.JackpotCountDic objectForKey:CurrentLevelString] doubleValue];
     double PlayCount = [[self.PlayCountDic objectForKey:CurrentLevelString] doubleValue];
    if (jackpot == YES) {
        JackpotCount++;
    }
    PlayCount++;
     [self.JackpotCountDic setObject:[NSNumber numberWithDouble:JackpotCount] forKey:CurrentLevelString];
     [self.PlayCountDic setObject:[NSNumber numberWithDouble:PlayCount] forKey:CurrentLevelString];

    [self SaveData];
}

-(void) SaveData {
     [[NSUserDefaults standardUserDefaults]  setInteger:self.currentLevel forKey:SETTING_CurrentLevel];
    [[NSUserDefaults standardUserDefaults] setObject:self.PlayCountDic forKey:SETTING_PlayCount];
   [[NSUserDefaults standardUserDefaults] setObject:self.JackpotCountDic forKey:SETTING_JackpotCount];
    [[NSUserDefaults standardUserDefaults] setObject:self.AchievementsDic forKey:SETTING_AchievementCounts];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *) Skill {
    double PrecentSkill = 0;
    for (int i=0;i<6;i++){
        GameLevel level = (GameLevel)i;
        double precent = [[self.levelPrecentDic objectForKey:[self GetLevelString:level]] doubleValue];
        PrecentSkill += [self LevelPercent:level] * 100 * precent;
    }
    return [NSString stringWithFormat:@"%.2f%%",PrecentSkill];
}

-(double) LevelPercent:(GameLevel) level {
    double PrecentSkill = 0;
    NSInteger limit = [[self.levelLimitDic objectForKey:[self GetLevelString:level]] integerValue];
    double Level_JackPotCount = [[self.JackpotCountDic objectForKey:[self GetLevelString:level]] doubleValue];
    double Level_PlayCount = [[self.PlayCountDic objectForKey:[self GetLevelString:level]] doubleValue];
    if (Level_PlayCount > limit) {
       // NSLog(@"leve %ld Precent = %.2f",(long)level,Level_JackPotCount/Level_PlayCount);
        PrecentSkill += Level_JackPotCount/Level_PlayCount;
    }
    NSLog(@"PrecentSkill = %.2f",PrecentSkill);
    return PrecentSkill;
}

-(NSString *) Point {
    __block double  totalPoint = 0;
    [self.JackpotCountDic enumerateKeysAndObjectsUsingBlock:^(NSString *key,NSString *value,BOOL *Finished){
        
        if ([key isEqualToString:[self GetLevelString:Level_1]]) {
            totalPoint += [value doubleValue];
        }
        else if ([key isEqualToString:[self GetLevelString:Level_2]]) {
            totalPoint += [value doubleValue]*[self GetLevelScore:Level_2];
        }
        else if ([key isEqualToString:[self GetLevelString:Level_3]]) {
            totalPoint += [value doubleValue]*[self GetLevelScore:Level_3];
        }
        else if ([key isEqualToString:[self GetLevelString:Level_4]]) {
            totalPoint += [value doubleValue]*[self GetLevelScore:Level_4];
        }
        else if ([key isEqualToString:[self GetLevelString:Level_5]]) {
            totalPoint += [value doubleValue]*[self GetLevelScore:Level_5];
        }
        else if ([key isEqualToString:[self GetLevelString:Level_6]]) {
            totalPoint += [value doubleValue]*[self GetLevelScore:Level_6];
        }}];

    return [NSString stringWithFormat:@"%.f",totalPoint];
}

-(NSString *) GetLevelString:(GameLevel) level {
    switch (level) {
        case Level_1:
            return @"Level01";
        case Level_2:
            return @"Level02";
        case Level_3:
            return @"Level03";
        case Level_4:
            return @"Level04";
        case Level_5:
            return @"Level05";
        case Level_6:
            return @"Level06";
    }

}

-(NSInteger) GetLevelScore:(GameLevel) level {
    switch (level) {
        case Level_1:
            return 1;
        case Level_2:
            return 2;
        case Level_3:
            return 3;
        case Level_4:
            return 5;
        case Level_5:
            return 8;
        case Level_6:
            return 10;
    }
}

-(NSInteger) GetLevelLimitTimes:(GameLevel) level {
   return  [[self.levelLimitDic objectForKey:[self GetLevelString:level]] integerValue];
}

-(void) SetAudioOFF:(BOOL) audioOFF {
    _AudioPOff = audioOFF;
    [[NSUserDefaults standardUserDefaults] setBool:_AudioPOff forKey:@"AudioOFF"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL) AudioOn {
   _AudioPOff =  [[NSUserDefaults standardUserDefaults] boolForKey:@"AudioOFF"];
    if (_AudioPOff == NO) {
        return YES;
    }
    else {
        return NO;
    }
}



@end
