//
//  PomodoroTimerDelegate.h
//  Pomodoro
//
//  Created by Michał Nowak on 13/07/2021.
//

#ifndef PomodoroTimerDelegate_h
#define PomodoroTimerDelegate_h

@protocol PomodoroTimerDelegate
- (void)didUpdate:(id) sender;

- (void)didEnd:(id) sender;

- (void)PomodoroTimer:(id) sender withState:(PomodoroTimerState) state;
@end

#endif /* PomodoroTimerDelegate_h */
