#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#import "Window.h"

NS_ASSUME_NONNULL_BEGIN

@interface WindowController : NSObject

- (nullable Window*) active;

- (nullable Window*) findWindowByPid: (pid_t) pid;

- (NSArray*) findAllAvailableWindows;

- (void) resize: (nonnull Window*) window position: (CGRect) position;

- (void) bringToFrontWindow: (nonnull Window*) window;

@end

NS_ASSUME_NONNULL_END
