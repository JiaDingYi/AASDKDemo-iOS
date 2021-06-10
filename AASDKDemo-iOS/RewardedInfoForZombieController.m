//
//  RewardedInfoForZombieController.m
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/6/10.
//

#import "RewardedInfoForZombieController.h"
#import <Masonry/Masonry.h>

@interface RewardedInfoForZombieController ()

@end

@implementation RewardedInfoForZombieController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)setUpUI {
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zombie_rewarded_bg"]];
    bgImg.userInteractionEnabled = YES;
    [self.view addSubview:bgImg];
    CGFloat bgWidth = self.view.frame.size.width * 0.6;
    CGFloat bgHeight = bgWidth / 1.42;
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.mas_equalTo(bgWidth);
        make.height.mas_equalTo(bgHeight);
    }];
    
    UIButton *receivedButton = [[UIButton alloc] init];
    [receivedButton setBackgroundImage:[UIImage imageNamed:@"zombie_received_button"] forState:UIControlStateNormal];
    [receivedButton addTarget:self action:@selector(userClickReceivedButton) forControlEvents:UIControlEventTouchUpInside];
    [bgImg addSubview:receivedButton];
    CGFloat buttonWidth = bgWidth * 0.33;
    CGFloat buttonheight = buttonWidth / 3.0;
    CGFloat bottomMargin = bgHeight * 0.085;
    [receivedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImg.mas_centerX);
        make.bottom.equalTo(bgImg.mas_bottom).offset(-bottomMargin);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonheight);
    }];
}

- (void)userClickReceivedButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userClickReceivedButton)]) {
        [self.delegate userClickReceivedButton];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
