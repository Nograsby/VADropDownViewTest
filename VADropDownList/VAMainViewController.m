//
//  VAMainViewController.m
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/18/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import "VAMainViewController.h"

#import "VAListView.h"

#import "JVFloatLabeledTextField.h"

@interface VAMainViewController () <VAListViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutletCollection(JVFloatLabeledTextField) NSArray *textFields;
@property (strong, nonatomic) VAListView *listView;
@property (strong, nonatomic) NSArray *listArray;


@end

@implementation VAMainViewController

- (IBAction)textFieldEditingChanged:(JVFloatLabeledTextField *)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UITextField *textField in self.textFields) {
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapRecognizer.cancelsTouchesInView = NO;
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.listArray = @[@"Россия 1", @"Россия 2", @"Россия 3", @"Россия 4", @"Россия 5", @"Беларусь", @"Украина"];
    
    

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

- (void)textFieldDidChange:(UITextField *)textField {
    [self hideDropListWithSender:textField];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", textField.text];
    NSArray *filteredArray = [self.listArray filteredArrayUsingPredicate:predicate];
    [self showDropListWithSender:textField dataArray:filteredArray];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self hideDropListWithSender:textField];
}

#pragma mark - VAListViewDelegate

- (void)dataFromListView:(NSString *)string
              withSender:(UIView *)sender {
    JVFloatLabeledTextField *textField = (JVFloatLabeledTextField *)sender;
    textField.text = string;
    
    [self.listView removeFromSuperview];

    self.listView = nil;
    [self.view endEditing:YES];
}

- (void)showDropListWithSender:(UIView *)sender
                     dataArray:(NSArray *)array {
    
    self.listView = [[VAListView alloc] initWithSender:sender
                                     maxDisplayedLines:3
                                             dataArray:array
                                         dropDirection:DropDirectionUp];
    self.listView.delegate = self;
}

- (void)hideDropListWithSender:(UIView *)sender {
    [self.listView hideListViewWithSender:sender];
    [self.listView removeFromSuperview];
    self.listView = nil;
}

@end
