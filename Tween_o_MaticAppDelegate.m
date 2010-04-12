//
//  Tween_o_MaticAppDelegate.m
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 25/03/2010.
//

#import "Tween_o_MaticAppDelegate.h"
#import "TimingFunction.h"

@implementation Tween_o_MaticAppDelegate

@synthesize window;
@synthesize grid;
@synthesize demoImage;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.grid.cp1 = NSMakePoint(0.0, 0.3);
    self.grid.cp2 = NSMakePoint(0.8, 1.0);
    self.grid.delegate = self;
    
    curveTypes = [[NSArray arrayWithObjects:
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionDefault constantName:@"kCAMediaTimingFunctionDefault" andDescription:@"Default"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionEaseIn constantName:@"kCAMediaTimingFunctionEaseIn" andDescription:@"Ease In"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionEaseOut constantName:@"kCAMediaTimingFunctionEaseOut" andDescription:@"Ease Out"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionEaseInEaseOut constantName:@"kCAMediaTimingFunctionEaseInEaseOut" andDescription:@"Ease In, Ease Out"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionLinear constantName:@"kCAMediaTimingFunctionLinear" andDescription:@"Linear"] autorelease],
       [[[TimingFunction alloc] initWithFunction:nil constantName:nil andDescription:@"Custom"] autorelease],
      nil
    ] retain];
    
    [curveTypeDropDown removeAllItems];
    for (TimingFunction* tf in curveTypes) {
        [curveTypeDropDown addItemWithTitle:tf.description];
    }
    
    [self updateTimingFunction:nil];
    
    [self updateControlPointFromGridAtIndex:CP_1];
    [self updateControlPointFromGridAtIndex:CP_2];
    
    
    demoAnimationStartX = 17.0f;
    demoAnimationEndX   = 250.0f;
}

-(IBAction)doAnimationDemo:(id)sender {
    CALayer* demoLayer = demoImage.layer;
        
    double duration = 1.0;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = demoLayer.position.y;
    CGPathMoveToPoint(path, NULL, demoAnimationStartX, y);
    CGPathAddLineToPoint(path, NULL, demoAnimationEndX, y);
    
    animation.path = path;
    animation.duration = duration;
    CGPathRelease(path);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;
    group.timingFunction = timingFunction;
    group.animations = [NSArray arrayWithObjects:animation, nil];
    
    [demoLayer addAnimation:group forKey:@"doAnimationDemo"];
    
    demoLayer.position = CGPointMake(demoAnimationEndX, y);
}


-(void)windowDidResize:(NSNotification*)notification {
    [self updateTimingFunction:nil];
}

-(IBAction)updateTimingFunction:(id)sender {
    int curveTypeIndex = [curveTypeDropDown indexOfSelectedItem];
    if (curveTypeIndex <= 4) {
        TimingFunction* tf = (TimingFunction*)[curveTypes objectAtIndex:curveTypeIndex];

        timingFunction = [CAMediaTimingFunction functionWithName:tf.function];
        
        // Update the grid with the appropriate control point coordinates
        float coords[2];
        [timingFunction getControlPointAtIndex:1 values:coords];
        self.grid.cp1 = NSMakePoint(coords[0], coords[1]);
        
        [timingFunction getControlPointAtIndex:2 values:coords];
        self.grid.cp2 = NSMakePoint(coords[0], coords[1]);
        
        // update the constructor field
        [constructor setStringValue:[NSString stringWithFormat:@"[CAMediaTimingFunction functionWithName:%@]", tf.constantName]];
        
    } else {
        timingFunction = [CAMediaTimingFunction functionWithControlPoints:self.grid.cp1.x
                                                                         :self.grid.cp1.y
                                                                         :self.grid.cp2.x
                                                                         :self.grid.cp2.y];
        // update the constructor field
        [constructor setStringValue:[NSString stringWithFormat:@"[CAMediaTimingFunction functionWithControlPoints:%.2f :%.2f :%.2f :%.2f]", self.grid.cp1.x, self.grid.cp1.y, self.grid.cp2.x, self.grid.cp2.y]];
    }
    [self doAnimationDemo:nil];
}

-(IBAction)updateControlPoints:(id)sender {
    [curveTypeDropDown selectItemAtIndex:5]; // set drop-down to "custom"
    grid.cp1 = NSMakePoint([cp1X floatValue], [cp1Y floatValue]);
    grid.cp2 = NSMakePoint([cp2X floatValue], [cp2Y floatValue]);
    [self updateTimingFunction:nil];
}

-(void)controlPointWasDraggedAtIndex:(unsigned int)index {
    [curveTypeDropDown selectItemAtIndex:5]; // set drop-down to "custom"
    [self updateControlPointFromGridAtIndex:index];
    [self updateTimingFunction:nil];
}
    
-(void)updateControlPointFromGridAtIndex:(unsigned int)index {
    if (index == CP_1) {
        [cp1X setFloatValue:self.grid.cp1.x];
        [cp1Y setFloatValue:self.grid.cp1.y];
    } else {
        [cp2X setFloatValue:self.grid.cp2.x];
        [cp2Y setFloatValue:self.grid.cp2.y];
    }
}

@end
