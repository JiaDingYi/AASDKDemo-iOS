//
//  CountdownViewForZombie.h
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CountdownViewDelegate <NSObject>
- (void)userClickAuthButtonInCountdownView;
- (void)userClickCheckDetailInfoButtonInCountdownView;

@end

@interface CountdownViewForZombie : UIView
@property (nonatomic, weak) id<CountdownViewDelegate> delegate;
@property (nonatomic, assign) int countdown;

- (void)updateAuthedUI;
@end

NS_ASSUME_NONNULL_END
