[toc]
# Get Started
This guide is intended for publishers who want to integrate the Anti-Addiction System.
# Prerequisites
- Xcode 10 or higher
- iOS 9.0 or higher
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
- Add the following parameters into the info.plist. 
  You can find the info.plist in your Xcode project.
  *warning: contact your PM for all of these IDs*
  ```xml
  <key>zgameid</key>
  <string>your game id</string>
  <key>zchannelid</key>
  <string>your channel id</string>
  ```

# Import SDK

  - Cocoapods (preferred)
    The simplest way to import the SDK into an iOS project is to use CocoaPods. 
    Open your project's Podfile and add this line to your app's target: 
    ```ruby
    pod 'AAManager', '~> 0.1.14'
    ```
    Then run the below command line:
    ```shell
    pod install
    ```
    If you're new to CocoaPods, see their [official documentation](https://guides.cocoapods.org/using/using-cocoapods) for info on how to create and use Podfile.

# Integration

1. Init SDK
   Usually we recommend initializing the SDK after the user agrees to the privacy policy.
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
2. Check user authentication status
   ```objective-c
   if ([self.aaManager isAuthenticated]) {
     // do something
   }
   ```
3. Present real name authentication controller
   ```objective-c
   - (void)realNameAuth {
       if ([self.aaManager isAuthenticated]) {
           return;
       }
       [self.aaManager presentRealNameAuthenticationController];
    }
   ```

4. Check left time of the current user

   The left time will update every minute or application resign to backend.(except off-line)

   -1 is no limited.

   ```objective-c
   - (void)checkLeftTime {
       int leftTime = [self.aaManager leftTimeOfCurrentUser];
   }
   ```
5. Implement Delegate
   ```objective-c
   #pragma mark - delegate
   // tourist login result (Automatic login is implemented by SDK)
   // Login is successful if touristsID have a value, otherwise login fails.
   - (void)touristsModeLoginResult:(nullable NSString *)touristsID {}
   
   // real name auth result
   - (void)realNameAuthenticateResult:(bool)success {}
   
   // tourist's time is ran out
   // will display real name auth controller after 3 seconds
   - (void)noTimeLeftWithTouristsMode {}
   
   // game time is ran out
   // will display the game time is ran out alert-controller after 3 seconds.
   - (void)noTimeLeftWithNonageMode {}
   ```