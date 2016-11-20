//
//  AVMainViewController.m
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/18/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import "AVMainViewController.h"

#import "VADropDownView.h"

#import "JVFloatLabeledTextField.h"

@interface AVMainViewController () <VADropDownViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(JVFloatLabeledTextField) NSArray *textFields;
@property (strong, nonatomic) VADropDownView *dropDownView;
@property (strong, nonatomic) NSArray *listArray;

@end

@implementation AVMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UITextField *textField in self.textFields) {
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.listArray = @[@"Россия 1", @"Россия 2", @"Россия 3", @"Россия 4", @"Россия 5", @"Беларусь", @"Украина"];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.view endEditing:YES];
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self hideDropListWithSender:textField];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", textField.text];
    NSArray *filteredArray = [self.listArray filteredArrayUsingPredicate:predicate];
    [self showDropListWithSender:textField dataArray:filteredArray];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideDropListWithSender:textField];
    });
}

#pragma mark - VADropDownViewDelegate

- (void)selectedData:(NSString *)string
        fromDropView:(VADropDownView *)view
           forSender:(UIView *)sender {
    JVFloatLabeledTextField *textField = (JVFloatLabeledTextField *)sender;
    view = nil;
    textField.text = string;
}

- (void)showDropListWithSender:(UIView *)sender
                     dataArray:(NSArray *)array {
    
    self.dropDownView = [[VADropDownView alloc] initWithSender:sender
                                             maxDisplayedLines:3
                                                     dataArray:array
                                                 dropDirection:DropDirectionDown];
    self.dropDownView.delegate = self;
}

- (void)hideDropListWithSender:(UIView *)sender {
    [self.dropDownView hideDropViewWithSender:sender];
    self.dropDownView = nil;
}

@end
