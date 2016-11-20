//
//  AVDropDownCell.h
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/19/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVDropDownCell : UITableViewCell

+ (NSString *)nibName;
+ (NSString *)cellIdentifier;

- (void)populateWithTitle:(NSString *)string;

@end
