//
//  PomodoroTimer.m
//  Pomodoro
//
//  Created by Michał Nowak on 13/07/2021.
//

#import <Foundation/Foundation.h>
#import "PomodoroTimer.h"

@implementation PomodoroTimer

- (id)init {
  self = [super init];
  [self setup];
  return self;
}

- (void)setup {
  self.timeInterval = 1.0;
}

- (void)start:(unsigned int)seconds {
  self.initialSeconds = seconds;
  self.seconds = self.initialSeconds;

  self.timer = [NSTimer scheduledTimerWithTimeInterval: self.timeInterval
                                                target: self
                                              selector:@selector(tickHandle)
                                              userInfo: nil
                                               repeats:YES];
}

- (void)stop {
  [self.timer invalidate];
  self.timer = nil;
  self.seconds = self.initialSeconds;
  [self.delegate didUpdate:self];
}

- (void)tickHandle {
  if (self.seconds <= 0) {
    [self stop];
    return;
  }
  self.seconds -= 1;
  [self.delegate didUpdate:self];
}

- (NSString*)time {
  unsigned int h = self.seconds / 3600;
  unsigned int m = (self.seconds / 60) % 60;
  unsigned int s = self.seconds % 60;

  return [NSString stringWithFormat:@"%02d : %02d : %02d", h, m, s];
}

- (float)currentProgress {
  return ((float)self.initialSeconds - (float)self.seconds) / (float)self.initialSeconds;
}

@end
