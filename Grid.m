//
//  Grid.m
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 25/03/2010.
//

#import "Grid.h"
#include <math.h>

@implementation Grid

@synthesize delegate;

#pragma mark -
#pragma mark Initialisation stuff
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        border = 20.0;
        activeDragHandle = CP_NONE;
    }
    return self;
}

-(void)awakeFromNib {
    //[[self window] setAcceptsMouseMovedEvents:YES];   
}

#pragma mark -
#pragma mark Utility methods and functions
// Convert a point with coordinates in the range of the actual
// grid to a point with coordinates in the range [0,1]
-(NSPoint)normalisePoint:(NSPoint)point {
    NSPoint result = NSMakePoint(
        (point.x - border) / ([self frame].size.width - border * 2),
        (point.y - border) / ([self frame].size.height - border * 2)
    );
    return result;
}

// Convert a point with coordinates in the range [0,1] to 
// a point with coordinates in the range of the actual grid
-(NSPoint)denormalisePoint:(NSPoint)point {
    NSPoint result = NSMakePoint(
        ([self frame].size.width - border * 2) * point.x + border,
        ([self frame].size.height - border * 2) * point.y + border
    );
    return result;
}

float distanceBetweenPoints(NSPoint a, NSPoint b) {
    float x = a.x - b.x;
    float y = a.y - b.y;
    return sqrtf(x * x + y * y);
}


#pragma mark -
#pragma mark Control Point accessors
-(NSPoint)cp1 {
    return [self normalisePoint:cp1];
}

-(void)setCp1:(NSPoint)point {
    cp1 = [self denormalisePoint:point];
    [self setNeedsDisplay:YES];
}

-(NSPoint)cp2 {
    return [self normalisePoint:cp2];
}

-(void)setCp2:(NSPoint)point {
    cp2 = [self denormalisePoint:point];
    [self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark NSView overrides
-(BOOL)acceptsFirstResponder {
    return YES;
}

-(BOOL)acceptsFirstMouse:(NSEvent*)event {
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:dirtyRect];
    
    NSRect rect = [self frame];
        
    float w = rect.size.width - border * 2;
    float h = rect.size.height - border * 2;
    
    NSPoint origin = NSMakePoint(border, border);
    NSPoint dest   = NSMakePoint(w + border - 1, h + border - 1);
    
    // draw the grid
    [[NSColor grayColor] set];
    for (int i = 0; i <= 10; i++) {
        float x = w / 10 * i + border;
        float y = h / 10 * i + border;
        [NSBezierPath strokeLineFromPoint:NSMakePoint(border, y) toPoint:NSMakePoint(border + w - 1, y)];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(x, border) toPoint:NSMakePoint(x, border + h - 1)];
    }
    
    // draw the curve
    [[NSColor blackColor] set];
    NSBezierPath* line = [NSBezierPath bezierPath];
    [line moveToPoint:origin];
    [line curveToPoint:dest
         controlPoint1:cp1
         controlPoint2:cp2];
    [line stroke];
    
    // draw control point 1
    [[NSColor redColor] set];
    line = [NSBezierPath bezierPath];
    [line moveToPoint:origin];
    [line lineToPoint:cp1];
    [line stroke];
    
    line = [NSBezierPath bezierPath];
    [line appendBezierPathWithArcWithCenter:cp1
                                     radius:DRAG_HANDLE_RADIUS
                                 startAngle:0
                                   endAngle:360];
    [[NSColor whiteColor] set];
    [line fill];
    [[NSColor redColor] set];
    [line stroke];
    
    // draw control point 2
    [[NSColor blueColor] set];
    line = [NSBezierPath bezierPath];
    [line moveToPoint:dest];
    [line lineToPoint:cp2];
    [line stroke];
    
    line = [NSBezierPath bezierPath];
    [line appendBezierPathWithArcWithCenter:cp2
                                     radius:DRAG_HANDLE_RADIUS
                                 startAngle:0
                                   endAngle:360];
    [[NSColor whiteColor] set];
    [line fill];
    [[NSColor blueColor] set];
    [line stroke];
    
}

#pragma mark -
#pragma mark Mouse event handling
-(void)mouseDown:(NSEvent *)event
{
    // convert the mouse-down location into the view coords
    NSPoint location = [self convertPoint:[event locationInWindow]
                                    fromView:nil];

    if (distanceBetweenPoints(location, cp2) < DRAG_HANDLE_RADIUS * 2) {
        activeDragHandle = CP_2;
        [[NSCursor closedHandCursor] push];
    } else if (distanceBetweenPoints(location, cp1) < DRAG_HANDLE_RADIUS * 2) {
        activeDragHandle = CP_1;
        [[NSCursor closedHandCursor] push];
    } else {
        activeDragHandle = CP_NONE;
    }
}

-(void)mouseUp:(NSEvent*)event {
//  [[NSCursor arrowCursor] set];
    [NSCursor pop];
    [[self window] invalidateCursorRectsForView:self];
}

-(void)mouseMoved:(NSEvent*)event {
    NSPoint location = [self convertPoint:[event locationInWindow]
                                 fromView:nil];
    
    if (distanceBetweenPoints(location, cp1) < DRAG_HANDLE_RADIUS * 2 || distanceBetweenPoints(location, cp2) < DRAG_HANDLE_RADIUS * 2) {
        [[NSCursor openHandCursor] set];
    } else {
        //[[NSCursor arrowCursor] set];
    }
}

-(void)mouseDragged:(NSEvent*)event {
    if (activeDragHandle > CP_NONE) {
        //[[NSCursor closedHandCursor] set];
        NSPoint location = [self convertPoint:[event locationInWindow]
                                     fromView:nil];
        
        if (location.x < border) 
            location.x = border;
        else if (location.x > [self frame].size.width - border - 1)
            location.x = [self frame].size.width - border - 1;
        
        if (location.y < border) 
            location.y = border;
        else if (location.y > [self frame].size.height - border - 1)
            location.y = [self frame].size.height - border - 1;
        
        if (activeDragHandle == CP_1) {
            cp1 = location;
        }
        else {
            cp2 = location;
        }
        
        if (delegate && [delegate respondsToSelector:@selector(controlPointWasDraggedAtIndex:)])
            [delegate controlPointWasDraggedAtIndex:activeDragHandle];

        [self setNeedsDisplay:YES];
    }
}

@end
