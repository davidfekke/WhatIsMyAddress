//
//  FlipsideViewController.h
//  WhatIsMyAddress
//
//  Created by Peter Fekke on 10/27/12.
//  Copyright (c) 2012 David Fekke L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
