//
//  ContainerView.m
//  SyphonToUnity
//
//  Created by Greg Borenstein on 1/20/14.
//  Copyright (c) 2014 Greg Borenstein. All rights reserved.
//

#import "ContainerView.h"

@implementation ContainerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSRect rect = NSMakeRect(10, 10, 400, 300);
        _imageView = [[NSImageView alloc] initWithFrame:rect];
        [_imageView setImageScaling:NSScaleProportionally];
        [_imageView setImage:[NSImage imageNamed:@"test_map.png"]];
        [self addSubview:_imageView];
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
