//
//  ViewController.h
//  MobileInsights1
//
//  Created by Krishnamurthy, Megha on 10/3/13.
//  Copyright (c) 2013 Krishnamurthy, Megha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (nonatomic) MPMediaQuery *everything;

- (IBAction)onClick:(id)sender;

@end
