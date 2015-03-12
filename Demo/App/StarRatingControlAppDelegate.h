#import <UIKit/UIKit.h>


@class StarRatingControlViewController;


@interface StarRatingControlAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    StarRatingControlViewController *viewController;
}


/**************************************************************************************************/
#pragma mark - Getters & Setters

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet StarRatingControlViewController *viewController;


@end
