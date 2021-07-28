//
//  PomodoroTimerParameters.h
//  Pomodoro
//
//  Created by Michał Nowak on 28/07/2021.
//

#ifndef PomodoroTimerParameters_h
#define PomodoroTimerParameters_h

#import <Foundation/Foundation.h>

typedef struct PomodoroTimerParameters {
  unsigned int intervals;
  
  unsigned int taskSeconds;

  unsigned int breakoutSeconds;

  unsigned int longBreakoutSeconds;
} PomodoroTimerParameters;

#endif /* PomodoroTimerParameters_h */
