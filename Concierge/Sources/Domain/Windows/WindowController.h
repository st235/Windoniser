#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#import "Window.h"

NS_ASSUME_NONNULL_BEGIN

@interface WindowController : NSObject

- (nullable Window*) active;

- (NSArray*) findAllAvailableWindows;

- (void) resize: (nonnull Window*) window position: (CGRect) position;

- (void) bringToFrontWindow: (nonnull Window*) window;

@end

NS_ASSUME_NONNULL_END
