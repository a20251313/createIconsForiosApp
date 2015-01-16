//
//  UIImage+exp.m
//  CreateIcons
//
//  Created by jingfuran on 14-10-16.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

#import "UIImage+exp.h"

@implementation NSImage (exp)


//缩放到目的大小，太小了不缩放添加背景
+ (NSImage *)createScalesImage:(NSImage *)sourceImage targetSize:(CGSize)taggetSize
{
    //set flipped
    [sourceImage setScalesWhenResized:YES];
   
    //source picture size
    NSSize srcSize = [sourceImage size];
    unsigned int uiWidth= srcSize.width;
    unsigned int uiHeight= srcSize.height;
    
    //target bg picture size
    unsigned int bgWidth = taggetSize.width;
    unsigned int bgHeight = taggetSize.height;
    NSSize tarSize =NSMakeSize(bgWidth, bgHeight);
    
    if(uiWidth>=bgWidth && uiHeight >= bgHeight)
    {
        [sourceImage setSize:tarSize];
        return [sourceImage copy];
    }
    if(1)
    {
        [sourceImage setSize:tarSize];
        
        //target bg picture
        NSImage *targetImage = [[NSImage alloc] initWithSize:tarSize];
        [targetImage lockFocus];
        //fill target bg picture,using white color
        [[NSColor whiteColor] set];
        NSRectFill(NSMakeRect(0,0, bgWidth, bgHeight));
        
        //draw
        [sourceImage drawAtPoint:NSMakePoint(0,(bgHeight - uiHeight)*0.5) fromRect:NSZeroRect operation:NSCompositeSourceIn fraction:1.0];
        [targetImage unlockFocus];
        return targetImage;
    }
    return nil;
}
@end
