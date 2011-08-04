//
//  TimingFunction.m
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 30/03/2010.
//

#import "TimingFunction.h"


@implementation TimingFunction

@synthesize constantName=_constantName;
@synthesize function=_function;
@synthesize description=_description;

-(id)initWithFunction:(NSString*)function 
         constantName:(NSString*)constantName 
       andDescription:(NSString*)description {
    if ((self = [super init])) {
        self.constantName = constantName;
        self.function = function;
        self.description = description;
    }
    return self;
}

-(void)dealloc {
    self.constantName = nil;
    self.function = nil;
    self.description = nil;
    [super dealloc];
}

@end
