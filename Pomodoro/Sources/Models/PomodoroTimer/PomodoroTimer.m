//
//  PomodoroTimer.m
//  Pomodoro
//
//  Created by Michał Nowak on 13/07/2021.
//

#import <Foundation/Foundation.h>
#import "PomodoroTimer.h"

@implementation PomodoroTimer

- (id)init:(struct PomodoroTimerParameters)parameters {
  self = [super init];
  self.parameters = parameters;
  [self setup];
  return self;
}

- (void)setup {
  self.state = task;
  self.timeInterval = 1.0;
  self.currentInterval = 0;
  [self setSeconds];
}

- (void)start {
  self.timer = nil;
  self.timer = [NSTimer scheduledTimerWithTimeInterval: self.timeInterval
                                                target: self
                                              selector: @selector(tickHandle)
                                              userInfo: nil
                                               repeats: YES];
  [self setSeconds];
}

- (void)setParameters:(struct PomodoroTimerParameters)parameters {
  _parameters = parameters;
  [self setup];
  [self.delegate didUpdate:self];
}

- (void)setSeconds {
  switch (self.state) {
    case task:
      self.seconds = self.parameters.taskSeconds;
      break;
    case breakout:
      self.seconds = self.parameters.breakoutSeconds;
      break;
    case longBreakout:
      self.seconds = self.parameters.longBreakoutSeconds;
      break;
  }

  self.currentSeconds = self.seconds;
}

- (void)stop {
  [self.timer invalidate];
  [self setSeconds];
  [self.delegate didUpdate:self];
}

- (void)reset {
  self.currentInterval = 0;
}

- (void)tickHandle {
  if (self.currentSeconds <= 0) {
    [self changeState];
    [self handleState];
    [self setSeconds];
    [self stop];
    [self.delegate didEnd:self];
    self.currentInterval += 1;
    return;
  }
  self.currentSeconds -= 1;
  [self.delegate didUpdate:self];
}

- (void)changeState {
  if (self.checkLongBreakout) {
    self.state = longBreakout;
  } else if (self.checkBreakout) {
    self.state = breakout;
  } else {
    self.state = task;
  }
}

- (void)handleState {
  switch (self.state) {
    case task:
      break;
    case breakout:
      break;
    case longBreakout:
      [self reset];
      break;
  }

  [self.delegate PomodoroTimer:self withState:self.state];
}

- (bool)checkBreakout {
  if ((self.currentInterval + 1) % 2 != 0) {
    return true;
  }
  return false;
}

- (bool)checkLongBreakout {
  if (self.currentInterval == (self.parameters.intervals) * 2) {
    return true;
  }
  return false;
}

- (NSString*)time {
  if (self.currentSeconds < 0) {
    return [NSString stringWithFormat:@"%02d : %02d : %02d", 0, 0, 0];
  }

  unsigned int h = self.currentSeconds / 3600;
  unsigned int m = (self.currentSeconds / 60) % 60;
  unsigned int s = self.currentSeconds % 60;

  return [NSString stringWithFormat:@"%02d : %02d : %02d", h, m, s];
}

- (float)currentProgress {
  return ((float)self.seconds - (float)self.currentSeconds) / (float)self.seconds;
}

@end
