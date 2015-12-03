//
//  CutImageView.m
//  Demo
//
//  Created by 尚加锋 on 14-12-29.
//  Copyright (c) 2014年 slyao. All rights reserved.
//

#import "CutImageView.h"

@implementation CutImageView

-(id)initWithImage:(UIImage *)image size:(CGSize)size tag:(NSInteger)tag
{
    if (self == [super init])
    {
        self.backgroundColor = [UIColor greenColor];
        self.tag = tag;
    
        [self cut:size image:image];
    }
    
    return self;
}

- (void)cut:(CGSize)size image:(UIImage *)image
{
    CGImageRef imageRef =image.CGImage;
    
    CGImageRef cutimage = CGImageCreateWithImageInRect(imageRef, CGRectMake((self.tag%2)*size.width, (self.tag/2)*size.height, size.width, size.height));
    
    UIImage*newImage = [[UIImage alloc] initWithCGImage:cutimage];
    
    self.image = newImage;;
}

@end
