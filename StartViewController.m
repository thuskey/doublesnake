//
//  StartViewController.m
//  DoubleSnake
//
//  Created by Charles on 7/22/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import "StartViewController.h"
#import "DoubleSnakeAppDelegate.h"

@interface StartViewController ()

@end

@implementation StartViewController

GKPeerPickerController *picker;

#pragma mark -
#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (![[self class] sharedGameStarted].gameStarted && CGRectEqualToRect([[self class] sharedLoading].rootViewController.view.frame, CGRectMake(0.0f,0.0f,320.0f,20.0f))) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:[[self class] sharedLoading].rootViewController.view cache:YES];
		[[[self class] sharedLoading] setClipsToBounds:YES];
		[[self class] sharedLoading].frame = CGRectMake(0.0f,20.0f,320.0f,0.0f);
		[[self class] sharedLoading].bounds = CGRectMake(0.0f,0.0f,320.0f,0.0f);
		//[[[self class] sharedLoading].rootViewController.view setFrame:CGRectMake(0.0f,20.0f,320.0f,0.0f)];
		//[[[self class] sharedLoading].label setFrame:CGRectMake(0,0,320.0f,0)];
		[UIView commitAnimations];
	}
	
    //NSLog(@"Refreshing");
	[self resetButtons];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[(((DoubleSnakeAppDelegate*) [UIApplication sharedApplication].delegate)).window makeKeyAndVisible];
	[self becomeFirstResponder];
}

- (void)resetButtons {
	self.settingsView.frame=CGRectMake(0, self.view.bounds.size.height-50, self.settingsView.frame.size.width, self.settingsView.frame.size.height);
	
    self.startButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.startButton.layer.shadowOpacity = 0.5;
    self.startButton.layer.shouldRasterize = YES;
    self.startButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.startButton.layer.shadowRadius = 5;
    self.startButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	
    self.connectButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.connectButton.layer.shadowOpacity = 0.5;
    self.connectButton.layer.shadowRadius = 5;
    self.connectButton.layer.shouldRasterize = YES;
    self.connectButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.connectButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	
    self.helpButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.helpButton.layer.shadowOpacity = 0.5;
    self.helpButton.layer.shouldRasterize = YES;
    self.helpButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.helpButton.layer.shadowRadius = 5;
    self.helpButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	
    self.highScoresButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.highScoresButton.layer.shadowOpacity = 0.5;
    self.highScoresButton.layer.shadowRadius = 5;
    self.highScoresButton.layer.shouldRasterize = YES;
    self.highScoresButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.highScoresButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    self.bottomBarView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bottomBarView.layer.shadowOpacity = 0.5;
    self.bottomBarView.layer.shadowRadius = 10;
    self.bottomBarView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.bottomBarView.layer.shouldRasterize = YES;
    self.bottomBarView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)viewWillDisappear:(BOOL)animated {
	//[self resignFirstResponder];
	[self resetButtons];
	[super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillDisappear:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	self.gameStarted.gameStarted = NO;
	
    UIColor *myColor = [UIColor colorWithRed:(71/255.0) green:(77/255.0) blue:(87/255.0) alpha:1.0];
	
    self.connectButton.tintColor = myColor;
    [self.startButton setBackgroundImage:[UIImage imageNamed:@"ButtonHighlighted.png"] forState:UIControlStateHighlighted];
    [self.connectButton setBackgroundImage:[UIImage imageNamed:@"ButtonHighlighted.png"] forState:UIControlStateHighlighted];
    [self.helpButton setBackgroundImage:[UIImage imageNamed:@"ButtonHighlighted.png"] forState:UIControlStateHighlighted];
    
    [self.spinner stopAnimating];
    [self.startButton setTitle:@"Start Single Player" forState:UIControlStateNormal];
    [self.connectSpinner stopAnimating];
    [self.connectButton setTitle:@"Connect with Bluetooth" forState:UIControlStateNormal];
    
    self.titleLabel.layer.shadowColor = [[UIColor colorWithRed:255 green:255 blue:255 alpha:1.0] CGColor];
    self.titleLabel.layer.shadowRadius = 4.0f;
    self.titleLabel.layer.shadowOpacity = .3;
    self.titleLabel.layer.shadowOffset = CGSizeZero;
    self.titleLabel.layer.masksToBounds = NO;
	self.titleLabel.layer.shouldRasterize = YES;
    self.titleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	
    self.firstTitleLabel.layer.shadowColor = [[UIColor colorWithRed:255 green:255 blue:255 alpha:1.0] CGColor];
    self.firstTitleLabel.layer.shadowRadius = 4.0f;
    self.firstTitleLabel.layer.shadowOpacity = .3;
    self.firstTitleLabel.layer.shadowOffset = CGSizeZero;
    self.firstTitleLabel.layer.masksToBounds = NO;
	self.firstTitleLabel.layer.shouldRasterize = YES;
    self.firstTitleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	self.showArrows = [[self class] sharedShowArrows];
	if ([prefs objectForKey:@"Direction Arrows"] == nil) {
		NSLog(@"Initing bool for arrows");
		[prefs setBool:NO forKey:@"Direction Arrows"];
		[prefs synchronize];
	}
	//NSLog(@"%@",[prefs boolForKey:@"Direction Arrows"] ? @"Yes" : @"No");
	self.showArrows.showArrows = [prefs boolForKey:@"Direction Arrows"];
	self.directionArrowsSwitch.on = self.showArrows.showArrows;
    
    self.wallCollisions = [[self class] sharedWallCollisions];
	if ([prefs objectForKey:@"Wall Collisions"] == nil) {
		NSLog(@"Initing bool for wall collisions");
		[prefs setBool:NO forKey:@"Wall Collisions"];
		[prefs synchronize];
	}
	self.wallCollisions.wallCollisions = [prefs boolForKey:@"Wall Collisions"];
	self.wallCollisionsSwitch.on = self.wallCollisions.wallCollisions;
    
    
    if ([prefs objectForKey:@"Last Snake Wins"] == nil) {
		NSLog(@"Initing bool for Last Snake Wins");
		[prefs setBool:NO forKey:@"Last Snake Wins"];
		[prefs synchronize];
	}
	self.lastSnakeWins = [[self class] sharedLastSnakeWins];
	self.lastSnakeWins.lastSnakeWins = [prefs boolForKey:@"Last Snake Wins"];
	self.lastSnakeSwitch.on = self.lastSnakeWins.lastSnakeWins;
    self.twoPlayer = [[self class] sharedTwoPlayer];
    self.twoPlayer.twoPlayer = NO;
    self.gameStarted = [[self class] sharedGameStarted];
    self.gameStarted.gameStarted = NO;
    self.speed = [[self class] sharedSpeed];
	if ([prefs objectForKey:@"Game Speed"] == nil) {
		[prefs setFloat:0.75f forKey:@"Game Speed"];
		[prefs synchronize];
	}
	self.speedSlider.value = [prefs floatForKey:@"Game Speed"];
    self.speed.speed = 1/powf(2.0,self.speedSlider.value-0.25);
	self.formattedSpeed = [[self class] sharedFormattedSpeed];
	float answer = roundf (powf(2.0,self.speedSlider.value)
						   * 2) / 2.0;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
	self.formattedSpeed.speed = answer - 0.5;
	if (self.formattedSpeed.speed==15.5) self.formattedSpeed.speed = 16;
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:self.formattedSpeed.speed]];
    self.speedMultiplierLabel.text = [numberString stringByAppendingString:@"x"];	
    self.peerLost = [[self class] sharedPeerLost];
    self.peerLost.peerLost = NO;
    self.peerBody = [[self class] sharedPeerBody];
	[[self class] sharedIStarted].iStarted = NO;
	
	self.food = [[self class] sharedFood];
	//[self becomeFirstResponder];
}

#pragma mark -
#pragma mark Shake to Clear Settings
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.subtype == UIEventSubtypeMotionShake) {
		NSLog(@"Shaken");
		//[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(71/255.0) green:(77/255.0) blue:(87/255.0) alpha:0.8] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.5]];
		
		BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Reset All Settings?" message:@"This will delete all high scores and reset all preferences and cannot be undone."];
		[alert setCancelButtonWithTitle:@"Cancel" block:nil];
		[alert setDestructiveButtonWithTitle:@"Reset" block:^{[self resetSettings];}];
		[alert show];
		/*[[[CustomAlertView alloc]
		  initWithTitle:@"Reset All Settings?"
		  message:@"This will delete all high scores and reset all preferences and cannot be undone."
		  delegate:self
		  cancelButtonTitle:@"Cancel"
		  otherButtonTitles:@"Reset", nil] show];*/
	}
}

- (void)resetSettings {
	NSLog(@"Resetting settings");
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Single Player" : @[@(0)]  , @"Two Player" : @[@(0)] }];
	[prefs setObject:data forKey:@"Scores"];
	[prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:@{ @"Times Won" : @[@(0)] }] forKey:@"Times Won"];
	[prefs synchronize];
	
	self.showArrows = [[self class] sharedShowArrows];
	[prefs setBool:NO forKey:@"Direction Arrows"];
	[prefs synchronize];
	self.showArrows.showArrows = [prefs boolForKey:@"Direction Arrows"];
	self.directionArrowsSwitch.on = self.showArrows.showArrows;
	
	[prefs setBool:NO forKey:@"Last Snake Wins"];
	[prefs synchronize];
	self.lastSnakeWins = [[self class] sharedLastSnakeWins];
	self.lastSnakeWins.lastSnakeWins = [prefs boolForKey:@"Last Snake Wins"];
	self.lastSnakeSwitch.on = self.lastSnakeWins.lastSnakeWins;
	
    [prefs setBool:NO forKey:@"Wall Collisions"];
    [prefs synchronize];
    self.wallCollisions = [[self class] sharedWallCollisions];
    self.wallCollisions.wallCollisions = [prefs boolForKey:@"Wall Collisions"];
    self.wallCollisionsSwitch.on = self.wallCollisions.wallCollisions;
    
	self.speed = [[self class] sharedSpeed];
	[prefs setFloat:0.75f forKey:@"Game Speed"];
	[prefs synchronize];
	self.speedSlider.value = [prefs floatForKey:@"Game Speed"];
	self.speed.speed = 1/powf(2.0,self.speedSlider.value-0.25);
	float answer = roundf (powf(2.0,self.speedSlider.value)
						   * 2) / 2.0;
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setMaximumFractionDigits:2];
	[formatter setRoundingMode: NSNumberFormatterRoundDown];
	self.formattedSpeed.speed = answer - 0.5;
	if (self.formattedSpeed.speed==15.5) self.formattedSpeed.speed = 16;
	NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:self.formattedSpeed.speed]];
	self.speedMultiplierLabel.text = [numberString stringByAppendingString:@"x"];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self resetSettings];
	}
}

#pragma mark -
#pragma mark Actions
- (IBAction)connectPressed:(id)sender {
	[UIView beginAnimations:@"contract" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.settingsView.frame=CGRectMake(0, self.view.bounds.size.height-50, self.settingsView.frame.size.width, self.settingsView.frame.size.height);
    [UIView commitAnimations];
    [[UIStoryboard storyboardWithName:@"MainStoryboard"
                               bundle: nil] instantiateViewControllerWithIdentifier:@"Confirmation"];
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.connectSpinner startAnimating];
	NSLog(@"%@", picker);
    [picker show];
}

- (IBAction)lastSnakeSwitchChanged:(UISwitch *)sender {
	[[self class] sharedLastSnakeWins].lastSnakeWins = sender.on;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:sender.on forKey:@"Last Snake Wins"];
	[prefs synchronize];
}

- (IBAction)helpPressed:(UIButton *)sender {
    [UIView beginAnimations:@"contract" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.settingsView.frame=CGRectMake(0, self.view.bounds.size.height-50, self.settingsView.frame.size.width, self.settingsView.frame.size.height);
    [UIView commitAnimations];
}
- (IBAction)gameSpeedChanged:(UISlider *)sender {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setFloat:sender.value forKey:@"Game Speed"];
	[prefs synchronize];
	self.speed.speed = 1/powf(2.0,sender.value-0.25);
	float answer = roundf (powf(2.0,sender.value)
 * 2) / 2.0;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
	self.formattedSpeed.speed = answer - 0.5;
	if (self.formattedSpeed.speed==15.5) self.formattedSpeed.speed = 16;
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:self.formattedSpeed.speed]];
    self.speedMultiplierLabel.text = [numberString stringByAppendingString:@"x"];
}

- (IBAction)startPressed:(UIButton *)sender {
	[UIView beginAnimations:@"contract" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.settingsView.frame=CGRectMake(0, self.view.bounds.size.height-50, self.settingsView.frame.size.width, self.settingsView.frame.size.height);
    [UIView commitAnimations];
    if (!self.twoPlayer.twoPlayer) [self performSegueWithIdentifier: @"startSegue" sender: self];
    else {
		[self tellPeerToStart];
		[self.spinner startAnimating];
		[self.startButton setTitle:@"" forState:UIControlStateNormal];
	}
	
}

- (IBAction)directionArrowsSwitchChanged:(UISwitch *)sender {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:sender.on forKey:@"Direction Arrows"];
	[prefs synchronize];
	//NSLog(@"Set value to %@", [prefs boolForKey:@"Direction Arrows"] ? @"Yes" : @"No");
	[[self class] sharedShowArrows].showArrows = sender.on;
}

- (IBAction)wallCollisionsSwitchChanged:(UISwitch *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:sender.on forKey:@"Wall Collisions"];
	[prefs synchronize];
	[[self class] sharedWallCollisions].wallCollisions = sender.on;
}
#pragma mark -
#pragma mark Open and Close Settings
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint(CGRectMake(0, self.view.bounds.size.height-50, self.settingsView.frame.size.width, 50), [touch locationInView:self.view])) {
        if (self.settingsView.frame.origin.y != self.view.bounds.size.height-self.settingsView.frame.size.height) {
            [UIView beginAnimations:@"expand" context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
            self.settingsView.frame=CGRectMake(0, self.view.bounds.size.height-self.settingsView.frame.size.height, self.settingsView.frame.size.width, self.settingsView.frame.size.height);
            [UIView commitAnimations];
        }
    }
    else if (CGRectContainsPoint(CGRectMake(0, self.view.bounds.size.height-self.settingsView.frame.size.height, self.settingsView.frame.size.width, 50), [touch locationInView:self.view])) {
        if (self.settingsView.frame.origin.y == self.view.bounds.size.height-self.settingsView.frame.size.height) {
            [UIView beginAnimations:@"expand" context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
            self.settingsView.frame=CGRectMake(0, self.view.bounds.size.height-50, self.settingsView.frame.size.width, self.settingsView.frame.size.height);
            [UIView commitAnimations];
        }
    }
}

- (IBAction)settingsSwiped:(UISwipeGestureRecognizer *)sender {
    [UIView beginAnimations:@"expand" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.settingsView.frame=CGRectMake(0, self.view.bounds.size.height-self.settingsView.frame.size.height, self.settingsView.frame.size.width, self.settingsView.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)settingsClosed:(UISwipeGestureRecognizer *)sender {
    [UIView beginAnimations:@"contract" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.settingsView.frame=CGRectMake(0, self.view.bounds.size.height-50, self.settingsView.frame.size.width, self.settingsView.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark -
#pragma mark Bluetooth Connection
- (void)peerPickerController:(GKPeerPickerController *)picker
              didConnectPeer:(NSString *)peerID
                   toSession:(GKSession *)session {
    NSLog(@"Connection established");
    self.bluetooth = [[self class] sharedBluetooth];
    self.bluetooth.currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
	picker.delegate = nil;
    [picker dismiss];
    [self.startButton setTitle:@"Start Two Player" forState:UIControlStateNormal];
    self.twoPlayer.twoPlayer = YES;
    [self.connectSpinner stopAnimating];
    [self.connectButton setTitle:@"Connected" forState:UIControlStateNormal];
	[self.connectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	self.connectButton.enabled = NO;
}

- (void)setDelegate:(id)delegate {
	self.doubleSnakeViewControllerDelegate = delegate;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//NSLog(@"%@",segue.destinationViewController);
	if ([segue.destinationViewController class] == [DoubleSnakeViewController class]) self.doubleSnakeViewControllerDelegate = segue.destinationViewController;
	
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
	[self.connectSpinner stopAnimating];
	[self.connectButton setTitle:@"Connection Failed" forState:UIControlStateNormal];
	[self.connectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	self.connectButton.enabled = NO;
	picker = [[GKPeerPickerController alloc] init];
	picker.delegate = self;
	picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	//picker.delegate = nil;
}

- (void)session:(GKSession *)session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state {
    if (state==GKPeerStateConnected)
        NSLog(@"Connected");
    if (state==GKPeerStateDisconnected) {
        NSLog(@"Disconnected");
        self.bluetooth.currentSession = nil;
        [self.startButton setTitle:@"Start Single Player" forState:UIControlStateNormal];
        self.twoPlayer.twoPlayer = NO;
        self.gameStarted.gameStarted = NO;
        [self.connectButton setTitle:@"Connect with Bluetooth" forState:UIControlStateNormal];
		if (!self.spinner.hidden) {
			//[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(71/255.0) green:(77/255.0) blue:(87/255.0) alpha:0.5] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.5]];
			[[[CustomAlertView alloc] initWithTitle:@"Peer Disconnected!" message:@"Your peer has been disconnected before accepting your request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
			[self.spinner stopAnimating];
		}
    }
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context {
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	//Check if message is "Declined"
	NSDictionary *declinedDictionary = [unarchiver decodeObjectForKey:@"Declined"];
	if (declinedDictionary) {
		NSString *declinedString = [declinedDictionary objectForKey:@"Declined"];
		if ([declinedString isEqualToString:@"Declined"]) {
			NSLog(@"Declined");
			//[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(71/255.0) green:(77/255.0) blue:(87/255.0) alpha:0.8] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.5]];
			[[[CustomAlertView alloc]
			  initWithTitle:@"Declined"
			  message:@"Your peer has declined your game request."
			  delegate:self
			  cancelButtonTitle:@"OK"
			  otherButtonTitles:nil] show];
            [self.spinner stopAnimating];
			[self.startButton setTitle:@"Start Two Player" forState:UIControlStateNormal];

        }
		
	}
	
	//Check if message is "Accepted"
	NSDictionary *acceptedDictionary = [unarchiver decodeObjectForKey:@"Accepted"];
	if (acceptedDictionary) {
		NSString *acceptedString = [acceptedDictionary objectForKey:@"Accepted"];
		if ([acceptedString isEqualToString:@"Accepted"]) {
            NSLog(@"Received accept message. Starting.");
            if (self.isViewLoaded && self.view.window) {
				[[self class] sharedIStarted].iStarted = YES;
                [self performSegueWithIdentifier: @"startSegue"
										  sender: self];
                NSLog(@"Starting");
            }
            else NSLog(@"Already started");
            [self.spinner stopAnimating];
			[self.startButton setTitle:@"Start Two Player" forState:UIControlStateNormal];
        }

	}
	
    //Check if message is "Start and Settings"
    NSDictionary *startDictionary = [unarchiver decodeObjectForKey: @"Start and Settings"];
    if (startDictionary) {
		self.formattedSpeed.speed = [[startDictionary objectForKey:@"Formatted Speed"] floatValue];
		self.lastSnakeWins.lastSnakeWins = [[startDictionary objectForKey:@"Last Wins"] boolValue];
		self.wallCollisions.wallCollisions = [[startDictionary objectForKey:@"Wall Collisions"] boolValue];
		//NSLog(@"%@", self.lastSnakeWins.lastSnakeWins ? @"Yes" : @"No");
        self.speed.speed = [[startDictionary objectForKey:@"Speed"] floatValue];
        NSString *str = [startDictionary objectForKey:@"Start"];
        if ([str isEqualToString:@"Start"]) {
            NSLog(@"Has been told to start");
            if (self.isViewLoaded && self.view.window) {
                [self performSegueWithIdentifier:@"confirmationSegue" sender:self];
                NSLog(@"Sent to confirmation pane");
            }
            else NSLog(@"Already started");
        }
    }
	//Check if message is "Positions"
	NSDictionary *positions = [unarchiver decodeObjectForKey: @"Positions"];
    if (positions) {
        NSMutableArray *receivedPositions = [positions objectForKey:@"Positions"];
        //if ([receivedPositions objectAtIndex:0]) NSLog(@"Got positions!!!");
		
        //NSLog(@"%f, %f",[(NSValue *)[receivedPositions objectAtIndex:0] CGPointValue].x, [(NSValue *)[receivedPositions objectAtIndex:0] CGPointValue].y);
		//Make sure this array is created properly
		//Flip coordinates
		for (int i=0;i<receivedPositions.count;i++) {
			receivedPositions[i] = [NSValue valueWithCGPoint:CGPointMake(300-[receivedPositions[i] CGPointValue].x, 480-[receivedPositions[i] CGPointValue].y)];
		}
        for (int i=0;i<receivedPositions.count;i++) {
            [self.peerBody addObject:[[BodyPart alloc] initWithPosition:[[receivedPositions objectAtIndex:i] CGPointValue] direction:@"Unknown" prevPart:nil nextPart:nil]];
        }
		[self.doubleSnakeViewControllerDelegate receiveMove:self];
    }
	
	//Check if message is "Food"
	NSDictionary *foodPositions = [unarchiver decodeObjectForKey: @"Food"];
    if (foodPositions) {
        NSMutableArray *receivedFoodPositions = [foodPositions objectForKey:@"Food"];
        //if ([receivedFoodPositions objectAtIndex:0]) NSLog(@"Got food positions!!!");
		//Make sure this array is created properly
		//Flip coordinates
		//NSLog(@"Before %f,%f",[receivedFoodPositions[0] CGPointValue].x,[receivedFoodPositions[0] CGPointValue].y);
		
		receivedFoodPositions[0] = [NSValue valueWithCGPoint:CGPointMake(300-[receivedFoodPositions[0] CGPointValue].x, 480-[receivedFoodPositions[0] CGPointValue].y)];
		
		//NSLog(@"After %f,%f",[receivedFoodPositions[0] CGPointValue].x,[receivedFoodPositions[0] CGPointValue].y);
		
		[self.doubleSnakeViewControllerDelegate clearFood:self];
		[self.food removeAllObjects];
        for (int i=0;i<receivedFoodPositions.count;i++) {
            [self.food addObject:[[BodyPart alloc] initWithPosition:[[receivedFoodPositions objectAtIndex:i] CGPointValue] direction:@"Unknown" prevPart:nil nextPart:nil]];
        }
		[self.doubleSnakeViewControllerDelegate receiveFood:self];
    }
	
	//Check if message is "Death"
	NSDictionary *deathDictionary = [unarchiver decodeObjectForKey:@"Death"];
    if (deathDictionary) {
        NSString *str = [deathDictionary objectForKey:@"Death"];
        if ([str isEqualToString:@"Death"]) {
			NSLog(@"Peer lost");
			self.peerLost.peerLost = YES;
			[self.doubleSnakeViewControllerDelegate endGame];
		}
    }
	
	//Check if message is "Paused"
	NSDictionary *pausedDictionary = [unarchiver decodeObjectForKey:@"Paused"];
	if (pausedDictionary) {
		NSString *pausedString = [pausedDictionary objectForKey:@"Paused"];
		if ([pausedString isEqualToString:@"Paused"]) {
			NSLog(@"Peer paused");
			[self.doubleSnakeViewControllerDelegate tellPaused:self];
		}
		
	}
	
	//Check if message is "Paused Death"
	NSDictionary *pausedDeathDictionary = [unarchiver decodeObjectForKey:@"Paused Death"];
    if (pausedDeathDictionary) {
        NSString *str = [pausedDeathDictionary objectForKey:@"Paused Death"];
        if ([str isEqualToString:@"Paused Death"]) {
			NSLog(@"Peer quit in pause");
			self.peerLost.peerLost = YES;
			[self.doubleSnakeViewControllerDelegate gotPauseDeath];
		}
    }
	
    //Check if message is "Resumed"
	NSDictionary *resumedDictionary = [unarchiver decodeObjectForKey:@"Resumed"];
	if (resumedDictionary) {
		NSString *resumedString = [resumedDictionary objectForKey:@"Paused"];
		if ([resumedString isEqualToString:@"Resumed"]) {
			NSLog(@"Peer resumed");
			[self.doubleSnakeViewControllerDelegate tellResumed:self];
            
        }
		
	}
	
	[unarchiver finishDecoding];
}

- (void)tellPeerToStart
{
    NSLog(@"Telling peer to start");
    NSMutableData *speedData = [NSMutableData dataWithCapacity:0];
    float z = self.speed.speed;
    [speedData appendBytes:&z length:sizeof(float)];
    if ([StartViewController sharedBluetooth]) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:@{ @"Start" : @"Start", @"Speed" : @(self.speed.speed),@"Formatted Speed" : @(self.formattedSpeed.speed), @"Last Wins" : [NSNumber numberWithBool:self.lastSnakeSwitch.on], @"Wall Collisions" : [NSNumber numberWithBool:self.wallCollisionsSwitch.on] } forKey: @"Start and Settings"];
        [archiver finishEncoding];
        [[[StartViewController sharedBluetooth] currentSession] sendDataToAllPeers:data
				  withDataMode:GKSendDataReliable
				         error:nil];
    }
}
#pragma mark -
#pragma mark Singletons
+ (Bluetooth *)sharedBluetooth
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedBluetooth = nil;
    dispatch_once(&pred, ^{
        _sharedBluetooth = [[Bluetooth alloc] init];
    });
    return _sharedBluetooth;
}

+ (TwoPlayer *)sharedTwoPlayer
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedTwoPlayer = nil;
    dispatch_once(&pred, ^{
        _sharedTwoPlayer = [[TwoPlayer alloc] init];
    });
    return _sharedTwoPlayer;
}
+ (GameStarted *)sharedGameStarted
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedGameStarted = nil;
    dispatch_once(&pred, ^{
        _sharedGameStarted = [[GameStarted alloc] init];
    });
    return _sharedGameStarted;
}

+ (Speed *)sharedSpeed
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedSpeed = nil;
    dispatch_once(&pred, ^{
        _sharedSpeed = [[Speed alloc] init];
    });
    return _sharedSpeed;
}

+ (Speed *)sharedFormattedSpeed
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedFormattedSpeed = nil;
    dispatch_once(&pred, ^{
        _sharedFormattedSpeed = [[Speed alloc] init];
    });
    return _sharedFormattedSpeed;
}

+ (PeerLost *)sharedPeerLost
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedPeerLost = nil;
    dispatch_once(&pred, ^{
        _sharedPeerLost = [[PeerLost alloc] init];
    });
    return _sharedPeerLost;
}

+ (NSMutableArray *)sharedPeerBody
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedPeerBody = nil;
    dispatch_once(&pred, ^{
        _sharedPeerBody = [[NSMutableArray alloc] init];
    });
    return _sharedPeerBody;
}

+ (NSMutableArray *)sharedFood
{
    static dispatch_once_t pred = 0;
    __strong static id _shared = nil;
    dispatch_once(&pred, ^{
        _shared = [[NSMutableArray alloc] init];
    });
    return _shared;
}

+ (LastSnakeWins *) sharedLastSnakeWins {
	static dispatch_once_t pred = 0;
    __strong static id _sharedLastSnakeWins = nil;
    dispatch_once(&pred, ^{
        _sharedLastSnakeWins = [[LastSnakeWins alloc] init];
    });
    return _sharedLastSnakeWins;
}
+ (ShowArrows *) sharedShowArrows {
	static dispatch_once_t pred = 0;
    __strong static id _sharedShowArrows = nil;
    dispatch_once(&pred, ^{
        _sharedShowArrows = [[ShowArrows alloc] init];
    });
    return _sharedShowArrows;
}
+ (WallCollisions *) sharedWallCollisions {
	static dispatch_once_t pred = 0;
    __strong static id _shared = nil;
    dispatch_once(&pred, ^{
        _shared = [[WallCollisions alloc] init];
    });
    return _shared;
}
+ (IStarted *) sharedIStarted {
	static dispatch_once_t pred = 0;
    __strong static id _shared = nil;
    dispatch_once(&pred, ^{
        _shared = [[IStarted alloc] init];
    });
    return _shared;
}
+ (DoubleSnakeStatusWindow *) sharedLoading {
	static dispatch_once_t pred = 0;
    __strong static id _shared = nil;
    dispatch_once(&pred, ^{
        _shared = [[DoubleSnakeStatusWindow alloc] init];
    });
    return _shared;
}
#pragma mark -
- (void)viewDidUnload {
    [self setStartButton:nil];
    [self setSpeedSlider:nil];
    [self setTitleLabel:nil];
    [self setNameLabel:nil];
    [self setGameSpeedLabel:nil];
    [self setFirstTitleLabel:nil];
    [self setBottomBarView:nil];
	[self setSpeedMultiplierLabel:nil];
	[self setLastSnakeSwitch:nil];
	[self setHelpButton:nil];
	[self setSpinner:nil];
    [self setConnectSpinner:nil];
	[self setDirectionArrowsSwitch:nil];
    [self setSettingsView:nil];
    [self setSettingsSwipeRecognizer:nil];
    [self setSettingsCloseRecognizer:nil];
    [self setSettingsLabel:nil];
	[self setHighScoresButton:nil];
	[self setLastSnakeSwitch:nil];
	[self setLastSnakeSwitch:nil];
	[self setWallCollisionsLabel:nil];
	[self setWallCollisionsSwitch:nil];
    [super viewDidUnload];
}
@end
