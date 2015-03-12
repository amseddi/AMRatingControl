//
//  StarRatingControl.h
//  RatingControl
//


#import <UIKit/UIKit.h>

typedef void (^EditingChangedBlock)(NSUInteger rating);
typedef void (^EditingDidEndBlock)(NSUInteger rating);


@interface StarRatingControl : UIControl


/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (nonatomic, assign) NSInteger maxRating;
@property (nonatomic, assign) float rating;
@property (nonatomic, readwrite) NSUInteger starFontSize;
@property (nonatomic, readwrite) NSUInteger starWidthAndHeight;
@property (nonatomic, readwrite) NSUInteger starSpacing;
@property (nonatomic, copy) EditingChangedBlock editingChangedBlock;
@property (nonatomic, copy) EditingDidEndBlock editingDidEndBlock;

/**************************************************************************************************/
#pragma mark - Birth & Death

/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param maxRating
 */
- (id)initWithLocation:(CGPoint)location andMaxRating:(NSInteger)maxRating;

/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param emptyColor & solidColor
 * @param maxRating
 */
- (id)initWithLocation:(CGPoint)location
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating;

/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param emptyImage & solidImage can both be nil, or not even a dot or a star (a any images you want!)
 * If either of these parameters are nil, the class will draw its own stars
 * @param maxRating
 */
- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
          andMaxRating:(NSInteger)maxRating;

/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param emptyImage & solidImage can both be nil, or not even a dot or a star (a any images you want!)
 * If either of these parameters are nil, the class will draw its own stars
 * @param userInteractionEnabled - self explanatory
 * @param initialRating will initialize the number of stars and partial stars to show with the control at startup
 * @param maxRating
 *
 */
- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
         initialRating:(float)initialRating
          andMaxRating:(NSInteger)maxRating;


@end
