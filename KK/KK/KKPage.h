//
//  KKPage.h
//  KK
//
//  Created by zhanghailong on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KK/KKApp.h>

typedef void * KKPageCPointer;

@class KKPage;

@protocol KKPageDelegate

@optional

-(void) KKPage:(KKPage *) page setOptions:(id) options;

@end

@interface KKPage : NSObject

@property(nonatomic,weak) id<KKPageDelegate> delegate;
@property(nonatomic,readonly,strong) KKApp  * app;
@property(nonatomic,readonly,strong) UIView * view;
@property(nonatomic,assign,readonly) KKPageCPointer CPointer;
@property(nonatomic,readonly,strong) NSMutableDictionary * librarys;

-(instancetype) initWithView:(UIView *) view app:(KKApp *) app;

-(void) run:(NSString *) path query:(NSDictionary<NSString *,NSString *> *) query;

-(void) setSize:(CGSize) size;

@end

