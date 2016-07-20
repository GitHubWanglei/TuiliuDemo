//
//  ViewController.m
//  推流Demo
//
//  Created by lihongfeng on 16/7/13.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "LivePreview.h"
#import "LFLivePreview.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) LivePreview *livePreview;

@property (nonatomic, strong) UIButton *startLiveBtn;// 开始/停止直播按钮
@property (nonatomic, strong) UILabel *liveStatusLabel;// 直播状态
@property (nonatomic, strong) UIButton *cameraBtn;// 前置/后置相机切换按钮

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self.view addSubview:[[LFLivePreview alloc] initWithFrame:self.view.bounds]];
    
    [self addLiveView];
    
}

- (void)addLiveView{
    NSString *url = @"rtmp://192.168.138.199:1935/video/room";
    self.livePreview = [LivePreview previewWithFrame:self.view.bounds streamUrlStr:url];
    [self.livePreview liveStateDidChange:^(LFLiveSession *session, LFLiveState state) {
        NSString *str = @"未连接!";
        switch (state) {
            case LFLiveReady:
                NSLog(@"liveStateDidChange: %ld 未连接", (unsigned long)state);
                str = @"未连接!";
                break;
            case LFLivePending:
                NSLog(@"liveStateDidChange: %ld 连接中...", (unsigned long)state);
                str = @"连接中...";
                break;
            case LFLiveStart:
                NSLog(@"liveStateDidChange: %ld 已连接", (unsigned long)state);
                str = @"已连接 √";
                break;
            case LFLiveError:
                NSLog(@"liveStateDidChange: %ld 连接错误", (unsigned long)state);
                str = @"连接错误!";
                break;
            case LFLiveStop:
                NSLog(@"liveStateDidChange: %ld 未连接", (unsigned long)state);
                str = @"未连接!";
                break;
            default:
                break;
        }
        _liveStatusLabel.text = str;
        if ([str isEqualToString:@"已连接 √"]) {
            _liveStatusLabel.textColor = [UIColor greenColor];
        }else{
            _liveStatusLabel.textColor = [UIColor redColor];
        }
    }];
    [self.livePreview liveDebugInfo:^(LFLiveSession *session, LFLiveDebug *debugInfo) {
        NSLog(@"debugInfo: %lf", debugInfo.dataFlow);
    }];
    [self.livePreview liveSocketErrorCode:^(LFLiveSession *session, LFLiveSocketErrorCode errorCode) {
        NSLog(@"errorCode: %lu", (unsigned long)errorCode);
    }];
    [self.livePreview setBeautyFace:NO];
    
    [self.view addSubview:self.livePreview];
    [self.view addSubview:self.startLiveBtn];
    [self.view addSubview:self.liveStatusLabel];
}

- (UIButton *)startLiveBtn{
    if (!_startLiveBtn) {
        CGRect btn_frame = CGRectMake(50, SCREEN_HEIGHT - 80, SCREEN_WIDTH - 2*50, 40);
        _startLiveBtn = [[UIButton alloc] initWithFrame:btn_frame];
        _startLiveBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [_startLiveBtn setTitleColor:[UIColor colorWithRed:115/255.0 green:200/255.0 blue:46/255.0 alpha:1] forState:UIControlStateNormal];
        [_startLiveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
        _startLiveBtn.layer.cornerRadius = 8;
        [_startLiveBtn addTarget:self action:@selector(starBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startLiveBtn;
}
- (void)starBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.livePreview starLive];
        [_startLiveBtn setTitle:@"停止直播" forState:UIControlStateNormal];
    }else{
        [self.livePreview stopLive];
        [_startLiveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    }
}

- (UILabel *)liveStatusLabel{
    if (!_liveStatusLabel) {
        CGRect label_frame = CGRectMake(15, 20, 80, 30);
        _liveStatusLabel = [[UILabel alloc] initWithFrame:label_frame];
        _liveStatusLabel.text = @"未连接!";
        _liveStatusLabel.textColor = [UIColor redColor];
        _liveStatusLabel.textAlignment = NSTextAlignmentCenter;
        _liveStatusLabel.backgroundColor = [UIColor clearColor];
    }
    return _liveStatusLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end






