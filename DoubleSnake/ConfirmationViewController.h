//
//  ConfirmationViewController.h
//  DoubleSnake
//
//  Created by Charles on 7/26/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Speed.h"
#import "StartViewController.h"
#import "LastSnakeWins.h"
#import "ShowArrows.h"
#import "IStarted.h"

@interface ConfirmationViewController : UIViewController
@property (weak) StartViewController *startViewControllerDelegate;
@property (weak) id doubleSnakeViewControllerDelegate;
@property (strong, nonatomic) IBOutlet UILabel *invitedLabel;
@property (strong, nonatomic) IBOutlet UILabel *gameSpeedLabel;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *declineButton;
@property (strong, nonatomic) IBOutlet UILabel *peerLabel;
@property (strong, nonatomic) IBOutlet UILabel *LastSnakeWinsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *optionsView;
@property (weak, nonatomic) IBOutlet UILabel *wallCollisionsLabel;
@property Bluetooth *bluetooth;

@end
