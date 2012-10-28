//
//  MainViewController.h
//  WhatIsMyAddress
//
//  Created by Peter Fekke on 10/27/12.
//  Copyright (c) 2012 David Fekke L.L.C. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
