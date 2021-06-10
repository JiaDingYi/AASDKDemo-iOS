//
//  AwardAlertForZombieController.m
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/6/10.
//

#import "AwardAlertForZombieController.h"
#import <Masonry/Masonry.h>

@interface AwardAlertForZombieController ()

@end

@implementation AwardAlertForZombieController

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
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zombie_leave_bg"]];
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
    
    UIButton *leaveButton = [[UIButton alloc] init];
    [leaveButton setBackgroundImage:[UIImage imageNamed:@"zombie_leave_button"] forState:UIControlStateNormal];
    [leaveButton addTarget:self action:@selector(userClickLeaveButton) forControlEvents:UIControlEventTouchUpInside];
    [bgImg addSubview:leaveButton];
    CGFloat buttonWidth = bgWidth * 0.33;
    CGFloat buttonheight = buttonWidth / 3.0;
    CGFloat bottomMargin = bgHeight * 0.085;
    [leaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImg.mas_centerX).multipliedBy(0.6);
        make.bottom.equalTo(bgImg.mas_bottom).offset(-bottomMargin);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonheight);
    }];
    
    UIButton *authButton = [[UIButton alloc] init];
    [authButton setBackgroundImage:[UIImage imageNamed:@"zombie_auth_button"] forState:UIControlStateNormal];
    [authButton addTarget:self action:@selector(userClickAuthButton) forControlEvents:UIControlEventTouchUpInside];
    [bgImg addSubview:authButton];
    [authButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImg.mas_centerX).multipliedBy(1.4);
        make.bottom.equalTo(leaveButton.mas_bottom);
        make.width.height.equalTo(leaveButton);
    }];
}

- (void)userClickLeaveButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userClickLeaveButton)]) {
        [self.delegate userClickAuthButton];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)userClickAuthButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userClickAuthButton)]) {
        [self.delegate userClickAuthButton];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
