//
//  SettingsViewController.h
//  Pomodoro
//
//  Created by Michał Nowak on 29/07/2021.
//

#import <UIKit/UIKit.h>
#import "PomodoroTimer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController

- (void)setRequiredData:(PomodoroTimer*)timer;

@end

NS_ASSUME_NONNULL_END
