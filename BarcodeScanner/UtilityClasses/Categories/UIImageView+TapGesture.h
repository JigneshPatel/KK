//
//  UIImageView+TapGesture.h
//  winkApp
//
//  Created by Temp on 16/12/14.
//  Copyright (c) 2014 kuriosthele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (TapGesture)

- (void)addTapGesture:(NSObject *)target withAction:(SEL)tapSelector;
- (void)removeTapGesture;
- (void)disableTapGesture:(BOOL)shouldDisable;
@end
