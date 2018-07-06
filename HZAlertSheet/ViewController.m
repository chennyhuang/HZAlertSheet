//
//  ViewController.m
//  HZAlertSheet
//
//  Created by huangzhenyu on 2018/6/26.
//  Copyright © 2018年 huangzhenyu. All rights reserved.
//

#import "ViewController.h"
#import "HZAlertSheet.h"
#define HZPageControlColor(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pop:(id)sender {
    HZAlertSheet *alertSheet = [[HZAlertSheet alloc] initWithMessage:@"选择性别" choiceButtonTitles:@[@"男", @"女"]];
    /*
        [alertSheet setMessageStyleWith:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:HZPageControlColor(0x666666)}];
        [alertSheet setItemStyleWith:@{NSFontAttributeName:[UIFont systemFontOfSize:30.0f],NSForegroundColorAttributeName:[UIColor colorWithRed:84/255.0 green:174/255.0 blue:247/255.0 alpha:1.0]} index:0];
        [alertSheet setCancelStyleWith:@{NSFontAttributeName:[UIFont systemFontOfSize:30.0f],NSForegroundColorAttributeName:HZPageControlColor(0x666666)}];
     */
    [alertSheet show];
    alertSheet.choiceButtonClickedBlock = ^(NSInteger i) {
        switch (i) {
            case 0:
            {
                NSLog(@"我选择了男");
                self.label.text = @"男";
            }
                break;
            case 1:
            {
                NSLog(@"我选择了女");
                self.label.text = @"女";
            }
                break;
            default:
                break;
        }
    };
}

@end
