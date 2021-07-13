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
  [self.pomodoroTimer start];
}

- (void)didFinishTickPeriod:(id)sender {
  self.label.text = [sender time];
}

@end
