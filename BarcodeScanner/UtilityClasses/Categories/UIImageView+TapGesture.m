//
//  UIImageView+TapGesture.m
//  winkApp
//
//  Created by Temp on 16/12/14.
//  Copyright (c) 2014 kuriosthele. All rights reserved.
//

#import "UIImageView+TapGesture.h"
#import "NSArray+safe.h"

@implementation UIImageView (TapGesture)

- (void)addTapGesture:(NSObject *)target withAction:(SEL)tapSelector{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                          initWithTarget:target
                                          action:tapSelector];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:singleTap];
}

- (void)removeTapGesture{
    UITapGestureRecognizer *tapGesture = [[self gestureRecognizers] safeObjectAtIndex:0];
    [self removeGestureRecognizer:tapGesture];
}

- (void)disableTapGesture:(BOOL)needToDisable{
    if (needToDisable) {
        UITapGestureRecognizer *tapGesture = [[self gestureRecognizers] safeObjectAtIndex:0];
        if ([tapGesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self setUserInteractionEnabled:NO];
        }
    }else{
        [self setUserInteractionEnabled:YES];
    }
}


@end
