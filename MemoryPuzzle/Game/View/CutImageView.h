//
//  CutImageView.h
//  Demo
//
//  Created by 尚加锋 on 14-12-29.
//  Copyright (c) 2014年 slyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CutImageView : UIImageView<UIPageViewControllerDelegate>
{
    UIImage   *cutImage;
}

-(id)initWithImage:(UIImage *)image
              size:(CGSize)size
               tag:(NSInteger)tag;

@end
