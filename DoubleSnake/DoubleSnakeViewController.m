//
//  DoubleSnakeViewController.m
//  DoubleSnake
//
//  Created by Charles on 7/20/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import "DoubleSnakeViewController.h"
#import "DoubleSnakeAppDelegate.h"

@interface DoubleSnakeViewController ()

@property (strong, nonatomic) IBOutlet UIView *doubleSnakeView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *upSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *downSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property NSString *directionBuffer;
@end


@implementation DoubleSnakeViewController

#pragma mark -
#pragma mark Load
/*
- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
	[super viewWillDisappear:animated];

}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"Motion");
	if (event.subtype == UIEventSubtypeMotionShake){
        [self prepareForRestart];
	}
}*/
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [self.loading resignFirstResponder];
    [self.loading removeFromSuperview];
    self.loading = nil;
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    [super viewWillDisappear:animated];
    [(((DoubleSnakeAppDelegate*) [UIApplication sharedApplication].delegate)).window makeKeyAndVisible];
}
- (void)prepareForRestart {
    //Get all subviews and remove them
    NSMutableArray *subviews = [[self.doubleSnakeView subviews] mutableCopy];
    //Except important views
    [subviews removeObject:self.scoreLabel];
    [subviews removeObject:self.backgroundView];
    [subviews removeObject:self.rightArrow];
    [subviews removeObject:self.leftArrow];
    [subviews removeObject:self.upArrow];
    [subviews removeObject:self.downArrow];
    [subviews removeObject:self.bottomView];
    [subviews removeObject:self.bottomPadView];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    self.body = nil;
    self.gameStarted.gameStarted = YES;
    //Unhide arrows
    self.rightArrow.hidden = NO;
    self.leftArrow.hidden = NO;
    self.downArrow.hidden = NO;
    self.upArrow.hidden = NO;
    self.scoreLabel.text = @"Score: 0";
    self.loading.label.text = self.scoreLabel.text;
    [self start];
}

-(void)appWillResignActive {
    NSLog(@"Pausing Game");
    if (self.twoPlayer.twoPlayer) {
        [self sendPauseDeathToPeers];
        [[StartViewController class] sharedGameStarted].gameStarted = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        self.pausedAlert = [BlockAlertView alertWithTitle:@"Game Paused" message:@""];
        __weak DoubleSnakeViewController *me = self;
        [self.pausedAlert setDestructiveButtonWithTitle:@"End Game" block:^{if (me.twoPlayer.twoPlayer) [me sendPauseDeathToPeers];
            [[StartViewController class] sharedGameStarted].gameStarted = NO;
            [me.navigationController popToRootViewControllerAnimated:YES];}];
        [self.pausedAlert setCancelButtonWithTitle:@"Resume" block:^{if (me.twoPlayer.twoPlayer) [me sendResumeGame];
            [me resume];}];
        [self.pausedAlert show];
    }
        if (self.updateTimer) [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    
    if (CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136))) {
        self.scoreLabel.frame = CGRectMake(20, self.scoreLabel.frame.origin.y+490, self.scoreLabel.frame.size.width, self.scoreLabel.frame.size.height);
        self.scoreLabel.textAlignment = NSTextAlignmentLeft;
        self.scoreLabel.font = [[self.scoreLabel font] fontWithSize:32];
        self.bottomView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.bottomView.layer.shadowOffset = CGSizeMake(0, -1);
        self.bottomView.layer.shadowOpacity = 1;
        self.bottomView.layer.shadowRadius = 1.0;
        self.bottomView.clipsToBounds = NO;
        self.bottomView.layer.shouldRasterize = YES;
        self.bottomView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    }
    else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0) {
            self.scoreLabel.alpha = 0;
            [self.bottomView removeFromSuperview];
            self.loading = [[StartViewController class] sharedLoading];
            self.loading.frame = CGRectMake(0,0,320,20);
            //self.loading.bounds = CGRectMake(0,0,320,20);
            //self.loading.label.frame = CGRectMake(0,0,320.0f,20);
            self.loading.rootViewController.view.frame = self.loading.frame;
            //[self.loading makeKeyAndVisible];
            [self.loading animate];
        }
        self.loading.label.text = @"Score: 0";
    }
    
    //NSLog(@"%@",self.navigationController);
    /*self.pausedAlert = [[CustomAlertView alloc] initWithTitle:@"Game Paused"
                                                          message:@""
                                                         delegate:self
                                                cancelButtonTitle:@"End Game"
                                                otherButtonTitles:@"Resume", nil];*/
    self.pausedAlert = [BlockAlertView alertWithTitle:@"Game Paused" message:@""];
    __weak DoubleSnakeViewController *me = self;
    [self.pausedAlert setDestructiveButtonWithTitle:@"End Game" block:^{if (me.twoPlayer.twoPlayer) [me sendPauseDeathToPeers];
        [[StartViewController class] sharedGameStarted].gameStarted = NO;
        [me.navigationController popToRootViewControllerAnimated:YES];}];
    [self.pausedAlert setCancelButtonWithTitle:@"Resume" block:^{if (me.twoPlayer.twoPlayer) [me sendResumeGame];
        [me resume];}];
    self.directionBuffer = @"Up";
    self.panRecognizer.delegate = self;
    //[self.panRecognizer requireGestureRecognizerToFail:self.downSwipeRecognizer];
    //[self.panRecognizer requireGestureRecognizerToFail:self.upSwipeRecognizer];
    //[self.panRecognizer requireGestureRecognizerToFail:self.leftSwipeRecognizer];
    //[self.panRecognizer requireGestureRecognizerToFail:self.rightSwipeRecognizer];
    //[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.5] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.5]];
    self.twoPlayer = [[StartViewController class] sharedTwoPlayer];
    self.gameStarted = [[StartViewController class] sharedGameStarted];
    self.speed = [[StartViewController class] sharedSpeed];
    self.peerLost = [[StartViewController class] sharedPeerLost];
    self.gameStarted.gameStarted = YES;
    self.peerBody = [[StartViewController class] sharedPeerBody];
    self.peerScore = 0;
    self.wallCollisions = [[StartViewController class] sharedWallCollisions];
    if (self.twoPlayer.twoPlayer == false) {
        NSLog(@"Single Player Started");
        [self start];
    }
    else {
        NSLog(@"Two Player Started");
        [self start];
    }
     
}
- (void)start {
    self.gameStarted.gameStarted = YES;
    self.dead = NO;
    self.score = 0;
    self.peerLost.peerLost = NO;
    self.directionBuffer = @"Up";
    self.body = nil;
    self.head = [[BodyPart alloc] initWithPosition:CGPointMake(140,420) direction:@"Up" prevPart:nil nextPart:self.tail];
    BodyPart *middle = [[BodyPart alloc] initWithPosition:CGPointMake(140,440) direction:@"Up" prevPart:self.head nextPart:nil];
    self.tail = [[BodyPart alloc] initWithPosition:CGPointMake(140,460) direction:@"Up" prevPart:self.head nextPart:nil];
    self.body = [[NSMutableArray alloc] init];
    [self.body addObject:self.head];
    [self.body addObject:middle];
    [self.body addObject:self.tail];
    self.food = [[NSMutableArray alloc] init];
    if (![StartViewController sharedIStarted].iStarted || !self.twoPlayer.twoPlayer) [self randomFood];
    if (![StartViewController sharedIStarted].iStarted && self.twoPlayer.twoPlayer) [self sendFood];
    [self paintStart];
    self.currentSpeed = self.speed.speed;
    if (self.twoPlayer.twoPlayer && ![StartViewController sharedIStarted].iStarted) {
        NSLog(@"Starting update cycles");
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                            target:self
                                                          selector:@selector(update)
                                                          userInfo:nil
                                                           repeats:NO];
    }
    else {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                           target:self
                                                         selector:@selector(update)
                                                         userInfo:nil
                                                          repeats:YES];
    }
}

- (void)clear {
    NSLog(@"Game Over");
    // Issue vibrate
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    for (BodyPart *bodyPart in self.body) {
        [bodyPart turnRed];
        [self.view addSubview:bodyPart.box];
    }
    
}


#pragma mark -
#pragma mark Gesture Recognizers

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint velocity = [sender velocityInView:sender.view];
        if (fabs([sender translationInView:self.view].x) > 1.5 || fabs([sender translationInView:self.view].y) > 1.5) {
            if (fabs(velocity.x) > fabs(velocity.y)) {
                //left or right
                if (velocity.x < 0) {
                    //NSLog(@"gesture went left");
                    if (![self.head.direction isEqualToString: @"Right"] && ![self.head.direction isEqualToString: @"Left"]) {
                        self.directionBuffer = @"Left";
                        if ([StartViewController sharedShowArrows].showArrows) {
                            [self.rightArrow setAlpha:0];
                            [self.upArrow setAlpha:0];
                            [self.downArrow setAlpha:0];
                            [self.leftArrow setAlpha:0.25];
                            [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(hideLeftArrow)
                                                           userInfo:nil
                                                            repeats:NO];
                        }
                    }
                }
                else {
                    //NSLog(@"gesture went right");
                    if (![self.head.direction isEqualToString: @"Left"] && ![self.head.direction isEqualToString: @"Right"]) {
                        self.directionBuffer = @"Right";
                        if ([StartViewController sharedShowArrows].showArrows) {
                            [self.leftArrow setAlpha:0];
                            [self.upArrow setAlpha:0];
                            [self.downArrow setAlpha:0];
                            [self.rightArrow setAlpha:0.25];
                            [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(hideRightArrow)
                                                           userInfo:nil
                                                            repeats:NO];
                        }
                    }
                }
            }
            else if (fabs(velocity.x) < fabs(velocity.y)) {
                //up or down
                if (velocity.y < 0) {
                    //NSLog(@"gesture went up");
                    if (![self.head.direction isEqual: @"Down"] && ![self.head.direction isEqual: @"Up"]) {
                        self.directionBuffer = @"Up";
                        if ([StartViewController sharedShowArrows].showArrows) {
                            [self.rightArrow setAlpha:0];
                            [self.leftArrow setAlpha:0];
                            [self.downArrow setAlpha:0];
                            [self.upArrow setAlpha:0.25];
                            [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(hideUpArrow)
                                                           userInfo:nil
                                                            repeats:NO];
                        }
                    }
                }
                else {
                    //NSLog(@"gesture went down");
                    if (![self.head.direction isEqual: @"Up"] && ![self.head.direction isEqual: @"Down"]) {
                        self.directionBuffer = @"Down";
                        if ([StartViewController sharedShowArrows].showArrows) {
                            [self.rightArrow setAlpha:0];
                            [self.upArrow setAlpha:0];
                            [self.leftArrow setAlpha:0];
                            [self.downArrow setAlpha:0.25];
                            [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(hideDownArrow)
                                                           userInfo:nil
                                                            repeats:NO];
                        }
                    }
                }
            }
        }
        [sender setTranslation:CGPointZero inView:self.view];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)hideLeftArrow {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.leftArrow setAlpha:0];
    [UIView commitAnimations];
}
- (void)hideRightArrow {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.rightArrow setAlpha:0];
    [UIView commitAnimations];
}
- (void)hideUpArrow {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.upArrow setAlpha:0];
    [UIView commitAnimations];
}
- (void)hideDownArrow {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.downArrow setAlpha:0];
    [UIView commitAnimations];
}
- (IBAction)leftSwipe:(UISwipeGestureRecognizer *)sender {
    if ([sender state]== UIGestureRecognizerStateEnded) {
        //At wall update
        BOOL atWall;
        if ([self isAtWall]) atWall = YES;
        else atWall = NO;
        
        //Acceleration
        if ([self.head.direction isEqual: @"Left"] && !self.twoPlayer.twoPlayer && !([(BodyPart *)[self.food objectAtIndex:0] position].x == self.head.position.x - 20 && [(BodyPart *)[self.food objectAtIndex:0] position].y == self.head.position.y)) {
            NSLog(@"Acceleration %@", self.directionBuffer);
            [self.updateTimer invalidate];
            self.updateTimer = nil;
            [self update];
            self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                                target:self
                                                              selector:@selector(update)
                                                              userInfo:nil
                                                               repeats:YES];
        }
        if (![self.head.direction isEqual: @"Right"] && ![self.head.direction isEqual: @"Left"])
            self.directionBuffer = @"Left";
        if (atWall) {
            if (!self.twoPlayer.twoPlayer){
                NSLog(@"Invalidating");
                [self.updateTimer invalidate];
                [self update];
                self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                                    target:self
                                                                  selector:@selector(update)
                                                                  userInfo:nil
                                                                   repeats:YES];
            }
        }
    }
}

- (IBAction)rightSwipe:(UISwipeGestureRecognizer *)sender {
    //At wall update
    BOOL atWall;
    if ([self isAtWall]) atWall = YES;
    else atWall = NO;
    
    //Acceleration
    if ([self.head.direction isEqual: @"Right"] && !self.twoPlayer.twoPlayer && !([(BodyPart *)[self.food objectAtIndex:0] position].x
        == self.head.position.x + 20 && [(BodyPart *)[self.food objectAtIndex:0] position].y == self.head.position.y)) {
        NSLog(@"Acceleration %@", self.directionBuffer);
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        [self update];
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                            target:self
                                                          selector:@selector(update)
                                                          userInfo:nil
                                                           repeats:YES];
    }
    if (![self.head.direction isEqual: @"Left"] && ![self.head.direction isEqual: @"Right"])
        self.directionBuffer = @"Right";
    if (atWall) {
        if (!self.twoPlayer.twoPlayer){
            NSLog(@"Invalidating");
            [self.updateTimer invalidate];
            [self update];
            self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                                target:self
                                                              selector:@selector(update)
                                                              userInfo:nil
                                                               repeats:YES];
        }
        
    }
}

- (IBAction)upSwipe:(UISwipeGestureRecognizer *)sender {
    //At wall update
    BOOL atWall;
    if ([self isAtWall]) atWall = YES;
    else atWall = NO;
    //Acceleration
    if ([self.head.direction isEqual: @"Up"] && !self.twoPlayer.twoPlayer && !([(BodyPart *)[self.food objectAtIndex:0] position].y
        == self.head.position.y - 20 && [(BodyPart *)[self.food objectAtIndex:0] position].x == self.head.position.x)){
        NSLog(@"Acceleration %@", self.directionBuffer);
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        [self update];
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                            target:self
                                                          selector:@selector(update)
                                                          userInfo:nil
                                                           repeats:YES];
    }
    if (![self.head.direction isEqual: @"Down"] && ![self.head.direction isEqual: @"Up"])
        self.directionBuffer = @"Up";
    if (atWall) {
        if (!self.twoPlayer.twoPlayer) {
            NSLog(@"Invalidating");
            [self.updateTimer invalidate];
            [self update];
            self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                                target:self
                                                              selector:@selector(update)
                                                              userInfo:nil
                                                               repeats:YES];
        }
        
    }
}
- (IBAction)downSwipe:(UISwipeGestureRecognizer *)sender {
    //At wall update
    BOOL atWall;
    if ([self isAtWall]) atWall = YES;
    else atWall = NO;
    
    //Acceleration
    if ([self.head.direction isEqual: @"Down"] && !self.twoPlayer.twoPlayer && !([(BodyPart *)[self.food objectAtIndex:0] position].y
        == self.head.position.y + 20 && [(BodyPart *)[self.food objectAtIndex:0] position].x == self.head.position.x)) {
        NSLog(@"Acceleration %@", self.directionBuffer);
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        [self update];
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                            target:self
                                                          selector:@selector(update)
                                                          userInfo:nil
                                                           repeats:YES];
    }
    if (![self.head.direction isEqual: @"Up"] && !![self.head.direction isEqual: @"Down"])
        self.directionBuffer = @"Down";
    if (atWall) {
        if (!self.twoPlayer.twoPlayer){
            NSLog(@"Invalidating");
            [self.updateTimer invalidate];
            [self update];
            self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                                target:self
                                                              selector:@selector(update)
                                                              userInfo:nil
                                                               repeats:YES];
        }
        
    }
}

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender {
    NSLog(@"Pausing Game");
    [sender.view removeGestureRecognizer:sender];
    if (self.twoPlayer.twoPlayer) {
        [self sendPauseDeathToPeers];
        [[StartViewController class] sharedGameStarted].gameStarted = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        __weak DoubleSnakeViewController *me = self;
        self.pausedAlert = [BlockAlertView alertWithTitle:@"Game Paused" message:@""];
        [self.pausedAlert setDestructiveButtonWithTitle:@"End Game" block:^{if (me.twoPlayer.twoPlayer) [me sendPauseDeathToPeers];
            [[StartViewController class] sharedGameStarted].gameStarted = NO;
            [me.navigationController popToRootViewControllerAnimated:YES];}];
        [self.pausedAlert setCancelButtonWithTitle:@"Resume" block:^{if (me.twoPlayer.twoPlayer) [me sendResumeGame];
            [me resume];}];
        [self.pausedAlert show];
    }
    if (self.updateTimer) [self.updateTimer invalidate];
    self.updateTimer = nil;
}


#pragma mark -
#pragma mark Send Bluetooth data

- (void)tellPaused:(id)startViewController {
    /*[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(71/255.0) green:(77/255.0) blue:(87/255.0) alpha:0.5] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.5]];
    
    self.pausedAlert = [[CustomAlertView alloc] initWithTitle:@"Game Paused"
                                                  message:@""
                                                 delegate:self
                                        cancelButtonTitle:@"End Game"
                                        otherButtonTitles:@"Resume", nil];
    [self.pausedAlert show];*/
    
    self.pausedAlert = [BlockAlertView alertWithTitle:@"Game Paused" message:@""];
    __weak DoubleSnakeViewController *me = self;
    [self.pausedAlert setDestructiveButtonWithTitle:@"End Game" block:^{if (me.twoPlayer.twoPlayer) [me sendPauseDeathToPeers];
        [[StartViewController class] sharedGameStarted].gameStarted = NO;
        [me.navigationController popToRootViewControllerAnimated:YES];}];
    [self.pausedAlert setCancelButtonWithTitle:@"Resume" block:^{if (me.twoPlayer.twoPlayer) [me sendResumeGame];
        [me resume];}];
    [self.pausedAlert show];
    
    if (self.updateTimer) [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)tellResumed:(id)startViewController {
    //[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(71/255.0) green:(77/255.0) blue:(87/255.0) alpha:0.5] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.5]];
    [[[UIAlertView alloc] initWithTitle:@"Called" message:@"hi" delegate:nil cancelButtonTitle:@"Bye" otherButtonTitles:nil, nil] show];
    [self.pausedAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self resume];
}


- (void)sendGameDataToPeers {

    NSLog(@"Sending data");
    NSMutableArray *positions = [[NSMutableArray alloc] init];
    for (int i=0;i<self.body.count;i++) {
        BodyPart *bodyPart = self.body[i];
        [positions addObject:[NSValue valueWithCGPoint:bodyPart.position]];
    }
    if ([StartViewController sharedBluetooth]) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:@{ @"Positions" : positions } forKey: @"Positions"];
        [archiver finishEncoding];
        [[[StartViewController sharedBluetooth] currentSession] sendDataToAllPeers:data
                                                                      withDataMode:GKSendDataReliable
                                                                             error:nil];
    }
}

- (void)sendFood {
    NSLog(@"Sending food");
    NSMutableArray *positions = [[NSMutableArray alloc] init];
    for (int i=0;i<self.food.count;i++) {
        BodyPart *food = self.food[i];
        [positions addObject:[NSValue valueWithCGPoint:food.position]];
    }
    if ([StartViewController sharedBluetooth]) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:@{ @"Food" : positions } forKey: @"Food"];
        [archiver finishEncoding];
        [[[StartViewController sharedBluetooth] currentSession] sendDataToAllPeers:data
                                                                      withDataMode:GKSendDataReliable
                                                                             error:nil];
    }
}

- (void)sendDeathToPeers {
    NSLog(@"Telling peers I lost");
    if ([StartViewController sharedBluetooth]) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:@{ @"Death" : @"Death"} forKey: @"Death"];
        [archiver finishEncoding];
        [[[StartViewController sharedBluetooth] currentSession] sendDataToAllPeers:data
                                                                      withDataMode:GKSendDataReliable
                                                                             error:nil];
    }

}
- (void)sendPauseDeathToPeers {
    NSLog(@"Telling peers I quit while pausing");
    if ([StartViewController sharedBluetooth]) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:@{ @"Paused Death" : @"Paused Death" } forKey: @"Paused Death"];
        [archiver finishEncoding];
        [[[StartViewController sharedBluetooth] currentSession] sendDataToAllPeers:data
                                                                      withDataMode:GKSendDataReliable
                                                                             error:nil];
    }
    
}
- (void)sendPauseGame {
    if ([StartViewController sharedBluetooth]) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:@{ @"Paused" : @"Paused" } forKey: @"Paused"];
        [archiver finishEncoding];
        [[[StartViewController sharedBluetooth] currentSession] sendDataToAllPeers:data
                                                                      withDataMode:GKSendDataReliable
                                                                             error:nil];
    }

}
-(void)sendResumeGame {
    if ([StartViewController sharedBluetooth]) {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:@{ @"Resumed" : @"Resumed" } forKey: @"Resumed"];
        [archiver finishEncoding];
        [[[StartViewController sharedBluetooth] currentSession] sendDataToAllPeers:data
                                                                      withDataMode:GKSendDataReliable
                                                                             error:nil];
    }
}
#pragma mark -
#pragma mark Actions

- (void)resume {
    if (!self.twoPlayer.twoPlayer) {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                            target:self
                                                          selector:@selector(update)
                                                          userInfo:nil
                                                           repeats:YES];
    }
    [self.view addGestureRecognizer:self.longPressRecognizer];
}




- (void)receiveMove:(StartViewController *)startViewController {
    //Clear old boxes
    for (int i=0;i<self.peerBodyToClear.count;i++) {
        if (self.peerBodyToClear[i]){
            NSLog(@"Clearing peer");
            [[self.peerBodyToClear[i] box] removeFromSuperview];
        }
    }
    if (self.fakePeerBody) {
        for (int i=0;i<self.fakePeerBody.count;i++) {
            if (self.fakePeerBody[i]){
                NSLog(@"Clearing fake peer");
                [[self.fakePeerBody[i] box] removeFromSuperview];
            }
        }
        self.fakePeerBody = nil;
    }
    //Display all of the peer's boxes
    for (int i=0;i<self.peerBody.count-1;i++) {
        if (self.peerBody[i]){
            NSLog(@"Displaying peer");
            [self.peerBody[i] box].layer.shadowColor = [UIColor blackColor].CGColor;
            [self.peerBody[i] box].alpha = 0.5;
            [self.peerBody[i] box].layer.shadowOpacity = 0.5;
            [self.peerBody[i] box].layer.shadowRadius = 5;
            [self.peerBody[i] box].layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
            [self.peerBody[i] box].layer.shouldRasterize = YES;
            [self.peerBody[i] box].layer.rasterizationScale = [[UIScreen mainScreen] scale];
            [self.view addSubview:[self.peerBody[i] box]];
        }
    }
    self.peerScore = (int)self.peerBody.count-4;
    self.peerBodyToClear = [self.peerBody copy];
    [self.peerBody removeAllObjects];
    if (!self.dead) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        NSLog(@"Restarting update cycles");
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                            target:self
                                                          selector:@selector(update)
                                                          userInfo:nil
                                                           repeats:NO];
    }
}

- (void)clearFood:(StartViewController *)startViewController {
    //Clear old boxes
    for (int i=0;i<self.food.count;i++) {
        if (self.food[i]){
            NSLog(@"Clearing food");
            [[self.food[i] box] removeFromSuperview];
        }
    }
}

- (void)receiveFood:(StartViewController *)startViewController {
    NSMutableArray *food = [StartViewController sharedFood];
    //NSLog(@"%@",food);
    //NSLog(@"Food at: %@",food[0]);
    BodyPart* myFood = food[0];
    [myFood turnFood];
    [myFood box].layer.shadowColor = [UIColor blackColor].CGColor;
    [myFood box].layer.shadowOpacity = 0.5;
    [myFood box].layer.shadowRadius = 5;
    [myFood box].layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [myFood box].layer.shouldRasterize = YES;
    [myFood box].layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [self.view addSubview:[myFood box]];
    [myFood attachPopUpAnimation];
    self.food = [food mutableCopy];
}

- (void)paintStart {
    //Render start scene
    for (int i=0;i<self.body.count;i++) {
        float opacity = 1 - 0.8 * (float)(i) / self.body.count;
        [self.body[i] box].layer.opacity = opacity;
        [self.body[i] box].layer.shadowColor = [UIColor blackColor].CGColor;
        [self.body[i] box].layer.shadowOpacity = 0.5;
        [self.body[i] box].layer.shadowRadius = 5;
        [self.body[i] box].layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        [self.body[i] box].layer.shouldRasterize = YES;
        [self.body[i] box].layer.rasterizationScale = [[UIScreen mainScreen] scale];
        [self.view addSubview:[self.body[i] box]];
    }
    for (int i=0;i<self.food.count;i++) {
        [self.food[i] box].layer.shadowColor = [UIColor blackColor].CGColor;
        [self.food[i] box].layer.shadowOpacity = 0.5;
        [self.food[i] box].layer.shadowRadius = 5;
        [self.food[i] box].layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        [self.food[i] box].layer.shouldRasterize = YES;
        [self.food[i] box].layer.rasterizationScale = [[UIScreen mainScreen] scale];
        [self.view addSubview:[self.food[i] box]];
    }
    if (self.twoPlayer.twoPlayer) {
        BodyPart *fakePeerHead = [[BodyPart alloc] initWithPosition:CGPointMake(160,60) direction:@"Up" prevPart:nil nextPart:self.tail];
        BodyPart *fakePeerMiddle = [[BodyPart alloc] initWithPosition:CGPointMake(160,40) direction:@"Up" prevPart:self.head nextPart:nil];
        BodyPart *fakePeerTail = [[BodyPart alloc] initWithPosition:CGPointMake(160,20) direction:@"Up" prevPart:self.head nextPart:nil];
        self.fakePeerBody = [[NSMutableArray alloc] init];
        [self.fakePeerBody addObject:fakePeerHead];
        [self.fakePeerBody addObject:fakePeerMiddle];
        [self.fakePeerBody addObject:fakePeerTail];
        for (int i=0;i<self.fakePeerBody.count;i++) {
            [self.fakePeerBody[i] box].layer.shadowColor = [UIColor blackColor].CGColor;
            [self.fakePeerBody[i] box].alpha = 0.5;
            [self.fakePeerBody[i] box].layer.shadowOpacity = 0.5;
            [self.fakePeerBody[i] box].layer.shadowRadius = 5;
            [self.fakePeerBody[i] box].layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
            [self.fakePeerBody[i] box].layer.shouldRasterize = YES;
            [self.fakePeerBody[i] box].layer.rasterizationScale = [[UIScreen mainScreen] scale];
            [self.view addSubview:[self.fakePeerBody[i] box]];
        }
    }
}

- (void)gotPauseDeath {
    NSLog(@"Got Paused Death");
    //[self.pausedAlert dismissWithClickedButtonIndex:-1 animated:YES];
    [self tellDeath];
}

- (void)tellDeath {
    NSLog(@"Peer lost");
    //Pause game
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    //Show alert
    self.peerScore = (int)self.peerBody.count-4;
    if (self.score < 0) self.score = 0;
    if (self.peerScore < 0) self.peerScore = 0;
    //[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(0/255.0) green:(255/255.0) blue:(0/255.0) alpha:0.5] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.5]];
    /*
    self.peerLostView = [[DoubleSnakeAlertView alloc] initWithTitle:@"You Won!"
                                                   message:@""
                         //message:[@"Final Score: " stringByAppendingFormat:@"%i to %i", self.score, self.peerScore]
                                                  delegate:self
                                         cancelButtonTitle:@"Main Menu"
                                         otherButtonTitles:nil];
    [self.peerLostView show];*/
    
    self.peerLostView = [BlockAlertView alertWithTitle:@"You Won!" message:@""];
    __weak DoubleSnakeViewController *me = self;
    [self.peerLostView setCancelButtonWithTitle:@"Main Menu" block:^{[[StartViewController class] sharedGameStarted].gameStarted = NO;
        [me.navigationController popToRootViewControllerAnimated:YES];}];
    [self.peerLostView show];
    
    
    
    //Update times won
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"Times Won"] == nil ||
        //![[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]] isKindOfClass:[NSDictionary class]] ||
        [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]] objectForKey:@"Times Won"] == nil// ||
        //![[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]] objectForKey:@"Times Won"] isKindOfClass:[NSArray class]]
        ) {
        
        NSLog(@"DoubleSnakeViewController is initing new times won dictionary");
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Times Won" : @[@(0)] }];
        [prefs setObject:data forKey:@"Times Won"];
        [prefs synchronize];
    }
    
    
    else {
        NSArray *oldTimesWon = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]] objectForKey:@"Times Won"];
        
        NSLog(@"Old Times Won : %i", [oldTimesWon[0] intValue]);
        
        NSMutableArray *newTimesWon = [oldTimesWon mutableCopy];
        int oldTimesWonInt = [newTimesWon[0] intValue];
        [newTimesWon replaceObjectAtIndex:0 withObject:@(oldTimesWonInt+1)];
        NSData *newTimesWonData = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Times Won" : [NSArray arrayWithArray:newTimesWon] }];
        [prefs setObject:newTimesWonData forKey:@"Times Won"];
    }
    [prefs synchronize];
}

- (void)update {
    if (self.dead) return;
    /*if (self.gameStarted.gameStarted == false && self.twoPlayer.twoPlayer) {
        NSLog(@"Peer disconnected");
        [self clear];
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Peer disconnected!" message:@"Your peer has been disconnected."];
        [alert setCancelButtonWithTitle:@"Main Menu" block:^{[[StartViewController class] sharedGameStarted].gameStarted = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];}];
        [alert show];
    }*/
    else {
        //Display all boxes
        for (int i=0;i<self.body.count;i++) {
            [self.body[i] box].layer.shadowColor = [UIColor blackColor].CGColor;
            [self.body[i] box].layer.shadowOpacity = 0.5;
            float opacity = 1 - 0.8*(float)(i+1) / self.body.count;
            [self.body[i] box].layer.opacity = opacity;
            [self.body[i] box].layer.shadowRadius = 5;
            [self.body[i] box].layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
            [self.body[i] box].layer.shouldRasterize = YES;
            [self.body[i] box].layer.rasterizationScale = [[UIScreen mainScreen] scale];
            [self.view addSubview:[self.body[i] box]];
        }
        
        //Set direction to direction buffer
        self.head.direction = self.directionBuffer;
        
        //Add new start node
        BodyPart *oldHead = self.head;
        if ([self.head.direction isEqualToString:@"Up"]) {
            //NSLog(@"Going up");
            self.head = [[BodyPart alloc] initWithPosition:CGPointMake(self.head.position.x, self.head.position.y-20) direction:@"Up" prevPart:self.head nextPart:nil];
        }
        if ([self.head.direction isEqualToString:@"Down"]) {
            //NSLog(@"Going down");
            self.head = [[BodyPart alloc] initWithPosition:CGPointMake(self.head.position.x, self.head.position.y+20) direction:@"Down" prevPart:self.head nextPart:nil];
        }
        if ([self.head.direction isEqualToString:@"Right"]) {
            //NSLog(@"Going right");
            self.head = [[BodyPart alloc] initWithPosition:CGPointMake(self.head.position.x+20, self.head.position.y) direction:@"Right" prevPart:self.head nextPart:nil];
        }
        if ([self.head.direction isEqualToString:@"Left"]) {
            //NSLog(@"Going left");
            self.head = [[BodyPart alloc] initWithPosition:CGPointMake(self.head.position.x-20, self.head.position.y) direction:@"Left" prevPart:self.head nextPart:nil];
        }
        oldHead.nextPart = self.head;
        [self.body insertObject:self.head atIndex:0];
        [self.body[0] box].layer.shadowColor = [UIColor blackColor].CGColor;
        [self.body[0] box].layer.shadowOpacity = 0.5;
        [self.body[0] box].layer.shadowRadius = 5;
        [self.body[0] box].layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        [self.body[0] box].layer.shouldRasterize = YES;
        [self.body[0] box].layer.rasterizationScale = [[UIScreen mainScreen] scale];
        if (![self isOutOfBounds] || !self.wallCollisions.wallCollisions) [self.view addSubview:self.head.box];
        
        //Check for collision with self
        if ([self isCollidingWithSelf]) {
            NSLog(@"Hit self");
            [self endGame];
            return;
        }
        
        if (self.wallCollisions.wallCollisions) {
            //Check if out of bounds
            if ([self isOutOfBounds]) {
                NSLog(@"Out of Bounds");
                [self endGame];
                return;
            }
        }
        
        else {
            //Wall collisions disabled
            if ([self isOutOfBounds]) {
                if (self.head.position.x<0) {
                    self.head.position = CGPointMake(300, self.head.position.y);
                    self.head.box.frame = CGRectMake(self.head.position.x, self.head.position.y, 20, 20);
                    
                    [self.view addSubview:[self.body[0] box]];
                    /*[UIView animateWithDuration:0.2
                                     animations:^{[[self.body lastObject] box].alpha = 0.0;}
                                     completion:^(BOOL finished){ [[[self.body lastObject] box] removeFromSuperview]; [self.body removeLastObject];}];*/
                }
                else if (self.head.position.x>300) {
                    self.head.position = CGPointMake(0, self.head.position.y);
                    self.head.box.frame = CGRectMake(self.head.position.x, self.head.position.y, 20, 20);
                    
                    [self.view addSubview:[self.body[0] box]];
                    /*[UIView animateWithDuration:0.2
                                     animations:^{[[self.body lastObject] box].alpha = 0.0;}
                                     completion:^(BOOL finished){ [[[self.body lastObject] box] removeFromSuperview]; [self.body removeLastObject];}];*/
                }
                else if (self.head.position.y<20) {
                    NSLog(@"Looping from top to bottom, y=%f", self.head.position.y);
                    self.head.position = CGPointMake(self.head.position.x, 460);
                    self.head.box.frame = CGRectMake(self.head.position.x, self.head.position.y, 20, 20);
                    
                    [self.view addSubview:[self.body[0] box]];
                    /*[UIView animateWithDuration:0.2
                                     animations:^{[[self.body lastObject] box].alpha = 0.0;}
                                     completion:^(BOOL finished){ [[[self.body lastObject] box] removeFromSuperview]; [self.body removeLastObject];}];*/
                }
                
                else if (self.head.position.y>460) {
                    NSLog(@"Looping from bottom to top, y=%f", self.head.position.y);
                    self.head.position = CGPointMake(self.head.position.x, 20);
                    self.head.box.frame = CGRectMake(self.head.position.x, self.head.position.y, 20, 20);
                    
                    [self.view addSubview:[self.body[0] box]];
                    /*[UIView animateWithDuration:0.2
                                     animations:^{[[self.body lastObject] box].alpha = 0.0;}
                                     completion:^(BOOL finished){ [[[self.body lastObject] box] removeFromSuperview]; [self.body removeLastObject];}];*/
                }
            }
        }
        
        //Check for collision with food
        if ([self isCollidingWithFood]) {
            self.score++;
            NSLog(@"Score increased; current body added length is %i", (int)self.body.count-3);
            // Issue vibrate
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            self.scoreLabel.text = [@"Score: " stringByAppendingFormat:@"%i", self.score];//body.count-3];
            self.loading.label.text = self.scoreLabel.text;
            [[[self.food lastObject] box] removeFromSuperview];
            [self.food removeLastObject];
            [self randomFood];
            if (self.twoPlayer.twoPlayer) [self sendFood];
        }
        
        //Destroy old end node
        else if (self.body.count != 1) {
            [UIView animateWithDuration:self.currentSpeed/2
                             animations:^{[[self.body lastObject] box].alpha = 0.0;}
                             completion:^(BOOL finished){ [[[self.body lastObject] box] removeFromSuperview]; [self.body removeLastObject];}];
        }
        
        if (self.wallCollisions.wallCollisions) {
            //Check if at wall and slow down
            if ([self isAtWall]) {
                if (!self.twoPlayer.twoPlayer) {
                    NSLog(@"Slowing down at wall");
                    [self.updateTimer invalidate];
                    if (self.currentSpeed < 0.5) {
                        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed*3
                                                                            target:self
                                                                          selector:@selector(update)
                                                                          userInfo:nil
                                                                           repeats:NO];
                    }
                    else self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                                             target:self
                                                                           selector:@selector(update)
                                                                           userInfo:nil
                                                                            repeats:NO];
                }
            }
            else {
                if (!self.twoPlayer.twoPlayer) {
                    [self.updateTimer invalidate];
                    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                                        target:self
                                                                      selector:@selector(update)
                                                                      userInfo:nil
                                                                       repeats:NO];
                }
            }
        }
        
        //Send data to peer
        if (self.twoPlayer.twoPlayer && !self.dead) [self sendGameDataToPeers];
    }
}

- (void)endGame {
    if (self.body) {
        NSLog(@"Game Over");
        [self.updateTimer invalidate];
        self.updateTimer = nil;
        if (!self.twoPlayer.twoPlayer) {
            for (int i=1;i<self.body.count;i++) {
                BodyPart *bodyPart = self.body[i];
                CATransition *transition = [CATransition animation];
                transition.duration = 1.0f;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [self.view.layer addAnimation:transition forKey:nil];
                [bodyPart turnRed];
                [self.view addSubview:bodyPart.box];
            }
            [self.body[0] box].alpha = 0;
        }
        //self.score = self.body.count-4;
        if (!self.twoPlayer.twoPlayer) self.body = nil;
        self.dead = YES;
        //Prevent arrows now
        self.rightArrow.hidden = YES;
        self.upArrow.hidden = YES;
        self.downArrow.hidden = YES;
        self.leftArrow.hidden = YES;
        if (self.twoPlayer.twoPlayer && self.peerLost.peerLost && [StartViewController sharedLastSnakeWins].lastSnakeWins) {
            if (self.score >0) [self updateHighScore];
            [self tellDeath];
            return;
        }
        if (!self.twoPlayer.twoPlayer) {
            //Single player - I lose
            for (BodyPart *bodyPart in self.body) {
                CATransition *transition = [CATransition animation];
                transition.duration = 1.0f;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [self.view.layer addAnimation:transition forKey:nil];
                [bodyPart turnRed];
                [self.view addSubview:bodyPart.box];
            }
            self.body = nil;
            /*[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.4] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.4]];
            [[[DoubleSnakeAlertView alloc] initWithTitle:@"Game Over!"
                                        message:@""
                                       delegate:self
                              cancelButtonTitle:@"Main Menu"
                              otherButtonTitles:@"Restart", nil] show];*/
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Game Over!" message:@""];
            [alert setDestructiveButtonWithTitle:@"Main Menu" block:^{if (self.twoPlayer.twoPlayer) [self sendPauseDeathToPeers];
                [[StartViewController class] sharedGameStarted].gameStarted = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];}];
            [alert setCancelButtonWithTitle:@"Restart" block:^{if (!self.twoPlayer.twoPlayer) [self prepareForRestart];}];
            [alert show];
            
            if (self.score >0) [self updateHighScore];
            return;
        }
        else {
            if ([StartViewController sharedLastSnakeWins].lastSnakeWins && !self.peerLost.peerLost) {
                //Last Snake wins - I lose
                NSLog(@"Last Snake Wins. You Lose");
                for (BodyPart *bodyPart in self.body) {
                    CATransition *transition = [CATransition animation];
                    transition.duration = 1.0f;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    [self.view.layer addAnimation:transition forKey:nil];
                    [bodyPart turnRed];
                    [self.view addSubview:bodyPart.box];
                }
                self.body = nil;
                /*[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.4] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.4]];
                [[[DoubleSnakeAlertView alloc] initWithTitle:@"Game Over!"
                                            message:@""
                                           delegate:self
                                  cancelButtonTitle:@"Main Menu"
                                  otherButtonTitles:nil] show];*/
                
                BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Game Over!" message:@""];
                [alert setCancelButtonWithTitle:@"Main Menu" block:^{
                    [[StartViewController class] sharedGameStarted].gameStarted = NO;
                    [self.navigationController popToRootViewControllerAnimated:YES];}];
                [alert show];
                
                if (self.score >0) [self updateHighScore];
                if (self.twoPlayer.twoPlayer && !self.peerLost.peerLost) [self sendDeathToPeers];
                return;
            }
            if (![StartViewController sharedLastSnakeWins].lastSnakeWins && self.score < self.peerScore) {
                //Longest Snake wins and I have less points
                if (self.score < 0) self.score = 0;
                if (self.peerScore < 0) self.peerScore = 0;
                for (BodyPart *bodyPart in self.body) {
                    CATransition *transition = [CATransition animation];
                    transition.duration = 1.0f;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    [self.view.layer addAnimation:transition forKey:nil];
                    [bodyPart turnRed];
                    [self.view addSubview:bodyPart.box];
                }
                self.body = nil;
                /*[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.4] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.4]];
                [[[DoubleSnakeAlertView alloc] initWithTitle:@"Game Over!"
                                            message:@""
                                            //message:[@"Final Score: " stringByAppendingFormat:@"%i to %i", self.score, self.peerScore]
                                           delegate:self
                                  cancelButtonTitle:@"Main Menu"
                                  otherButtonTitles:nil] show];*/
                
                BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Game Over!" message:@""];
                [alert setCancelButtonWithTitle:@"Main Menu" block:^{
                    [[StartViewController class] sharedGameStarted].gameStarted = NO;
                    [self.navigationController popToRootViewControllerAnimated:YES];}];
                [alert show];
                
                if (self.score >0) [self updateHighScore];
                if (self.twoPlayer.twoPlayer && !self.peerLost.peerLost) [self sendDeathToPeers];
                return;
            }
            if (![StartViewController sharedLastSnakeWins].lastSnakeWins && self.score > self.peerScore) {
                NSLog(@"Longest Snake Wins. You Win");
                NSLog(@"%i, peer %i", self.score, self.peerScore);
                //Longest Snake wins and I have more points
                [self tellDeath];
                if (self.score >0) [self updateHighScore];
                self.body = nil;
                if (self.twoPlayer.twoPlayer && !self.peerLost.peerLost) {
                    NSLog(@"Telling peer I won");
                    [self sendDeathToPeers];
                }
                return;
            }
            if (![StartViewController sharedLastSnakeWins].lastSnakeWins && self.score == self.peerScore) {
                //Longest Snake wins and I have same as peer
                if (self.score < 0) self.score = 0;
                if (self.peerScore < 0) self.peerScore = 0;
                /*[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.4] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.4]];
                [[[DoubleSnakeAlertView alloc] initWithTitle:@"Game Over!"
                                            message:@""
                                            //message:[@"Final Score: " stringByAppendingFormat:@"%i to %i", self.score, self.peerScore]
                                           delegate:self
                                  cancelButtonTitle:@"Main Menu"
                                  otherButtonTitles:nil] show];*/
                
                BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Game Over!" message:@""];
                [alert setCancelButtonWithTitle:@"Main Menu" block:^{
                    [[StartViewController class] sharedGameStarted].gameStarted = NO;
                    [self.navigationController popToRootViewControllerAnimated:YES];}];
                [alert show];
                
                if (self.score >0) [self updateHighScore];
                if (self.twoPlayer.twoPlayer && !self.peerLost.peerLost) [self sendDeathToPeers];
                return;
            }
        }
    }
}
/*
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == self.peerLostView) {
        if (buttonIndex == 0) {
            [[StartViewController class] sharedGameStarted].gameStarted = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (actionSheet == self.pausedAlert) {
        if (buttonIndex == 0) {
            if (self.twoPlayer.twoPlayer) [self sendPauseDeathToPeers];
            [[StartViewController class] sharedGameStarted].gameStarted = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        if (buttonIndex == 1) {
            if (self.twoPlayer.twoPlayer) [self sendResumeGame];
            [self resume];
        }
        
    }
    else {
        if (buttonIndex == 0) {
            [[StartViewController class] sharedGameStarted].gameStarted = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        if (!self.twoPlayer.twoPlayer && buttonIndex == 1) [self prepareForRestart];
    }
}
*/



- (void)updateHighScore {
    //Write to highscore database
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"Adding %i to highscores", self.score);
    if (!self.twoPlayer.twoPlayer) {
        if ([prefs objectForKey:@"Scores"] == nil ||
            //![[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] isKindOfClass:[NSDictionary class]] ||
            [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Single Player"] == nil ||
            //![[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Single Player"] isKindOfClass:[NSArray class]] ||
            [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Two Player"] == nil //||
            //![[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Two Player"] isKindOfClass:[NSArray class]
            ) {
            
            NSLog(@"Initing new scores dictionary");
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Single Player" : @[@(0)]  , @"Two Player" : @[@(0)] }];
            [prefs setObject:data forKey:@"Scores"];
            [prefs synchronize];
        }
        else {
            NSArray *oldSinglePlayerScores = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Single Player"];
            NSArray *oldTwoPlayerScores = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Two Player"];
            NSMutableArray *newSinglePlayerScores = [oldSinglePlayerScores mutableCopy];
            [newSinglePlayerScores addObject:@(self.score)];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Single Player" : newSinglePlayerScores , @"Two Player" : oldTwoPlayerScores}];
            [prefs setObject:data forKey:@"Scores"];
        }
    }
    else if (self.twoPlayer.twoPlayer) {
        if ([prefs objectForKey:@"Scores"] == nil ||
            //![[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] isKindOfClass:[NSDictionary class]] ||
            [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Single Player"] == nil ||
            //![[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Single Player"] isKindOfClass:[NSArray class]] ||
            [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Two Player"] == nil //||
            //![[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Two Player"] isKindOfClass:[NSArray class]]
            ) {
            
            NSLog(@"Initing new scores dictionary");
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Single Player" : @[@(0)]  , @"Two Player" : @[@(0)] }];
            [prefs setObject:data forKey:@"Scores"];
            [prefs synchronize];
        }
        else {
            NSArray *oldSinglePlayerScores = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Single Player"];
            NSArray *oldTwoPlayerScores = [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Two Player"];
            NSMutableArray *newTwoPlayerScores = [oldTwoPlayerScores mutableCopy];
            [newTwoPlayerScores addObject:@(self.score)];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Single Player" : oldSinglePlayerScores , @"Two Player" : newTwoPlayerScores }];
            [prefs setObject:data forKey:@"Scores"];
        }
    }
    [prefs synchronize];
}

- (void)randomFood {
    BodyPart *food = [[BodyPart alloc] initWithPosition:CGPointMake((int)(arc4random()%16)*20, (int)(arc4random()%22+1)*20) direction:@"Left" prevPart:nil nextPart:nil];
    [food turnFood];
    [self.food insertObject:food atIndex:0];
    for (int i=0;i<self.food.count;i++) {
        [self.food[i] box].layer.shadowColor = [UIColor blackColor].CGColor;
        [self.food[i] box].layer.shadowOpacity = 0.5;
        [self.food[i] box].layer.shadowRadius = 5;
        [self.food[i] box].layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        [self.food[i] box].layer.shouldRasterize = YES;
        [self.food[i] box].layer.rasterizationScale = [[UIScreen mainScreen] scale];
        [self.view addSubview:[self.food[i] box]];
        [self.food[i] attachPopUpAnimation];
        
    }
    //Don't let food overlap body
    for (int i=0;i<self.body.count;i++) {
        if ([(BodyPart *)self.food[0] position].x == [(BodyPart *)self.body[i] position].x && [(BodyPart *)self.food[0] position].y==[(BodyPart *)self.body[i] position].y) {
            [[[self.food lastObject] box] removeFromSuperview];
            [self.food removeLastObject];
            [self randomFood];
        }
    }
}
#pragma mark -
#pragma mark Status Check

- (BOOL)isCollidingWithSelf {
    for (int i=1;i<self.body.count;i++) {
        BodyPart *bodyPart = self.body[i];
        if (bodyPart.position.x == self.head.position.x && bodyPart.position.y==self.head.position.y) return true;
    }
    return false;
}
- (BOOL)isOutOfBounds {
    //NSLog(@"%f",self.head.position.y);
    if (self.head.position.x<0 || self.head.position.x>300 || self.head.position.y<20 || self.head.position.y>460) return true;
    return false;
}
- (BOOL)isAtWall {
    if (self.head.position.x<20 && [self.head.direction isEqualToString:@"Left"]) return true;
    if (self.head.position.x>280 && [self.head.direction isEqualToString:@"Right"]) return true;
    if (self.head.position.y<0 && [self.head.direction isEqualToString:@"Up"]) return true;
    if (self.head.position.y>420 && [self.head.direction isEqualToString:@"Down"]) return true;
    return false;
}
- (BOOL)isCollidingWithFood {
    if ([(BodyPart *)[self.food objectAtIndex:0] position].x == self.head.position.x && [(BodyPart *)[self.food objectAtIndex:0] position].y==self.head.position.y) {
        //Change speed
        //if (!self.twoPlayer.twoPlayer) {
        NSLog(@"init speed was %f", self.speed.speed);
        self.currentSpeed /= pow(1.2, self.speed.speed);
        NSLog(@"Speed is now %f", self.currentSpeed);
        if (!self.twoPlayer.twoPlayer) {
            [self.updateTimer invalidate];
            self.updateTimer = nil;
            self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.currentSpeed
                                                                target:self
                                                              selector:@selector(update)
                                                              userInfo:nil
                                                               repeats:YES];
        }
        return true;
    }
    return false;
}
#pragma mark -
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
    [self setRightSwipeRecognizer:nil];
    [self setLeftSwipeRecognizer:nil];
    [self setUpSwipeRecognizer:nil];
    [self setDownSwipeRecognizer:nil];
    [self setBackgroundView:nil];
    [self setLongPressRecognizer:nil];
    [self setPanRecognizer:nil];
    [self setDownArrow:nil];
    [self setUpArrow:nil];
    [self setLeftArrow:nil];
    [self setScoreLabel:nil];
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        if ([subviews count] > 0)
            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]])
                [(UIAlertView *)[subviews objectAtIndex:0] dismissWithClickedButtonIndex:[(UIAlertView *)[subviews objectAtIndex:0] cancelButtonIndex] animated:NO];
    }
    
    [self setBottomView:nil];
    [super viewDidUnload];
}
@end
