//
//  RDHSpringViewController.m
//  RDHSpringAnimations
//
//  Created by Richard Hodgkins on 16/10/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHSpringViewController.h"

#import <UIView-Autolayout/UIView+Autolayout.h>

static NSTimeInterval const RDH_DEFAULT_DURATION    = 1.5;
static CGFloat const        RDH_DEFAULT_DAMPENING   = 0.3;
static CGFloat const        RDH_DEFAULT_VELOCITY    = 10;

static CGFloat const RDH_DEFAULT_WIDTH  = 100;
static CGFloat const RDH_DEFAULT_HEIGHT = 100;

typedef NS_ENUM(NSUInteger, RDHAnimation)
{
    RDHAnimation1,
    RDHAnimation2,
    RDHAnimation3,
    RDHAnimation4,
    RDHAnimation5,
    RDHAnimation6,
    RDHAnimation7,
    RDHAnimation8,
    RDHAnimation9,
    RDHAnimationCount
};

@interface RDHSpringViewController ()<UITextFieldDelegate>
{
    BOOL needsAnimationUpdate;
}

@property (nonatomic, weak) IBOutlet UIStepper *stepperDuration;
@property (nonatomic, weak) IBOutlet UITextField *fieldDuration;

@property (nonatomic, weak) IBOutlet UIStepper *stepperDampening;
@property (nonatomic, weak) IBOutlet UITextField *fieldDampening;

@property (nonatomic, weak) IBOutlet UIStepper *stepperVelocity;
@property (nonatomic, weak) IBOutlet UITextField *fieldVelocity;

@property (nonatomic, weak) IBOutlet UIView *animationView1;
@property (nonatomic, weak) IBOutlet UIView *animationView2;

@property (nonatomic, weak) NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) NSLayoutConstraint *centerXConstraint;
@property (nonatomic, weak) NSLayoutConstraint *centerYConstraint;

@property (nonatomic, assign) RDHAnimation animationState;
@property (nonatomic, assign) BOOL animationResting;

@end

@implementation RDHSpringViewController

-(instancetype)init
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    needsAnimationUpdate = YES;
    [self didChangeDuration:@(RDH_DEFAULT_DURATION)];
    [self didChangeDampening:@(RDH_DEFAULT_DAMPENING)];
    [self didChangeVelocity:@(RDH_DEFAULT_VELOCITY)];
    
    [self setupSteppers:@[self.stepperDuration, self.stepperDampening, self.stepperVelocity]];
    [self setupFields:@[self.fieldDuration, self.fieldDampening, self.fieldVelocity]];
    
    [self setupAnimationViews];
}

-(CGFloat)defaultWidth
{
    return RDH_DEFAULT_WIDTH * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 1 : 2);
}

-(CGFloat)defaultHeight
{
    return RDH_DEFAULT_HEIGHT * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 1 : 2);
}

#pragma mark - Animation updates

-(void)setNeedsAnimationUpdate
{
    if (needsAnimationUpdate) {
        needsAnimationUpdate = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateAnimationIfNeeded];
        });
    }
}

-(void)updateAnimationIfNeeded
{
    needsAnimationUpdate = YES;
    
    NSLog(@"Update animation");
    
    NSTimeInterval duration = self.stepperDuration.value;
    CGFloat dampening = self.stepperDampening.value;
    CGFloat velocity = self.stepperVelocity.value;
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:dampening initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:[self animationBlock] completion:^(BOOL finished) {
                
        if (finished) {
            
            self.animationResting = !self.animationResting;
            
            if (!self.animationResting) {
                self.animationState = (self.animationState + 1) % RDHAnimationCount;
            }
            
            [self setNeedsAnimationUpdate];
        }
    }];
}

-(dispatch_block_t)animationBlock
{
    self.widthConstraint.constant = [self defaultWidth];
    self.heightConstraint.constant = [self defaultHeight];
    self.centerXConstraint.constant = 0;
    self.centerYConstraint.constant = 0;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if (!self.animationResting) {
        switch (self.animationState) {
            case RDHAnimation1:
                self.widthConstraint.constant = [self defaultWidth] / 2;
                break;
                
            case RDHAnimation2:
                self.heightConstraint.constant = [self defaultHeight] / 2;
                break;
                
            case RDHAnimation3:
                self.centerXConstraint.constant = -[self defaultWidth];
                break;
                
            case RDHAnimation4:
                self.centerXConstraint.constant = [self defaultWidth];
                break;
                
            case RDHAnimation5:
                self.centerYConstraint.constant = -[self defaultHeight] / 2;
                break;
                
            case RDHAnimation6:
                self.centerYConstraint.constant = [self defaultHeight] / 2;
                break;
                
            case RDHAnimation7:
                transform = CGAffineTransformMakeRotation(M_PI_4);
                break;
                
            case RDHAnimation8:
                transform = CGAffineTransformMakeRotation(M_PI_4 * 3);
                break;
                
            case RDHAnimation9:
                transform = CGAffineTransformMakeRotation(M_PI_4 * 7);
                break;
                
            default:
                break;
        }
    }
    return ^{
        
        UIColor *backgroundColor;
        
        if (self.animationResting) {
            backgroundColor = [UIColor redColor];
        } else {
            backgroundColor = [UIColor blueColor];
        }
        
        self.animationView1.transform = transform;
        
        [self.animationView1 layoutIfNeeded];
        self.animationView2.backgroundColor = backgroundColor;
    };
}

#pragma mark - Value changing

-(void)didChangeDuration:(NSNumber *)value
{
    self.stepperDuration.value = [value doubleValue];
    self.fieldDuration.text = [[self numberFormatter] stringFromNumber:value];
    
    [self setNeedsAnimationUpdate];
}

-(void)didChangeDampening:(NSNumber *)value
{
    self.stepperDampening.value = [value doubleValue];
    self.fieldDampening.text = [[self numberFormatter] stringFromNumber:value];
    
    [self setNeedsAnimationUpdate];
}

-(void)didChangeVelocity:(NSNumber *)value
{
    self.stepperVelocity.value = [value doubleValue];
    self.fieldVelocity.text = [[self numberFormatter] stringFromNumber:value];
    
    [self setNeedsAnimationUpdate];
}

#pragma mark - Actions

-(IBAction)didChangeStepper:(UIStepper *)stepper
{
    NSNumber *value = @(stepper.value);
    
    if (stepper == self.stepperDuration) {
        [self didChangeDuration:value];
    } else if (stepper == self.stepperDampening) {
        [self didChangeDampening:value];
    } else if (stepper == self.stepperVelocity) {
        [self didChangeVelocity:value];
    }
}

#pragma mark - Text field delegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSNumber *value = [[self numberFormatter] numberFromString:textField.text];
    
    if (textField == self.fieldDuration) {
        [self didChangeDuration:value];
    } else if (textField == self.fieldDampening) {
        [self didChangeDampening:value];
    } else if (textField == self.fieldVelocity) {
        [self didChangeVelocity:value];
    }
}

#pragma mark - Number formatting

-(NSNumberFormatter *)numberFormatter
{
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.generatesDecimalNumbers = YES;
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 2;
    });
    return formatter;
}

#pragma mark - View setup

-(void)setupSteppers:(NSArray *)steppers
{
    for (UIStepper *stepper in steppers) {
        stepper.minimumValue = 0;
        stepper.maximumValue = 20;
        stepper.stepValue = 0.05;
    }
}

-(void)setupFields:(NSArray *)fields
{
    for (UITextField *field in fields) {
        field.enabled = NO;
        field.textAlignment = NSTextAlignmentRight;
        field.keyboardType = UIKeyboardTypeNumberPad;
    }
}

-(void)setupAnimationViews
{
    self.widthConstraint = [self.animationView1 constrainToWidth:RDH_DEFAULT_WIDTH];
    self.heightConstraint = [self.animationView1 constrainToHeight:RDH_DEFAULT_HEIGHT];
    self.centerXConstraint = [self.animationView1 centerInContainerOnAxis:NSLayoutAttributeCenterX];
    self.centerYConstraint = [self.animationView1 centerInContainerOnAxis:NSLayoutAttributeCenterY];
}

@end
