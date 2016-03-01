//
//  PlaylistViewController.m
//  Project-Music01
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import "PlaylistViewController.h"
#import "PlayViewController.h"
#import "PlayerManager.h"
#import "MusicInfo.h"
#import "PlaylistCustomCell.h"
@interface PlaylistViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;
@property (nonatomic, strong)PlayerManager *playerManger;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation PlaylistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playerManger = [PlayerManager playerManager];
    self.title = @"播放列表";
    [self.playerManger getPlayListCompletionHandler:^{
        NSLog(@"请求完成");
        [self.playlistTableView reloadData];
    }];
    self.backImageView.image = [UIImage imageNamed:@"background"];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playerManger.playlistCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取对应的播放列表自定义的单元格
    PlaylistCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //创建模型接收从单例中返回的数据
    MusicInfo *musicInfo = [self.playerManger getmusicInfoWithIndext:indexPath.row];
    
    [cell setCellWithMusicInfo:musicInfo];
    
    // 设置被选取的cell
    UIView *view = [[UIView alloc]initWithFrame:cell.contentView.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayViewController *playVC = [PlayViewController defaultManager];
    
    playVC.musicIndex = indexPath.row;
    
    [self.navigationController pushViewController:playVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


@end
