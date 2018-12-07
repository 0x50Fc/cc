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
@end

@implementation WXRecoderManager

@synthesize recorder = _recorder;



-(void)star:(id<WXRecoderManagerStarObject>) object{
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    NSError * sessionError;
    NSError * seesionActiveError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (sessionError) {
        return;
    }
    [session setActive:YES error:&seesionActiveError];
    if (seesionActiveError) {
        return;
    }
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [path stringByAppendingString:@"/recorder.wav"];
    NSURL * recordFilUrl = [NSURL fileURLWithPath:filePath];
    
//    self.recorder = [AVAudioRecorder alloc] initWithURL:recordFilUrl format:<#(nonnull AVAudioFormat *)#> error:nil
    self.recorder = [[AVAudioRecorder alloc] initWithURL:recordFilUrl settings:@{} error:nil];
    
//    NSMutableDictionary * setting = [[NSMutableDictionary alloc] init];
//
//
//    NSString * strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
 
    
    
    
    
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
