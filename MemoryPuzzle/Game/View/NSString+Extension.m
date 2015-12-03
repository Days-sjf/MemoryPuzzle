//
//  NSString+Extension.m
//  MobilyRanan
//
//  Created by 尚加锋 on 14-10-22.
//  Copyright (c) 2014年 Huawei. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGRect)ep_sizeWithFont:(UIFont *)font boundsSize:(CGSize)size
{
    CGRect rect;
    if(IOS7_OR_LATER)
    {
        rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    }else
    {
        CGSize tmpSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
        rect = CGRectMake(0, 0, tmpSize.width, tmpSize.height);
    }
    
    return rect;
}


@end
