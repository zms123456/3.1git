//
//  PlayViewController.m
//  Project-Music01
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayerManager.h"
#import "UIImageView+WebCache.h"
#import "PlayerConsole.h"
@interface PlayViewController ()<UITableViewDataSource, UITableViewDelegate,playerManagerDelegate>

@property (nonatomic,strong) PlayerManager *playManager;
@property (weak, nonatomic) IBOutlet UIImageView *musicPic;
@property (weak, nonatomic) IBOutlet UITableView *musicLyric;
@property (nonatomic,strong) NSArray *lyricArr;
@property (weak, nonatomic) IBOutlet PlayerConsole *playerConsole;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@end

@implementation PlayViewController

// 将播放页面视图做成单例 对操作状态进行保存
static PlayViewController *s_defaultManager = nil;
+ (PlayViewController *)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        s_defaultManager = [storyBoard instantiateViewControllerWithIdentifier:@"PlayViewController"];
    });
    return s_defaultManager;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 调用准备播放的歌曲同时获取到MusicInfo
    [self.playManager prepareMusic:self.musicIndex];
    
}

// 因为使用单例界面改变了当前视图的生命周期 导致ViewDidLoad只可以执行一次 需要将一部分实现放到ViewWillAppear
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playManager = [PlayerManager playerManager];
    
    self.playManager.delegate = self;
    
    // 专辑图片
    // 将改变约束的生命周期提前
    [self.musicPic layoutIfNeeded];
    [self.musicPic.layer setMasksToBounds:YES];
    [self.musicPic.layer setCornerRadius:self.musicPic.frame.size.width / 2];

    self.scrollerView.showsHorizontalScrollIndicator = NO;
}

// 歌词按钮触发方法
- (IBAction)lyricButton:(id)sender {
    
    NSInteger b = self.view.frame.size.width;
    [self.scrollerView setContentOffset:CGPointMake(b, 0) animated:YES];
    
}
// 收藏按钮
- (IBAction)collectButton:(id)sender {
    NSLog(@"收藏成功");
}

- (IBAction)styleButton:(UIButton *)sender {
    
//    if ([sender.titleLabel.text isEqualToString:@"顺序播放"]) {
//        [sender setTitle:@"随机播放" forState:UIControlStateNormal];
//        self.playManager.buttonTitle = @"随机播放";
//        
//    }else if ([sender.titleLabel.text isEqualToString:@"随机播放"]){
//        [sender setTitle:@"单曲循环" forState:UIControlStateNormal];
//        self.playManager.buttonTitle = @"单曲循环";
//        
//    }else{
//        [sender setTitle:@"顺序播放" forState:UIControlStateNormal];
//        self.playManager.buttonTitle = @"顺序播放";
//        
//    }
}


#pragma mark - Player Manager Delegate
-(void)didPlayChangeStatus:(NSString *)time{
    // NSLog(@"音乐在播放");
    
    [self.playerConsole playMusicWithFormatString:time];
    
    // 遍历当前数组中的元素
    for (int i = 0; i < self.lyricArr.count; i++) {
        
        // 找到被遍历的字典
        NSDictionary *dic = self.lyricArr[i];
        
        // [[dic allKeys]lastObject]找到字典中的字符串Key
        if ([time isEqualToString:[[dic allKeys]lastObject]]) {
            
            [self.musicLyric selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    
    self.musicPic.transform = CGAffineTransformRotate(self.musicPic.transform, M_PI/360);
}


- (void)didMusicCutWithMusicInfo:(MusicInfo *)musicInfo{
    
    // 控制台
    [self.playerConsole prepareMusicInfo:musicInfo];
    
    // 将时间歌词添加到当前VC的数组中
    self.lyricArr = [[NSArray alloc]initWithArray:musicInfo.timeForLyric];
    
    //刷新TableView
    [self.musicLyric reloadData];
    
    [self.musicPic sd_setImageWithURL:[NSURL URLWithString:musicInfo.picUrl] placeholderImage:nil];
    
    
    self.backImageView.image = [UIImage imageNamed:@"background"];
    self.backImageView.alpha = 0.8;
 
    self.navigationItem.title = musicInfo.name;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.lyricArr[indexPath.row];
    
    cell.textLabel.text = dic.allValues[0];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    [cell.textLabel setNumberOfLines:0];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    // 设置文字高亮颜色
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:1];
    
    // 设置被选取的cell
    UIView *view = [[UIView alloc]initWithFrame:cell.contentView.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    
    return cell;
}

@end
