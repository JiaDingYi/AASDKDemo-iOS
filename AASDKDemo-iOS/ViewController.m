//
//  ViewController.m
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/5/27.
//

#import "ViewController.h"
#import <AAManager/AAManager.h>
#import <Masonry/Masonry.h>
#import "AwardAlertForZombieController.h"
#import "RewardedInfoForZombieController.h"
#import "CountdownViewForZombie.h"

@interface ViewController () <AAManagerDelegate, AwardAlertInfoControllerDelegate, RewardedInfoControllerDelegate, CountdownViewDelegate>
// 暂不认证 实名认证控制器
@property (nonatomic) UIButton *realNameAuthButton;
// 退出游戏 实名认证控制器
@property (nonatomic) UIButton *realNameAuthButtonWithForceExit;
// 查看剩余时间
@property (nonatomic) UIButton *checkLeftTimeButton;
// 查看详情
@property (nonatomic) UIButton *checkDetailInfoButton;
// 消费限制
@property (nonatomic) UIButton *cashLimitedButton;
@property (nonatomic, assign) BOOL isPresentAlertInfo;
// 僵尸奖励挽留界面
@property (nonatomic) UIButton *awardAlertButton;
// 僵尸奖励后界面
@property (nonatomic) UIButton *rewardedButton;
@property (nonatomic) UITextView *console;
// 倒计时
@property (nonatomic) CountdownViewForZombie *countdownView;

@property (nonatomic) AAManager *aaManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAASDK];
    [self setUpUI];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 展示提示控制器
    if ([self.aaManager isLogined] && !self.isPresentAlertInfo) {
        if ([self.aaManager isAdult] == adult) {
            return;
        }
        [self.aaManager presentAlertInfoControllerWithRootViewController:self];
        self.isPresentAlertInfo = YES;
    }
}

- (void)initAASDK {
    self.aaManager = [AAManager shared];
    self.aaManager.delegate = self;
    [self addLog:[NSString stringWithFormat:@"游客登录状态: %d", self.aaManager.isLogined]];
    [self addLog:[NSString stringWithFormat:@"用户实名状态: %d", self.aaManager.isAuthenticated]];
}

- (void)setUpUI {
    CGFloat topMarigin = 48.0;
    CGFloat bottomMargin = 34.0;
    CGFloat margin = 10.0;
    
    self.realNameAuthButton = [[UIButton alloc] init];
    [self.realNameAuthButton addTarget:self action:@selector(realNameAuth) forControlEvents:UIControlEventTouchUpInside];
    self.realNameAuthButton.backgroundColor = [UIColor blackColor];
    self.realNameAuthButton.layer.cornerRadius = 8.0;
    self.realNameAuthButton.layer.masksToBounds = YES;
    [self.realNameAuthButton setTitle:@"展示暂不认证实名认证界面" forState:UIControlStateNormal];
    CGSize realNameSize = [self.realNameAuthButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.realNameAuthButton.titleLabel.font, NSFontAttributeName, nil]];
    [self.view addSubview:self.realNameAuthButton];
    [self.realNameAuthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(topMarigin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(realNameSize.width + 30);
        make.height.mas_greaterThanOrEqualTo(realNameSize.height);
    }];
    
    self.realNameAuthButtonWithForceExit = [[UIButton alloc] init];
    [self.realNameAuthButtonWithForceExit addTarget:self action:@selector(realNameAuthWithForceExit) forControlEvents:UIControlEventTouchUpInside];
    self.realNameAuthButtonWithForceExit.backgroundColor = [UIColor blackColor];
    self.realNameAuthButtonWithForceExit.layer.cornerRadius = 8.0;
    self.realNameAuthButtonWithForceExit.layer.masksToBounds = YES;
    [self.realNameAuthButtonWithForceExit setTitle:@"展示强制退出实名认证界面" forState:UIControlStateNormal];
    CGSize realNameWithForceExitSize = [self.realNameAuthButtonWithForceExit.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.realNameAuthButtonWithForceExit.titleLabel.font, NSFontAttributeName, nil]];
    [self.view addSubview:self.realNameAuthButtonWithForceExit];
    [self.realNameAuthButtonWithForceExit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.realNameAuthButton.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(realNameWithForceExitSize.width + 30);
        make.height.mas_greaterThanOrEqualTo(realNameWithForceExitSize.height);
    }];
    
    self.checkDetailInfoButton = [[UIButton alloc] init];
    [self.checkDetailInfoButton addTarget:self action:@selector(checkDetailInfo) forControlEvents:UIControlEventTouchUpInside];
    self.checkDetailInfoButton.backgroundColor = [UIColor blackColor];
    self.checkDetailInfoButton.layer.cornerRadius = 8.0;
    self.checkDetailInfoButton.layer.masksToBounds = YES;
    [self.checkDetailInfoButton setTitle:@"查看详情" forState:UIControlStateNormal];
    CGSize detailInfoSize = [self.checkDetailInfoButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.checkDetailInfoButton.titleLabel.font, NSFontAttributeName, nil]];
    [self.view addSubview:self.checkDetailInfoButton];
    [self.checkDetailInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.realNameAuthButtonWithForceExit.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(detailInfoSize.width + 30);
        make.height.mas_greaterThanOrEqualTo(detailInfoSize.height);
    }];
    
    self.cashLimitedButton = [[UIButton alloc] init];
    [self.cashLimitedButton addTarget:self action:@selector(presentCashLimitedController) forControlEvents:UIControlEventTouchUpInside];
    self.cashLimitedButton.backgroundColor = [UIColor blackColor];
    self.cashLimitedButton.layer.cornerRadius = 8.0;
    self.cashLimitedButton.layer.masksToBounds = YES;
    [self.cashLimitedButton setTitle:@"消费限制" forState:UIControlStateNormal];
    CGSize cashLimitedSize = [self.cashLimitedButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.cashLimitedButton.titleLabel.font, NSFontAttributeName, nil]];
    [self.view addSubview:self.cashLimitedButton];
    [self.cashLimitedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkDetailInfoButton.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(cashLimitedSize.width + 30);
        make.height.mas_greaterThanOrEqualTo(cashLimitedSize.height);
    }];
    
    self.checkLeftTimeButton = [[UIButton alloc] init];
    [self.checkLeftTimeButton addTarget:self action:@selector(checkLeftTime) forControlEvents:UIControlEventTouchUpInside];
    self.checkLeftTimeButton.backgroundColor = [UIColor blackColor];
    self.checkLeftTimeButton.layer.cornerRadius = 8.0;
    self.checkLeftTimeButton.layer.masksToBounds = YES;
    [self.checkLeftTimeButton setTitle:@"查询剩余时间" forState:UIControlStateNormal];
    CGSize checkLeftTimeSize = [self.checkLeftTimeButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.checkLeftTimeButton.titleLabel.font, NSFontAttributeName, nil]];
    [self.view addSubview:self.checkLeftTimeButton];
    [self.checkLeftTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cashLimitedButton.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(checkLeftTimeSize.width + 30);
        make.height.mas_greaterThanOrEqualTo(checkLeftTimeSize.height);
    }];
    
    self.awardAlertButton = [[UIButton alloc] init];
    [self.awardAlertButton addTarget:self action:@selector(presentAwardAlertControllerForZombie) forControlEvents:UIControlEventTouchUpInside];
    self.awardAlertButton.backgroundColor = [UIColor blackColor];
    self.awardAlertButton.layer.cornerRadius = 8.0;
    self.awardAlertButton.layer.masksToBounds = YES;
    [self.awardAlertButton setTitle:@"展示僵尸奖励提示界面" forState:UIControlStateNormal];
    CGSize awardSize = [self.awardAlertButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.awardAlertButton.titleLabel.font, NSFontAttributeName, nil]];
    [self.view addSubview:self.awardAlertButton];
    [self.awardAlertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkLeftTimeButton.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(awardSize.width + 30);
        make.height.mas_greaterThanOrEqualTo(awardSize.height);
    }];
    
    self.rewardedButton = [[UIButton alloc] init];
    [self.rewardedButton addTarget:self action:@selector(presentRewardedControllerForZombie) forControlEvents:UIControlEventTouchUpInside];
    self.rewardedButton.backgroundColor = [UIColor blackColor];
    self.rewardedButton.layer.cornerRadius = 8.0;
    self.rewardedButton.layer.masksToBounds = YES;
    [self.rewardedButton setTitle:@"展示僵尸奖励后界面" forState:UIControlStateNormal];
    CGSize rewardedSize = [self.rewardedButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.rewardedButton.titleLabel.font, NSFontAttributeName, nil]];
    [self.view addSubview:self.rewardedButton];
    [self.rewardedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.awardAlertButton.mas_bottom).with.offset(margin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(rewardedSize.width + 30);
        make.height.mas_greaterThanOrEqualTo(rewardedSize.height);
    }];
    
    if ([self.aaManager isAdult] != adult && [self.aaManager isLogined]) {
        [self addCountdownView];
        return;
    }
    
    self.console = [[UITextView alloc] init];
    self.console.backgroundColor = [UIColor grayColor];
    self.console.editable = NO;
    [self.view addSubview:self.console];
    [self.console mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rewardedButton.mas_bottom).with.offset(margin);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.8);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-bottomMargin);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)addCountdownView {
    CGFloat margin = 10.0;
    CGFloat bottomMargin = 34.0;
    self.countdownView = [[CountdownViewForZombie alloc] init];
    self.countdownView.delegate = self;
    [self.view addSubview:self.countdownView];
    [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(0.7);
        make.height.mas_equalTo(30.0);
        make.top.equalTo(self.rewardedButton.mas_bottom).offset(margin);
        make.centerX.equalTo(self.view);
    }];
    
    [self.console removeFromSuperview];
    self.console = nil;
    self.console = [[UITextView alloc] init];
    self.console.backgroundColor = [UIColor grayColor];
    self.console.editable = NO;
    [self.view addSubview:self.console];
    [self.console mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countdownView.mas_bottom).with.offset(margin);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.8);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-bottomMargin);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)removeCountdownView {
    CGFloat margin = 10.0;
    CGFloat bottomMargin = 34.0;
    [self.countdownView removeFromSuperview];
    self.countdownView = nil;
    
    self.console = [[UITextView alloc] init];
    self.console.backgroundColor = [UIColor grayColor];
    self.console.editable = NO;
    [self.view addSubview:self.console];
    [self.console mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rewardedButton.mas_bottom).with.offset(margin);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.8);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-bottomMargin);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)addLog:(NSString *)newLog {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.console.layoutManager.allowsNonContiguousLayout = NO;
        NSString *oldLog = weakSelf.console.text;
        NSString *text = [NSString stringWithFormat:@"%@\n%@", oldLog, newLog];
        if (oldLog.length == 0) {
            text = [NSString stringWithFormat:@"%@", newLog];
        }
        [weakSelf.console scrollRangeToVisible:NSMakeRange(text.length, 1)];
        weakSelf.console.text = text;
    });
}

- (void)realNameAuth {
    if (![self.aaManager isLogined]) {
        [self addLog:@"请检查网络状态，并游客登录"];
        return;
    }
    if ([self.aaManager isAuthenticated]) {
        [self addLog:@"您已实名认证，无需再次认证"];
        return;
    }
    [self.aaManager presentRealNameAuthenticationControllerWithRootViewController:self];
}

- (void)realNameAuthWithForceExit {
    if (![self.aaManager isLogined]) {
        [self addLog:@"请检查网络状态，并游客登录"];
        return;
    }
    if ([self.aaManager isAuthenticated]) {
        [self addLog:@"您已实名认证，无需再次认证"];
        return;
    }
    [self.aaManager presentForceExitRealNameAuthControllerWithRootViewController:self];
}

- (void)checkDetailInfo {
    [self.aaManager presentDetailInfoControllerWithRootViewController:self];
}

- (void)presentCashLimitedController {
    if ([self.aaManager isAdult] == adult) {
        [self addLog:@"成年人无消费限制"];
        return;
    }
    [self.aaManager presentCashLimitedControllerWith:self];
}

- (void)checkLeftTime {
    int leftTime = [self.aaManager leftTimeOfCurrentUser];
    if (leftTime < 0) {
        [self addLog:[NSString stringWithFormat:@"成年用户无限制时长"]];
        return;
    }
    [self addLog:[NSString stringWithFormat:@"当前用户剩余时长：%.2f 分钟", (leftTime / 60.0)]];
}

- (void)presentAwardAlertControllerForZombie {
    AwardAlertForZombieController *awardAlertController = [[AwardAlertForZombieController alloc] init];
    awardAlertController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    awardAlertController.delegate = self;
    [self presentViewController:awardAlertController animated:NO completion:nil];
}

- (void)presentRewardedControllerForZombie {
    RewardedInfoForZombieController *rewardedController = [[RewardedInfoForZombieController alloc] init];
    rewardedController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    rewardedController.delegate = self;
    [self presentViewController:rewardedController animated:NO completion:nil];
}

#pragma mark - delegate
// 游客登录结果
// touristsID 有值则为登录成功，否则登录失败
- (void)touristsModeLoginResult:(nullable NSString *)touristsID {
    if (touristsID.length) {
        [self addLog:[NSString stringWithFormat:@"游客登录成功，游客ID: %@", touristsID]];
        [self.aaManager presentAlertInfoControllerWithRootViewController:self];
        self.isPresentAlertInfo = YES;
        if ([self.aaManager isLogined] && [self.aaManager isAdult] != adult) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addCountdownView];
            });
            return;
        }
    } else {
        [self addLog:[NSString stringWithFormat:@"游客登录失败"]];
    }
}

/// 实名认证成功
- (void)realNameAuthSuccess {
    [self addLog:[NSString stringWithFormat:@"用户实名认证成功"]];
    [self.aaManager resumeTimer];
}

/// 用户在实名认证界面点击暂不认证
- (void)clickTempLeaveButtonOnRealNameAuthController {
    [self addLog:[NSString stringWithFormat:@"用户点击暂不认证"]];
}

/// 用户在实名认证界面点击退出游戏
- (void)clickForceExitButtonOnRealNameAuthController {
    [self addLog:[NSString stringWithFormat:@"用户点击退出游戏"]];
    UIAlertController *alert = [[UIAlertController alloc] init];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.aaManager presentForceExitRealNameAuthControllerWithRootViewController:self];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

// 游客时长已用尽(1h/15 days)
// 收到此回调后，会展示实名认证界面
- (UIViewController *)noTimeLeftWithTouristsMode {
    [self addLog:[NSString stringWithFormat:@"游客时长已用尽，将展示实名认证界面"]];
    return self;
}

// 未成年时长已用尽(2h/1 day)
// 收到此回调后，会展示未成年时长已用尽弹窗
- (UIViewController *)noTimeLeftWithNonageMode {
    [self addLog:[NSString stringWithFormat:@"未成年时长已用尽，将展示 Alert View"]];
    return self;
}

- (void)currentUserInfo:(int)leftTime isAuthenticated:(BOOL)isAuth ageGroup:(AAAgeGroup)ageGroup {
    [self addLog:[NSString stringWithFormat:@"----------\n剩余时间 %d\n认证状态 %d\n是否成年 %lu\n----------", leftTime, isAuth, (unsigned long)ageGroup]];
    if (isAuth && self.countdownView.superview) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.countdownView updateAuthedUI];
        });
    }
    if (ageGroup == adult && self.countdownView.superview) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeCountdownView];
        });
    }
    if (self.countdownView.superview) {
        self.countdownView.countdown = leftTime;
    }
}

#pragma mark - AwardAlertInfoControllerDelegate
- (void)userClickLeaveButton {
    NSLog(@"userClickLeaveButton");
}
- (void)userClickAuthButton {
    NSLog(@"userClickAuthButton");
}

#pragma mark - RewardedInfoControllerDelegate
- (void)userClickReceivedButton {
    NSLog(@"userClickAuthButton");
}

#pragma mark - CountdownViewDelegate
- (void)userClickAuthButtonInCountdownView {
    [self.aaManager presentRealNameAuthenticationControllerWithRootViewController:self];
}

- (void)userClickCheckDetailInfoButtonInCountdownView {
    [self.aaManager presentDetailInfoControllerWithRootViewController:self];
}

@end
