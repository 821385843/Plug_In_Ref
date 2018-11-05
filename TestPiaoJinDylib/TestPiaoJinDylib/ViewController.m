//
//  ViewController.m
//  TestPiaoJinDylib
//
//  Created by Mr Xie on 2018/11/5.
//  Copyright © 2018 Mr Xie. All rights reserved.
//

#import "ViewController.h"
#import "SSZipArchive.h"
#include <dlfcn.h>

static void *libHandle = NULL;

@interface ViewController ()

@property (nonnull, strong) NSBundle *bundle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

/**
 解压动态库的zip到沙盒
 */
- (IBAction)unZipFramework:(UIButton *)sender {
    NSString *destinationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", destinationPath);
    
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"PiaoJinDylib" ofType:@"zip"];
    BOOL isSuccess = [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
    if (isSuccess) {
        NSLog(@"解压成功");
    } else {
        NSLog(@"解压失败");
    }
}

/**
 使用NSBundle加载动态库
 */
- (IBAction)loadFrameworkForNSBundle:(UIButton *)sender {
    //从服务器去下载并且存入Documents下(只要知道存哪里即可),事先要知道framework名字,然后去加载
    NSString *destinationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *frameworkPath = [destinationPath stringByAppendingPathComponent:@"PiaoJinDylib.framework"];
    
    NSError *err = nil;
    NSBundle *bundle = [NSBundle bundleWithPath:frameworkPath];
    NSString *str = @"加载动态库失败!";
    if ([bundle loadAndReturnError:&err]) {
        self.bundle = bundle;
        NSLog(@"bundle load framework success.");
        str = @"加载动态库成功!";
    } else {
        NSLog(@"bundle load framework err:%@",err);
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

/**
 使用dlopen加载动态库
 */
- (IBAction)loadFrameworkForDlopen:(UIButton *)sender {
    //从服务器去下载并且存入Documents下(只要知道存哪里即可),事先要知道framework名字,然后去加载(注意需要加上PiaoJinDylib)
    NSString *destinationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *frameworkPath = [destinationPath stringByAppendingPathComponent:@"PiaoJinDylib.framework/PiaoJinDylib"];
    
    libHandle = NULL;
    libHandle = dlopen([frameworkPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    NSString *str = @"加载动态库失败!";
    
    if (libHandle == NULL) {
        char *error = dlerror();
        NSLog(@"dlopen error: %s", error);
    } else {
        NSLog(@"dlopen load framework success.");
        str = @"加载动态库成功!";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

/**
 释放动态库（释放使用NSBundle加载的动态库）
 */
- (IBAction)unloadForNSBundle:(UIButton *)sender {
    if ([self.bundle unload]) {
        NSLog(@"释放成功!");
    } else {
        NSLog(@"释放失败!");
    }
}

/**
 释放动态库（释放使用dlopen加载的动态库）
 */
- (IBAction)dlcloseForDlopen:(UIButton *)sender {
    int result = dlclose(libHandle);
    //为0表示释放成功
    if (result == 0) {
        NSLog(@"释放成功!");
    } else {
        NSLog(@"释放失败!");
    }
}

/**
 利用运行时调用动态库方法
 */
- (IBAction)callFrameworkMethod:(UIButton *)sender {
    Class piaoJinClass = NSClassFromString(@"PiaoJin");
    if (piaoJinClass) {
        //事先要知道有什么方法在这个FrameWork中
        id object = [[piaoJinClass alloc] init];
        //由于没有引入相关头文件故通过performSelector调用
        [object performSelector:@selector(love)];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"调用方法失败!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}




@end
