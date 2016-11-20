//
//  VADropDownView.m
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/17/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import "VADropDownView.h"

#import "AVDropDownCell.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat const AVDropViewCornerRadius = 8.0f;
static CGFloat const AVDropViewSenderInsetY = 5.0f;
static CGFloat const AVDropViewShowAnimationDuration = 0.5f;
static CGFloat const AVDropViewHideAnimationDuration = 0.2f;
static CGFloat const AVDropViewMinWidth = 120.0f;

@interface VADropDownView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (assign, nonatomic) DropDirection dropDirection;
@property (strong, nonatomic) UIView *sender;

@end

@implementation VADropDownView

- (instancetype)initWithSender:(UIView *)sender
             maxDisplayedLines:(NSInteger)linesQuantityMax
                     dataArray:(NSArray *)dataArray
                 dropDirection:(DropDirection)direction {
    self = [super init];
    
    self.sender = sender;
    self.dataArray = dataArray;
    self.dropDirection = direction;
    
    if (self) {
        [self commonSetup];
        
        UINib *nib = [UINib nibWithNibName:[AVDropDownCell nibName] bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:[AVDropDownCell cellIdentifier]];
        self.tableView.layer.cornerRadius = AVDropViewCornerRadius;

        [self customize];
        
        CGFloat dropDownListHeight = (dataArray.count >= linesQuantityMax) ? linesQuantityMax * 44.f : dataArray.count * 44.f;
        
        CGRect senderFrame = sender.frame;
        if (self.dropDirection == DropDirectionUp) {
            self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMinY(senderFrame) - AVDropViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), AVDropViewMinWidth), 0);
        }
        else if (self.dropDirection == DropDirectionDown) {
            self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMaxY(senderFrame) + AVDropViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), AVDropViewMinWidth), 0);
        }

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:AVDropViewShowAnimationDuration];
        if (self.dropDirection == DropDirectionUp) {
            self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMinY(senderFrame) - AVDropViewSenderInsetY - dropDownListHeight, MAX(CGRectGetWidth(senderFrame), AVDropViewMinWidth), dropDownListHeight);
        }
        else if (self.dropDirection == DropDirectionDown) {
            self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMaxY(senderFrame) + AVDropViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), AVDropViewMinWidth) , dropDownListHeight);
        }
        
        self.tableView.frame = CGRectMake(0, 0, MAX(CGRectGetWidth(senderFrame), AVDropViewMinWidth), dropDownListHeight);
        [UIView commitAnimations];
        [sender.superview addSubview:self];
    }
    
    return self;
}

- (void)commonSetup {
    UIView *nibView = [self loadViewFromNib];
    nibView.frame = self.bounds;
    nibView.layer.cornerRadius = AVDropViewCornerRadius;
    nibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:nibView];
}

- (UIView *)loadViewFromNib {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIView *view = [[bundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    return view;
}

- (void)customize {
    self.layer.cornerRadius = AVDropViewCornerRadius;
    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVDropDownCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[AVDropDownCell cellIdentifier]];
    [cell populateWithTitle:self.dataArray[indexPath.row]];
    return cell;
}

- (void)hideDropViewWithSender:(UIView *)sender {

    CGRect senderFrame = sender.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:AVDropViewHideAnimationDuration];
    if (self.dropDirection == DropDirectionUp) {
        self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMinY(senderFrame) - AVDropViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), AVDropViewMinWidth), 0);
    }
    else if (self.dropDirection == DropDirectionDown) {
        self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMaxY(senderFrame) + AVDropViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), AVDropViewMinWidth), 0);
    }
    self.tableView.frame = CGRectMake(0, 0, MAX(CGRectGetWidth(senderFrame), AVDropViewMinWidth), 0);
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropViewWithSender:self.sender];
    
    [self.delegate selectedData:self.dataArray[indexPath.row]
                   fromDropView:self
                      forSender:self.sender];
}

@end
