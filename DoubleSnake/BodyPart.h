//
//  BodyPart.h
//  DoubleSnake
//
//  Created by Charles on 7/21/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface BodyPart : NSObject

@property CGPoint position;
@property NSString *direction;
@property BodyPart *prevPart;
@property BodyPart *nextPart;
@property UIImageView *box;

- (BodyPart *)initWithPosition:(CGPoint)position direction:(NSString *)direction prevPart:(BodyPart *)prevPart nextPart:(BodyPart *)nextPart;
- (void)turnRed;
- (void)turnFood;
- (void)attachPopUpAnimation;
@end
