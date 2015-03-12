#import "StarRatingControlAppDelegate.h"
#import "StarRatingControlViewController.h"


@implementation StarRatingControlAppDelegate


/**************************************************************************************************/
#pragma mark - Getters & Setters

@synthesize window;
@synthesize viewController;


/**************************************************************************************************/
#pragma mark - Application Lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [self.window setRootViewController:viewController];
    [window makeKeyAndVisible];
}


@end
