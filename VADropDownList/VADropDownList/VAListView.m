//
//  VAListView.m
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/17/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import "VAListView.h"

#import "VAListCell.h"
#import "VAConstants.h"
#import <QuartzCore/QuartzCore.h>

@interface VAListView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UIView *sender;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@end

@implementation VAListView

- (instancetype)initWithSender:(UIView *)sender
            visibleSenderFrame:(CGRect)senderFrame
                     dataArray:(NSArray *)dataArray {
    self = [super init];
    
    self.sender = sender;
    self.dataArray = dataArray;
    
    if (self) {
        [self commonSetup];
        [self setupTableView];
        
        CGFloat listViewHeight = MIN(self.dataArray.count * 30.0f + VAListViewInvisibleHeight, VAListViewMaxHeight);
        DropDirection dropDirection = (CGRectGetMinY(senderFrame) - listViewHeight >= VAListViewUpperInsetY ) ? DropDirectionUp : DropDirectionDown;
        
        [self animateListViewWithHeight:listViewHeight andDropDirection:dropDirection];
        [sender.superview addSubview:self];
        [self customizeSenderWithDropDirection:dropDirection];
     }
    
    return self;
}

- (void)commonSetup {
    UIView *nibView = [self loadViewFromNib];
    nibView.frame = self.bounds;
    nibView.layer.cornerRadius = VAListViewCornerRadius;
    nibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:nibView];
    [self customize];
}

- (UIView *)loadViewFromNib {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIView *view = [[bundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    return view;
}

- (void)customize {
    self.layer.cornerRadius = VAListViewCornerRadius;
    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)setupTableView {
    UINib *nib = [UINib nibWithNibName:[VAListCell nibName] bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[VAListCell cellIdentifier]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.layer.cornerRadius = VAListViewCornerRadius;
}

- (void)animateListViewWithHeight:(CGFloat)listViewHeight andDropDirection:(DropDirection)dropDirection {
    
    CGRect senderFrame = self.sender.frame;

    self.topViewHeightConstraint.constant = (dropDirection == DropDirectionUp) ? 0 : VAListViewInvisibleHeight;
    self.bottomViewHeightConstraint.constant = (dropDirection == DropDirectionUp) ? VAListViewInvisibleHeight : 0;
    
    switch (dropDirection) {
        case DropDirectionUp:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame),
                                    CGRectGetMinY(senderFrame) - VAListViewSenderInsetY,
                                    CGRectGetWidth(senderFrame),
                                    0);
            
            break;
        case DropDirectionDown:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame),
                                    CGRectGetMaxY(senderFrame) + VAListViewSenderInsetY,
                                    CGRectGetWidth(senderFrame),
                                    0);
            self.topView.frame = CGRectMake(CGRectGetMinX(senderFrame),
                                            CGRectGetMinY(senderFrame) + VAListViewSenderInsetY,
                                            CGRectGetWidth(senderFrame),
                                            0);
            break;
        default:
            break;
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:VAListViewShowAnimationDuration];
    switch (dropDirection) {
        case DropDirectionUp:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame),
                                    CGRectGetMinY(senderFrame) - VAListViewSenderInsetY - listViewHeight,
                                    CGRectGetWidth(senderFrame),
                                    listViewHeight);
            break;
        case DropDirectionDown:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame),
                                    CGRectGetMaxY(senderFrame) + VAListViewSenderInsetY,
                                    CGRectGetWidth(senderFrame),
                                    listViewHeight);
            break;
        default:
            break;
    }

    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(senderFrame), listViewHeight);
    self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(senderFrame), 0);

    [UIView commitAnimations];
}

- (void)customizeSenderWithDropDirection:(DropDirection)dropDirection {
    [self.sender.superview bringSubviewToFront:self.sender];
    
    self.sender.layer.masksToBounds = NO;
    self.sender.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sender.layer.shadowOpacity = 0.5f;
    self.sender.layer.shadowRadius = 3.0f;
    self.sender.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIEdgeInsets contentInsets;
    switch (dropDirection) {
        case DropDirectionUp:
            contentInsets = UIEdgeInsetsMake(0, 5, 5, 5);
            break;
        case DropDirectionDown:
            contentInsets = UIEdgeInsetsMake(5, 5, 0, 5);
            break;
        default:
            break;
    }
    
    CGRect shadowPath = UIEdgeInsetsInsetRect(self.sender.bounds, contentInsets);
    self.sender.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[VAListCell cellIdentifier]];
    [cell populateWithTitle:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate dataFromListView:self.dataArray[indexPath.row]
                         withSender:self.sender];
}

@end
