//
//  CountdownViewForZombie.m
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/6/10.
//

#import "CountdownViewForZombie.h"
#import <Masonry/Masonry.h>

@interface CountdownViewForZombie ()
@property (nonatomic) UILabel *infoLabelOne;
@property (nonatomic) UIButton *authButton;
@property (nonatomic) UILabel *infoLabelTwo;
@property (nonatomic) UILabel *countdownLabel;
@property (nonatomic) UIButton *checkDetailInfoButton;
@end

@implementation CountdownViewForZombie

- (void)setCountdown:(int)countdown {
    _countdown = countdown;
    [self updateCountdownLabel];
}

- (instancetype)init {
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    [self setUpUI];
    return self;
}

- (void)setUpUI {
    self.infoLabelOne = [[UILabel alloc] init];
    self.infoLabelOne.text = @"您尚未实名登记";
    self.infoLabelOne.textColor = [UIColor whiteColor];
    self.infoLabelOne.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [self addSubview:self.infoLabelOne];
    [self.infoLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.height.equalTo(self);
        make.top.equalTo(self);
    }];
    
    self.authButton = [[UIButton alloc] init];
    [self.authButton setTitle:@"实名登记" forState:UIControlStateNormal];
    [self.authButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    self.authButton.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [self.authButton addTarget:self action:@selector(userClickAuthButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.authButton];
    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.infoLabelOne.mas_right).with.offset(5);
        make.height.equalTo(self);
    }];
    
    self.checkDetailInfoButton = [[UIButton alloc] init];
    [self.checkDetailInfoButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.checkDetailInfoButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    self.checkDetailInfoButton.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [self.checkDetailInfoButton addTarget:self action:@selector(userClickCheckDetailInfoButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.checkDetailInfoButton];
    [self.checkDetailInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.infoLabelOne.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(self);
    }];
    
    self.countdownLabel = [[UILabel alloc] init];
    self.countdownLabel.text = @"00:00:00";
    self.countdownLabel.textColor = [UIColor whiteColor];
    self.countdownLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [self addSubview:self.countdownLabel];
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.checkDetailInfoButton.mas_left).with.offset(-5);
        make.height.equalTo(self);
        make.top.equalTo(self);
    }];
    
    self.infoLabelTwo = [[UILabel alloc] init];
    self.infoLabelTwo.text = @"剩余游戏时间";
    self.infoLabelTwo.textColor = [UIColor whiteColor];
    self.infoLabelTwo.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [self addSubview:self.infoLabelTwo];
    [self.infoLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countdownLabel.mas_left).with.offset(-5);
        make.height.equalTo(self);
        make.top.equalTo(self);
    }];
    
}

- (void)updateCountdownLabel {
    int hours = self.countdown / 3600;
    int minutes = (self.countdown / 60) % 60;
    int seconds = self.countdown % 60;
    NSString *str = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.countdownLabel.text = str;
    });
}

- (void)updateAuthedUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.infoLabelOne removeFromSuperview];
        [self.authButton removeFromSuperview];
    });
}

- (void)userClickAuthButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userClickAuthButtonInCountdownView)]) {
        [self.delegate userClickAuthButtonInCountdownView];
    }
}

- (void)userClickCheckDetailInfoButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userClickCheckDetailInfoButtonInCountdownView)]) {
        [self.delegate userClickCheckDetailInfoButtonInCountdownView];
    }
}

@end
