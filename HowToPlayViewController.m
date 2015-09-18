//
//  HowToPlayViewController.m
//  DoubleSnake
//
//  Created by Charles on 7/28/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import "HowToPlayViewController.h"

@interface HowToPlayViewController ()

@end

@implementation HowToPlayViewController
@synthesize backButton;
@synthesize titleLabel;

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
	self.backButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backButton.layer.shadowOpacity = 0.5;
    self.backButton.layer.shadowRadius = 5;
    self.backButton.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
    self.backButton.layer.shouldRasterize = YES;
    self.backButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.titleLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.titleLabel.layer.shadowOpacity = 0.5;
    self.titleLabel.layer.shadowRadius = 5;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
    self.titleLabel.layer.shouldRasterize = YES;
    self.titleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)backPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidUnload {
    [self setBackButton:nil];
    [self setTitleLabel:nil];
    [self setText:nil];
    [super viewDidUnload];
}
@end
