//
//  VAListView.m
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/17/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import "VAListView.h"

#import "VAListCell.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat const VAListViewCornerRadius = 8.0f;
static CGFloat const VAListViewSenderInsetY = 5.0f;
static CGFloat const VAListViewShowAnimationDuration = 0.3f;
static CGFloat const VAListViewMinWidth = 120.0f;
static CGFloat const VAListViewUpperInsetY = 20.0f;

@interface VAListView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UIView *sender;

@end

@implementation VAListView

- (instancetype)initWithSender:(UIView *)sender
            visibleSenderFrame:(CGRect)senderFrame
             maxDisplayedLines:(NSInteger)linesQuantityMax
                     dataArray:(NSArray *)dataArray {
    self = [super init];
    
    self.sender = sender;
    self.dataArray = dataArray;
    
    if (self) {
        [self commonSetup];
        [self setupTableView];
        [self animateListViewWithSenderFrame:senderFrame linesQuantityMax:linesQuantityMax];
        [sender.superview addSubview:self];
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
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)setupTableView {
    UINib *nib = [UINib nibWithNibName:[VAListCell nibName] bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[VAListCell cellIdentifier]];
    self.tableView.layer.cornerRadius = VAListViewCornerRadius;
}

- (void)animateListViewWithSenderFrame:(CGRect)visibleSenderFrame
                      linesQuantityMax:(NSInteger)linesQuantityMax {
    
    CGFloat height = (self.dataArray.count >= linesQuantityMax) ? linesQuantityMax * 44.f : self.dataArray.count * 44.f;
    DropDirection dropDirection = (CGRectGetMinY(visibleSenderFrame) - height >= VAListViewUpperInsetY ) ? DropDirectionUp : DropDirectionDown;
    
    CGRect senderFrame = self.sender.frame;

    switch (dropDirection) {
        case DropDirectionUp:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame),
                                    CGRectGetMinY(senderFrame) - VAListViewSenderInsetY,
                                    MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth),
                                    0);
            break;
        case DropDirectionDown:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame),
                                    CGRectGetMaxY(senderFrame) + VAListViewSenderInsetY,
                                    MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth),
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
                                    CGRectGetMinY(senderFrame) - VAListViewSenderInsetY - height,
                                    MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth),
                                    height);
            break;
        case DropDirectionDown:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame),
                                    CGRectGetMaxY(senderFrame) + VAListViewSenderInsetY,
                                    MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth) ,
                                    height);
            break;
        default:
            break;
    }

    self.tableView.frame = CGRectMake(0, 0, MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth), height);
    [UIView commitAnimations];
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
