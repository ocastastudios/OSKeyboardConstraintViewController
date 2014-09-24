//
//  OSKeyboardConstraintViewController.h
//  Ocasta Studios
//
//  Created by Chris Birch on 31/01/2014.
//  Copyright (c) 2014 OcastaStudios. All rights reserved.
//

/**
 * This is used to automatically adjust the specified layout contraint to make sure content is not hidden when keyboard is shown. YAY!
 */

#import <UIKit/UIKit.h>

@interface OSKeyboardConstraintViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic,assign) CGRect keyboardFrame;
/**
 * YES if we should automatically close the keyboard when the user taps behind
 */
@property (nonatomic,assign) BOOL closeKeyboardOnTapBehind;

/**
 * Set the layout contraint to be adjusted when the keyboard is shown
 */
@property (nonatomic,weak) NSLayoutConstraint* constraintToAdjust;

/**
 * When the keyboard is shown, this is an aditional amount that is added to the constraint constant. Useful for when an additional control has been appended to the
 * top of the keyboard
 */
@property (nonatomic,assign) CGFloat additionalYOffset;

/**
 * Prevent constraint from being adjusted
 */
@property (nonatomic,assign) BOOL suppressUpdates;

/**
 * Override to be notified that the kb has finished hiding
 */
-(void)keyboardDidHide;
/**
 * Override to be notified that the kb has finished showing
 */
-(void)keyboardDidShow;

/**
 * Override to be notified that the kb is about to be hidden
 */
-(void)keyboardWillHide;

/**
 * Override to be notified that the kb is about to be shown
 */
-(void)keyboardWillShow;


-(void)closeKeyboard;

@end
