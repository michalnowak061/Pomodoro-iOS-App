//
//  PomodoroTimer.h
//  Pomodoro
//
//  Created by Michał Nowak on 13/07/2021.
//

#ifndef PomodoroTimer_h
#define PomodoroTimer_h

#import <Foundation/Foundation.h>
#import "PomodoroTimerDelegate.h"
#import "Time.h"

@interface PomodoroTimer : NSObject

@property (nonatomic, weak) id <PomodoroTimerDelegate> delegate;

@property NSTimeInterval timeInterval;

@property NSTimer *timer;

@property unsigned int seconds;

- (void)start;

- (void)stop;

- (NSString*)time;

@end

#endif /* PomodoroTimer_h */
