//
//  SkinViewController.m
//  Calculator
//
//  Created by Scarlett on 2017/7/20.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import "SkinViewController.h"
#import "SkinTableViewCell.h"
#import "SkinModel.h"

@interface SkinViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSString *chuanStr;


@end

static NSString *const skinTableViewCell = @"SkinTableViewCell";

@implementation SkinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"主题换肤";
    self.view.backgroundColor = WhiteColor;
    _dataArr = [NSMutableArray array];
    _dataArr = [[SkinModel dataArr] mutableCopy];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(chuan) forControlEvents:UIControlEventTouchUpInside];


    
    
    _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[SkinTableViewCell class] forCellReuseIdentifier:skinTableViewCell];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chuan {
    [self.navigationController popViewControllerAnimated:YES];
    //通知传值
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:_chuanStr,@"str", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"chuanTongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    view.backgroundColor = WhiteColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, 50)];
    SkinModel *model = _dataArr[section];
    titleLabel.text = model.title;
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textColor = BlackColor;
    [view addSubview:titleLabel];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SkinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:skinTableViewCell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SkinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:skinTableViewCell];
    }
//    SkinModel *model = _dataArr[indexPath.section];
//    cell.dataArr = model.contentArr;
    
    cell.dataArr = _dataArr;
    cell.section = indexPath.section;
    
    cell.block = ^(NSString *str) {
        _chuanStr = str;
        [tableView reloadData];
    };
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//
//    _secArr = @[
//                                  @{
//                                      @"content" : @[@"1423794199415.jpg",@"3186-150119164122-50.jpg",@"DUQ1F1CAE4NN.jpg",@"u=631465196,1018701104&fm=26&gp=0.jpg"],
//                                      @"title" : @"风景"
//                                      },
//                                  @{
//                                      @"content" : @[@"1483438321894.jpg",@"20150921002612_FUza8.jpeg",@"20150921002754_scZzn.jpeg",@"u=725175699,1222476565&fm=214&gp=0.jpg"],
//                                      @"title" : @"卡通"
//                                      },
//                                  @{
//                                      @"content" :@[@"t0105135ad8fb3d04f1.jpg",@"t01aff42f0c12df80a5.jpg"],
//                                      @"title" : @"城市"
//                                      },
//                                  @{
//                                      @"content" : @[@"139-161110152510.jpg",@"20160902025453826.jpg",@"wangzherongyao056.jpg"],
//                                      @"title" : @"游戏"
//                                      }
//                                ];



@end
