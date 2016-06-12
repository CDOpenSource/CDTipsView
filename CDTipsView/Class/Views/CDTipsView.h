//
//  CDTipsView.h
//  CDTipsView
//
//  Created by Cindy on 16/5/24.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  吐司提示显示位置的枚举
 */
typedef NS_ENUM(NSInteger, CDTipsViewShowPostion) {
    /**
     *  在底部展示
     */
    CDTipsViewShowPostionBottom,
    /**
     *  在中间展示
     */
    CDTipsViewShowPostionCenter,
    /**
     *  在顶部展示
     */
    CDTipsViewShowPostionTop
};


@interface CDTipsView : UIView

+(CDTipsView *)sharedTips;

- (void)setSupperView:(UIView *)supperView;
- (void)setTipBackgroundColor:(UIColor *)backgroundColor;

/**
 *  设置 吐司 显示的位置
 *
 *  @param postion 位置值（枚举类型）
 */
- (void)setTipsPostion:(CDTipsViewShowPostion)postion;

/**
 *  简单的纯文本 吐司 提示
 *
 *  @param tipsString 提示文本内容
 *  @param delay      持续时间长度
 */
- (void)setTipString:(NSString *)tipString;
- (void)tipString:(NSString *)tipsString fontSize:(CGFloat)size;


- (void)show:(BOOL)animation;
- (void)hiden:(BOOL)animation;
- (void)hiden:(BOOL)animation delayTime:(CGFloat)delayTime;


@end
