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

@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBar;

@property (weak, nonatomic) IBOutlet UILabel *label;

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
  self.pomodoroTimer = [[PomodoroTimer alloc] init];
  self.pomodoroTimer.delegate = self;
  self.state = init;
  
  [self setupButton];
}

- (void)setupButton {
  [self.button setTitle:@"Start" forState:normal];
}

// MARK: - IBAction's
- (IBAction)buttonTouchUpInside:(UIButton *)sender {
  switch (self.state) {
    case init:
      [self.pomodoroTimer start:120];
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
  NSString *actualTime = [sender time];
  float progress = [sender currentProgress];

  [UIView animateWithDuration:0.5 animations:^{
    self.progressBar.value = progress;
  }];

  self.label.text = actualTime;
}

@end
