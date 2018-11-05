//
//  PiaoJin.m
//  PiaoJinDylib
//
//  Created by 谢伟 on 2018/11/5.
//  Copyright © 2018 谢伟. All rights reserved.
//

#import "PiaoJin.h"
#import <UIKit/UIKit.h>

@implementation PiaoJin

- (void)love {
    NSLog(@"love you more than I can say!");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"love you more than I can say by 飘金!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

@end
