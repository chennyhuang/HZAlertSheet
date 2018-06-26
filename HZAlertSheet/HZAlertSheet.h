//
//  HZAlertSheet.h
//  HZAlertSheet
//
//  Created by huangzhenyu on 2018/6/22.
//  Copyright © 2018年 huangzhenyu. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ChoiceButtonClickedBlock)(NSInteger tag);

@interface HZAlertSheet : UIView

@property (nonatomic, copy) ChoiceButtonClickedBlock choiceButtonClickedBlock;


/**
 弹出alertsheet

 @param message 标题，可以设置 nil 或者 @"" 表示不展示
 @param titlesArray 选项按钮设置
 @return alert实例
 */
- (instancetype)initWithMessage:(NSString *)message choiceButtonTitles:(NSArray *)titlesArray;
- (void)show;

/**
 设置标题的样式

 @param attribute 字典类型的样式，包括字体颜色等
 */
- (void)setMessageStyleWith:(NSDictionary *)attribute;

/**
 设置选择按钮的样式

 @param attribute  字典类型的样式，包括字体颜色等
 @param index 选择项目的下标，从上往下依次从 0 开始递增
 */
- (void)setItemStyleWith:(NSDictionary *)attribute index:(NSUInteger)index;

/**
 设置取消按钮的样式

 @param attribute 字典类型的样式，包括字体颜色等
 */
- (void)setCancelStyleWith:(NSDictionary *)attribute;
@end
