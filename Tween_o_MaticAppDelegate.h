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
}

-(IBAction)updateTimingFunction:(id)sender;
-(IBAction)updateControlPoints:(id)sender;
-(IBAction)doAnimationDemo:(id)sender;

-(void)updateControlPointFromGridAtIndex:(unsigned int)index;

@property (nonatomic, retain) IBOutlet Grid* grid;
@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSImageView *demoImage;

@property (nonatomic, copy) NSArray* curveTypes;
@property (nonatomic, retain) CAMediaTimingFunction* timingFunction;
@property (nonatomic) CGFloat demoAnimationStartX;
@property (nonatomic) CGFloat demoAnimationEndX;

@property (nonatomic, retain) IBOutlet NSPopUpButton* curveTypeDropDown;
@property (nonatomic, retain) IBOutlet NSTextField* cp1X;
@property (nonatomic, retain) IBOutlet NSTextField* cp1Y;
@property (nonatomic, retain) IBOutlet NSTextField* cp2X;
@property (nonatomic, retain) IBOutlet NSTextField* cp2Y;
@property (nonatomic, retain) IBOutlet NSTextField* constructor;

@end
