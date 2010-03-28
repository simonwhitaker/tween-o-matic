//
//  Tween_o_MaticAppDelegate.m
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 25/03/2010.
//

#import "Tween_o_MaticAppDelegate.h"

@implementation Tween_o_MaticAppDelegate

@synthesize window;
@synthesize grid;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	self.grid.cp1 = NSMakePoint(0.0, 0.3);
	self.grid.cp2 = NSMakePoint(0.8, 1.0);
	self.grid.delegate = self;
	
	curveTypes = [[NSArray arrayWithObjects:
				  kCAMediaTimingFunctionDefault,
				  kCAMediaTimingFunctionEaseIn,
				  kCAMediaTimingFunctionEaseOut,
				  kCAMediaTimingFunctionEaseInEaseOut,
				  kCAMediaTimingFunctionLinear,
				  @"custom",
				  nil
				  ] retain];
	
	[curveTypeDropDown removeAllItems];
	[curveTypeDropDown addItemsWithTitles:curveTypes];
	[self updateTimingFunction:nil];
}

-(void)windowDidResize:(NSNotification*)notification {
	[self updateTimingFunction:nil];
}

-(void)updateTimingFunction:(id)sender {
	int curveTypeIndex = [curveTypeDropDown indexOfSelectedItem];
	if (curveTypeIndex <= 4) {
		timingFunction = [CAMediaTimingFunction functionWithName:(NSString*)[curveTypes objectAtIndex:curveTypeIndex]];
		[cp1X setEnabled:NO];
		[cp1Y setEnabled:NO];
		[cp2X setEnabled:NO];
		[cp2Y setEnabled:NO];
	} else {
		timingFunction = [CAMediaTimingFunction functionWithControlPoints:self.grid.cp1.x
																		 :self.grid.cp1.y
																		 :self.grid.cp2.x
																		 :self.grid.cp2.y];
		[cp1X setEnabled:YES];
		[cp1Y setEnabled:YES];
		[cp2X setEnabled:YES];
		[cp2Y setEnabled:YES];
	}
	
	float coords[2];
	[timingFunction getControlPointAtIndex:1 values:coords];
	self.grid.cp1 = NSMakePoint(coords[0], coords[1]);

	[timingFunction getControlPointAtIndex:2 values:coords];
	self.grid.cp2 = NSMakePoint(coords[0], coords[1]);
}

-(IBAction)updateControlPoints:(id)sender {
	grid.cp1 = NSMakePoint([cp1X floatValue], [cp1Y floatValue]);
	grid.cp2 = NSMakePoint([cp2X floatValue], [cp2Y floatValue]);
}

-(void)gridDidUpdate {
	[cp1X setFloatValue:self.grid.cp1.x];
	[cp1Y setFloatValue:self.grid.cp1.y];
	[cp2X setFloatValue:self.grid.cp2.x];
	[cp2Y setFloatValue:self.grid.cp2.y];
}

@end
