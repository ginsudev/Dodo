//
//  DodoThemeCell.m
//  
//
//  Created by Noah Little on 27/8/2022.
//

#import "include/dodo.h"

@implementation DodoThemeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.translatesAutoresizingMaskIntoConstraints = NO;
        [_title setFont:[UIFont boldSystemFontOfSize:16]];
        [self.contentView addSubview:_title];
        
        _subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitle.translatesAutoresizingMaskIntoConstraints = NO;
        [_subtitle setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_subtitle];
        
        [_title.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor constant:-24].active = YES;
        [_title.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:12].active = YES;
        [_title.bottomAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:0].active = YES;

        [_subtitle.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor constant:-24].active = YES;
        [_subtitle.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:12].active = YES;
        [_subtitle.topAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant:0].active = YES;
    }
    
    return self;
}

@end
