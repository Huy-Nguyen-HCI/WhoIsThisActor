//
//  MovieCell.m
//  WhoIsThisActor
//
//  Created by Nguyen Huy on 9/29/15.
//  Copyright © 2015 Nguyen Huy. All rights reserved.
//

#import "MovieCell.h"


@implementation MovieCell

- (void)layoutSubviews
{
    CGRect contentRect = self.contentView.bounds;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, contentRect.size.width-20, 20)];
    titleLabel.text = self.titleText;
    [self setAttributedStringForLabel:titleLabel];
    [self.contentView addSubview:titleLabel];
    
    
    UIImageView *poster = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height, contentRect.size.width/2 - 10, contentRect.size.height-20)];
    poster.image = self.posterImage;
    [self.contentView addSubview:poster];
    
    
    UITextView *description = [[UITextView alloc] initWithFrame:CGRectMake(contentRect.size.width/2, poster.frame.origin.y, contentRect.size.width/2 - 10, poster.frame.size.height) textContainer:nil];
    description.text = self.descriptionText;
    description.editable = NO;
    [self.contentView addSubview:description];
    
}

- (void)setAttributedStringForLabel:(UILabel *)label
{
    NSDictionary *attribs =
    @{
      NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
      NSForegroundColorAttributeName : [UIColor greenColor],
      NSStrokeColorAttributeName : [UIColor orangeColor]
      };
                              
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:label.text attributes:attribs];
    label.attributedText = attributedText;
    
}



@end
