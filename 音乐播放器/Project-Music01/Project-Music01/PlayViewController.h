//
//  PlayViewController.h
//  Project-Music01
//
//  Created by lanou3g on 15/10/26.
//  Copyright © 2015年 dingyuwei. All rights reserved.
//

#import "ViewController.h"

@interface PlayViewController : ViewController

@property (nonatomic,assign) NSUInteger musicIndex;

+ (PlayViewController *)defaultManager;

@end
