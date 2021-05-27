
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
# 导入防沉迷 SDK
1. CocoaPods （首选）
   要将该 SDK 导入 iOS 项目，最简便的方法就是使用 [CocoaPods](https://guides.cocoapods.org/using/getting-started)。
   ```ruby
   pod 'AAManager', '~> 0.1.13'
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
4. 展示实名认证界面
   如果游戏没有主动调用，游客游戏时长用尽时将由 SDK 主动触发
   ```objective-c
   - (void)realNameAuth {
    if (![self.aaManager isLogined]) {
        return;
    }
    if ([self.aaManager isAuthenticated]) {
        return;
    }
    [self.aaManager presentRealNameAuthenticationController];
   }
   ```
5. 查询当前用户剩余时间
   联网状态下每分钟（或切换前后台时）更新一次
   ```objective-c
   - (void)checkLeftTime {
    int leftTime = [self.aaManager leftTimeOfCurrentUser];
   }
   ```
6. 实现代理回调
   ```objective-c
   #pragma mark - delegate
   // 游客登录结果
   // touristsID 有值则为登录成功，否则登录失败
   - (void)touristsModeLoginResult:(nullable NSString *)touristsID {}
   
   // 实名认证结果
   - (void)realNameAuthenticateResult:(bool)success {}
   
   // 游客时长已用尽(1h/15 days)
   // 收到此回调 3s 后，会展示实名认证界面
   // 游戏请在收到回调 3s 内处理未尽事宜
   - (void)noTimeLeftWithTouristsMode {}
   
   // 未成年时长已用尽(2h/1 day)
   // 收到此回调 3s 后，会展示未成年时长已用尽弹窗
   // 游戏请在收到回调 3s 内处理未尽事宜
   - (void)noTimeLeftWithNonageMode {}
   ```