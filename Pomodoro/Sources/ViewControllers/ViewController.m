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

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (assign, nonatomic) SystemSoundID systemSoundID;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

// MARK: - Implementation
@implementation ViewController

// MARK: - Function's
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
  [self setupSettingsButton];
}

- (void)setupTimer {
  PomodoroTimerParameters parameters;
  parameters.taskSeconds = 900;
  parameters.breakoutSeconds = 300;
  parameters.longBreakoutSeconds = 1200;
  parameters.intervals = 4;

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

- (void)setupSettingsButton {
  self.settingsButton.layer.masksToBounds = NO;
  self.settingsButton.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
  self.settingsButton.layer.shadowColor = UIColor.blackColor.CGColor;
  self.settingsButton.layer.shadowRadius = 2;
  self.settingsButton.layer.shadowOpacity = 0.5;
  self.settingsButton.layer.cornerRadius = self.settingsButton.frame.size.height / 2;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"showSettingsVC"]) {
    SettingsViewController *viewController = [segue destinationViewController];
    [viewController setRequiredData:self.pomodoroTimer];

    if (self.state == counting) {
      [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
  }
}

- (void)playAlarmSound {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"];
  NSURL *url = [NSURL fileURLWithPath:path];

  self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
  self.audioPlayer.numberOfLoops = -1;

  [self.audioPlayer play];
}

- (void)stopAlarmSound {
  [self.audioPlayer stop];
}

- (void)showAlert {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alarm" message:@"Time out!" preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self stopAlarmSound];
  }];

  [alert addAction:ok];
  [self presentViewController:alert animated:YES completion:nil];
}

// MARK: - PomodoroTimerDelegate function's
- (void)didUpdate:(id)sender {
  [self setupTimeLabelAndProgressBar];
}

- (void)didEnd:(id)sender {
  self.state = init;
  [self.button setTitle:@"Start" forState:normal];
  [self playAlarmSound];
  [self showAlert];
}

- (void)PomodoroTimer:(id)sender withState:(PomodoroTimerState)state {
  [self setupStateNameLabel];
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

@end
