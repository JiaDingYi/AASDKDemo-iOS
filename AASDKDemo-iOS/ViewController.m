//
//  ViewController.m
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/5/27.
//

#import "ViewController.h"
#import <AAManager/AAManager.h>
#import <Masonry/Masonry.h>

@interface ViewController () <AAManagerDelegate>
@property (nonatomic) UIButton *realNameAuthButton;
@property (nonatomic) UIButton *checkLeftTimeButton;
@property (nonatomic) UITextView *console;

@property (nonatomic) AAManager *aaManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setUpUI];
    [self initAASDK];
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
    
    self.realNameAuthButton = [[UIButton alloc] init];
    [self.realNameAuthButton addTarget:self action:@selector(realNameAuth) forControlEvents:UIControlEventTouchUpInside];
    self.realNameAuthButton.backgroundColor = [UIColor blackColor];
    self.realNameAuthButton.layer.cornerRadius = 8.0;
    self.realNameAuthButton.layer.masksToBounds = YES;
    [self.realNameAuthButton setTitle:@"实名认证" forState:UIControlStateNormal];
    CGSize realNameSize = [self.realNameAuthButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.realNameAuthButton.titleLabel.font, NSFontAttributeName, nil]];
    [self.view addSubview:self.realNameAuthButton];
    [self.realNameAuthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(topMarigin);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(realNameSize.width + 30);
        make.height.mas_greaterThanOrEqualTo(realNameSize.height);
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
        make.top.equalTo(self.realNameAuthButton.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(checkLeftTimeSize.width + 30);
        make.height.mas_greaterThanOrEqualTo(checkLeftTimeSize.height);
    }];
    
    self.console = [[UITextView alloc] init];
    self.console.backgroundColor = [UIColor grayColor];
    self.console.editable = NO;
    [self.view addSubview:self.console];
    [self.console mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkLeftTimeButton.mas_bottom).with.offset(20);
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
    [self.aaManager presentRealNameAuthenticationController];
}

- (void)checkLeftTime {
    int leftTime = [self.aaManager leftTimeOfCurrentUser];
    if (leftTime < 0) {
        [self addLog:[NSString stringWithFormat:@"成年用户无限制时长"]];
        return;
    }
    [self addLog:[NSString stringWithFormat:@"当前用户剩余时长：%.2f 分钟", (leftTime / 60.0)]];
}

#pragma mark - delegate
// 游客登录结果
// touristsID 有值则为登录成功，否则登录失败
- (void)touristsModeLoginResult:(nullable NSString *)touristsID {
    if (touristsID.length) {
        [self addLog:[NSString stringWithFormat:@"游客登录成功，游客ID: %@", touristsID]];
    } else {
        [self addLog:[NSString stringWithFormat:@"游客登录失败"]];
    }
}

// 实名认证结果
- (void)realNameAuthenticateResult:(bool)success {
    if (success) {
        [self addLog:[NSString stringWithFormat:@"用户实名认证成功"]];
    } else {
        [self addLog:[NSString stringWithFormat:@"用户实名认证失败"]];
    }
}

// 游客时长已用尽(1h/15 days)
// 收到此回调 3s 后，会展示实名认证界面
// 游戏请在收到回调 3s 内处理未尽事宜
- (void)noTimeLeftWithTouristsMode {
    [self addLog:[NSString stringWithFormat:@"游客时长已用尽，3s 后展示实名认证界面"]];
}

// 未成年时长已用尽(2h/1 day)
// 收到此回调 3s 后，会展示未成年时长已用尽弹窗
// 游戏请在收到回调 3s 内处理未尽事宜
- (void)noTimeLeftWithNonageMode {
    [self addLog:[NSString stringWithFormat:@"未成年时长已用尽，3s 后展示 Alert View"]];
}


@end
