//
//  WXRecorder.h
//  WX
//
//  Created by zuowu on 2018/12/6.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import <WX/WX.h>
#import <AVFoundation/AVFoundation.h>

@protocol WXRecoderManagerStarObject <NSObject>
@property (nonatomic, assign) int duration;             //录音的时长，单位 ms，最大值 600000（10 分钟）
@property (nonatomic, assign) int sampleRate;           //采样率
@property (nonatomic, assign) int numberOfChannels;     //通道数
@property (nonatomic, assign) int encodeBitRate;        //编码码率
@property (nonatomic, copy) NSString * format;          //音频格式
@property (nonatomic, assign) int frameSize;            //指定帧大小，单位 KB。每录制指定帧大小的内容后，会回调录制的文件内容，不指定则不会回调。暂仅支持 mp3 格式。
@property (nonatomic, copy) NSString * audioSource;     //指定录音的音频输入源 耳机麦克风 手机麦克风 等可通过 wx.getAvailableAudioSources() 获取当前可用的音频源
@end

@interface WXRecoderManagerStarObject : NSObject <WXRecoderManagerStarObject>
@end

@interface WXRecoderManager : NSObject <AVAudioRecorderDelegate>
-(void)star:(id<WXRecoderManagerStarObject>) object;
-(void)stop;
-(void)play;
@end

@interface WX (WXRecorder)

-(WXRecoderManager *) getRecoderManager;

@end


