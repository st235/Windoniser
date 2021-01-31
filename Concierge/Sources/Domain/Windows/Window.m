#import "Window.h"

@implementation Window

@synthesize pid;

@synthesize ref;

@synthesize number;

- (id) initFocusedWithPid:(pid_t)pid andRef:(AXUIElementRef)ref {
    self = [super init];
    
    self.pid = pid;
    self.ref = ref;
    
    // NO NUMBER
    self.number = -1;
    
    return self;
}

- (id) initWithPid:(pid_t)pid andNumber: (long) number andRef:(AXUIElementRef)ref {
    self = [super init];
    
    self.pid = pid;
    self.ref = ref;
    self.number = number;
    
    return self;
}

- (NSString*) title {
    NSString* title = nil;
    AXUIElementCopyAttributeValue(ref, kAXTitleAttribute, (void*) &title);
    return title;
}

- (CGPoint) position {
    CGPoint position;
    CFTypeRef positionRef;

    AXUIElementCopyAttributeValue(ref, kAXPositionAttribute, (CFTypeRef*) &positionRef);
    AXValueGetValue(positionRef, kAXValueCGPointType, &position);
    
    CFRelease(positionRef);
    
    return position;
}

- (CGSize) size {
    CGSize size;
    CFTypeRef sizeRef;

    AXUIElementCopyAttributeValue(ref, kAXSizeAttribute, (CFTypeRef*) &sizeRef);
    AXValueGetValue(sizeRef, kAXValueCGSizeType, &size);
    
    CFRelease(sizeRef);
    return size;
}

@end
