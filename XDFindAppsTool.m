//
//  XDFindAppsTool.m
//  FindApps
//
//  Created by wangxiangzhao on 2022/11/11.
//

#import "XDFindAppsTool.h"
#import <objc/runtime.h>

@implementation XDFindAppsTool

+ (LSApplicationWorkspace *)workspace {
    return LSApplicationWorkspace.defaultWorkspace;
}

+ (NSSet<LSApplicationProxy *> *)allApps {
    NSArray *plugins = [[self workspace] installedPlugins];
    NSMutableSet<LSApplicationProxy *> *apps = [[NSMutableSet alloc] init];
    NSMutableSet<NSString *> *ids = [[NSMutableSet alloc] init];
    for (LSPlugInKitProxy *plugin in plugins) {
        LSApplicationProxy *app = [plugin containingBundle];
        if (app) {
            NSString *appType = app.applicationType;
            if (([appType isEqualToString:@"User"] || [appType isEqualToString:@"System"]) && app.itemID != nil && ![[NSString stringWithFormat:@"%@", app.itemID]  isEqualToString: @"0"]) {
                [apps addObject:app];
                [ids addObject:[NSString stringWithFormat:@"%@", app.itemID]];
            }
        }
    }
    /*
    [self getInfoWithItemID:[[ids allObjects] componentsJoinedByString:@","] completedHandler:^(NSArray *infos) {
        NSDictionary *first = infos.firstObject;
        NSString *imageUrl = first[@"artworkUrl512"];
        [self downloadImageWithPath:imageUrl completedHandler:^(UIImage * _Nullable image) {
            NSLog(@"%@", image);
        }];
    }];
     */
    return apps;
}

+ (void)getInfoWithItemID:(NSString *)itemID completedHandler:(void(^)(NSArray *infos))completedHandler {
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", itemID];
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    if (countryCode) {
        [urlString appendFormat:@"&country=%@", countryCode];
    }
    NSURL *appURL = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.f];
    NSURLSession *session = [NSURLSession sharedSession];
    //4. 根据会话对象创建请求任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (completedHandler) {
                NSArray *array = dict[@"results"];
                if (array == nil || ![array isKindOfClass:NSArray.class]) {
                    array = @[];
                }
                completedHandler(array);
            }
        } else {
            if (completedHandler) {
                completedHandler(@[]);
            }
        }
    }];
    [task resume];
}

+ (void)downloadImageWithPath:(NSString *)path completedHandler:(void(^)(UIImage  * _Nullable image))completedHandler {
    NSURL *appURL = [NSURL URLWithString: path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.f];
    NSURLSession *session = [NSURLSession sharedSession];
    //4. 根据会话对象创建请求任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data != nil) {
            UIImage *image = [UIImage imageWithData:data];
            if (completedHandler) {
                completedHandler(image);
            }
        } else {
            if (completedHandler) {
                completedHandler(nil);
            }
        }
    }];
    [task resume];
}

@end
