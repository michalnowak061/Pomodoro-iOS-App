//
//  PomodoroTimer.h
//  Pomodoro
//
//  Created by Michał Nowak on 13/07/2021.
//

#ifndef PomodoroTimer_h
#define PomodoroTimer_h

#import <Foundation/Foundation.h>
#import "PomodoroTimerParameters.h"
#import "PomodoroTimerState.h"
#import "PomodoroTimerDelegate.h"

@interface PomodoroTimer : NSObject

@property (nonatomic, weak) id <PomodoroTimerDelegate> delegate;

@property struct PomodoroTimerParameters parameters;

@property PomodoroTimerState state;

@property NSTimeInterval timeInterval;

@property NSTimer *timer;

@property unsigned int seconds;

@property unsigned int currentSeconds;

@property unsigned int currentInterval;

- (id)init:(struct PomodoroTimerParameters)parameters;

- (NSString*)time;

- (void)start;

- (void)stop;

- (void)reset;

- (void)tickHandle;

- (void)setSeconds;

- (float)currentProgress;

- (void)changeState;

- (void)handleState;

- (bool)checkBreakout;

- (bool)checkLongBreakout;

@end

#endif /* PomodoroTimer_h */
