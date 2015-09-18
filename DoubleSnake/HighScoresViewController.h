//
//  HighScoresViewController.h
//  DoubleSnake
//
//  Created by Charles on 7/31/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DoubleSnakeAlertView.h"
#import "CustomAlertView.h"

@interface HighScoresViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property NSMutableDictionary *scores;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UILabel *timesWonLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIImageView *tableBack;
- (IBAction)resetPressed:(UIButton *)sender;
@end
