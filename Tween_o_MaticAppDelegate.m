//
//  Tween_o_MaticAppDelegate.m
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 25/03/2010.
//

#import "Tween_o_MaticAppDelegate.h"
#import "TimingFunction.h"

@implementation Tween_o_MaticAppDelegate

@synthesize window=_window;
@synthesize grid=_grid;
@synthesize demoImage=_demoImage;
@synthesize curveTypes=_curveTypes;
@synthesize timingFunction=_timingFunction;
@synthesize demoAnimationStartX=_demoAnimationStartX;
@synthesize demoAnimationEndX=_demoAnimationEndX;

@synthesize curveTypeDropDown=_curveTypeDropDown;
@synthesize cp1X=_cp1X;
@synthesize cp1Y=_cp1Y;
@synthesize cp2X=_cp2X;
@synthesize cp2Y=_cp2Y;
@synthesize constructor=_constructor;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.grid.cp1 = NSMakePoint(0.0, 0.3);
    self.grid.cp2 = NSMakePoint(0.8, 1.0);
    self.grid.delegate = self;
    
    self.curveTypes = [NSArray arrayWithObjects:
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionDefault 
                                    constantName:@"kCAMediaTimingFunctionDefault" 
                                  andDescription:@"Default"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionEaseIn 
                                    constantName:@"kCAMediaTimingFunctionEaseIn" 
                                  andDescription:@"Ease In"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionEaseOut 
                                    constantName:@"kCAMediaTimingFunctionEaseOut" 
                                  andDescription:@"Ease Out"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionEaseInEaseOut 
                                    constantName:@"kCAMediaTimingFunctionEaseInEaseOut" 
                                  andDescription:@"Ease In, Ease Out"] autorelease],
       [[[TimingFunction alloc] initWithFunction:kCAMediaTimingFunctionLinear 
                                    constantName:@"kCAMediaTimingFunctionLinear" 
                                  andDescription:@"Linear"] autorelease],
       [[[TimingFunction alloc] initWithFunction:nil 
                                    constantName:nil 
                                  andDescription:@"Custom"] autorelease],
      nil
    ];
    
    [self.curveTypeDropDown removeAllItems];
    for (TimingFunction* tf in self.curveTypes) {
        [self.curveTypeDropDown addItemWithTitle:tf.description];
    }
    
    [self updateTimingFunction:nil];
    
    [self updateControlPointFromGridAtIndex:CP_1];
    [self updateControlPointFromGridAtIndex:CP_2];
    
    
    self.demoAnimationStartX = 17.0f;
    self.demoAnimationEndX   = 250.0f;
}

-(void)dealloc {
    self.window = nil;
    self.grid = nil;
    self.demoImage = nil;
    self.curveTypes = nil;
    self.timingFunction = nil;
    self.curveTypeDropDown = nil;
    self.cp1X = nil;
    self.cp2X = nil;
    self.cp1Y = nil;
    self.cp2Y = nil;
    self.constructor = nil;
    [super dealloc];
}

-(IBAction)doAnimationDemo:(id)sender {
    CALayer* demoLayer = self.demoImage.layer;
        
    double duration = 1.0;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = demoLayer.position.y;
    CGPathMoveToPoint(path, NULL, self.demoAnimationStartX, y);
    CGPathAddLineToPoint(path, NULL, self.demoAnimationEndX, y);
    
    animation.path = path;
    animation.duration = duration;
    CGPathRelease(path);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;
    group.timingFunction = self.timingFunction;
    group.animations = [NSArray arrayWithObjects:animation, nil];
    
    [demoLayer addAnimation:group forKey:@"doAnimationDemo"];
    
    demoLayer.position = CGPointMake(self.demoAnimationEndX, y);
}


-(void)windowDidResize:(NSNotification*)notification {
    [self updateTimingFunction:nil];
}

-(IBAction)updateTimingFunction:(id)sender {
    int curveTypeIndex = [self.curveTypeDropDown indexOfSelectedItem];
    if (curveTypeIndex <= 4) {
        TimingFunction* tf = (TimingFunction*)[self.curveTypes objectAtIndex:curveTypeIndex];

        self.timingFunction = [CAMediaTimingFunction functionWithName:tf.function];
        
        // Update the grid with the appropriate control point coordinates
        float coords[2];
        [self.timingFunction getControlPointAtIndex:1 values:coords];
        self.grid.cp1 = NSMakePoint(coords[0], coords[1]);
        
        [self.timingFunction getControlPointAtIndex:2 values:coords];
        self.grid.cp2 = NSMakePoint(coords[0], coords[1]);
        
        // update the constructor field
        [self.constructor setStringValue:[NSString stringWithFormat:@"[CAMediaTimingFunction functionWithName:%@]", tf.constantName]];
        
    } else {
        self.timingFunction = [CAMediaTimingFunction functionWithControlPoints:self.grid.cp1.x
                                                                         :self.grid.cp1.y
                                                                         :self.grid.cp2.x
                                                                         :self.grid.cp2.y];
        // update the constructor field
        [self.constructor setStringValue:[NSString stringWithFormat:@"[CAMediaTimingFunction functionWithControlPoints:%.2f :%.2f :%.2f :%.2f]", self.grid.cp1.x, self.grid.cp1.y, self.grid.cp2.x, self.grid.cp2.y]];
    }
    [self doAnimationDemo:nil];
}

-(IBAction)updateControlPoints:(id)sender {
    [self.curveTypeDropDown selectItemAtIndex:5]; // set drop-down to "custom"
    self.grid.cp1 = NSMakePoint([self.cp1X floatValue], [self.cp1Y floatValue]);
    self.grid.cp2 = NSMakePoint([self.cp2X floatValue], [self.cp2Y floatValue]);
    [self updateTimingFunction:nil];
}

-(void)controlPointWasDraggedAtIndex:(unsigned int)index {
    [self.curveTypeDropDown selectItemAtIndex:5]; // set drop-down to "custom"
    [self updateControlPointFromGridAtIndex:index];
    [self updateTimingFunction:nil];
}
    
-(void)updateControlPointFromGridAtIndex:(unsigned int)index {
    if (index == CP_1) {
        [self.cp1X setFloatValue:self.grid.cp1.x];
        [self.cp1Y setFloatValue:self.grid.cp1.y];
    } else {
        [self.cp2X setFloatValue:self.grid.cp2.x];
        [self.cp2Y setFloatValue:self.grid.cp2.y];
    }
}

@end
