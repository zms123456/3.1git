//
//  PlaylistCustomCell.h
//  Project-Music01
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"
@interface PlaylistCustomCell : UITableViewCell
/*
 *设置单元格使用信息对应赋值
 *@param musicInfo 音乐信息
 *
 */
-(void)setCellWithMusicInfo:(MusicInfo *)musicInfo;

@end
