#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#import "Window.h"

NS_ASSUME_NONNULL_BEGIN

@interface WindowController : NSObject

- (nullable Window*) active;

- (nullable Window*) findWindowByPid: (pid_t) pid;

- (NSArray*) findAllAvailableWindows;

- (void) resize: (Window*) window position: (CGRect) position;

@end

NS_ASSUME_NONNULL_END
