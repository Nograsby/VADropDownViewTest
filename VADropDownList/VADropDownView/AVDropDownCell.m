//
//  AVDropDownCell.m
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/19/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import "AVDropDownCell.h"

@interface AVDropDownCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AVDropDownCell

+ (NSString *)nibName {
    return NSStringFromClass([self class]);
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)populateWithTitle:(NSString *)string {
    self.titleLabel.text = string;
}

@end
