//
//  VAMainViewController.m
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/18/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import "VAMainViewController.h"

#import "VAListView.h"

@interface VAMainViewController () <VAListViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) VAListView *listView;
@property (strong, nonatomic) NSArray *listArray;
@property (weak, nonatomic) IBOutlet UIView *scrollView;

@end

@implementation VAMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapRecognizer.cancelsTouchesInView = NO;
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.listArray = @[@"Belarus 1", @"Belarus 2", @"Belarus 3", @"Belarus 4", @"Belarus 5", @"Russia", @"Ukraine", @"Belgium", @"Andorra"];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    [self hideDropList];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", sender.text];
    NSArray *filteredArray = [self.listArray filteredArrayUsingPredicate:predicate];
    [self showDropListWithSender:sender dataArray:filteredArray];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self hideDropList];
}

#pragma mark - VAListViewDelegate

- (void)dataFromListView:(NSString *)string withSender:(UIView *)sender {
    UITextField *textField = (UITextField *)sender;
    textField.text = string;
    
    [self.listView removeFromSuperview];
    self.listView = nil;
    
    [self.view endEditing:YES];
}

- (void)showDropListWithSender:(UIView *)sender dataArray:(NSArray *)array {
    
    CGRect visibleSenderFrame = [self getVisibleFrameFor:sender];
    
    self.listView = [[VAListView alloc] initWithSender:sender
                                    visibleSenderFrame:visibleSenderFrame
                                     maxDisplayedLines:3
                                             dataArray:array];
    self.listView.delegate = self;
}

- (CGRect)getVisibleFrameFor:(UIView *)sender {
    CGRect visibleRect = [self.scrollView convertRect:self.scrollView.bounds toView:self.view];
    CGRect senderFrame = sender.frame;
    CGRect visibleSenderFrame = CGRectMake(CGRectGetMinX(senderFrame), CGRectGetMinY(senderFrame) + CGRectGetMinY(visibleRect), CGRectGetWidth(senderFrame), CGRectGetHeight(senderFrame));
    return visibleSenderFrame;
}

- (void)hideDropList {
    [self.listView removeFromSuperview];
    self.listView = nil;
}

@end
