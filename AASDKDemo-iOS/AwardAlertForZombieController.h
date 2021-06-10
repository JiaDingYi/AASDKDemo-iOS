//
//  AwardAlertForZombieController.h
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AwardAlertInfoControllerDelegate <NSObject>
- (void)userClickLeaveButton;
- (void)userClickAuthButton;

@end

@interface AwardAlertForZombieController : UIViewController
@property (nonatomic, weak) id<AwardAlertInfoControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
