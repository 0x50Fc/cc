//
//  KKPage.h
//  KK
//
//  Created by hailong11 on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KK/KKApp.h>

typedef void * KKPageCPointer;

@interface KKPage : NSObject

@property(nonatomic,readonly,strong) KKApp  * app;
@property(nonatomic,readonly,strong) UIView * view;
@property(nonatomic,assign,readonly) KKPageCPointer CPointer;

-(instancetype) initWithView:(UIView *) view app:(KKApp *) app;

-(void) run:(NSString *) path query:(NSDictionary<NSString *,NSString *> *) query;

@end

