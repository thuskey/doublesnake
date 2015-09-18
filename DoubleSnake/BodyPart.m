//
//  BodyPart.m
//  DoubleSnake
//
//  Created by Charles on 7/21/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import "BodyPart.h"

@implementation BodyPart

@synthesize position = _position;
@synthesize direction = _direction;
@synthesize prevPart = _prevPart;
@synthesize nextPart = _nextPart;
@synthesize box = _box;

- (BodyPart *)initWithPosition:(CGPoint)position direction:(NSString *)direction prevPart:(BodyPart *)prevPart nextPart:(BodyPart *)nextPart {
    if (self = [super init]) {
        self.position = position;
        self.direction = [NSString stringWithString: direction];
        self.prevPart = prevPart;
        self.nextPart = nextPart;
        self.box = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"box.png"]];
        self.box.frame = CGRectMake(position.x, position.y, 20, 20);
        self.box.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)attachPopUpAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale2 = CATransform3DMakeScale(2.0, 2.0, 1);
    CATransform3D scale3 = CATransform3DMakeScale(1.5, 1.5, 1);
    CATransform3D scale4 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale5 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            [NSValue valueWithCATransform3D:scale5],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.4],
                           [NSNumber numberWithFloat:0.6],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];    
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 5;
    
    [self.box.layer addAnimation:animation forKey:@"popup"];
}


- (void)turnRed {
    self.box.image = [UIImage imageNamed:@"redbox.png"];
}
- (void)turnFood {
    self.box.image = [UIImage imageNamed:@"yellowbox.png"];
}

@end
