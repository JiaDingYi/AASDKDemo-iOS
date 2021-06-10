//
//  RewardedInfoForZombieController.h
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RewardedInfoControllerDelegate <NSObject>
- (void)userClickReceivedButton;

@end

@interface RewardedInfoForZombieController : UIViewController
@property (nonatomic, weak) id<RewardedInfoControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
