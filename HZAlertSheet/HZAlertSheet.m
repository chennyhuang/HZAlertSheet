//
//  HZAlertSheet.m
//  HZAlertSheet
//
//  Created by huangzhenyu on 2018/6/22.
//  Copyright © 2018年 huangzhenyu. All rights reserved.
//


#import "HZAlertSheet.h"
#define kScreenWidth [UIScreen  mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTagBase 1000
static CGFloat const kMessageLabelHeght                  = 52.0f;
static CGFloat const kChoiceButtonHeght                  = 52.0f;
static CGFloat const kCancelButtonHeght                  = 50.0f;
static CGFloat const kMoveToSupviewDuration              = 0.2f;
static CGFloat const kRemoveFromSupviewDuration          = 0.2f;
static CGFloat const kMarginBetweenChoiceAndCancelButton = 5.0f;

@interface HZAlertSheet()

@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, assign) CGFloat  selfHeight;

@end

@implementation HZAlertSheet
- (void)dealloc{
//    NSLog(@"alert销毁");
}
- (instancetype)initWithMessage:(NSString *)message choiceButtonTitles:(NSArray *)titlesArray {
    if (self = [super init]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
        CGFloat messageMaxY = 0;
        if (message && ![message isEqualToString:@""]) {
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMessageLabelHeght)];
            messageLabel.tag = kTagBase + 100;
            messageLabel.text            = message;
            messageLabel.textAlignment   = NSTextAlignmentCenter;
            messageLabel.font            = [UIFont systemFontOfSize:17];
            messageLabel.textColor       = [UIColor blackColor];
            messageLabel.backgroundColor = [UIColor whiteColor];
            [self addSubview:messageLabel];
            messageMaxY = CGRectGetMaxY(messageLabel.frame) + 0.5;
        }
        if (messageMaxY == 0) {
            self.selfHeight = titlesArray.count * (kChoiceButtonHeght + 0.5) + kMarginBetweenChoiceAndCancelButton + kCancelButtonHeght;
        } else {
            self.selfHeight = kMessageLabelHeght + titlesArray.count * (kChoiceButtonHeght + 0.5) + kMarginBetweenChoiceAndCancelButton + kCancelButtonHeght;
        }
        
        for (int i = 0; i < titlesArray.count; i ++) {
            UIButton *choiceButton = [[UIButton alloc] init];
            CGFloat choiceButtonY  = messageMaxY + i * (kChoiceButtonHeght + 0.5);
            choiceButton.frame     = CGRectMake(0, choiceButtonY, kScreenWidth, kChoiceButtonHeght);
            choiceButton.tag       = kTagBase + i;
            choiceButton.backgroundColor = [UIColor whiteColor];
            [choiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [choiceButton setTitle:titlesArray[i] forState:UIControlStateNormal];
            choiceButton.titleLabel.font = [UIFont systemFontOfSize:18];
            [choiceButton addTarget:self action:@selector(choiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:choiceButton];
        }
        
        UIButton *cancelButton       = [[UIButton alloc] init];
        cancelButton.tag = kTagBase + 101;
        CGFloat cancelButtonY        = messageMaxY + titlesArray.count * (kChoiceButtonHeght + 0.5) + kMarginBetweenChoiceAndCancelButton;
        cancelButton.frame           = CGRectMake(0, cancelButtonY, kScreenWidth, kCancelButtonHeght);
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:cancelButton];
    }
    return self;
}

- (void)show {
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.selfHeight);
    [[self lastWindow] addSubview:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil) {
        return ;
    }
    
    if (!self.coverBtn) {
        self.coverBtn                  = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.coverBtn.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.coverBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.coverBtn addTarget:self action:@selector(coverBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIWindow *lastWindow = [self lastWindow];
    [lastWindow addSubview:self.coverBtn];
    
    CGRect afterFrame = CGRectMake(0, kScreenHeight - self.selfHeight, kScreenWidth, self.selfHeight);
    [UIView animateWithDuration:kMoveToSupviewDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = afterFrame;
        self.coverBtn.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    } completion:^(BOOL finished) {
        
    }];

}

- (void)removeFromSuperview {
    CGRect afterFrame = CGRectMake(0, kScreenHeight, kScreenWidth, self.selfHeight);
    [UIView animateWithDuration:kRemoveFromSupviewDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = afterFrame;
        self.coverBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        [self.coverBtn removeFromSuperview];
        self.coverBtn = nil;
    }];
}

- (void)coverBtnClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)choiceButtonClicked:(UIButton *)sender {
    [self removeFromSuperview];
    
    if (self.choiceButtonClickedBlock) {
        self.choiceButtonClickedBlock(sender.tag - kTagBase);
    }
}

- (void)cancelButtonClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

#pragma mark attributes
- (void)setMessageStyleWith:(NSDictionary *)attribute{
    UILabel *messageLabel = (UILabel *)[self viewWithTag:kTagBase + 100];
    if (messageLabel) {
        messageLabel.textColor = attribute[NSForegroundColorAttributeName];
        messageLabel.font = attribute[NSFontAttributeName];
    }
}

- (void)setItemStyleWith:(NSDictionary *)attribute index:(NSUInteger)index{
    UIButton *choiceButton = (UIButton *)[self viewWithTag:index + kTagBase];
    if (choiceButton) {
        [choiceButton setTitleColor:attribute[NSForegroundColorAttributeName] forState:UIControlStateNormal];
        choiceButton.titleLabel.font = attribute[NSFontAttributeName];
    }
}

- (void)setCancelStyleWith:(NSDictionary *)attribute{
    UIButton *cancelButton = (UIButton *)[self viewWithTag:kTagBase + 101];
    if (cancelButton) {
        [cancelButton setTitleColor:attribute[NSForegroundColorAttributeName] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = attribute[NSFontAttributeName];
    }
}

- (UIWindow *)lastWindow {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            window.windowLevel == UIWindowLevelNormal &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}
@end
