//
//  SettingsViewController.m
//  Pomodoro
//
//  Created by Michał Nowak on 29/07/2021.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property PomodoroTimer *pomodoroTimer;

@property (weak, nonatomic) IBOutlet UIDatePicker *taskTimePicker;

@property (weak, nonatomic) IBOutlet UIDatePicker *breakoutTimePicker;

@property (weak, nonatomic) IBOutlet UIDatePicker *longBreakoutPicker;

@property (weak, nonatomic) IBOutlet UIStepper *intervalsStepper;

@property (weak, nonatomic) IBOutlet UILabel *intervalsLabel;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *views;

@end

@implementation SettingsViewController

- (void)loadView {
  [super loadView];
  [self setup];
}

- (void)setup {
  [self.taskTimePicker setCountDownDuration:self.pomodoroTimer.parameters.taskSeconds];
  [self.breakoutTimePicker setCountDownDuration:self.pomodoroTimer.parameters.breakoutSeconds];
  [self.longBreakoutPicker setCountDownDuration:self.pomodoroTimer.parameters.longBreakoutSeconds];
  [self.intervalsStepper setValue:self.pomodoroTimer.parameters.intervals];

  NSString *intervalsString = [NSString stringWithFormat:@"%d", self.pomodoroTimer.parameters.intervals];

  [self.intervalsLabel setText: intervalsString];

  [self setupViews];
}

- (void)setupViews {
  for (int i = 0; i < self.views.count; ++i) {
    UIView *view = self.views[i];
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    view.layer.shadowColor = UIColor.blackColor.CGColor;
    view.layer.shadowRadius = 2;
    view.layer.shadowOpacity = 0.5;
    view.layer.cornerRadius = 10;
  }
}

- (void)setRequiredData:(PomodoroTimer*)timer {
  self.pomodoroTimer = timer;
}

- (IBAction)taskTimeDidChange:(UIDatePicker *)sender {
  int seconds = (int)sender.countDownDuration;
  PomodoroTimerParameters parameters = self.pomodoroTimer.parameters;
  parameters.taskSeconds = seconds;

  self.pomodoroTimer.parameters = parameters;
}

- (IBAction)breakoutTimeDidCHange:(UIDatePicker *)sender {
  int seconds = (int)sender.countDownDuration;
  PomodoroTimerParameters parameters = self.pomodoroTimer.parameters;
  parameters.breakoutSeconds = seconds;

  self.pomodoroTimer.parameters = parameters;
}

- (IBAction)longBreakoutTimeDidChange:(UIDatePicker *)sender {
  int seconds = (int)sender.countDownDuration;
  PomodoroTimerParameters parameters = self.pomodoroTimer.parameters;
  parameters.longBreakoutSeconds = seconds;

  self.pomodoroTimer.parameters = parameters;
}

- (IBAction)intervalsValueDidChange:(UIStepper *)sender {
  int intervals = sender.value;
  NSString *intervalsString = [NSString stringWithFormat:@"%d", intervals];

  [self.intervalsLabel setText: intervalsString];

  PomodoroTimerParameters parameters = self.pomodoroTimer.parameters;
  parameters.intervals = intervals;

  self.pomodoroTimer.parameters = parameters;
}

@end
