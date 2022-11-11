//
//  XDFindAppsTool.h
//  FindApps
//
//  Created by wangxiangzhao on 2022/11/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSApplicationWorkspace.h"
#import "LSApplicationProxy.h"
#import "LSPlugInKitProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDFindAppsTool : NSObject

+ (LSApplicationWorkspace *)workspace;
//获取所有的App
+ (NSSet<LSApplicationProxy *> *)allApps;

///可以是各个Appid 通过,拼接， 一次请求多个
+ (void)getInfoWithItemID:(NSString *)itemID completedHandler:(void(^)(NSArray *infos))completedHandler;
//下载图片
+ (void)downloadImageWithPath:(NSString *)path completedHandler:(void(^)(UIImage  * _Nullable image))completedHandler;

@end

NS_ASSUME_NONNULL_END
