
[See English Guide](https://github.com/yumimobi/AASDKDemo-iOS/blob/main/Anti-Addiction-iOS.md)

[toc]

# 入门指南
本指南适用于希望通过 AAManager SDK 接入防沉迷功能的发布商。
# 前提条件
- 使用 Xcode 10.0 或更高版本
- 使用 iOS 9.0 或更高版本
- 在 info.plist 中添加如下ID，具体值请联系产品经理获取。
  ```xml
  <key>zgameid</key>
  <string>your game id</string>
  <key>zchannelid</key>
  <string>your channel id</string>
  ```
- [获取 demo](https://github.com/yumimobi/AASDKDemo-iOS) 
# 导入防沉迷 SDK
1. CocoaPods （首选）
   
   要将该 SDK 导入 iOS 项目，最简便的方法就是使用 [CocoaPods](https://guides.cocoapods.org/using/getting-started)。
   
   ```ruby
   pod 'AAManager', '~> 0.4.1'
   ```
   然后使用命令行运行
   ```shell
   pod install
   ```
   如果您刚开始接触 CocoaPods，请参阅其[官方文档](https://guides.cocoapods.org/using/using-cocoapods)，了解如何创建和使用 Podfile。
# 快速接入
1. SDK 初始化
   在用户同意隐私政策之后进行 SDK 初始化。
   SDK 初始化后，开始计时。
   ```objective-c
   #import <AAManager/AAManager.h>
   @interface AAViewController () <AAManagerDelegate>
   @property (nonatomic) AAManager *aaManager;
   
   @end
   
   @implementation AAViewController
   - (void)initAASDK {
    self.aaManager = [AAManager shared];
    self.aaManager.delegate = self;
   }
   @end
   ```
2. 查询用户是否已经游客登录
   游客登录将在 SDK 初始化后，由 SDK 内部实现。
   如因网络等原因造成游客登录失败，SDK 将默认在 1 小时后弹出实名认证界面。
   ```objective-c
   if ([self.aaManager isLogined]) {
        // do something
   }
   ```
3. 判断用户是否已经实名认证
   ```objective-c
   if ([self.aaManager isAuthenticated]) {
        // do something
    }
   ```
4. 判断用户年龄状态
   ```objective-c
   typedef enum: NSUInteger {
    // 未认证
    unknown,
    // 成年
    adult,
    // 未成年
    nonage,
   }AAAgeGroup;

   // 成年人
   if ([self.aaManager isAdult] == adult) {
      // do someting
   }
   // 未成年人
   if ([self.aaManager isAdult] == nonage) {
      // do someting
   }
   // 未认证
   if ([self.aaManager isAdult] == unknown) {
      // do someting
   }
   ```
5. 每次进入游戏时，展示在线时长提示界面
   此界面由游戏在初始化时调用。
   需判断SDK已登录，如SDK未登录，则在SDK登录成功的回调中调用。
   成年人无需展示此界面。
   ```objective-c
   // 展示提示控制器
    if ([self.aaManager isLogined]) {
        if ([self.aaManager isAdult] == adult) {
            return;
        }
        [self.aaManager presentAlertInfoControllerWithRootViewController:self];
    }
   ```
   在登录成功的回调中调用
   ```objective-c
   // 游客登录结果
   // touristsID 有值则为登录成功，否则登录失败
   - (void)touristsModeLoginResult:(nullable NSString *)touristsID {
       if (touristsID.length) {
         [self.aaManager presentAlertInfoControllerWithRootViewController:self];
       }
   }
   ```

6. 展示实名认证界面（用户可点击暂不认证）
   ```objective-c
   - (void)realNameAuth {
    if (![self.aaManager isLogined]) {
        return;
    }
    if ([self.aaManager isAuthenticated]) {
        return;
    }
    [self.aaManager presentRealNameAuthenticationControllerWithRootViewController:self];
   }
   ```
7. 展示实名认证界面（用户可点击退出游戏）
   使用场景：
   如果用户点击退出游戏，开发者需要在`- (void)clickForceExitButtonOnRealNameAuthController;`此回调中展示实名认证获取奖励界面（此界面由开发者自己实现），此界面提供两个交互按钮。
   退出游戏按钮：点击此按钮退出游戏。
   实名认证按钮：点击此按钮再次展示SDK提供的实名认证界面。
   *warning： 此时计时器暂停，开发者需要在认证成功回调中重启计时器`- (void)resumeTimer;`*
   ```objective-c
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
   ```
8. 查询当前用户剩余时间
   -1 为无限制
   
   ```objective-c
   - (void)checkLeftTime {
    int leftTime = [self.aaManager leftTimeOfCurrentUser];
   }
   ```
9. 展示查看详情界面
   此界面展示中宣部关于防沉迷政策的相关规则
   ```objective-c
   - (void)checkDetailInfo {
      [self.aaManager presentDetailInfoControllerWithRootViewController:self];
   }
   ```
10. 展示消费限制界面
    未登录及未成年人无法在游戏中付费。
    成年人无限制
   ```objective-c
    - (void)presentCashLimitedController {
      if ([self.aaManager isAdult] == adult) {
         [self addLog:@"成年人无消费限制"];
         return;
      }
      [self.aaManager presentCashLimitedControllerWith:self];
    }
   ```
11. 定时器管理，暂停计时器计时
    ```objective-c
    /// 暂停计时器
    - (void)stopTimer;
    ```
12. 定时器管理，恢复计时器计时
    实名认证成功时，需调用此方法
    
    ```objective-c
    /// 恢复计时器
    - (void)resumeTimer;
    ```
13.  实现代理回调
   ```objective-c
    #pragma mark - delegate
    // 游客登录结果(登录行为只有一次，此回调只会在登录成功后调用一次)
    // touristsID 有值则为登录成功，否则登录失败
    - (void)touristsModeLoginResult:(nullable NSString *)touristsID {
        if (touristsID.length) {
            [self addLog:[NSString stringWithFormat:@"游客登录成功，游客ID: %@", touristsID]];
            [self.aaManager presentAlertInfoControllerWithRootViewController:self];
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
    // 此回调每秒执行一次
    // leftTime: 当前用户剩余时间，-1无限制
    // isAuth: 是否已认证
    // ageGroup: 用户年龄段
    - (void)currentUserInfo:(int)leftTime isAuthenticated:(BOOL)isAuth ageGroup:(AAAgeGroup)ageGroup {
        [self addLog:[NSString stringWithFormat:@"----------\n剩余时间 %d\n认证状态 %d\n是否成年 %lu\n----------", leftTime, isAuth, (unsigned long)ageGroup]];
    }
   ```