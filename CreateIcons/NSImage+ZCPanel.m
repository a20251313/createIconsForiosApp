

#import "NSImage+ZCPanel.h"
float distance(NSPoint aPoint);
enum pixelComponents { red, green, blue, alpha };
#define PI 3.14159265358979323846264338327950288
@implementation NSImage (ZCPanel)
////倒立，深度
/*+ (NSImage *)reflectedImage:(NSImage *)sourceImage amountReflected:(float)fraction
{
    NSImage *reflection = [[NSImage alloc] initWithSize:[sourceImage size]];
    [reflection setFlipped:YES];
    [reflection lockFocus];
    CTGradient *fade = [CTGradient gradientWithBeginningColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.5] endingColor:[NSColor clearColor]];
    [fade fillRect:NSMakeRect(0, 0, [sourceImage size].width, [sourceImage size].height*fraction) angle:90.0];
    [sourceImage drawAtPoint:NSMakePoint(0,0) fromRect:NSZeroRect operation:NSCompositeSourceIn fraction:1.0];
    [reflection unlockFocus];
    return [reflection autorelease];
}*/



//缩放到目的大小，太小了不缩放添加背景
+ (NSImage *)createScalesImage:(NSImage *)sourceImage  size:(NSSize)taggetSize
{
    unsigned int bgWidth = taggetSize.width;
    unsigned int bgHeight = taggetSize.height;
    NSSize tarSize =NSMakeSize(bgWidth, bgHeight);

    NSImage *targetImage = [[NSImage alloc] initWithSize:tarSize];
    [targetImage lockFocus];
    [[NSColor whiteColor] set];
    NSRectFill(NSMakeRect(0, 0, bgWidth, bgWidth));
    
    //draw
    [sourceImage drawInRect:NSMakeRect(0, 0, bgWidth, bgHeight) fromRect:NSZeroRect operation:NSCompositeSourceIn fraction:1];
    
    //    [sourceImage drawAtPoint:NSMakePoint((bgWidth - uiWidth)*0.5, (bgHeight - uiHeight)*0.5) fromRect:NSZeroRect operation:NSCompositeSourceIn fraction:1.0];
    [targetImage unlockFocus];
    return [targetImage autorelease];
    
}



//缩放到目的大小，太小了不缩放添加背景
+ (NSImage *)createScalesImage:(NSImage *)sourceImage flipFlag:(BOOL)bFlip amountReflected:(float)fraction
{

    //source picture size
    NSSize srcSize = [sourceImage size];
    unsigned int uiWidth= srcSize.width;
    unsigned int uiHeight= srcSize.height;
    
    //target bg picture size
    unsigned int bgWidth = PIC_WIDTH;
    unsigned int bgHeight = PIC_HEIGHT;
    NSSize tarSize =NSMakeSize(bgWidth, bgHeight);
    
    if(uiWidth>=bgWidth && uiHeight >= bgHeight)
    {
        [sourceImage setSize:tarSize];
        return [[sourceImage copy] autorelease];
    }
    if(uiWidth>bgWidth && uiHeight < bgHeight)
    {
        [sourceImage setSize:tarSize];
        
        //target bg picture
        NSImage *targetImage = [[NSImage alloc] initWithSize:tarSize];
        [targetImage lockFocus];
        //fill target bg picture,using white color
        [[NSColor whiteColor] set];
        NSRectFill(NSMakeRect(0,0, bgWidth, bgHeight*fraction));
        
        //draw
        [sourceImage drawAtPoint:NSMakePoint(0,(bgHeight - uiHeight)*0.5) fromRect:NSZeroRect operation:NSCompositeSourceIn fraction:1.0];
        [targetImage unlockFocus];
        return [targetImage autorelease];
    }
    if(uiWidth<bgWidth && uiHeight >bgHeight)
    {
        [sourceImage setSize:tarSize];
        
        //target bg picture
        NSImage *targetImage = [[NSImage alloc] initWithSize:tarSize];
        [targetImage lockFocus];
        //fill target bg picture,using white color
        [[NSColor whiteColor] set];
        NSRectFill(NSMakeRect(0, 0, bgWidth, bgWidth*fraction));
        
        //draw
        [sourceImage drawAtPoint:NSMakePoint((bgWidth- uiWidth)*0.5, 0) fromRect:NSZeroRect operation:NSCompositeSourceIn fraction:1.0];
        [targetImage unlockFocus];
        return [targetImage autorelease];
    }
    else
        //(uiWidth<bgWidth && uiHeight < bgHeight)
    {
        //[sourceImage setSize:tarSize];
        //target bg picture
        NSImage *targetImage = [[NSImage alloc] initWithSize:tarSize];
        [targetImage lockFocus];
        //fill target bg picture,using white color
        [[NSColor whiteColor] set];
        NSRectFill(NSMakeRect(0, 0, bgWidth, bgWidth*fraction));
        
        //draw
        [sourceImage drawAtPoint:NSMakePoint((bgWidth - uiWidth)*0.5, (bgHeight - uiHeight)*0.5) fromRect:NSZeroRect operation:NSCompositeSourceIn fraction:1.0];
        [targetImage unlockFocus];
        return [targetImage autorelease];
    }
}
//按照图片的中心旋转90.180.270,360度
+ (NSImage *) rotateImage:(NSImage*)sourceImage byDegrees:(float)deg
{
    NSSize srcsize= [sourceImage size];
    float srcw = srcsize.width;
    float srch= srcsize.height;
    float newdeg = 0;
    //旋转弧度
    //double ratain = ((deg/180) * PI);
    NSRect r1;
    if(0< deg && deg <=90)
    {
        r1 = NSMakeRect(0.5*(srcw -srch), 0.5*(srch-srcw), srch, srcw);
        newdeg = 90.0;
    }
    if(90< deg && deg <=180)
    {
        r1 = NSMakeRect(0, 0, srcw, srch);
        newdeg = 180.0;
    }
    if(180< deg && deg <=270)
    {
        r1 = NSMakeRect(0.5*(srcw -srch), 0.5*(srch-srcw), srch, srcw);
        newdeg = 270.0;
    }
    if(270< deg && deg <=360)
    {
        r1 = NSMakeRect(0, 0, srch, srcw);
        newdeg = 360;
    }
    
    //draw new image
    NSImage *rotated = [[NSImage alloc] initWithSize:[sourceImage size]];
    [rotated lockFocus];
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:(0.5*srcw) yBy: (0.5*srch)];  //按中心图片旋转
    [transform rotateByDegrees:newdeg];                   //旋转度数，rotateByRadians：使用弧度
    [transform translateXBy:(-0.5*srcw) yBy: (-0.5*srch)];
    [transform concat];
    [[sourceImage bestRepresentationForDevice: nil] drawInRect: r1];//矩形内画图
    
    //[sourceImage drawInRect:r1 fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    //[sourceImage drawAtPoint:arge/*NSZeroPoint*/ fromRect:NSMakeRect(arge.x, arge.y,ww ,wh)/*NSZeroRect*/ operation:NSCompositeCopy fraction:1.0];
    [rotated unlockFocus];
    
    return [rotated autorelease];
}
//save image to file
- (BOOL)saveImage:(NSImage*)image                      //source image
         saveType:(NSBitmapImageFileType)storageType   //save type "NSJPEGFileType"
       properties:(NSDictionary *)properties         //properties "NSImageCompressionFactor = (NSNumber)0.8"
         ToTarget:(NSString *) targePath               //save path
{
    NSData *tempdata;
    NSBitmapImageRep *srcImageRep;
    BOOL reflag = NO;
    [image lockFocus];
    srcImageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    tempdata = [srcImageRep representationUsingType:storageType properties:properties];
    reflag = [tempdata writeToFile:targePath atomically:YES];
    [image unlockFocus];
    return reflag;
}
// ---------------------------------------------------------------------------------------------------------------------
- (CGImageRef)thumbnailForFile: (NSString*)name
                        atPath: (NSString*)filePath
{
    // use ImageIO to get a thumbnail for a file at a given path
    CGImageSourceRef    isr = NULL;
    NSString *          path = [filePath stringByExpandingTildeInPath];
    CGImageRef          image = NULL;
    
    //  path = [path stringByAppendingPathComponent: name];
    
    // create the CGImageSourceRef
    isr = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath: path], NULL);
    if (isr)
    {
        // create a thumbnail:
        // - specify max pixel size
        // - create the thumbnail with honoring the EXIF orientation flag (correct transform)
        // - always create the thumbnail from the full image (ignore the thumbnail that may be embedded in the image -
        //                                                  reason: our MAX_ICON_SIZE is larger than existing thumbnail)
        image = CGImageSourceCreateThumbnailAtIndex (isr, 0, (CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                                               [NSNumber numberWithInt: MAX_PIXEL_SIZE],  kCGImageSourceThumbnailMaxPixelSize,
                                                                               (id)kCFBooleanTrue,                       kCGImageSourceCreateThumbnailWithTransform,
                                                                               (id)kCFBooleanTrue,                       kCGImageSourceCreateThumbnailFromImageAlways,
                                                                               NULL] );
        
        CFRelease(isr);
    }
    return image;
}
+ (NSImage*) imageFromCGImageRef:(CGImageRef)image
{
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
    CGContextRef imageContext = nil;
    NSImage* newImage = nil;
    // Get the image dimensions.
    imageRect.size.height = CGImageGetHeight(image);
    imageRect.size.width = CGImageGetWidth(image);
    // Create a new image to receive the Quartz image data.
    newImage = [[[NSImage alloc] initWithSize:imageRect.size] autorelease];
    [newImage lockFocus];
    // Get the Quartz context and draw.
    imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
    [newImage unlockFocus];
    return newImage;
}
- (CGImageRef)nsImageToCGImageRef//:(NSImage*)image;
{
    NSData * imageData = [self TIFFRepresentation];
    CGImageRef imageRef;
    if(imageData)
    {
        CGImageSourceRef imageSource =
        CGImageSourceCreateWithData(
                                    (CFDataRef)imageData,  NULL);
        imageRef = CGImageSourceCreateImageAtIndex(
                                                   imageSource, 0, NULL);
    }
    return imageRef;
}
//Set smoothing effect
- (BOOL)setSmoothingEffect
{
    NSBitmapImageRep *rep = [[self representations] objectAtIndex: 0];
    NSSize size = NSMakeSize ([rep pixelsWide], [rep pixelsHigh]);
    if(size.width >0 && size.height>0)
    {
        [self setSize: size];
        return YES;
    }
    return NO;
}
// Generates a 256 by 256 pixel image with a complicated gradient in it.
+ (NSImage *) prettyGradientImage:(NSSize)gradientSize
{
    NSImage *newImage = [[self alloc] initWithSize:gradientSize];  // In this case, the pixel dimensions match the image size.
    int pixelsWide = gradientSize.width;
    int pixelsHigh = gradientSize.height;
    
    NSBitmapImageRep *bitmapRep =
    [[NSBitmapImageRep alloc]
     initWithBitmapDataPlanes: nil  // Nil pointer makes the kit allocate the pixel buffer for us.
     pixelsWide: pixelsWide  // The compiler will convert these to integers, but I just wanted to  make it quite explicit
     pixelsHigh: pixelsHigh //
     bitsPerSample: 8
     samplesPerPixel: 4  // Four samples, that is: RGBA
     hasAlpha: YES
     isPlanar: NO  // The math can be simpler with planar images, but performance suffers..
     colorSpaceName: NSCalibratedRGBColorSpace  // A calibrated color space gets us ColorSync for free.
     bytesPerRow: 0     // Passing zero means "you figure it out."
     bitsPerPixel: 32];  // This must agree with bitsPerSample and samplesPerPixel.
    
    unsigned char *imageBytes = [bitmapRep bitmapData];  // -bitmapData returns a void*, not an NSData object ;-)
    
    int row = pixelsHigh;
    while(row--)
    {
        int col = pixelsWide;
        while(col--)
        {
            int
            pixelIndex = 4 * (row * pixelsWide + col);
            imageBytes[pixelIndex + red] = rint(fmod(distance(NSMakePoint(col/1.5,(255-row)/1.5)),255.0));  //red
            imageBytes[pixelIndex + green] = rint(fmod(distance(NSMakePoint(col/1.5, row/1.5)),255.0));  // green
            imageBytes[pixelIndex + blue] = rint(fmod(distance(NSMakePoint((255-col)/1.5,(255-row)/1.5)),255.0));  // blue
            imageBytes[pixelIndex + alpha] = 255;  // Not doing anything tricky with the Alpha value here...
        }
    }
    [newImage addRepresentation:bitmapRep];
    return [newImage autorelease];
}
@end
float distance(NSPoint aPoint)  // Stole this from some guy named Pythagoras..  Returns the distance of aPoint from the origin.
{
    return sqrt(aPoint.x * aPoint.x + aPoint.y *aPoint.y);
}
//open selecter file panel
/*static NSArray* openImageFiles()
 {
 // Get a list of extensions to filter in our NSOpenPanel.
 NSOpenPanel* panel = [NSOpenPanel openPanel];
 [panel setCanChooseDirectories:YES];    // The user can choose a folder; images in the folder are added recursively.
 [panel setCanChooseFiles:YES];
 [panel setAllowsMultipleSelection:YES];
 if ([panel runModalForTypes:[NSImage imageUnfilteredFileTypes]] == NSOKButton)
 return [panel filenames];
 return nil;
 }*/