//
//  PlayerConsole.m
//  Project-Music01
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import "PlayerConsole.h"
#import "MusicTimeFormatter.h"
#import "PlayerManager.h"
@interface PlayerConsole ()

@property (nonatomic,weak) IBOutlet UISlider *timeSlider; // 时间条

@property (nonatomic,weak) IBOutlet UISlider *volumeSlider; // 声音条

@property (nonatomic,weak) IBOutlet UILabel *currentTime; // 当前时间label

@property (nonatomic,weak) IBOutlet UILabel *totalTime;  // 总时间label

@property (nonatomic,weak) IBOutlet UIButton *upButton;  // 上一首button

@property (nonatomic,weak) IBOutlet UIButton *nextButton;  // 下一首button

@property (nonatomic,weak) IBOutlet UIButton *playButton;  // 播放&暂停按钮


@end

@implementation PlayerConsole

- (void)prepareMusicInfo:(MusicInfo *)musicInfo{
    self.currentTime.text = @"00:00";
    
    // 获取音乐模型中的秒数
    NSInteger seconds = [musicInfo.duration intValue] / 1000;
    
    // 使用音乐时间工具类 将秒数转换为格式化后的字符串
    self.totalTime.text = [MusicTimeFormatter getStringFormatBySeconds:seconds];
    
    self.timeSlider.maximumValue = seconds;
    self.volumeSlider.value = 0.4;
    
    self.timeSlider.minimumTrackTintColor = [UIColor blackColor];
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    
    self.volumeSlider.minimumTrackTintColor = [UIColor blackColor];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    
    [self.upButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)playMusicWithFormatString:(NSString *)string{
    self.timeSlider.value = [MusicTimeFormatter getSecondsFormatByString:string];
    self.currentTime.text = string;
    
}

- (IBAction)didPlayButtonClicked:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"播放"]) {
        [[PlayerManager playerManager]musicPlay];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [[PlayerManager playerManager]pause];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }
}

- (IBAction)didTimeSliderValueChanged:(UISlider *)sender{
    [[PlayerManager playerManager]musicSeekToTime:sender.value];
}

- (IBAction)didVolumnSliderValueChanged:(UISlider *)sender{
    [[PlayerManager playerManager]musicVolumn:sender.value];
}

// 上一首按钮的触发事件
- (IBAction)didUpButtonClicked:(UIButton *)sender{
    [[PlayerManager playerManager]upMusic];
}

// 下一首按钮的触发事件
- (IBAction)didNextButtonClicked:(UIButton *)sender{
    [[PlayerManager playerManager]nextMusic];
}

@end
