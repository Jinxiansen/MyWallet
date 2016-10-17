//
//  ViewController.m
//  MyWallet
//
//  Created by 晋先森 on 16/9/9.
//  Copyright © 2016年 晋先森 https://github.com/Jinxiansen . All rights reserved.
//


#import "ViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController ()<PKAddPassesViewControllerDelegate>
@property (strong,nonatomic) PKPass *pass;//票据
@property (strong,nonatomic) PKAddPassesViewController *addPassesController;//票据添加控制器
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - UI事件

- (IBAction)walletButtonClick:(UIButton *)sender {

    [self addPass];
}


#pragma mark - 属性
/**
 *  创建Pass对象
 *
 *  @return Pass对象
 */
-(PKPass *)pass{
    if (!_pass) {
        // Coupon.pkpass BoardingPass.pkpass StoreCard.pkpass
        NSString *passPath=[[NSBundle mainBundle] pathForResource:@"StoreCard.pkpass" ofType:nil];
        NSData *passData=[NSData dataWithContentsOfFile:passPath];
        NSError *error=nil;
        _pass=[[PKPass alloc]initWithData:passData error:&error];
        if (error) {
            NSLog(@"创建Pass过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }

//        //读取
//        NSString *passFile = [[[NSBundle mainBundle] resourcePath]
//                              stringByAppendingPathComponent:name];
//        NSData *passData = [NSData dataWithContentsOfFile:passFile];
//
//        NSError* error = nil;
//        PKPass *newPass = [[PKPass alloc] initWithData:passData
//                                                 error:&error];
//
//
//        if (error != nil) {
//            [[[UIAlertView alloc] initWithTitle:@"Passes error"
//                                        message:[error
//                                                 localizedDescription]
//                                       delegate:nil
//                              cancelButtonTitle:@"Ooops"
//                              otherButtonTitles: nil] show];
//            return;
//        }

    }
    return _pass;
}

/**
 *  创建添加Pass的控制器
 */
-(PKAddPassesViewController *)addPassesController{
    if (!_addPassesController) {
        // 检查PKPassLibrary内是否已经有同样的pass, 有的话, 进行更新, 没有就要进行增加.
//        PKPassLibrary *passLibrary = [[PKPassLibrary alloc] init];
//        if([passLibrary containsPass:self.pass]) {
//            BOOL replaceResult = [passLibrary replacePassWithPass:self.pass];
//        } else {
        _addPassesController=[[PKAddPassesViewController alloc]initWithPass:self.pass];
        _addPassesController.delegate=self;//设置代理
//        }
    }
    return _addPassesController;
}

#pragma mark - 私有方法
-(void)addPass{
    if (![PKAddPassesViewController canAddPasses]) {
        return;
    }
    [self presentViewController:self.addPassesController animated:YES completion:nil];
}

#pragma mark - PKAddPassesViewController代理方法
-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller{
    NSLog(@"添加成功.");
    [self.addPassesController dismissViewControllerAnimated:YES completion:nil];
    //添加成功后转到Passbook应用并展示添加的Pass
    NSLog(@"%@",self.pass.passURL);
    [[UIApplication sharedApplication] openURL:self.pass.passURL];
}
@end




