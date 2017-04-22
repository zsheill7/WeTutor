//
//  FSCalendarDelegationFactory.h
//  FSCalendar


#import <Foundation/Foundation.h>
#import "FSCalendarDelegationProxy.h"

@interface FSCalendarDelegationFactory : NSObject

+ (FSCalendarDelegationProxy *)dataSourceProxy;
+ (FSCalendarDelegationProxy *)delegateProxy;

@end
