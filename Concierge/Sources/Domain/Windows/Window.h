#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Window : NSObject

@property(nonatomic) pid_t pid;

@property(nonatomic) long number;

@property(nonatomic) AXUIElementRef ref;

- (id) initFocusedWithPid: (pid_t) pid andRef: (AXUIElementRef) ref;

- (id) initWithPid:(pid_t)pid andNumber: (long) number andRef:(AXUIElementRef)ref;

- (NSString*) title;

- (CGPoint) position;

- (CGSize) size;

@end

NS_ASSUME_NONNULL_END
