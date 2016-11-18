//
//  ViewController.m
//  VADropDownList
//
//  Created by Vladimir Ananko on 11/17/16.
//  Copyright © 2016 Vladimir Ananko. All rights reserved.
//

#import "ViewController.h"

#import "VADropDownView.h"

@interface ViewController () <VADropDownViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) VADropDownView *dropDownView;
@property (strong, nonatomic) NSArray *listArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.listArray = @[@"Россия 1", @"Россия 2", @"Россия 3", @"Россия 4", @"Россия 5", @"Беларусь", @"Украина"];
}

- (void)hideKeyboard:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.view endEditing:YES];
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self hideDropDownList:textField];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", textField.text];
    NSArray *filteredArray = [self.listArray filteredArrayUsingPredicate:predicate];
    [self showDropDownList:textField withDataArray:filteredArray];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.dropDownView = nil;
}


#pragma mark - VADropDownViewDelegate

- (void)hideDropDownView:(VADropDownView *)view withData:(NSString *)string {
    self.dropDownView = nil;
    self.textField.text = string;
}

- (void)showDropDownList:(id)sender withDataArray:(NSArray *)array {
    if (!self.dropDownView) {
        
        CGFloat dropDownListHeight = (array.count >= 4) ? 176.f : array.count * 44.f;
        NSString *direction = @"down";
        
        self.dropDownView = [[VADropDownView alloc] showDropDown:sender
                                                      withHeight:dropDownListHeight
                                                        withData:array
                                              animationDirection:direction];
        self.dropDownView.delegate = self;
    }
}

- (void)hideDropDownList:(id)sender {
    [self.dropDownView hideDropDownView:sender];
    self.dropDownView = nil;
}

@end
