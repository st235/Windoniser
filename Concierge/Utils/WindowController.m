#import "WindowController.h"

@implementation WindowController

- (NSRunningApplication*) activeApplication {
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSArray *apps = [workspace runningApplications];

    for (NSRunningApplication* app in apps) {
        if (app.activationPolicy == NSApplicationActivationPolicyRegular && app.isActive) {
            return app;
        }
    }

    return nil;
}

- (Window*) active {
    NSRunningApplication* runningApp = [self activeApplication];
    
    AXUIElementRef app = AXUIElementCreateApplication(runningApp.processIdentifier);
    
    AXUIElementRef window = nil;
    AXUIElementCopyAttributeValue(app, kAXFocusedWindowAttribute, (CFTypeRef*)&window);


    return [[Window alloc] initWithPid:runningApp.processIdentifier andRef:window];
}

- (Window*) windowForPid:(pid_t)pid {
    AXUIElementRef appRef = AXUIElementCreateApplication(pid);
    
    CFArrayRef windowList;
    AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute, (CFTypeRef*) &windowList);
    if ((!windowList) || CFArrayGetCount(windowList) < 1) {
        return nil;
    }
    
    AXUIElementRef windowRef = (AXUIElementRef) CFArrayGetValueAtIndex(windowList, 0);
    return [[Window alloc] initWithPid:pid andRef:windowRef];
}

- (NSArray*) requestAllWindows {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    @autoreleasepool {
        CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
        NSArray* arr = CFBridgingRelease(windowList);
        
        for (NSMutableDictionary* entry in arr) {
            pid_t pid = [[entry objectForKey:(id)kCGWindowOwnerPID] intValue];
            Window* window = [self windowForPid:pid];
            
            if (!window) {
                continue;
            }
            
            [result addObject: (id) window];
        }
    }
    
    return result;
}

- (void) resize:(Window *)window position:(CGRect)position {
    AXValueRef temp;
    temp = AXValueCreate(kAXValueCGSizeType, &position.size);
    AXUIElementSetAttributeValue(window.ref, kAXSizeAttribute, temp);
    CFRelease(temp);

    temp = AXValueCreate(kAXValueCGPointType, &position.origin);
    AXUIElementSetAttributeValue(window.ref, kAXPositionAttribute, temp);
    CFRelease(temp);
    
    temp = AXValueCreate(kAXValueCGSizeType, &position.size);
    AXUIElementSetAttributeValue(window.ref, kAXSizeAttribute, temp);
    CFRelease(temp);
}

@end
