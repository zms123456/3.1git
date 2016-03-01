//
//  PlayerManager.m
//  Project-Music01
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import "PlayerManager.h"
#import "Header.h"
#import "MusicTimeFormatter.h"
@import AVFoundation;  // @import只能引入系统框架

@interface PlayerManager ()
@property (nonatomic,strong) NSMutableArray *playlist;
@property (nonatomic,strong) AVPlayer *player; // 播放器属性
@property (nonatomic,strong) NSTimer *timer;  // 定时器
@property (nonatomic,assign) NSInteger currentIndex;  // 当前的音乐下标
@end

@implementation PlayerManager

#pragma make - Lazy loading Method  懒加载
-(NSMutableArray *)playlist
{
    if (!_playlist) {
        _playlist = [NSMutableArray new];
    }
    return _playlist;
}

-(AVPlayer *)player{
    
    if (!_player) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}

// 单例 创建单例的目的是封装必要的方法，提高程序可读性 同时锻炼封装思想
static PlayerManager *playerManager = nil;
+(instancetype)playerManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerManager = [[PlayerManager alloc] init];
    });
    return playerManager;
}

// 初始化 内部对音乐播放状态添加观察者 当音乐播放完成时 调用指定的方法
- (instancetype)init{
    self = [super init];
    if (self) {
        self.currentIndex = -1;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didMusicFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

// 这是当一首歌曲播放完成时调用的方法
- (void)didMusicFinished{
    [self pause];
    [self nextMusic];
    [self musicPlay];
//    if ([self.buttonTitle isEqualToString:@"顺序播放"]) {
//            [self nextMusic];
//            [self musicPlay];
//    }else if ([self.buttonTitle isEqualToString:@"随机播放"]){
//        [self prepareMusic:arc4random() % self.playlist.count ];
//        [self musicPlay];
//    }else {
//        [self prepareMusic:self.currentIndex];
//    }
}

// 获取歌曲列表plist接口 通过block返回 创建异步子线程去实现 防止程序卡死
-(void)getPlayListCompletionHandler:(void(^)())handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //每次调用该获取接口内容的方法，先清除播放列表中已有的数据
        [self.playlist removeAllObjects];
        NSArray *tempArr = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:kPlaylistURL]];
        
        for (NSDictionary *dict in tempArr) {
            //创建Model对象
            MusicInfo *musicInfo = [MusicInfo new];
            //对应的向Model中的属性赋值
            [musicInfo setValuesForKeysWithDictionary:dict];
            [self.playlist addObject:musicInfo];
        }
        // NSLog(@"%@", tempArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用block
          handler();
        });
    });
}

// 返回歌曲列表数量
-(NSUInteger)playlistCount
{
    return self.playlist.count;
}

// 通过外部点击的行数确定是在音乐列表中的哪一条数据 然后将歌曲的模型返回
-(MusicInfo *)getmusicInfoWithIndext:(NSUInteger)index{
    return self.playlist[index];
}

// 预播放音乐 整个程序中调用次数最多的方法 很多地方需要调用这个方法 判断第二次点击的音乐是不是当前正在播放的音乐 然后内部直接调用单例中得到模型的方法 预播放需要实例化一个AVPlayerItem 也就是所谓的CD 实例化的时候使用模型中mp3URL的方法 然后调用AVPlayer中替换当前音乐的方法 也就是说外部的音乐状态改变是从这里边实现的 代理方法的安全判断与执行也从预播放中执行
- (void)prepareMusic:(NSUInteger)index{
 
    if (self.currentIndex != index) {
        self.currentIndex = index;
        // 获取当前音乐信息
        MusicInfo *musicInfo = [self getmusicInfoWithIndext:index];
        
        // 实例化一个PlayerItem作为Player的"CD"
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:musicInfo.mp3Url]];
    
        // 替换当前的PlayerItem
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        
        // 安全判断
        if ([self.delegate respondsToSelector:@selector(didMusicCutWithMusicInfo:)]) {
            [self.delegate didMusicCutWithMusicInfo:musicInfo];
        }
    }else{
        
        
    }
}

/*
 音乐播放
 内部实例化一个计时器 调用监听的频率为0.1s一次
 */
- (void)musicPlay{
    // 实例化一个计时器 并且调用"timerAction"的频率为0.1s
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:true];
    // 开始播放
    [self.player play];
}

/*
 音乐暂停
 */
- (void)pause{
    [self.timer invalidate];
    
    self.timer = nil;
    
    [self.player pause];
}

// 播放上一首歌曲
- (void)upMusic{
    [self prepareMusic:self.currentIndex - 1 < 0 ? self.playlist.count - 1: self.currentIndex - 1];
}

// 播放下一首歌曲
- (void)nextMusic{
    [self prepareMusic:self.currentIndex + 1 < self.playlist.count ? self.currentIndex + 1 : 0 ];
}

// 计时器实现方法
- (void)timerAction{
    // 代理的安全判断
    if ([self.delegate respondsToSelector:@selector(didPlayChangeStatus:)]) {
        // 歌曲播放时向外部调用改变状态的方法
        
        // 获取当前播放的字典类型时间
        CGFloat currentTime = CMTimeGetSeconds(self.player.currentTime);
        // 歌曲播放时向外部调用改变状态的方法 并将格式化后的时间作为参数传出
        [self.delegate didPlayChangeStatus:[MusicTimeFormatter getStringFormatBySeconds:currentTime]];
        // NSLog(@"%f",currentTime);
    }
}

// 音乐时间跳转方法  参数为跳转到的秒数
- (void)musicSeekToTime:(float)time {
    [self.player seekToTime: CMTimeMake(time, 1)];
    
}

// 音乐音量的控制  0.0 ~ 0.1
- (void)musicVolumn:(float)value{
    self.player.volume = value;
    
}

@end
