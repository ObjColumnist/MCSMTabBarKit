//
//  MCSMTabBarItemView.m
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 20/07/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

#import "MCSMTabBarItemView.h"
#import <QuartzCore/QuartzCore.h>


@implementation MCSMTabBarItemView

@synthesize textLabel = textLabel_;
@synthesize imageView = imageView_;
@synthesize backgroundView = backgroundView_;
@synthesize selectedBackgroundView = selectedBackgroundView_;

@synthesize title = title_;
@synthesize image = image_;
@synthesize selectedImage = selectedImage_;

@synthesize selected = selected_;

@synthesize style = style_;

+ (UIImage *)imageForUnfinishedImage:(UIImage *)image style:(MCSMTabBarItemViewStyle)style{
    
    if(style == MCSMTabBarItemViewStyleDefault)
    {
        NSArray *colors = @[[UIColor colorWithHue:(0.0/360.0) saturation:(0.0/100.0) brightness:(62.0/100.0) alpha:(1.0/1.0)],
                           [UIColor colorWithHue:(0.0/360.0) saturation:(0.0/100.0) brightness:(27.0/100.0) alpha:(1.0/1.0)]];
        
        return [image MCSMTabBarItemView_imageMaskedWithColors:colors
                                                       opacity:0.0];
    }else{
        return image;
    }
    
}
+ (UIImage *)selectedImageForUnfinishedImage:(UIImage *)image style:(MCSMTabBarItemViewStyle)style{
    
    if(style == MCSMTabBarItemViewStyleDefault)
    {

        NSArray *colors = @[[UIColor colorWithHue:(216.0/360.0) saturation:(19.0/100.0) brightness:(97.0/100.0) alpha:(1.0/1.0)],
                           [UIColor colorWithHue:(206.0/360.0) saturation:(100.0/100.0) brightness:(96.0/100.0) alpha:(1.0/1.0)]];
        
        
        return [image MCSMTabBarItemView_imageMaskedWithColors:colors
                                                       opacity:0.0];
    }else{
        return image;
    }
    
}

+ (id)tabBarItemViewWithStyle:(MCSMTabBarItemViewStyle)style{
    return [[[[self class] alloc] initWithStyle:style] autorelease];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        imageView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView_.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView_];
        
        textLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel_.textColor = [UIColor grayColor];
        textLabel_.highlightedTextColor = [UIColor whiteColor];
        textLabel_.textAlignment = UITextAlignmentCenter;
        textLabel_.font = [UIFont boldSystemFontOfSize:11];
        textLabel_.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel_];        
    }
    return self;
}

- (id)initWithStyle:(MCSMTabBarItemViewStyle)style{
    
    if((self = [self initWithFrame:CGRectZero])){
        style_ = style;
        
        if(style_ == MCSMTabBarItemViewStyleDefault)
        {
            self.backgroundColor = [UIColor clearColor];
                        
            selectedBackgroundView_ = [[UIView alloc] initWithFrame:CGRectZero];
            selectedBackgroundView_.backgroundColor = [UIColor colorWithWhite:(50.0/100.0) alpha:0.7];
            selectedBackgroundView_.alpha = 0.35;
            selectedBackgroundView_.layer.cornerRadius = 4.0;
            [selectedBackgroundView_ setHidden:YES];
            [self addSubview:selectedBackgroundView_];
        }
    }
    
    return self;
}

- (void)dealloc{

    [textLabel_ release], textLabel_ = nil;
    [imageView_ release], imageView_ = nil;

    [backgroundView_ release], backgroundView_ = nil;
    [selectedBackgroundView_ release], selectedBackgroundView_ = nil;

    [title_ release], title_ = nil;
    [image_ release], image_ = nil;
    [selectedImage_ release], selectedImage_ = nil;
    [super dealloc];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(style_ == MCSMTabBarItemViewStyleDefault)
    {
        CGRect backgroundViewFrame = self.bounds;
        
        backgroundViewFrame.size.height -= 8;
        backgroundViewFrame.size.width -= 8;
        
        backgroundViewFrame.origin.x += 4;
        backgroundViewFrame.origin.y += 4;

        self.backgroundView.frame = backgroundViewFrame;
        self.selectedBackgroundView.frame = backgroundViewFrame;
        
        if([self.title length] && self.image)
        {
            [self.textLabel sizeToFit];
            
            CGRect textLabelFrame = self.textLabel.bounds;
            
            textLabelFrame.size.width = self.bounds.size.width - 12;

            textLabelFrame.origin.x = 6;
            textLabelFrame.origin.y = self.bounds.size.height - textLabelFrame.size.height - 6;
            
            self.textLabel.frame = textLabelFrame;

            CGRect imageViewFrame = CGRectZero;
            
            CGFloat imageViewHeight = self.bounds.size.height - 6 - 4 - (self.bounds.size.height - textLabelFrame.origin.y);
            
            imageViewFrame.size.width = self.bounds.size.width - 12;
            imageViewFrame.size.height = imageViewHeight;
            imageViewFrame.origin.x = 6;
            imageViewFrame.origin.y = 6;
            
            self.imageView.frame = imageViewFrame;
        
        
        }else if([self.title length])
        {
            
            CGRect textLabelFrame = self.bounds;
            
            textLabelFrame.size.height -= 16;
            textLabelFrame.size.width -= 16;
            
            textLabelFrame.origin.x += 8;
            textLabelFrame.origin.y += 8;
            
            self.textLabel.frame = textLabelFrame;
            self.imageView.frame = CGRectZero;
        }else if(self.image)
        {
            CGRect imageViewFrame = self.bounds;
            
            imageViewFrame.size.height -= 16;
            imageViewFrame.size.width -= 16;
            
            imageViewFrame.origin.x += 8;
            imageViewFrame.origin.y += 8;
            
            self.textLabel.frame = CGRectZero;
            self.imageView.frame = imageViewFrame;

        }else
        {        
            self.textLabel.frame = CGRectZero;
            self.imageView.frame = CGRectZero;
        }
        
    }
    
}


- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title{
    [title_ release];
    title_ = [title copy];
    
    textLabel_.text = self.title;
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image{
    [image_ release];
    image_ = [image retain];
    
    imageView_.image = self.image;
    [self setNeedsLayout];
}

- (void)setSelectedImage:(UIImage *)selectedImage{
    [selectedImage_ release];
    selectedImage_ = [selectedImage retain];
    
    if([self isSelected])
    {
        imageView_.image = self.selectedImage;
    }
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected{
    [self setSelected:selected animated:YES];
}

- (void)setImage:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    self.image = image;
    self.selectedImage = selectedImage;
}


- (void)setUnfinishedImage:(UIImage *)image{
    
    if(style_ == MCSMTabBarItemViewStyleDefault)
    {
        self.image = [[self class] imageForUnfinishedImage:image style:MCSMTabBarItemViewStyleDefault];
        self.selectedImage = [[self class] selectedImageForUnfinishedImage:image style:MCSMTabBarItemViewStyleDefault];
    }else{
        self.image = image;
        self.selectedImage = image;
    }
}

- (void)setBackgroundView:(UIView *)backgroundView{
    [backgroundView_ removeFromSuperview], [backgroundView_ release], backgroundView_ = nil;
    backgroundView_ = [backgroundView retain];
    
    [self addSubview:backgroundView_];
    [self sendSubviewToBack:backgroundView_];
    
    
    if(self.selected && self.selectedBackgroundView)
    {
        [backgroundView_ setHidden:YES];
        [selectedBackgroundView_ setHidden:NO];
        
    }else{
        [backgroundView_ setHidden:NO];
        [selectedBackgroundView_ setHidden:YES];
        
    }
    
    [self setNeedsLayout];
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView{
    
    [selectedBackgroundView_ removeFromSuperview], [selectedBackgroundView_ release], selectedBackgroundView_ = nil;
    selectedBackgroundView_ = [selectedBackgroundView retain];
    
    [self addSubview:selectedBackgroundView_];
    [self sendSubviewToBack:selectedBackgroundView_];
    
    
    if(self.selected && self.selectedBackgroundView)
    {
        [backgroundView_ setHidden:YES];
        [selectedBackgroundView_ setHidden:NO];
        
    }else{
        [backgroundView_ setHidden:NO];
        [selectedBackgroundView_ setHidden:YES];
        
    }
    
    [self setNeedsLayout];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    selected_ = selected;
    
    if(selected && self.selectedImage)
    {
        [imageView_ setImage:self.selectedImage];
    }else{
        [imageView_ setImage:self.image];
    }
    
    [textLabel_ setHighlighted:selected];
     
    if(self.selected && self.selectedBackgroundView)
    {
        [backgroundView_ setHidden:YES];
        [selectedBackgroundView_ setHidden:NO];
        
    }else{
        [backgroundView_ setHidden:NO];
        [selectedBackgroundView_ setHidden:YES];

    }

    [self setNeedsLayout];
}

@end

@implementation UIImage (MCSMTabBarItemViewAdditions)

- (UIImage *)MCSMTabBarItemView_imageMaskedWithColors:(NSArray *)colors opacity:(CGFloat)opacity{
    
	if ([colors count])
    {
		UIImage *image = nil;
		
        UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
		{
			CGRect rect = CGRectZero;
			rect.size = [self size];
			CGContextRef currentContext = UIGraphicsGetCurrentContext();
			CGContextSaveGState(currentContext);
			{
				CGContextTranslateCTM(currentContext, 0, rect.size.height);
				CGContextScaleCTM(currentContext, 1.0, -1.0);
				
				CGRect maskRect = CGRectMake(0, 0, self.size.width, self.size.height);
				CGContextClipToMask(currentContext, maskRect, self.CGImage);
                
				CGContextSaveGState(currentContext);
				{
					CGContextSaveGState(currentContext);
					{
						CGContextTranslateCTM(currentContext, CGRectGetMinX(rect), CGRectGetMinY(rect));
						CGContextAddRect(currentContext, CGRectMake(0, 0, rect.size.width, rect.size.height));
						CGContextClosePath(currentContext);
					}
                    
					CGContextRestoreGState(currentContext);
					
					CGContextClip(currentContext);
                    
					NSMutableArray *cgColors = [NSMutableArray array];
                    
					for (UIColor *color in colors) {
						[cgColors addObject:(id)color.CGColor];
					}
                    
					CGColorSpaceRef colorSpace = CGBitmapContextGetColorSpace(currentContext);
					CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)cgColors, NULL);
					
                    CGContextDrawLinearGradient(currentContext,
												gradient,
												CGPointMake(rect.origin.x, rect.origin.y + rect.size.height),
												CGPointMake(rect.origin.x, rect.origin.y),
												kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
					CGGradientRelease(gradient);
				}
                
				CGContextRestoreGState(currentContext);
			}
			CGContextRestoreGState(currentContext);
			image = UIGraphicsGetImageFromCurrentImageContext();
		}
        
		UIGraphicsEndImageContext();
		return image;
	}
    
	return self;
}


@end

