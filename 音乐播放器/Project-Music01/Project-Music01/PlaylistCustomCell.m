//
//  PlaylistCustomCell.m
//  Project-Music01
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import "PlaylistCustomCell.h"
#import "UIImageView+WebCache.h"
@interface PlaylistCustomCell ()
@property (weak, nonatomic) IBOutlet UIImageView *musicPic;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;

@end

@implementation PlaylistCustomCell
-(void)setCellWithMusicInfo:(MusicInfo *)musicInfo
{
    //音乐名称Lable赋值
    self.musicName.text = musicInfo.name;
    //歌手名称Lable赋值
    self.singerName.text = musicInfo.singer;
    //使用第三方加载图片
    [self.musicPic sd_setImageWithURL:[NSURL URLWithString:musicInfo.picUrl]placeholderImage:[UIImage imageNamed:@"2"]];
    self.musicPic.layer.cornerRadius = self.musicPic.frame.size.width / 2;
    self.musicPic.clipsToBounds = YES;

}

@end
