//
//  AwardAlertForZombieController.m
//  AASDKDemo-iOS
//
//  Created by jdy on 2021/6/10.
//

#import "AwardAlertForZombieController.h"

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
    self.view.backgroundColor = [UIColor redColor];
}

@end
