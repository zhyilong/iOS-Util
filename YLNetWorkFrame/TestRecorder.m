//
//  TestRecorder.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/7/21.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "TestRecorder.h"
#import "YLRecorder.h"
#import "YLPlayer.h"

@interface TestRecorder ()

@end

@implementation TestRecorder

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)OnStartDown:(UIButton*)sender
{
    if (![YLRecorder currentYLRecorder])
    {
        [[YLRecorder alloc] init];
    }
    
    [[YLRecorder currentYLRecorder] startRecord];
}

- (IBAction)OnStopDown:(UIButton*)sender
{
    if ([YLRecorder currentYLRecorder])
    {
        [[YLRecorder currentYLRecorder] stopRecord];
    }
}

- (IBAction)OnPlayDown:(UIButton*)sender
{
    if (![YLPlayer currentPlayer])
    {
        [[YLPlayer alloc] initWithFile:[YLRecorder currentYLRecorder].mp3FilePath];
    }
    
    [[YLPlayer currentPlayer] play];
}

- (IBAction)OnPlayStopDown:(UIButton*)sender
{
    if ([YLPlayer currentPlayer])
    {
        [[YLPlayer currentPlayer] stop];
    }
}

@end
