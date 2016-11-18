//
//  VADropDownView.h
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/17/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VADropDownView;

@protocol VADropDownViewDelegate

- (void)hideDropDownView:(VADropDownView *)view withData:(NSString *)string;

@end

@interface VADropDownView : UIView <UITableViewDelegate, UITableViewDataSource> {
    NSString *animationDirection;
}
@property (nonatomic, retain) id <VADropDownViewDelegate> delegate;
//@property (nonatomic, retain) NSString *animationDirection;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIButton *btnSender;
@property (nonatomic, retain) NSArray *dataArray;

- (void)hideDropDownView:(UIView *)view;
- (id)showDropDown:(UIView *)b withHeight:(CGFloat)height withData:(NSArray *)arr animationDirection:(NSString *)direction;

@end
