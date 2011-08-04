//
//  Grid.h
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 25/03/2010.
//

#import <Cocoa/Cocoa.h>
#define DRAG_HANDLE_RADIUS 5.0

enum draghandle {
    CP_NONE,
    CP_1,
    CP_2
};

@protocol GridDelegate;

@interface Grid : NSView {
}

@property (nonatomic) CGFloat border;
@property (nonatomic) NSUInteger activeDragHandle;
@property (nonatomic) NSPoint cp1;
@property (nonatomic) NSPoint cp2;
@property (nonatomic, assign) id<GridDelegate> delegate;

@end

@protocol GridDelegate <NSObject>

-(void)controlPointWasDraggedAtIndex:(unsigned int)index;

@end