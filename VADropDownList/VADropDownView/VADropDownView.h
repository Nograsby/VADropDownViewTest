//
//  VADropDownView.h
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/17/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VADropDownView;

typedef NS_ENUM(NSInteger, DropDirection) {
    DropDirectionDown = 1,
    DropDirectionUp
};

@protocol VADropDownViewDelegate

- (void)selectedData:(NSString *)string
        fromDropView:(VADropDownView *)dropView
           forSender:(UIView *)sender;

@end

@interface VADropDownView : UIView

@property (nonatomic, retain) id <VADropDownViewDelegate> delegate;

- (instancetype)initWithSender:(UIView *)sender
             maxDisplayedLines:(NSInteger)linesQuantity
                     dataArray:(NSArray *)dataArray
                 dropDirection:(DropDirection)direction;

- (void)hideDropViewWithSender:(UIView *)sender;

@end
