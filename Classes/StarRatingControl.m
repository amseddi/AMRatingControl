//
//  StarRatingControl.m
//  RatingControl
//


#import "StarRatingControl.h"


// Constants :
static const CGFloat kFontSize = 20;
static const NSInteger kStarWidthAndHeight = 27;
static const NSInteger kStarSpacing = 0;

static const NSString *kDefaultEmptyChar = @"☆";
static const NSString *kDefaultSolidChar = @"★";

@interface StarRatingControl (Private)

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating;

- (void)adjustFrame;
- (void)handleTouch:(UITouch *)touch;

@end


@implementation StarRatingControl
{
    BOOL _respondsToTranslatesAutoresizingMaskIntoConstraints;
    UIImage *_emptyImage, *_solidImage;
    UIColor *_emptyColor, *_solidColor;
    NSInteger _maxRating;
    BOOL _partialStarsAllowed;
}

/**************************************************************************************************/
#pragma mark - Getters & Setters

- (void)setMaxRating:(NSInteger)maxRating
{
    _maxRating = maxRating;
    if (_rating > maxRating) {
        _rating = maxRating;
    }
    [self adjustFrame];
    [self setNeedsDisplay];
}

- (void)setRating:(float)rating
{
    _rating = (rating < 0) ? 0 : rating;
    _rating = (rating > _maxRating) ? _maxRating : rating;
    [self setNeedsDisplay];
}

- (void)setStarWidthAndHeight:(NSUInteger)starWidthAndHeight
{
    _starWidthAndHeight = starWidthAndHeight;
    [self adjustFrame];
    [self setNeedsDisplay];
}

- (void)setStarSpacing:(NSUInteger)starSpacing
{
    _starSpacing = starSpacing;
    [self adjustFrame];
    [self setNeedsDisplay];
}

/**************************************************************************************************/
#pragma mark - Birth & Death

- (id)initWithLocation:(CGPoint)location andMaxRating:(NSInteger)maxRating
{
    return [self initWithLocation:location
                       emptyImage:nil
                       solidImage:nil
                       emptyColor:nil
                       solidColor:nil
                     andMaxRating:maxRating];
}

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
          andMaxRating:(NSInteger)maxRating
{
	return [self initWithLocation:location
                       emptyImage:emptyImageOrNil
                       solidImage:solidImageOrNil
                       emptyColor:nil
                       solidColor:nil
                     andMaxRating:maxRating];
}


- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
         initialRating:(float)initialRating
          andMaxRating:(NSInteger)maxRating
{
    return [self initWithLocation:location
                       emptyImage:emptyImageOrNil
                       solidImage:solidImageOrNil
                       emptyColor:nil
                       solidColor:nil
                    initialRating:initialRating
                     andMaxRating:maxRating];
}


- (id)initWithLocation:(CGPoint)location
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating
{
    return [self initWithLocation:location
                       emptyImage:nil
                       solidImage:nil
                       emptyColor:emptyColor
                       solidColor:solidColor
                     andMaxRating:maxRating];
}

- (void)dealloc
{
	_emptyImage = nil,
	_solidImage = nil;
    _emptyColor = nil;
    _solidColor = nil;
}

/**************************************************************************************************/
#pragma mark - Auto Layout

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(_maxRating * _starWidthAndHeight + (_maxRating - 1) * _starSpacing,
                      _starWidthAndHeight);
}


/**************************************************************************************************/
#pragma mark - View Lifecycle

- (void)drawRect:(CGRect)rect
{
	CGPoint currPoint = CGPointZero;
    int wholeStars = (int)floor(_rating);
    float partialStars = _rating - (float)wholeStars;
	
	for (int i = 0; i < wholeStars; i++)
	{
        
		if (_solidImage)
        {
            [_solidImage drawAtPoint:currPoint];
        }
		else
        {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), _solidColor.CGColor);
            [kDefaultSolidChar drawAtPoint:currPoint withFont:[UIFont boldSystemFontOfSize:_starFontSize]];
        }
        
		currPoint.x += (_starWidthAndHeight + _starSpacing);
	}
    
    if (partialStars > 0) {
        UIImage *partialStar = [self partialImage:_solidImage fraction:partialStars];
        [_emptyImage drawAtPoint:currPoint];
        [partialStar drawAtPoint:currPoint];
        currPoint.x += (_starWidthAndHeight + _starSpacing);
    }
   
	NSInteger remaining = (floor)(_maxRating - _rating) ;
	
	for (int i = 0; i < remaining; i++)
	{
		if (_emptyImage)
        {
			[_emptyImage drawAtPoint:currPoint];
        }
		else
        {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), _emptyColor.CGColor);
			[kDefaultEmptyChar drawAtPoint:currPoint withFont:[UIFont boldSystemFontOfSize:_starFontSize]];
        }
		currPoint.x += (_starWidthAndHeight + _starSpacing);
	}
}


/**************************************************************************************************/
#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self handleTouch:touch];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self handleTouch:touch];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.editingDidEndBlock)
    {
        self.editingDidEndBlock(_rating);
    }
}


/**************************************************************************************************/
#pragma mark - Private Methods


- (void)initializeWithEmptyImage:(UIImage *)emptyImageOrNil
                      solidImage:(UIImage *)solidImageOrNil
                      emptyColor:(UIColor *)emptyColor
                      solidColor:(UIColor *)solidColor
                    andMaxRating:(NSInteger)maxRating
{
    [self initializeWithEmptyImage:emptyImageOrNil
                           solidImage:solidImageOrNil
                           emptyColor:emptyColor
                           solidColor:solidColor
                     initialRating:0.0
                         andMaxRating:maxRating];
}

- (void)initializeWithEmptyImage:(UIImage *)emptyImageOrNil
                      solidImage:(UIImage *)solidImageOrNil
                      emptyColor:(UIColor *)emptyColor
                      solidColor:(UIColor *)solidColor
                   initialRating:(float)initialRating
                    andMaxRating:(NSInteger)maxRating
{
    _respondsToTranslatesAutoresizingMaskIntoConstraints = [self respondsToSelector:@selector(translatesAutoresizingMaskIntoConstraints)];
    
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    _emptyImage = emptyImageOrNil;
    _solidImage = solidImageOrNil;
    _emptyColor = emptyColor;
    _solidColor = solidColor;
    _maxRating = maxRating;
    _rating =  initialRating;
    _starFontSize = kFontSize;
    _starWidthAndHeight = kStarWidthAndHeight;
    _starSpacing = kStarSpacing;
    
    if(!_emptyColor && !_solidColor && _solidImage)
    {
        _partialStarsAllowed = YES;
    }
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self initializeWithEmptyImage:nil
                            solidImage:nil
                            emptyColor:nil
                            solidColor:nil
                            initialRating:0.0
                          andMaxRating:0];
    }
    return self;
}


- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
         initialRating:(float)initialRating
          andMaxRating:(NSInteger)maxRating
{
    if (self = [self initWithFrame:CGRectMake(location.x,
                                              location.y,
                                              (maxRating * kStarWidthAndHeight),
                                              kStarWidthAndHeight)])
	{
		[self initializeWithEmptyImage:emptyImageOrNil
                            solidImage:solidImageOrNil
                            emptyColor:emptyColor
                            solidColor:solidColor
                         initialRating:(float)initialRating
                          andMaxRating:maxRating];
	}
	
	return self;
}

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating
{
    if (self = [self initWithFrame:CGRectMake(location.x,
                                              location.y,
                                              (maxRating * kStarWidthAndHeight),
                                              kStarWidthAndHeight)])
	{
		[self initializeWithEmptyImage:emptyImageOrNil
                            solidImage:solidImageOrNil
                            emptyColor:emptyColor
                            solidColor:solidColor
                         initialRating:0.0f
                          andMaxRating:maxRating];
	}
	
	return self;
}


- (void)adjustFrame
{
    if (_respondsToTranslatesAutoresizingMaskIntoConstraints && !self.translatesAutoresizingMaskIntoConstraints)
    {
        [self invalidateIntrinsicContentSize];
    }
    else
    {
        CGRect newFrame = CGRectMake(self.frame.origin.x,
                                     self.frame.origin.y,
                                     _maxRating * _starWidthAndHeight + (_maxRating - 1) * _starSpacing,
                                     _starWidthAndHeight);
        self.frame = newFrame;
    }
}

- (void)handleTouch:(UITouch *)touch
{
    CGFloat width = self.frame.size.width;
	CGRect section = CGRectMake(0, 0, _starWidthAndHeight, self.frame.size.height);
	
	CGPoint touchLocation = [touch locationInView:self];
	
	if (touchLocation.x < 0 || touchLocation.x < ((float)kStarWidthAndHeight)/3.0)
	{
		if (_rating != 0)
		{
			_rating = 0;
            if (self.editingChangedBlock)
            {
                self.editingChangedBlock(_rating);
            }
		}
	}
	else if (touchLocation.x > width)
	{
		if (_rating != _maxRating)
		{
			_rating = _maxRating;
            if (self.editingChangedBlock)
            {
                self.editingChangedBlock(_rating);
            }
		}
	}
	else
	{
        float halfWidth = (float)_starWidthAndHeight/2.0;
        
		for (int i = 0 ; i < _maxRating ; i++)
		{
			if (touchLocation.x > section.origin.x)
			{
                if (_partialStarsAllowed) {
                    // first half of the star
                    if (touchLocation.x < (section.origin.x + halfWidth)) {
                        if (_rating != (i + 0.5))
                        {
                            _rating = i + 0.5;
                            if (self.editingChangedBlock)
                            {
                                self.editingChangedBlock(_rating);
                            }
                        }
                        break;
                    }
                    
                    // second half of the star
                    if (touchLocation.x > (section.origin.x + halfWidth) &&
                        touchLocation.x < (section.origin.x + _starWidthAndHeight)) {
                        if (_rating != (i + 1))
                        {
                            _rating = i + 1;
                            if (self.editingChangedBlock)
                            {
                                self.editingChangedBlock(_rating);
                            }
                        }
                        break;
                    }
                }else{ // only wholestars
                    if (touchLocation.x < (section.origin.x + _starWidthAndHeight)) {
                        if (_rating != (i + 1))
                        {
                            _rating = i + 1;
                            if (self.editingChangedBlock)
                            {
                                self.editingChangedBlock(_rating);
                            }
                        }
                        break;
                    }
                }
 
			}
			section.origin.x += (_starWidthAndHeight + _starSpacing);
		}
	}
	[self setNeedsDisplay];
}

- (UIImage *) partialImage:(UIImage *)image fraction:(float)fraction
{
    CGImageRef imgRef = image.CGImage;
    CGImageRef fractionalImgRef = CGImageCreateWithImageInRect(imgRef, CGRectMake(0, 0, image.size.width * fraction, image.size.height));
    UIImage *fractionalImg = [UIImage imageWithCGImage:fractionalImgRef];
    CGImageRelease(fractionalImgRef);
    return fractionalImg;
}

@end
