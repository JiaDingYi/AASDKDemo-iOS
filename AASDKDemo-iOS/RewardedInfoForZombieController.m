//
//  RewardedInfoForZombieController.m
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/6/10.
//

#import "RewardedInfoForZombieController.h"

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
    self.view.backgroundColor = [UIColor redColor];
}

@end
