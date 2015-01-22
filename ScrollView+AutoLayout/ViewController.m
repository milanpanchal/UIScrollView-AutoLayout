//
//  ViewController.m
//  ScrollView+AutoLayout
//
//  Created by MilanPanchal on 21/01/15.
//  Copyright (c) 2015 Pantech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *bloodGroupTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomSpace;

@property (weak, nonatomic) UITextField *activeField;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];


}

-(void)viewDidAppear:(BOOL)animated {

    self.scrollView.contentSize = self.contentView.frame.size;

    NSLog(@"Content Size %@",NSStringFromCGSize(self.scrollView.contentSize));
}


- (void)viewWillDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    if (self.firstNameTF == textField) {
        [self.lastNameTF becomeFirstResponder];
    
    } else if (self.lastNameTF == textField) {
        [self.emailAddressTF becomeFirstResponder];
    
    } else if (self.emailAddressTF == textField) {
        [self.phoneNumberTF becomeFirstResponder];
    
    } else if (self.phoneNumberTF == textField) {
        [self.bloodGroupTF becomeFirstResponder];
    
    } else if (self.bloodGroupTF == textField) {
        [self.bloodGroupTF resignFirstResponder];
    }

    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)sender {
    self.activeField = sender;
}

- (void)textFieldDidEndEditing:(UITextField *)sender {
    self.activeField = nil;
}


#pragma mark - NSNotificationCenter for Keyboard

- (void) keyboardDidShow:(NSNotification *)notification {

    // Get keyboard frame
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect aRect = self.view.frame;
    aRect.size.height -= frame.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
    
    self.constraintBottomSpace.constant = frame.size.height;
    [self.view layoutIfNeeded];

}

- (void) keyboardWillBeHidden:(NSNotification *)notification {
    self.constraintBottomSpace.constant = 0;
    [self.view layoutIfNeeded];
}

@end
