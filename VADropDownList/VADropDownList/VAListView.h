//
//  VAListView.h
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/17/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VAListView;

typedef NS_ENUM(NSInteger, DropDirection) {
    DropDirectionDown = 1,
    DropDirectionUp
};

@protocol VAListViewDelegate

- (void)dataFromListView:(NSString *)string
              withSender:(UIView *)sender;

@end

@interface VAListView : UIView

@property (nonatomic, weak) id <VAListViewDelegate> delegate;

- (instancetype)initWithSender:(UIView *)sender
             maxDisplayedLines:(NSInteger)linesQuantity
                     dataArray:(NSArray *)dataArray
                 dropDirection:(DropDirection)direction;

- (void)hideListViewWithSender:(UIView *)sender;

@end
