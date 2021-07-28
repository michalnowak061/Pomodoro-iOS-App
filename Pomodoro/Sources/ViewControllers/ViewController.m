//
//  ViewController.m
//  Pomodoro
//
//  Created by Michał Nowak on 13/07/2021.
//

#import "ViewController.h"

// MARK: - Interface
@interface ViewController () <PomodoroTimerDelegate>

@property PomodoroTimer *pomodoroTimer;

@property ViewControllerState state;

@property (weak, nonatomic) IBOutlet UILabel *stateNameLabel;

@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

// MARK: - Implementation
@implementation ViewController
// MARK: - Override function's
- (void)loadView {
  [super loadView];
  [self setup];
}

- (void)setup {
  self.state = init;

  [self setupTimer];
  [self setupStateNameLabel];
  [self setupTimeLabelAndProgressBar];
  [self setupButton];
}

- (void)setupTimer {
  PomodoroTimerParameters parameters;
  parameters.intervals = 2;
  parameters.taskSeconds = 1200;
  parameters.breakoutSeconds = 2;
  parameters.longBreakoutSeconds = 3;

  self.pomodoroTimer = [[PomodoroTimer alloc] init:parameters];
  self.pomodoroTimer.delegate = self;
}

- (void)setupStateNameLabel {
  switch (self.pomodoroTimer.state) {
    case task:
      self.stateNameLabel.text = @"Task";
      break;
    case breakout:
      self.stateNameLabel.text = @"Breakout";
      break;
    case longBreakout:
      self.stateNameLabel.text = @"Long breakout";
      break;
  }
}

- (void)setupTimeLabelAndProgressBar {
  NSString *actualTime = [self.pomodoroTimer time];
  float progress = [self.pomodoroTimer currentProgress];

  [UIView animateWithDuration:0.5 animations:^{
    self.progressBar.value = progress;
  }];

  self.timeLabel.text = actualTime;
}

- (void)setupButton {
  [self.button setTitle:@"Start" forState:normal];
  self.button.layer.masksToBounds = NO;
  self.button.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
  self.button.layer.shadowColor = UIColor.blackColor.CGColor;
  self.button.layer.shadowRadius = 2;
  self.button.layer.shadowOpacity = 0.5;
  self.button.layer.cornerRadius = 10;
}

// MARK: - IBAction's
- (IBAction)buttonTouchUpInside:(UIButton *)sender {
  switch (self.state) {
    case init:
      [self.pomodoroTimer start];
      [self.button setTitle:@"Stop" forState:normal];
      self.state = counting;
      break;
    case counting:
      [self.pomodoroTimer stop];
      [self.button setTitle:@"Start" forState:normal];
      self.state = init;
      break;
    case brakeout:
      break;
    case longBrakeout:
      break;
  }
}

- (void)didUpdate:(id)sender {
  [self setupTimeLabelAndProgressBar];
}

- (void)didEnd:(id)sender {
  self.state = init;
  [self.button setTitle:@"Start" forState:normal];
}

- (void)PomodoroTimer:(id)sender withState:(PomodoroTimerState)state {
  [self setupStateNameLabel];
}

@end
