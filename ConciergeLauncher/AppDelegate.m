#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
    pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
    NSString *path = [NSString pathWithComponents:pathComponents];
    
    NSWorkspaceOpenConfiguration* configuration = [NSWorkspaceOpenConfiguration new];
    [configuration setPromptsUserIfNeeded:true];
    
    [[NSWorkspace sharedWorkspace] openApplicationAtURL: [NSURL fileURLWithPath:path]
                                   configuration:configuration
                                   completionHandler:^(NSRunningApplication* app, NSError* error) {
        if (error) {
            NSLog(@"Failed to load applocation: %@", error.localizedDescription);
        }
        
        [NSApp terminate:nil];
    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
