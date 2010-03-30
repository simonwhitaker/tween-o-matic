//
//  TimingFunction.m
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 30/03/2010.
//

#import "TimingFunction.h"


@implementation TimingFunction

@synthesize constantName;
@synthesize function;
@synthesize description;

-(id)initWithFunction:(NSString*)fn constantName:(NSString*)cn andDescription:(NSString*)desc {
	self = [super init];
	if (self) {
		constantName = [cn retain];
		function	 = [fn retain];
		description  = [desc retain];
	}
	return self;
}

-(void)dealloc {
	[constantName release];
	[function release];
	[description release];
	[super dealloc];
}

@end
