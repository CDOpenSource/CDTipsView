//
//  CDMainViewController.m
//  CDTipsView
//
//  Created by Cindy on 16/5/24.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDTipsView.h"

@interface CDMainViewController ()
{
    CDTipsView *tipView;
}
@end

@implementation CDMainViewController


- (IBAction)changeTipsPostionEvent:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [tipView setTipsPostion:CDTipsViewShowPostionBottom];
        }
            break;
        case 1:
        {
            [tipView setTipsPostion:CDTipsViewShowPostionCenter];
        }
            break;
        case 2:
        {
            [tipView setTipsPostion:CDTipsViewShowPostionTop];
        }
            break;
        default:
            break;
    }
    [self testFunctionMethod:nil];
}

- (IBAction)testFunctionMethod:(UIButton *)sender
{
    [self.fieldTextTest resignFirstResponder];
    static NSInteger count = 0;
    if (self.fieldTextTest.text.length > 0) {
        [tipView setTipString:self.fieldTextTest.text];
    } else {
        [tipView setTipString:[NSString stringWithFormat:@"√ 恭喜您第%zi次修改成功",++count]];
    }
    [tipView show:YES];
    [tipView hiden:YES delayTime:1.0];
}

#pragma mark - view
- (void)viewWillLayoutSubviews
{
    tipView.frame = CGRectInset(self.view.frame, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Tips Function Test";
    tipView = [CDTipsView sharedTips];
    [tipView setSupperView:self.view];
    [tipView setTipBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [tipView setTipsPostion:CDTipsViewShowPostionBottom];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",NSStringFromCGRect(tipView.frame));
    [tipView tipString:@"~温馨小提示~\n感谢你下载并使用此开源小控件，如果你觉得还有任何的疑问或者建议给到我，请发送至我的邮箱chendi1123@aliyun.com，我会及时回复你，感谢你的支持，谢谢!" fontSize:14.0f];
    [tipView show:YES];
    [tipView hiden:YES delayTime:10.0];
    
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(11.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipView setTipString:@"√ 恭喜您修改成功"];
        [tipView show:YES];
        [tipView hiden:YES delayTime:1.0];
    });
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

@end
