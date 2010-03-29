//
//  Grid.h
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 25/03/2010.
//

#import <Cocoa/Cocoa.h>
#import "GridDelegate.h"
#define DRAG_HANDLE_RADIUS 5.0

enum draghandle {
	CP_NONE,
	CP_1,
	CP_2
};

@interface Grid : NSView {
	float border;
	NSPoint cp1;
	NSPoint cp2;
	unsigned int activeDragHandle;
	id delegate;
}

@property (nonatomic) NSPoint cp1;
@property (nonatomic) NSPoint cp2;
@property (retain, nonatomic) id delegate;

@end
