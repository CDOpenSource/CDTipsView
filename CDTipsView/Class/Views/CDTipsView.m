//
//  CDTipsView.m
//  CDTipsView
//
//  Created by Cindy on 16/5/24.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "CDTipsView.h"

#define  INSERT_H  _fontSize / 12.0  * 10.0
#define INSERT_W _fontSize / 12.0  * 12.0

#define ANIMATION_DURATION 0.4f

@interface CDTipsView()
{
    CDTipsViewShowPostion _showPostion;
    
    UIView *_supperView; //  需要显示这个tip的view；
    UIView *_contentView;
    UILabel *_text;
    
    NSTimer *_delayTimer;
    CGFloat _fontSize;
    UIColor *_backgroundColor;  //  吐司的背景颜色；
}
@end

@implementation CDTipsView

+(CDTipsView *)sharedTips
{
    static CDTipsView *tips = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        tips = [[self alloc] init];
    });
    return tips;
}

- (void)layoutSubviews
{
    [self initSubviewLayer];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //    // Drawing code.
    //    //获得处理的上下文
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    //设置线条样式
    //    CGContextSetLineCap(context, kCGLineCapButt);
    //    //设置线条粗细宽度
    //    CGContextSetLineWidth(context, 1.0);
    //    //开始一个起始路径
    //    CGContextBeginPath(context);
    //    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    //    CGContextMoveToPoint(context, 70, 20);
    //    //设置下一个坐标点
    //    CGContextAddLineToPoint(context, 100, 100);
    //    //设置下一个坐标点
    //    CGContextAddLineToPoint(context, 0, 150);
    //    //设置下一个坐标点
    //    CGContextAddLineToPoint(context, 50, 180);
    //    //连接上面定义的坐标点
    //    CGContextStrokePath(context);
    //    //设置颜色
    //    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
}

#pragma mark - Private Method
- (void)initContentView
{
    if (_contentView) {
        // 更新视图显示
        NSArray *subList = [_contentView subviews];
        for (UIView *sub in subList) {
            [sub removeFromSuperview];
        }
        [_contentView removeFromSuperview];
    } else {
        //  创建新的视图
        self.backgroundColor = [UIColor clearColor];
        
        //  整个显示内容view
        _contentView = [[UIView alloc] init];
        if (_backgroundColor) {
            _contentView.backgroundColor = _backgroundColor;
        } else {
            _contentView.backgroundColor = [UIColor blackColor];
        }
        _contentView.layer.cornerRadius = 4.0f;
        _contentView.clipsToBounds = YES;
        
        //  文本控件
        _text = [[UILabel alloc] init];
        _text.textAlignment = NSTextAlignmentCenter;
        _text.textColor = [UIColor whiteColor];
        _text.numberOfLines = 0;
        
        _fontSize = _fontSize > 0 ? _fontSize : 12.0;  //  默认的吐司字体大小为12
    }
}

- (void)initSubviewLayer
{
    if ([[_contentView subviews] containsObject:_text] == NO) {
        [_contentView addSubview:_text];
    }
    
    CGSize sizeOfText = [self getMaxSize];
    _contentView.bounds = CGRectMake(0, 0, sizeOfText.width + INSERT_W, sizeOfText.height + INSERT_H);
    _text.bounds = CGRectMake(0, 0, sizeOfText.width, sizeOfText.height);
    _text.center = CGPointMake(CGRectGetWidth(_contentView.bounds)/2.0, CGRectGetHeight(_contentView.bounds)/2.0);
    
    [self initPotion];
}

- (void)initPotion
{
    if ([self.subviews containsObject:_contentView] == NO) {
        [self addSubview:_contentView];
    }
    
    switch (_showPostion) {
        case CDTipsViewShowPostionTop:
        {
            _contentView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/5.0);
        }
            break;
        case CDTipsViewShowPostionCenter:
        {
            _contentView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
        }
            break;
        case CDTipsViewShowPostionBottom:
        {
            _contentView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/5.0*4.0);
        }
            break;
        default:
            break;
    }
//    NSLog(@"_contentView.frame :\n%@",NSStringFromCGRect(_contentView.frame));
}

- (CGSize)getMaxSize
{
    CGRect rectOfText = [_text textRectForBounds:CGRectMake(0, 0, self.bounds.size.width - 50.0, self.bounds.size.height) limitedToNumberOfLines:0];
    return rectOfText.size;
}

#pragma mark - Public Method
- (void)setSupperView:(UIView *)supperView
{
    if (_supperView) {
        [_supperView removeFromSuperview];
    }
    _supperView = supperView;
}

- (void)setTipBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    _contentView.backgroundColor = _backgroundColor;
}

- (void)setTipsPostion:(CDTipsViewShowPostion)postion
{
    _showPostion = postion;
}

#pragma mark
- (void)tipString:(NSString *)tipsString fontSize:(CGFloat)size
{
    _fontSize = size;
    [self setTipString:tipsString];
}

- (void)setTipString:(NSString *)tipString
{
    [self initContentView];
    _text.text = tipString;
    _text.font = [UIFont fontWithName:@"HelveticaNeue-bold" size:_fontSize];
    [self initSubviewLayer];
}

#pragma mark
- (void)show:(BOOL)animation
{
    [_delayTimer invalidate];
    [self removeFromSuperview];
    [_supperView addSubview:self];
    if (animation == YES) {
        [self changePotionToAnimationState];
        self.alpha = 0;
        //  添加动画
        [UIView animateWithDuration:ANIMATION_DURATION animations: ^{
            self.alpha = 1;
            [self initPotion];
        }];
    } else {
        self.alpha = 1;
    }
}

- (void)hiden:(BOOL)animation
{
    [_delayTimer invalidate];
    if (animation == YES) {
        //  添加动画
        [UIView animateWithDuration:ANIMATION_DURATION animations: ^{
            self.alpha = 0;
            [self changePotionToAnimationState];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

- (void)hiden:(BOOL)animation delayTime:(CGFloat)delayTime
{
    [_delayTimer invalidate];
    _delayTimer = [NSTimer scheduledTimerWithTimeInterval:delayTime target:self selector:@selector(timerSelectorMethod:) userInfo:[NSNumber numberWithBool:animation] repeats:NO];
}

#pragma mark
- (void)timerSelectorMethod:(NSTimer *)timer
{
    BOOL  animation = [timer.userInfo boolValue];
    [self hiden:animation];
}

- (void)changePotionToAnimationState
{
    CGPoint centerNow = _contentView.center;
    if (_showPostion == CDTipsViewShowPostionBottom) {
        _contentView.center = CGPointMake(centerNow.x, centerNow.y + 16.0);
    } else {
        _contentView.center = CGPointMake(centerNow.x, centerNow.y - 16.0);
    }
}


@end
