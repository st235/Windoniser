#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#import "Window.h"

NS_ASSUME_NONNULL_BEGIN

@interface WindowController : NSObject

- (Window*) active;

- (NSArray*) requestAllWindows;

- (void) resize: (Window*) window position: (CGRect) position;

@end

NS_ASSUME_NONNULL_END
