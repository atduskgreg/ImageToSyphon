//
//  GABAppDelegate.h
//  SyphonToUnity
//
//  Created by Greg Borenstein on 1/18/14.
//  Copyright (c) 2014 Greg Borenstein. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GLKit/GLKit.h>
#import <Syphon/Syphon.h>
#import "ContainerView.h"

@interface GABAppDelegate : NSObject <NSApplicationDelegate>{
    IBOutlet ContainerView* containerView;
    SyphonServer* syphonServer;
}

@property (assign) IBOutlet NSWindow *window;

@end
