//
//  TimingFunction.h
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 30/03/2010.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface TimingFunction : NSObject {
	NSString* function;
	NSString* constantName;
	NSString* description;
}

-(id)initWithFunction:(NSString*)function constantName:(NSString*)constantName andDescription:(NSString*)description;

@property (retain, nonatomic) NSString* function;
@property (retain, nonatomic) NSString* constantName;
@property (retain, nonatomic) NSString* description;

@end
