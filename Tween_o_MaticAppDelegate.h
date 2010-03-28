//
//  Tween_o_MaticAppDelegate.h
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 25/03/2010.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "Grid.h"

@interface Tween_o_MaticAppDelegate : NSObject <NSApplicationDelegate, GridDelegate> {
    NSWindow *window;
	Grid* grid;
	NSArray* curveTypes;
	CAMediaTimingFunction* timingFunction;
	
	IBOutlet NSPopUpButton* curveTypeDropDown;
	IBOutlet NSTextField* cp1X;
	IBOutlet NSTextField* cp1Y;
	IBOutlet NSTextField* cp2X;
	IBOutlet NSTextField* cp2Y;
}

-(IBAction)updateTimingFunction:(id)sender;
-(IBAction)updateControlPoints:(id)sender;

@property (assign) IBOutlet Grid* grid;
@property (assign) IBOutlet NSWindow *window;

@end
