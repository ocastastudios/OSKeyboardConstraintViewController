//
//  OSKeyboardConstraintViewController.m
//  Ocasta Studios
//
//  Created by Chris Birch on 31/01/2014.
//  Copyright (c) 2014 OcastaStudios. All rights reserved.
//

#import "OSKeyboardConstraintViewController.h"

@interface OSKeyboardConstraintViewController ()
{
    UITapGestureRecognizer* tap;
    CGFloat initialConstantValue;
    BOOL keyboardShown;
    
}
@end

@implementation OSKeyboardConstraintViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.closeKeyboardOnTapBehind = YES;
    
    initialConstantValue=-1;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_closeKeyboardOnTapBehind)
    {
    
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
        tap.delegate= self;

        [self.view addGestureRecognizer:tap];
    }
    
   
}


-(void)setConstraintToAdjust:(NSLayoutConstraint *)constraintToAdjust
{
    _constraintToAdjust = constraintToAdjust;
    initialConstantValue = _constraintToAdjust.constant;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(initialConstantValue==-1)
        initialConstantValue = _constraintToAdjust.constant;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView* view = touch.view;
    //Dont close keyboard if the view is a user interactable type
    if ([view isKindOfClass:UIButton.class])
    {
        
    }
    else if ([view isKindOfClass:UITextField.class])
    {
    
    }
    else if ([view isKindOfClass:UITextView.class])
    {
        
    }
    else
    {
        [self closeKeyboard];
    }
    
    return NO;
}

-(void)closeKeyboard
{
    [self.view endEditing:YES];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view removeGestureRecognizer:tap];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)keyboardChangeFrame:(NSNotification*)note
{
    
    NSLayoutConstraint* constraintToAdjust = _constraintToAdjust;
    
    if (constraintToAdjust)
    {
    
        CGRect start = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect end = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        //if device is is orientated landscape then we need to take this into account
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            start = CGRectMake(start.origin.y, start.origin.x, start.size.height, start.size.width);
            end = CGRectMake(end.origin.y, end.origin.x, end.size.height, end.size.width);
        }
        
        NSUInteger curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
        double duration =[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //If the keyboard starts off at the bottom of the screen
        //or if the keyboard start and end origins dont change (i.e we've come back to this view from a pushed viewcontroller)
        BOOL kbGoingToShow = (start.origin.y > end.origin.y || start.origin.y == end.origin.y);
        //If duration is not > than 0 must just be a change of type of keyboard
        //so dont do anything
        
        if (kbGoingToShow)
            [self keyboardWillShow];
        else
            [self keyboardWillHide];
        
        _keyboardFrame = end;
                              
       // if (duration > 0)
        {
            [UIView animateWithDuration:duration delay:0 options:curve animations:^{
                
                //Work out we are hiding or showing
                
                if (kbGoingToShow)
                {
                    //showing
                    constraintToAdjust.constant = end.size.height + _additionalYOffset;
                    
                    keyboardShown = YES;
                }
                else
                {
                    //Hiding
                    constraintToAdjust.constant = initialConstantValue;
                    keyboardShown = NO;
                }
                
                
                [self.view layoutIfNeeded];
                
                NSLog(@"%.2f",constraintToAdjust.constant);
            } completion:^(BOOL finished)
             {
                if (keyboardShown)
                    [self keyboardDidShow];
                 else
                     [self keyboardDidHide];
            }];
        }

    }
//    else
//        [NSException raise:@"No constraint!" format:@"Cannot adjust constraint in reaction to the keyboard as no contraint has been set! Please specify a containt by setting the contraintToAdjust propeerty"];
}

-(void)keyboardWillShow
{
    //Not implemented here
}

-(void)keyboardWillHide
{
    //Not implemented here
}


-(void)keyboardDidHide
{
    //Not implemented here
}

-(void)keyboardDidShow
{
    //Not implemented here
}



@end
