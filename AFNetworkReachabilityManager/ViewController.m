//
//  ViewController.m
//  AFNetworkReachabilityManager
//
//  Created by 张培根 on 2017/6/30.
//  Copyright © 2017年 张培根. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface ViewController ()

@property (nonatomic) Reachability *internetReachability;

@property (weak, nonatomic) IBOutlet UILabel *afLabel;
@property (weak, nonatomic) IBOutlet UILabel *reachablityLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AFNetworkReachabilityManager];
    
    [self reachablity];
    
}

-(void)reachablity{
    //创建监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //生成对象
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    //由于kReachabilityChangedNotification监听只有在网络状态改变时才会生效，所以调用此方法，主动判断网络状态
    [self updateInterfaceWithReachability:self.internetReachability];
}

-(void)reachabilityChanged:(NSNotification *)note{
    
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
    
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            self.reachablityLabel.text = @"当前网络状态为：无网络";
            break;
        case ReachableViaWiFi:
            self.reachablityLabel.text = @"当前网络状态为：WIFI";
            break;
        case ReachableViaWWAN:
            self.reachablityLabel.text = @"当前网络状态为：手机网络";
            break;
        default:
            break;
    }
}

-(void)AFNetworkReachabilityManager{
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger startMonitoring];
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.afLabel.text = @"当前网络状态为：未知网络";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.afLabel.text = @"当前网络状态为：无网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.afLabel.text = @"当前网络状态为：WIFI";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.afLabel.text = @"当前网络状态为：手机网络";
                break;
            default:
                break;
        }
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
