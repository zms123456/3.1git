//
//  MusicInfo.m
//  Project-Music01
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import "MusicInfo.h"

@implementation MusicInfo
//只进一次
-(instancetype)init
{
    self = [super init];
    if (self) {
        //实例化时间歌词的数组
        self.timeForLyric = [NSMutableArray new];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }else if([key isEqualToString:@"lyric"])
    {
        [self formatLyricWithLyricStr:value];
    }
}

-(void)formatLyricWithLyricStr:(NSString *)str
{

    //以"\n"拆解字符串:"[00:00.000]ABCD","[00:00.000]BCDEF"
    NSArray *returnArr = [str componentsSeparatedByString:@"\n"];
    for (NSString *tempStr in returnArr) {  
        if (![tempStr isEqualToString:@""]) {
            //在使用"]"拆解字符串后的结果("[00:00.000]","ABCD")
            NSArray *lyricAndTimeArr = [tempStr componentsSeparatedByString:@"]"];
            //将时间拆解成想要的格式:"00:00"，以作为字典的key
            NSString *timeKey = [[lyricAndTimeArr firstObject] substringWithRange:NSMakeRange(1, 5)];
            //以"00:00"，作为字典的key。"ABCD"(数组的最后一位)作为字典的value
            NSDictionary *lyricDic = @{timeKey:[lyricAndTimeArr lastObject]};
            //时间歌词的数组添加时间歌词字典
            [self.timeForLyric addObject:lyricDic];
        }
    }
    
}


@end
