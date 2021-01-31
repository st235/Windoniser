#import "WindowController.h"

@interface WindowController()

- (nullable NSRunningApplication*) activeApplication;

- (nullable NSRunningApplication*) applicationWithPid: (pid_t) pid;

- (nullable Window*) findWindowByPid: (pid_t) pid andNumber: (long) number andPosition:(CGPoint) position andSize: (CGSize) size;

@end

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

- (nullable NSRunningApplication*) applicationWithPid:(pid_t)pid  {
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSArray *apps = [workspace runningApplications];

    for (NSRunningApplication* app in apps) {
        if (app.activationPolicy == NSApplicationActivationPolicyRegular && app.processIdentifier == pid) {
            return app;
        }
    }

    return nil;
}

- (nullable Window*) active {
    NSRunningApplication* runningApp = [self activeApplication];
    
    AXUIElementRef app = AXUIElementCreateApplication(runningApp.processIdentifier);
    
    AXUIElementRef window = nil;
    AXUIElementCopyAttributeValue(app, kAXFocusedWindowAttribute, (CFTypeRef*)&window);
    CFRelease(app);

    return [[Window alloc] initFocusedWithPid:runningApp.processIdentifier andRef:window];
}

- (nullable Window*) findWindowByPid:(pid_t)pid andNumber: (long) number andPosition:(CGPoint) position andSize: (CGSize) size {
    AXUIElementRef appRef = AXUIElementCreateApplication(pid);
    
    CFArrayRef windowList;
    AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute, (CFTypeRef*) &windowList);
    CFRelease(appRef);
    
    if ((!windowList) || CFArrayGetCount(windowList) < 1) {
        return nil;
    }
    
    for (NSUInteger i = 0; i < CFArrayGetCount(windowList); i++) {
        AXUIElementRef windowRef = (AXUIElementRef) CFArrayGetValueAtIndex(windowList, i);
        Window* possibleWindow = [[Window alloc] initWithPid:pid andNumber:number andRef:windowRef];
        
        CGPoint candidatePosition = [possibleWindow position];
        CGSize candidateSize = [possibleWindow size];
        
        if (position.x == candidatePosition.x && position.y == candidatePosition.y && candidateSize.width == size.width && candidateSize.height == size.height) {
            return possibleWindow;
        }
    }
    
    return nil;
}

- (NSArray*) findAllAvailableWindows {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    @autoreleasepool {
        CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
        NSArray* arr = CFBridgingRelease(windowList);
        
        for (NSMutableDictionary* entry in arr) {
            pid_t pid = [[entry objectForKey:(id)kCGWindowOwnerPID] intValue];
            id rawBounds  = [entry objectForKey:(id)kCGWindowBounds];
            long windowNumber = [[entry objectForKey:(id)kCGWindowNumber] longValue];
            
            if ((!rawBounds) || ![rawBounds isKindOfClass: [NSDictionary class]]) {
                continue;
            }
            
            NSDictionary* bounds = (NSDictionary*) rawBounds;
            
            CGPoint windowPosition = CGPointMake([[bounds objectForKey: @"X"] floatValue], [[bounds objectForKey: @"Y"] floatValue]);
            CGSize windowSize = CGSizeMake([[bounds objectForKey: @"Width"] floatValue], [[bounds objectForKey: @"Height"] floatValue]);
            
            Window* window = [self findWindowByPid:pid andNumber: windowNumber andPosition: windowPosition andSize: windowSize];
            
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

- (void) bringToFrontWindow:(Window *)window {
    NSRunningApplication* app = [self applicationWithPid:window.pid];
    
    if (!app) {
        return;
    }
    
    [app activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

@end
