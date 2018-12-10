//
//  WXRecorder.m
//  WX
//
//  Created by zuowu on 2018/12/6.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXRecorder.h"
#import <AudioUnit/AudioUnit.h>


#define RecoderManagerKey "RecoderManagerKey"

@implementation WXRecorderManagerStarObject
@synthesize duration = duration;
@synthesize sampleRate = _sampleRate;
@synthesize numberOfChannels = _numberOfChannels;
@synthesize encodeBitRate = _encodeBitRate;
@synthesize format = _format;
@synthesize frameSize = _frameSize;
@synthesize audioSource = _audioSource;
@end

@implementation WXRecorderOnStopRes
@synthesize tempFilePath = _tempFilePath;
@end

@implementation WXRecorderOnErrorRes
@synthesize errMsg = _errMsg;
-(instancetype)initWithErrMsg:(NSString *)errMsg{
    if (self = [super init]) {
        self.errMsg = errMsg;
    }
    return self;
}
+(WXRecorderOnErrorRes *)resWithErrorMessage:(NSString *)errMsg{
    return [[WXRecorderOnErrorRes alloc] initWithErrMsg:errMsg];
}
@end

@implementation WXRecorderOnFrameRecordedRes
@synthesize frameBuffer = _frameBuffer;
@synthesize isLastFrame = _isLastFrame;
@end


@interface WXRecorderManager()
@property (nonatomic, strong) AVAudioRecorder * recorder;
@property (nonatomic, strong) AVAudioPlayer * player;
@property (nonatomic, strong) NSURL * recordFilUrl;
@end

@implementation WXRecorderManager

@synthesize onStart = _onStart;
@synthesize onStop = _onStop;
@synthesize onError = _onError;

@synthesize recorder = _recorder;
@synthesize player = _player;
@synthesize recordFilUrl = _recordFilUrl;

-(instancetype)init{
    
    if (self = [super init]) {
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        //[session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        [session setActive:YES error:nil];
    }
    return self;
}



-(AVAudioPlayer *)player{
    if (!_player) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL recordingFileURL] error:nil];
        _player.numberOfLoops = 0;
        [_player prepareToPlay];
    }
    return _player;
}

-(void)stopRecord{
    if (self.recorder && self.recorder.isRecording) {
        [self.recorder stop];
    }
    self.recorder = nil;
}



-(void)star:(id<WXRecorderManagerStarObject>) object{
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        
        if (granted) {
            // 通过验证
            NSLog(@"通过");
            
            //最大时间10分钟
            if (object.duration > 60 * 1000 || object.duration <= 0) {
                //错误返回
                return;
            }
            
            if (self.recorder && self.recorder.isRecording) {
                
                //send err 正在录音或者暂停不能开始
                return;
                
            }else{
                
                self.recorder = [AVAudioRecorder recorderWithStartObject:object];
                self.recorder.meteringEnabled = YES;
                self.recorder.delegate = self;
                
                
                [self.recorder prepareToRecord];
                [self.recorder record];
                
                self.onStart();
                
                //自动到时间后停止
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(object.duration * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                    [self stopRecord];
                });
            }
            
        } else {
            // 未通过验证 send err
            NSLog(@"未通过");
        }
    }];
}

-(void)stop{
    [self stopRecord];
}

-(void)pause{

    if (self.recorder != nil && self.recorder.isRecording) {
        [self.recorder pause];
    }else {
        self.onError([WXRecorderOnErrorRes resWithErrorMessage:@"operateRecorder:fail not recording"]);
    }
}
-(void)resume{
    if (self.recorder != nil) {
        [self.recorder record];
    }
}


-(void)play{
    if (!self.player.isPlaying) {
        self.player.numberOfLoops = 0;
        [self.player prepareToPlay];
        [self.player play];
    }
}


#pragma mark  --  AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"finish success = %d, %@",flag, recorder);
    WXRecorderOnStopRes * res = [[WXRecorderOnStopRes alloc] init];
    res.tempFilePath = [NSURL recordingFileURL].absoluteString;
    self.onStop(res);
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur recorder = %@", recorder);
}



@end

@implementation AVAudioRecorder(WXRecorder)

+(AVAudioRecorder *)recorderWithStartObject:(WXRecorderManagerStarObject *)object{
    
    /*  setting */
    //采样率 默认 8000
    NSNumber * sampleRata = [NSNumber numberWithInt: object.sampleRate == 0 ? 8000 : object.sampleRate];
    //音频通道数 默认 2
    NSNumber * numberOfChannels = [NSNumber numberWithInt: object.numberOfChannels == 0 ? 2 : object.numberOfChannels];
    //音频编码率 默认 48000
    NSNumber * encodeBitRate = [NSNumber numberWithInt:object.encodeBitRate == 0 ? 48000 : object.encodeBitRate];
    //音频格式 默认 aac  kAudioFormatMPEGLayer3 = mp3 , kAudioFormatMPEG4AAC = aac
    NSNumber * format = [NSNumber numberWithInt:kAudioFormatMPEG4AAC];
    if (object.format != nil && [object.format isEqualToString:@"mp3"]) {
        format = [NSNumber numberWithInt:kAudioFormatMPEGLayer3];
    }else if (object.format != nil && [object.format isEqualToString:@"aac"]) {
        format = [NSNumber numberWithInt:kAudioFormatMPEG4AAC];
    }
    
    NSDictionary * setting = @{
        AVSampleRateKey: sampleRata,
        AVNumberOfChannelsKey: numberOfChannels,
        AVEncoderBitRateKey: encodeBitRate,
        AVFormatIDKey: format
    };
    
    NSError * err;
    AVAudioRecorder * recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL recordingFileURL] settings:setting error:&err];
    if (!err) {
        return recorder;
    }else {
        //send err
        return nil;
    }
    
}

@end

@implementation NSURL(WXRecorder)
+(NSURL *)recordingFileURL{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [NSURL fileURLWithPath:[path stringByAppendingString:@"/recorder"]];
}
@end


@interface WX()


@end



@implementation WX (WXRecorder)


-(WXRecorderManager *) getRecoderManager{
    WXRecorderManager * _recoderManager = objc_getAssociatedObject(self, RecoderManagerKey);
    if (!_recoderManager) {
        _recoderManager = [[WXRecorderManager alloc] init];
        objc_setAssociatedObject(self, RecoderManagerKey, _recoderManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _recoderManager;
}

@end
