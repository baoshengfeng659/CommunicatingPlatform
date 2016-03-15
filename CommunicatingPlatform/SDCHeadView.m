//
//  SDCHeadView.m
//  CommunicatingPlatform
//
//  Created by baoshengfeng on 16/1/14.
//  Copyright (c) 2016年 baoshengfeng. All rights reserved.
//

#import "SDCHeadView.h"

@implementation SDCHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 40)];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        titleLabel.text = @"评论区";
        
        [self addSubview:titleLabel];
    }
    
    return self;
}

@end
