//
//  GABAppDelegate.m
//  SyphonToUnity
//
//  Created by Greg Borenstein on 1/18/14.
//  Copyright (c) 2014 Greg Borenstein. All rights reserved.
//

#import "GABAppDelegate.h"

@implementation GABAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    NSOpenGLPixelFormatAttribute attr[] =
    {
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFAAccelerated,
		NSOpenGLPFADepthSize, 24,
		NSOpenGLPFAMultisample,
		NSOpenGLPFASampleBuffers, 1,
		NSOpenGLPFASamples, 4,
		(NSOpenGLPixelFormatAttribute) 0
    };
//
//    // Make our GL Pixel Format
    NSOpenGLPixelFormat* pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:attr];
    
    if(!pf)
        NSLog(@"Could not create pixel format, falling back to simpler pixel format");
    
    NSOpenGLPixelFormatAttribute simpleattr[] =
    {
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAAccelerated,
        (NSOpenGLPixelFormatAttribute) 0
    };
    
    pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:simpleattr];
    
    if(!pf)
    {
        NSLog(@"Could not create pixel format, bailing");
        [NSApp terminate:self];
    }
    
    NSOpenGLContext* glContext = [[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];
    
    [glContext makeCurrentContext];

    syphonServer = [[SyphonServer alloc] initWithName:nil
                                              context:[glContext CGLContextObj]
                                              options:nil];

    NSImage* anImage = [containerView.imageView image];

    const size_t bitsPerComponent = 8;
    const int componentsPerPixel = 4;
    const size_t bytesPerRow=((bitsPerComponent * [[containerView.imageView image] size].width) / 8) * componentsPerPixel;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSLog(@"image size: %fx%f", [anImage size].width, [anImage size].height);

    NSBitmapImageRep* imageRep=[[NSBitmapImageRep alloc] initWithData:[anImage TIFFRepresentation]];
    CGImageRef pixelData = [imageRep CGImage];

    //unsigned char *rawData = malloc([anImage size].width * [anImage size].height * 4);
    CGContextRef gtx = CGBitmapContextCreate(NULL, [anImage size].width, [anImage size].height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(gtx, CGRectMake(0, 0, 1132, 994), pixelData);
    CGContextFlush(gtx);

    // ALTERNATIVE GLKTextureLoader LOAD FROM FILE EXPERIMENT
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"test_map" ofType:@"png"];
//    NSLog(@"path: %@", path);
//    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:path options:NULL error:NULL];

    GLKTextureInfo* texture = [GLKTextureLoader textureWithCGImage:pixelData options:NULL error:NULL];

    NSLog(@"texture: %i %ix%i", texture.name, texture.width, texture.height);
    [syphonServer publishFrameTexture:texture.name
                    textureTarget:GL_TEXTURE_2D
                      imageRegion:NSMakeRect(0, 0, texture.width, texture.height)
                textureDimensions:NSMakeSize(texture.width, texture.height)
                          flipped:YES];
    
}

@end
