//
//  KKApp.h
//  KK
//
//  Created by zhanghailong on 2018/10/31.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void * KKAppCPointer;

@class KKApp;

@protocol KKAppDelegate <NSObject>

@optional

-(BOOL) KKApp:(KKApp *) app openURI:(NSString *) uri;

-(BOOL) KKApp:(KKApp *) app openPageViewController:(NSString *) path animated:(BOOL) animated query:(NSDictionary<NSString *,NSString *> *) query;

-(BOOL) KKApp:(KKApp *) app openPageWindow:(NSString *) path animated:(BOOL) animated query:(NSDictionary<NSString *,NSString *> *) query;

-(BOOL) KKApp:(KKApp *) app openApp:(NSString *) url animated:(BOOL) animated query:(NSDictionary<NSString *,NSString *> *) query;

-(BOOL) KKApp:(KKApp *) app openViewController:(UIViewController *) viewController animated:(BOOL) animated;

@end

@interface KKApp : NSObject

@property(nonatomic,strong) UIViewController * rootViewController;
@property(nonatomic,strong,readonly) NSString * basePath;
@property(nonatomic,assign,readonly) KKAppCPointer CPointer;
@property(nonatomic,weak) id<KKAppDelegate> delegate;

-(instancetype) initWithBasePath:(NSString *) basePath;

-(void) run:(NSDictionary<NSString *,NSString *> *) query;

-(void) open:(NSString *) uri animated:(BOOL) animated;

-(void) openPageViewController:(NSString *) path animated:(BOOL) animated query:(NSDictionary<NSString *,NSString *> *) query;

-(void) openPageWindow:(NSString *) path animated:(BOOL) animated query:(NSDictionary<NSString *,NSString *> *) query;

-(void) openApp:(NSString *) url animated:(BOOL) animated query:(NSDictionary<NSString *,NSString *> *) query;

-(void) openViewController:(UIViewController *) viewController animated:(BOOL) animated;

+(NSString *) encodeURL:(NSString *) url;

+(NSString *) decodeURL:(NSString *) url;

@end
