#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Window : NSObject

@property(nonatomic) pid_t pid;

@property(nonatomic) AXUIElementRef ref;

- (id) initWithPid: (pid_t) pid andRef: (AXUIElementRef) ref;

- (NSString*) title;

- (CGPoint) position;

- (CGSize) size;

@end

NS_ASSUME_NONNULL_END
