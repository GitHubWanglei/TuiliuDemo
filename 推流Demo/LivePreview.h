//
//  LivePreview.h
//  推流Demo
//
//  Created by wanglei on 16/7/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFLiveSession.h"

typedef void(^LiveStateDidChange)(LFLiveSession *session, LFLiveState state);
typedef void(^LiveDebugInfo)(LFLiveSession *session, LFLiveDebug *debugInfo);
typedef void(^LiveSocketErrorCode)(LFLiveSession *session, LFLiveSocketErrorCode errorCode);

@interface LivePreview : UIView

//初始化方法
+ (instancetype)previewWithFrame:(CGRect)frame streamUrlStr:(NSString *)urlStr;
//开始
- (void)starLive;
//停止
- (void)stopLive;
//美颜
- (void)setBeautyFace:(BOOL)beautyFace;

/** live status changed will callback */
- (void)liveStateDidChange:(LiveStateDidChange)stateDidChange;
/** live debug info callback */
- (void)liveDebugInfo:(LiveDebugInfo)debugInfo;
/** callback socket errorcode */
- (void)liveSocketErrorCode:(LiveSocketErrorCode)errorCode;

@end
