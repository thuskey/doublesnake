//
//  ConfirmationViewController.m
//  DoubleSnake
//
//  Created by Charles on 7/26/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "DoubleSnakeViewController.h"

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController
@synthesize startViewControllerDelegate = _startViewControllerDelegate;
@synthesize invitedLabel = _invitedLabel;
@synthesize gameSpeedLabel = _gameSpeedLabel;
@synthesize acceptButton = _acceptButton;
@synthesize declineButton = _declineButton;
@synthesize peerLabel = _peerLabel;
@synthesize LastSnakeWinsLabel = _LastSnakeWinsLabel;
@synthesize optionsView = _optionsView;
@synthesize bluetooth = _bluetooth;

- (IBAction)acceptGame:(UIButton *)sender {
    NSLog(@"Accepted. Telling peer to start");
    if ([StartViewController sharedBluetooth]) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:@{ @"Accepted" : @"Accepted"} forKey: @"Accepted"];
        [archiver finishEncoding];
        [[[StartViewController sharedBluetooth] currentSession] sendDataToAllPeers:data
                                                                      withDataMode:GKSendDataReliable
                                                                             error:nil];
    }
    [StartViewController sharedIStarted].iStarted = NO;

    //[self performSegueWithIdentifier:@"twoPlayerStartAfterConfirm" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//NSLog(@"%@",segue.destinationViewController);
	if ([segue.destinationViewController class] == [DoubleSnakeViewController class]) {
        self.doubleSnakeViewControllerDelegate = segue.destinationViewController;
        [self.startViewControllerDelegate setDelegate:self.doubleSnakeViewControllerDelegate];
    }
}

- (IBAction)declineGame:(UIButton *)sender {
    NSLog(@"Declined");
    if ([StartViewController sharedBluetooth]) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:@{ @"Declined" : @"Declined"} forKey: @"Declined"];
        [archiver finishEncoding];
        [[[StartViewController sharedBluetooth] currentSession] sendDataToAllPeers:data
                                                                      withDataMode:GKSendDataReliable
                                                                             error:nil];
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    self.startViewControllerDelegate = [viewControllers objectAtIndex:0];
    [self.navigationController popViewControllerAnimated:YES];
}

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
    
    self.startViewControllerDelegate = [self.navigationController.viewControllers objectAtIndex:0];
    [self.acceptButton setBackgroundImage:[UIImage imageNamed:@"ButtonHighlighted.png"] forState:UIControlStateHighlighted];
    [self.declineButton setBackgroundImage:[UIImage imageNamed:@"ButtonHighlighted.png"] forState:UIControlStateHighlighted];
	float answer = roundf ([StartViewController sharedFormattedSpeed].speed
                           * 2) / 2.0;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];

    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:answer]];
    self.gameSpeedLabel.text = [[@"Game Speed: " stringByAppendingString:numberString] stringByAppendingString:@"x"];
    
    self.optionsView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.optionsView.layer.shadowOpacity = 0.5;
    self.optionsView.layer.shadowRadius = 5;
    self.optionsView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    
	self.acceptButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.acceptButton.layer.shadowOpacity = 0.5;
    self.acceptButton.layer.shadowRadius = 5;
    self.acceptButton.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.declineButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.declineButton.layer.shadowOpacity = 0.5;
    self.declineButton.layer.shadowRadius = 5;
    self.declineButton.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.invitedLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.invitedLabel.layer.shadowOpacity = 0.5;
    self.invitedLabel.layer.shadowRadius = 5;
    self.invitedLabel.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.bluetooth = [StartViewController sharedBluetooth];
    if(self.bluetooth) {
        self.peerLabel.text = [[self.bluetooth.currentSession displayNameForPeer:[self.bluetooth.currentSession peersWithConnectionState: GKPeerStateConnected][0]] stringByAppendingString:@" requests"];
    }
    self.LastSnakeWinsLabel.text = ([StartViewController sharedLastSnakeWins].lastSnakeWins ? @"Last Surviving Snake Wins" : @"Longest Snake Wins");
    self.wallCollisionsLabel.text = ([StartViewController sharedWallCollisions].wallCollisions ? @"Wall Collisions On" : @"Wall Collisions Off");

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

- (void)viewDidUnload {
    [self setGameSpeedLabel:nil];
    [self setInvitedLabel:nil];
    [self setAcceptButton:nil];
    [self setDeclineButton:nil];
    [self setPeerLabel:nil];
    [self setLastSnakeWinsLabel:nil];
    [self setOptionsView:nil];
    [self setWallCollisionsLabel:nil];
    [super viewDidUnload];
}
@end
