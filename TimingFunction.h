//
//  TimingFunction.h
//  Tween-o-Matic
//
//  Created by Simon Whitaker on 30/03/2010.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface TimingFunction : NSObject {
}

-(id)initWithFunction:(NSString*)function constantName:(NSString*)constantName andDescription:(NSString*)description;

@property (copy, nonatomic) NSString* function;
@property (copy, nonatomic) NSString* constantName;
@property (copy, nonatomic) NSString* description;

@end
