//
//  PlayerConsole.h
//  Project-Music01
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"
@interface PlayerConsole : UIView

/*
 当每次准备播放一首歌时的方法
 参数为音乐模型类
 */
- (void)prepareMusicInfo:(MusicInfo *)musicInfo;

/*
 当音乐已经播放时所调用的方法
 参数是格式化的时间字符串
 */
- (void)playMusicWithFormatString:(NSString *)string;

@end
