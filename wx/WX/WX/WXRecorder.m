//
//  WXRecorder.m
//  WX
//
//  Created by zuowu on 2018/12/6.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "WXRecorder.h"


#define RecoderManagerKey "RecoderManagerKey"

@implementation WXRecoderManagerStarObject
@synthesize duration = duration;
@synthesize sampleRate = _sampleRate;
@synthesize numberOfChannels = _numberOfChannels;
@synthesize encodeBitRate = _encodeBitRate;
@synthesize format = _format;
@synthesize frameSize = _frameSize;
@synthesize audioSource = _audioSource;
@end


@interface WXRecoderManager()
@property (nonatomic, strong) AVAudioRecorder * recorder;
@property (nonatomic, strong) AVAudioPlayer * player;
@property (nonatomic, strong) NSURL * recordFilUrl;
@end

@implementation WXRecoderManager

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



-(NSURL *)getSavePath{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [path stringByAppendingString:@"/recorder"];
    NSLog(@"file path = %@", filePath);
    return [NSURL fileURLWithPath:filePath];
}

-(NSDictionary *)getAudioSettion
{

    NSMutableDictionary * dicM = [[NSMutableDictionary alloc] init];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般的录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
     //设置通道，这里采用单声道
     [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数，分为8，16，24，32
     [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
     //是否使用浮点数采样
     [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
     //。。。。是他设置
     return dicM;
    
}


-(AVAudioRecorder *)recorder{
    if (!_recorder) {
        NSURL * url = [self getSavePath];
        _recorder = [[AVAudioRecorder alloc]initWithURL:url settings:[self getAudioSettion] error:nil];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;//如果要控制声波则必须设置为YES
    }
    return _recorder;
}

-(AVAudioPlayer *)player{
    if (!_player) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getSavePath] error:nil];
        _player.numberOfLoops = 0;
        [_player prepareToPlay];
    }
    return _player;
}



-(void)star:(id<WXRecoderManagerStarObject>) object{
    

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (granted) {
            // 通过验证
            NSLog(@"通过");
            if (!self.recorder.isRecording) {
                [self.recorder record];
            }
            
        } else {
            // 未通过验证
            NSLog(@"未通过");
        }
    }];
}

-(void)stop{
    [self.recorder stop];
}

-(void)play{
    if (!self.player.isPlaying) {
        self.player.numberOfLoops = 0;
        [self.player prepareToPlay];
        [self.player play];
    }
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"finish success = %d, %@",flag, recorder);
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur recorder = %@", recorder);
}



@end



@interface WX()


@end



@implementation WX (WXRecorder)


-(WXRecoderManager *) getRecoderManager{
    WXRecoderManager * _recoderManager = objc_getAssociatedObject(self, RecoderManagerKey);
    if (!_recoderManager) {
        _recoderManager = [[WXRecoderManager alloc] init];
        objc_setAssociatedObject(self, RecoderManagerKey, _recoderManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _recoderManager;
}

@end
