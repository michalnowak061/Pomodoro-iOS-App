//
//  PomodoroTimerTests.m
//  PomodoroTests
//
//  Created by Michał Nowak on 27/07/2021.
//

#import <XCTest/XCTest.h>
#import "PomodoroTimer.h"

@interface PomodoroTimerTests : XCTestCase

@property PomodoroTimer *sut;

@property unsigned int intervals;

@property unsigned int taskSeconds;

@property unsigned int breakoutSeconds;

@property unsigned int longBreakoutSeconds;

@end

@implementation PomodoroTimerTests

- (void)setUp {
  self.intervals = 2;
  self.taskSeconds = 1;
  self.breakoutSeconds = 2;
  self.longBreakoutSeconds = 3;

  PomodoroTimerParameters parameters;
  parameters.intervals = self.intervals;
  parameters.taskSeconds = self.taskSeconds;
  parameters.breakoutSeconds = self.breakoutSeconds;
  parameters.longBreakoutSeconds = self.longBreakoutSeconds;

  self.sut = [[PomodoroTimer alloc] init:parameters];
}

- (void)tearDown {
  self.sut = nil;
}

- (void)testInit {
  XCTAssertEqual(self.sut.parameters.intervals, self.intervals);
  XCTAssertEqual(self.sut.parameters.taskSeconds, self.taskSeconds);
  XCTAssertEqual(self.sut.parameters.breakoutSeconds, self.breakoutSeconds);
  XCTAssertEqual(self.sut.parameters.longBreakoutSeconds, self.longBreakoutSeconds);
}

- (void)testSetup {
  XCTAssertEqual(self.sut.state, task);
  XCTAssertEqual(self.sut.timeInterval, 1);
  XCTAssertEqual(self.sut.currentInterval, 0);
  XCTAssertEqual(self.sut.seconds, self.sut.parameters.taskSeconds);
}

- (void)testStart {
  [self.sut start];
  XCTAssertNotNil(self.sut.timer);
  XCTAssertTrue(self.sut.timer.isValid);
}

- (void)testSetSeconds {
  self.sut.state = task;
  [self.sut setSeconds];
  XCTAssertEqual(self.sut.seconds, self.sut.parameters.taskSeconds);
  XCTAssertEqual(self.sut.currentSeconds, self.sut.seconds);

  self.sut.state = breakout;
  [self.sut setSeconds];
  XCTAssertEqual(self.sut.seconds, self.sut.parameters.breakoutSeconds);
  XCTAssertEqual(self.sut.currentSeconds, self.sut.seconds);

  self.sut.state = longBreakout;
  [self.sut setSeconds];
  XCTAssertEqual(self.sut.seconds, self.sut.parameters.longBreakoutSeconds);
  XCTAssertEqual(self.sut.currentSeconds, self.sut.seconds);
}

- (void)testStop {
  [self.sut start];
  XCTAssertTrue(self.sut.timer.isValid);
  [self.sut stop];
  XCTAssertFalse(self.sut.timer.isValid);
}

- (void)testReset {
  [self.sut reset];
  XCTAssertEqual(self.sut.currentInterval, 0);
}

- (void)testTickHandle {
  unsigned int interval = self.sut.currentInterval;

  self.sut.currentSeconds = 0;
  [self.sut tickHandle];
  XCTAssertEqual(self.sut.currentInterval, interval + 1);

  unsigned int seconds = self.sut.currentSeconds;

  [self.sut tickHandle];
  XCTAssertEqual(self.sut.currentInterval, seconds - 1);
}

- (void)testChangeState {
  self.sut.currentInterval = 0;
  [self.sut changeState];
  XCTAssertEqual(self.sut.state, breakout);

  self.sut.currentInterval = self.intervals - 1;
  [self.sut changeState];
  XCTAssertEqual(self.sut.state, task);

  self.sut.currentInterval = (self.intervals * 2);
  [self.sut changeState];
  XCTAssertEqual(self.sut.state, longBreakout);
}

- (void)testCheckBreakout {
  self.sut.currentInterval = 0;
  XCTAssertTrue([self.sut checkBreakout]);

  self.sut.currentInterval = 1;
  XCTAssertFalse([self.sut checkBreakout]);

  self.sut.currentInterval = 2;
  XCTAssertTrue([self.sut checkBreakout]);

  self.sut.currentInterval = 3;
  XCTAssertFalse([self.sut checkBreakout]);

  self.sut.currentInterval = 4;
  XCTAssertTrue([self.sut checkBreakout]);
}

- (void)testCheckLongBreakout {
  self.sut.currentInterval = self.intervals * 2;
  XCTAssertTrue([self.sut checkLongBreakout]);

  self.sut.currentInterval = 0;
  XCTAssertFalse([self.sut checkLongBreakout]);

  self.sut.currentInterval = 1;
  XCTAssertFalse([self.sut checkLongBreakout]);
}

- (void)testTime {
  self.sut.currentSeconds = 0;
  XCTAssertTrue([self.sut.time isEqual:@"00 : 00 : 00"]);

  self.sut.currentSeconds = 120;
  XCTAssertTrue([self.sut.time isEqual:@"00 : 02 : 00"]);

  self.sut.currentSeconds = 1200;
  XCTAssertTrue([self.sut.time isEqual:@"00 : 20 : 00"]);

  self.sut.currentSeconds = 43200;
  XCTAssertTrue([self.sut.time isEqual:@"12 : 00 : 00"]);

  self.sut.currentSeconds = 43932;
  XCTAssertTrue([self.sut.time isEqual:@"12 : 12 : 12"]);
}

- (void)testCurrentProgress {
  self.sut.seconds = 60;

  self.sut.currentSeconds = 0;
  XCTAssertEqual(self.sut.currentProgress, 1);

  self.sut.currentSeconds = 30;
  XCTAssertEqual(self.sut.currentProgress, 0.5);

  self.sut.currentSeconds = self.sut.seconds;
  XCTAssertEqual(self.sut.currentProgress, 0);
}

@end
