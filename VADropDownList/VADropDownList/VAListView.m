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
static CGFloat const VAListViewShowAnimationDuration = 0.5f;
static CGFloat const VAListViewHideAnimationDuration = 5.2f;
static CGFloat const VAListViewMinWidth = 120.0f;

@interface VAListView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (assign, nonatomic) DropDirection dropDirection;
@property (strong, nonatomic) UIView *sender;
@property (assign, nonatomic) CGFloat currentKeyboardHeight;

@end

@implementation VAListView

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
        
        UINib *nib = [UINib nibWithNibName:[VAListCell nibName] bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:[VAListCell cellIdentifier]];
        self.tableView.layer.cornerRadius = VAListViewCornerRadius;
        
        CGFloat listViewHeight = (dataArray.count >= linesQuantityMax) ? linesQuantityMax * 44.f : dataArray.count * 44.f;
        [self checkDropDirectionWithHeight:listViewHeight];
        [self showListViewWithHeight:listViewHeight];
        
        [sender.superview addSubview:self];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}


- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat deltaHeight = kbSize.height - _currentKeyboardHeight;
    // Write code to adjust views accordingly using deltaHeight
    _currentKeyboardHeight = kbSize.height;
    NSLog(@"currentKeyboardHeight  ---   %f", self.currentKeyboardHeight);

}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // Write code to adjust views accordingly using kbSize.height
    _currentKeyboardHeight = 0.0f;
    NSLog(@"currentKeyboardHeight  ---   %f", self.currentKeyboardHeight);

}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)checkDropDirectionWithHeight:(CGFloat)height {
    CGRect senderFrame = self.sender.frame;

    if (CGRectGetMinY(senderFrame) - height < 0 ) {
        self.dropDirection = DropDirectionDown;
    }
}

- (void)showListViewWithHeight:(CGFloat)height {
    CGRect senderFrame = self.sender.frame;
    
    switch (self.dropDirection) {
        case DropDirectionUp:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMinY(senderFrame) - VAListViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth), 0);
            break;
        case DropDirectionDown:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMaxY(senderFrame) + VAListViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth), 0);
            break;
        default:
            break;
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:VAListViewShowAnimationDuration];
    switch (self.dropDirection) {
        case DropDirectionUp:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMinY(senderFrame) - VAListViewSenderInsetY - height, MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth), height);
            break;
        case DropDirectionDown:
            self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMaxY(senderFrame) + VAListViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth) , height);
            break;
        default:
            break;
    }

    self.tableView.frame = CGRectMake(0, 0, MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth), height);
    [UIView commitAnimations];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VAListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[VAListCell cellIdentifier]];
    [cell populateWithTitle:self.dataArray[indexPath.row]];
    return cell;
}

- (void)hideListViewWithSender:(UIView *)sender {
    CGRect senderFrame = sender.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:VAListViewHideAnimationDuration];
    if (self.dropDirection == DropDirectionUp) {
        self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMinY(senderFrame) - VAListViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth), 0);
    }
    else if (self.dropDirection == DropDirectionDown) {
        self.frame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMaxY(senderFrame) + VAListViewSenderInsetY, MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth), 0);
    }
    self.tableView.frame = CGRectMake(0, 0, MAX(CGRectGetWidth(senderFrame), VAListViewMinWidth), 0);
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideListViewWithSender:self.sender];
    
    [self.delegate dataFromListView:self.dataArray[indexPath.row]
                         withSender:self.sender];
}

@end
