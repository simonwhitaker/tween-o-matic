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
	NSImageView* demoImage;
	CGFloat demoAnimationStartX;
	CGFloat demoAnimationEndX;
	
	IBOutlet NSPopUpButton* curveTypeDropDown;
	IBOutlet NSTextField* cp1X;
	IBOutlet NSTextField* cp1Y;
	IBOutlet NSTextField* cp2X;
	IBOutlet NSTextField* cp2Y;
	IBOutlet NSTextField* constructor;
}

-(IBAction)updateTimingFunction:(id)sender;
-(IBAction)updateControlPoints:(id)sender;
-(IBAction)doAnimationDemo:(id)sender;

-(void)updateControlPointFromGridAtIndex:(unsigned int)index;

@property (assign) IBOutlet Grid* grid;
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *demoImage;

@end
