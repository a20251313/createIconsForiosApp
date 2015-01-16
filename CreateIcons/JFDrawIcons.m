//
//  JFDrawIcons.m
//  CreateIcons
//
//  Created by jingfuran on 14-10-16.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

#import "JFDrawIcons.h"
#import "NSImage+ZCPanel.h"
@interface JFDrawIcons ()<NSTableViewDataSource,NSTableViewDelegate>
{
    NSMutableString *m_filePath;
    NSMutableString *m_storePath;

    IBOutlet NSPathControl   *iconPathCon;
    IBOutlet NSPathControl   *storePathCon;
    
    NSMutableArray  *arrayFiles;
    
}

@end

@implementation JFDrawIcons

-(id)init
{
    self = [super init];
    if (self)
    {
        m_filePath = [[NSMutableString alloc] init];
        m_storePath = [[NSMutableString alloc] init];
        arrayFiles = [[NSMutableArray alloc] init];
        [arrayFiles addObjectsFromArray:@[@"120",@"114",@"29",@"58",@"87",@"40",@"80",@"50",@"100",@"72",@"144",@"1024",@"512"]];
    }
    return self;
}

-(IBAction)clickStartAction:(id)sender
{
    if ([m_filePath isEqualToString:@""])
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@"请选择icon文件！" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
        [self clickIconPath:nil];
    }
    
    if ([m_storePath isEqualToString:@""])
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@"请选择文件保存路径！" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
        [self clickStorePath:nil];
    }
    
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:m_filePath];
    for (NSString *strSize in arrayFiles)
    {
        [self saveImage:image size:strSize];
    }
    
}



-(void)saveImage:(NSImage*)image size:(NSString*)strSize
{
    
    NSSize size = {[strSize floatValue],[strSize floatValue]};
    
    NSImage *tarGetImage = [NSImage createScalesImage:image size:size];

    

   // NSData  *data = [image TIFFRepresentationUsingCompression:NSTIFFCompressionCCITTFAX4 factor:1.0];
  /*  [image lockFocus];
    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc]initWithFocusedViewRect:NSMakeRect(0, 0, [strSize floatValue], [strSize floatValue])];
    [image unlockFocus];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:NSImageCompressionFactor];*/
     NSData *imageData = [tarGetImage TIFFRepresentation];
    
     NSString *strFilePath = [NSString stringWithFormat:@"%@/%@x%@.png",m_storePath,strSize,strSize];
     BOOL y = [imageData writeToFile:strFilePath atomically:YES];
     NSLog(@"Save Image: %d", y);
}

-(NSImage*)getImageOfSize:(CGSize)size image:(NSImage*)sourceImage
{
    
    
    return nil;
}
-(IBAction)clickIconPath:(id)sender
{
    
    NSRect rect = {400,0,400,200};
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] initWithContentRect:rect
                                                            styleMask:NSTitledWindowMask | NSResizableWindowMask backing:NSBackingStoreBuffered defer:YES];
    openPanel.canChooseDirectories = NO;
    openPanel.canChooseFiles = YES;
    openPanel.allowedFileTypes = @[@"png",@"PNG"];
    [openPanel setTitle:@"选择你的源文件(png类型)"];
    [openPanel setPrompt:@"确定"];
    [openPanel runModal];
    
    NSString    *strFile = [[openPanel URL] path];
    [m_filePath setString:strFile];
    [iconPathCon setURL:[NSURL fileURLWithPath:strFile]];
    
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:m_filePath];
    
    if (image != nil)
    {
        NSLog(@"image has value............\n\n\n\n\n");
    }
    if (image.size.width != image.size.height)
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@"图片不符合格式，请选择长宽相等的图片，谢谢！" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
    }
    NSLog(@"currentFile:%@",strFile);
}

-(IBAction)clickStorePath:(id)sender
{
    
    NSRect rect = {400,0,400,200};
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] initWithContentRect:rect
                                                            styleMask:NSTitledWindowMask | NSResizableWindowMask backing:NSBackingStoreBuffered defer:YES];
    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
   // openPanel.allowedFileTypes = @[@"png",@"PNG"];
    [openPanel setTitle:@"选择你的文件保存目录"];
    [openPanel setPrompt:@"确定"];
    [openPanel runModal];
    NSString    *strFile = [[openPanel URL] path];
    [m_storePath setString:strFile];
    [storePathCon setURL:[NSURL fileURLWithPath:strFile]];
    NSLog(@"currentFileDir:%@",strFile);
    
}



- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return arrayFiles.count;
}

/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView).
 */
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    static int count = 0;
    NSString    *strInfo = arrayFiles[row];
    NSLog(@"count:%d",count);
    count++;
    return strInfo;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{

}
@end
