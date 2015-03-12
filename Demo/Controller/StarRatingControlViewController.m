#import "StarRatingControlViewController.h"
#import "StarRatingControl.h"


@interface StarRatingControlViewController (Private)

- (void)updateRating:(id)sender;
- (void)updateEndRating:(id)sender;

@end


@implementation StarRatingControlViewController


/**************************************************************************************************/
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create a simple instance, initing with :
    // - a CGPoint (the position in your view from which it will be drawn)
    // - and max rating
	StarRatingControl *simpleRatingControl = [[StarRatingControl alloc] initWithLocation:CGPointMake(80, 60)
                                                                        andMaxRating:5];
    
    // Customize the current rating if needed
    [simpleRatingControl setRating:3];
    [simpleRatingControl setStarSpacing:10];
    
    // Define block to handle events
	simpleRatingControl.editingChangedBlock = ^(NSUInteger rating)
    {
        [label setText:[NSString stringWithFormat:@"%d", rating]];
    };
    
    simpleRatingControl.editingDidEndBlock = ^(NSUInteger rating)
    {
        [endLabel setText:[NSString stringWithFormat:@"%d", rating]];
    };
    
    
    // Create an instance with images, initing with :
    // - a CGPoint (the position in your view from which it will be drawn)
    // - a custom empty image and solid image if you wish (pass nil if you want to use the default).
    // - initial rating (how many stars the rating will have initially when displayed)
    // - and max rating
    // This control, when initialized with (at least) the fullStar image will support partial rating stars, i.e., 3.5
	UIImage *emptyStar, *fullStar;
	emptyStar = [UIImage imageNamed:@"star_rating_empty.png"];
	fullStar = [UIImage imageNamed:@"star_rating_full.png"];
  
	StarRatingControl *imagesRatingControl = [[StarRatingControl alloc] initWithLocation:CGPointMake(90, 220)
                                                                          emptyImage:emptyStar
                                                                          solidImage:fullStar
                                                                       initialRating:3.5
                                                                        andMaxRating:5];
  
    // Create an instance with custom color, initing with :
    // - a CGPoint (the position in your view from which it will be drawn)
    // - colors for "empty" and "full" rating stars
    // - and max rating
	StarRatingControl *coloredRatingControl = [[StarRatingControl alloc] initWithLocation:CGPointMake(90, 380)
                                                                           emptyColor:[UIColor yellowColor]
                                                                           solidColor:[UIColor redColor]
                                                                         andMaxRating:5];
    
    
    
    // Add the control(s) as a subview of your view
	[self.view addSubview:simpleRatingControl];
    [self.view addSubview:imagesRatingControl];
    [self.view addSubview:coloredRatingControl];
}


@end
