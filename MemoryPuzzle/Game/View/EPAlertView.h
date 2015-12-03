//
//  EPAlertView.h
//  MobilyRanan
//
//  Created by 尚加锋 on 14-10-22.
//  Copyright (c) 2014年 Huawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPAlertView : UIView
{
    UIView          *_contentView;
    
    UIWindow        *_mainWindow;
    
    UIWindow        *_overlayWindow;
    
    UIButton        *_maskView;      //蒙版
    
    float           _showDuration; //alert显示最长时间
}

typedef void (^EP_ALERTVIEW_CLICK_BTN_BLOCK)(int index,EPAlertView *alert); //actionSheet 点击按钮block

typedef void(^EP_ALERTVIEW_DISMISS_BLOCK)(void); //actionSheet 消失block

@property (nonatomic, copy) EP_ALERTVIEW_CLICK_BTN_BLOCK clickBlock;
@property (nonatomic, copy)EP_ALERTVIEW_DISMISS_BLOCK    dismissBlock;
@property (nonatomic) BOOL isDismissWhenPressMask;   //默认为NO  设为YES则点击蒙板消失
@property (nonatomic) BOOL isDismissWhenPressButton; //默认为YES 设为NO则点击按钮不消失
@property (nonatomic, strong)UIViewController   *rootViewController;

- (id)initWithTitle:(NSString *)title contentString:(NSString *)content buttonTitles:(NSString *)btnTitle,...;

- (id)initWithTitle:(NSString *)title customView:(UIView *)customView buttonTitles:(NSString *)btnTitle,...;


- (void)show;

- (void)dismiss;


@end
