//
//  NSImage+NSImage_ZCPanel_h.h
//  CreateIcons
//
//  Created by jingfuran on 15/1/16.
//  Copyright (c) 2015年 jingfuran. All rights reserved.
//


#import <Cocoa/Cocoa.h>
//#import "CTGradient.h"
#define MAX_PIXEL_SIZE   600*800
#define PIC_WIDTH  800
#define PIC_HEIGHT 600
//Picture fram
/*
 NSBMPFileType,
 NSGIFFileType,
 NSJPEGFileType,
 NSPNGFileType,
 NSJPEG2000FileType*/
@interface NSImage (ZCPanel)
+ (NSImage *) prettyGradientImage:(NSSize)gradientSize;  // Generates a 256 by 256 pixel image with a complicated gradient in it.
+ (NSImage *) reflectedImage:(NSImage *)sourceImage amountReflected:(float)fraction;
+ (NSImage *) createScalesImage:(NSImage *)sourceImage flipFlag:(BOOL)bFlip amountReflected:(float)fraction;
+ (NSImage *) rotateImage:(NSImage*)sourceImage byDegrees:(float)deg;
+ (NSImage *) imageFromCGImageRef:(CGImageRef)image; //FROME CGImageRef to NSImage
- (CGImageRef) nsImageToCGImageRef;//FROME  NSImage to CGImageRef
- (BOOL) setSmoothingEffect; //Set smoothing effect
- (BOOL) saveImage:(NSImage*)image
          saveType:(NSBitmapImageFileType)storageType
        properties:(NSDictionary *)properties
          ToTarget:(NSString *) targePath;

- (CGImageRef)thumbnailForFile: (NSString*)name atPath: (NSString*)filePath;

+ (NSImage *)createScalesImage:(NSImage *)sourceImage  size:(NSSize)taggetSize;
@end
