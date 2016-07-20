//
//  LivePreview.m
//  推流Demo
//
//  Created by wanglei on 16/7/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "LivePreview.h"


@interface LivePreview ()<LFLiveSessionDelegate>

@property (nonatomic, strong) LFLiveSession *liveSession;
@property (nonatomic, strong) NSString *streamUrlStr;

@property (nonatomic, strong) LiveStateDidChange stateDidChange;
@property (nonatomic, strong) LiveDebugInfo debugInfo;
@property (nonatomic, strong) LiveSocketErrorCode errorCode;

@end

@implementation LivePreview

+ (instancetype)previewWithFrame:(CGRect)frame streamUrlStr:(NSString *)urlStr{
    return [[self alloc] initWithFrame:frame streamUrlStr:urlStr];
}

- (instancetype)initWithFrame:(CGRect)frame streamUrlStr:(NSString *)urlStr{
    if ([super initWithFrame:frame]) {
        if (urlStr.length > 0) {
            self.streamUrlStr = urlStr;
        }else{
            return nil;
        }
    }
    return self;
}

- (void)starLive{
    [self requestAccessForVideo];
    [self requestAccessForAudio];
    LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
    stream.url = self.streamUrlStr;
    [self.liveSession startLive:stream];
}

- (void)stopLive{
    [self.liveSession stopLive];
}

- (void)setBeautyFace:(BOOL)beautyFace{
    [self.liveSession setBeautyFace:beautyFace];
}

- (void)requestAccessForVideo{
    __weak typeof(self) weak_self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:// 首次访问, 系统弹框询问用户是否授权访问
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {//同意授权
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weak_self.liveSession setRunning:YES];
                    });
                }else{//拒绝授权
                    
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:// 用户已同意授权访问
        {
            [weak_self.liveSession setRunning:YES];
            break;
        }
        case AVAuthorizationStatusDenied:// 用户已拒绝授权访问
        {
            break;
        }
        case AVAuthorizationStatusRestricted:// 受限制
        {
            break;
        }
        default:
            break;
    }
}

- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

- (LFLiveSession *)liveSession{
    if (!_liveSession) {
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        _liveSession = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration]
                                                      videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2]
                                                                liveType:LFLiveRTMP];
        _liveSession.delegate = self;
    }
    _liveSession.running = YES;
    _liveSession.preView = self;
    _liveSession.delegate = self;
    return _liveSession;
}

- (void)liveStateDidChange:(LiveStateDidChange)stateDidChange{
    self.stateDidChange = stateDidChange;
}
- (void)liveDebugInfo:(LiveDebugInfo)debugInfo{
    self.debugInfo = debugInfo;
}
- (void)liveSocketErrorCode:(LiveSocketErrorCode)errorCode{
    self.errorCode = errorCode;
}

#pragma mark - LFLiveSessionDelegate

/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    if (self.stateDidChange) {
        self.stateDidChange(session, state);
    }
}
/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    if (self.debugInfo) {
        self.debugInfo(session, debugInfo);
    }
}
/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    if (self.errorCode) {
        self.errorCode(session, errorCode);
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
