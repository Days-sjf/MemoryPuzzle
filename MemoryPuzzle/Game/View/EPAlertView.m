//
//  EPAlertView.m
//  MobilyRanan
//
//  Created by 尚加锋 on 14-10-22.
//  Copyright (c) 2014年 Huawei. All rights reserved.
//

#import "EPAlertView.h"
#import "NSString+Extension.h"
#define EPAT_BTN_BASE_TAG 888

#define EPAT_BTN_SPACE  15

#define MARGIN_AROUND   22

#define Button_Height   50

static EPAlertView *alert = nil;

static int height = 25;

@implementation EPAlertView

- (void)dealloc
{
    _dismissBlock = nil;
    _clickBlock = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithTitle:(NSString *)title contentString:(NSString *)content buttonTitles:(NSString *)btnTitle,...
{
    
    if (self = [super init])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        if(btnTitle)
        {
            [array addObject:btnTitle];
            
            va_list args;
            
            va_start(args, btnTitle);
            
            id arg;
            
            while (1) {
                arg = va_arg(args, id);
                
                if(arg == nil)
                    break;
                else
                    [array addObject:arg];
            }
            
            va_end(args);
        }
        
        UIView *customView = [[UIView alloc] initWithFrame:CGRectZero];
        
        UIFont *font = DefaultFont(17);
        
        int i = [UIScreen mainScreen].bounds.size.width - 52 - MARGIN_AROUND * 2;
        
        CGRect rect = [content ep_sizeWithFont:font boundsSize:CGSizeMake(i, 1000)];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 52 - rect.size.width)/2, 0, rect.size.width, rect.size.height+2)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = Get_Color(0x333333);
        contentLabel.font = font;
        contentLabel.text = content;
        contentLabel.numberOfLines = 0;
        
        [customView addSubview:contentLabel];
        
        customView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 52, contentLabel.bottom);
        
        [self layoutWithTitle:title customView:customView buttonTitle:array andMargin:26];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title customView:(UIView *)customView buttonTitles:(NSString *)btnTitle,...
{
    if(self = [super init])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        if(btnTitle)
        {
            [array addObject:btnTitle];
            
            va_list args;
            
            va_start(args, btnTitle);
            
            id arg;
            
            while (1) {
                arg = va_arg(args, id);
                
                if(arg == nil)
                    break;
                else
                    [array addObject:arg];
            }
            
            va_end(args);
        }
        
        
        [self layoutWithTitle:title customView:customView buttonTitle:array andMargin:26];
        
    }
    
    return self;
}


- (void)layoutWithTitle:(NSString *)title customView:(UIView *)customView buttonTitle:(NSArray *)array andMargin:(NSInteger)margin
{
    _isDismissWhenPressMask = NO;
    _isDismissWhenPressButton = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

    if(_contentView == nil)
    {
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(margin, ([UIScreen mainScreen].bounds.size.height-height)/2, [UIScreen mainScreen].bounds.size.width - margin*2, height);
        _contentView.backgroundColor = RGBCOLOR(0xf6, 0xf6, 0xf5);
        _contentView.clipsToBounds = NO;
        _contentView.alpha = 0;
    }
    [_contentView removeAllSubviews];
    
    if(title)
    {
        UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 48)];
        titleBgView.backgroundColor = RGBCOLOR(0x0b, 0x78, 0xb6);
        [_contentView addSubview:titleBgView];
        
        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, _contentView.width, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = RGBCOLOR(0xff, 0xff, 0xff);
        _titleLabel.font = DefaultBoldFont(18);
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleBgView addSubview:_titleLabel];
        
        height = titleBgView.bottom + 12;
    }
    
    if(customView)
    {
        customView.top = height;
        customView.left = ([UIScreen mainScreen].bounds.size.width - margin*2-customView.width)/2;
        
        [_contentView addSubview:customView];
        
        height = customView.bottom + 12;
    }
    
    if ([array count]>0)
    {
        UIView *cutLine = [[UIView alloc] initWithFrame:CGRectMake(0, height, _contentView.width, 1)];
        cutLine.backgroundColor = RGBCOLOR(0xcc, 0xcc, 0xcc);
        
        [_contentView addSubview:cutLine];
        
        height +=cutLine.height;
    }
    
    for(int i = 0; i < [array count]; i++)
    {
        NSString *btnTitle = array[i];
        
        UIView  *cutView = [[UIView alloc] init];
        cutView.backgroundColor = RGBCOLOR(0xcc, 0xcc, 0xcc);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = EPAT_BTN_BASE_TAG + i;
        btn.exclusiveTouch = YES;
        btn.clipsToBounds = YES;
        [btn setTitleColor:RGBCOLOR(0x44, 0x44, 0x44) forState:UIControlStateNormal];
        
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        btn.titleLabel.font = DefaultFont(15);
        
        if ([array count] == 1)
        {
            btn.frame = CGRectMake(0, height, [UIScreen mainScreen].bounds.size.width - 2*margin, Button_Height);
        }else
        {
            NSInteger k = _contentView.width/[array count];
            
            if ([LocalizedUtil isEnglishLanguage])
            {
                btn.frame = CGRectMake(i*k , height, k, Button_Height);
                if (i< [array count] - 1)
                {
                    cutView.frame = CGRectMake(btn.right-0.5, height, 1, Button_Height);
                }
            }else if ([LocalizedUtil isArabicLanguage])
            {
                btn.frame = CGRectMake(([array count]-i-1)*k , height, k, Button_Height);
                if (i< [array count] - 1)
                {
                    cutView.frame = CGRectMake(btn.left-0.5, height, 1, Button_Height);
                }
            }
        }
        
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:btn];
        [_contentView addSubview:cutView];
    }
    
    if ([array count] > 0)
    {
        height += 50;
    }
    
    _contentView.frame = CGRectMake(margin, ([UIScreen mainScreen].bounds.size.height-height)/2, [UIScreen mainScreen].bounds.size.width - margin*2, height);
}


- (void)show
{
    if(_overlayWindow || alert)
        return;
    
    _mainWindow = [UIApplication sharedApplication].keyWindow;
    
    _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _overlayWindow.backgroundColor = [UIColor clearColor];
    
    if (!_rootViewController) {
        _rootViewController  = [[UIViewController alloc] init];
        _rootViewController.view.backgroundColor = [UIColor clearColor];
    }
    
    _overlayWindow.rootViewController = _rootViewController;
    
    //添加蒙版
    if(_maskView == nil)
    {
        _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
        _maskView.backgroundColor = [UIColor blackColor];
        [_maskView addTarget:self action:@selector(tapMaskView:) forControlEvents:UIControlEventTouchUpInside];
        _maskView.frame = _overlayWindow.frame;
        _maskView.alpha = 0.001;
        _maskView.enabled = NO;
    }
    
    [_rootViewController.view addSubview:_maskView];
    
    [_rootViewController.view addSubview:_contentView];
    
    _maskView.userInteractionEnabled = NO;

    __weak UIView *blockView = _contentView;
    
    [_mainWindow resignKeyWindow];
    
    [_overlayWindow makeKeyAndVisible];
    
    alert = self;
    
    [UIView animateWithDuration:0.3  delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _maskView.alpha = 0.5;
        
        blockView.alpha = 1.0;
        
    } completion:^(BOOL finished)
    {
        _maskView.userInteractionEnabled = YES;

        _maskView.enabled = YES;
    }];
}


- (void)dismiss
{
    __weak UIView *blockView = _contentView;
    __weak EP_ALERTVIEW_DISMISS_BLOCK dismissBlock = _dismissBlock;
    
    _maskView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        blockView.alpha = 0;
        
        _maskView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        __strong EP_ALERTVIEW_DISMISS_BLOCK strongBlock = dismissBlock;
        
        [_overlayWindow resignKeyWindow];
        
        _overlayWindow = nil;
        
        [_mainWindow makeKeyAndVisible];
        
        if(strongBlock)
        {
            strongBlock();
        }
        
        alert = nil;
    }];
}


- (void)btnPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.isHighlighted)
    {
        button.backgroundColor = RGBCOLOR(0x00, 0x00, 0x00);
        button.alpha = 0.9;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.backgroundColor = [UIColor clearColor];
            button.alpha = 1.0;
        });
    }
    
    long index = [(UIButton *)sender tag] - EPAT_BTN_BASE_TAG;
    
    if(_clickBlock)
    {
        _clickBlock((int)index,self);
    }
    
    if (_isDismissWhenPressButton)
    {
        [self dismiss];
    }
}

- (void)tapMaskView:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if(_isDismissWhenPressMask)
    {
        [self dismiss];
    }
}

#pragma mark- 键盘通知

- (void)keyBoardWillShow:(NSNotification *)notication
{
    NSDictionary *keyBoardDic = (NSDictionary *)notication.userInfo;
    
    CGSize  boardSize = [[keyBoardDic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentView.top = [UIScreen mainScreen].bounds.size.height - boardSize.height - _contentView.height - 20;
    } completion:nil];
    
}

- (void)keyBoardWillHidden:(NSNotification *)notication
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentView.top = ([UIScreen mainScreen].bounds.size.height-height)/2;
    } completion:nil];
}


@end
