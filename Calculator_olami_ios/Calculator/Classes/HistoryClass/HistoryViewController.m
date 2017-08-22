//
//  HistoryViewController.m
//  Calculator
//
//  Created by Scarlett on 2017/7/6.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import "HistoryViewController.h"
#import "UIViewController+ZYSliderViewController.h"
#import "ZYSliderViewController.h"
#import "DataBaseManager.h"
#import "Equation.h"
#import "HistoryTableViewCell.h"

#define zScreenW self.view.frame.size.width
#define zScreenH self.view.frame.size.height

static NSString *const historyCell = @"historyCell";

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *selectArr;

@property (nonatomic, strong) UIView *deleteView;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = WhiteColor;
    
    _selectArr = [[NSMutableArray alloc] init];
    
    _dataSource = [[NSMutableArray alloc] init];
    
    [self setUI];
    
    _dataSource = [[DataBaseManager shareDataBase] getAllEquation];
    
    //注册通知（接收通知）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveTongzhi:) name:@"saveTongzhi" object:nil];
}

- (void)setUI {
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(zScreenW-240, 0, 240, zScreenH)];
    backImage.image = [UIImage imageNamed:@"222.jpeg"];
    [self.view addSubview:backImage];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(zScreenW-240, 0, 240, 64)];
    headView.backgroundColor = ClearColor;
    [self.view addSubview:headView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(zScreenW-240 + (240/2-40), 30, 80, 30)];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    lineView.frame = CGRectMake(zScreenW-240, 64, 240, 0.5);
    titleLabel.text = @"我的收藏";
    titleLabel.font = textFont(18);
    titleLabel.textColor = WhiteColor;
    [self.view addSubview:titleLabel];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 36, 16, 16);
    [leftBtn setImage:[[UIImage imageNamed:@"back2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    rightBtn.titleLabel.font = textFont(16);
    [rightBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightBtn];
    rightBtn.frame = CGRectMake(240-10-34, 35, 41, 24);
    _rightBtn = rightBtn;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(zScreenW-240, 64+10, 240, zScreenH-64-10) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:historyCell];
    
    _deleteView = [[UIView alloc] initWithFrame:CGRectMake(zScreenW-240, zScreenH-49, 240, 49)];
    _deleteView.backgroundColor = ARGBColor(200, 241, 199, 223);
    [self.view addSubview:_deleteView];
    UIButton *deleteAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteAllBtn setBackgroundColor:RedColor];
    [deleteAllBtn setTitle:@"全部删除" forState:UIControlStateNormal];
    [deleteAllBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    deleteAllBtn.layer.cornerRadius = 8;
    deleteAllBtn.layer.masksToBounds = YES;
    [_deleteView addSubview:deleteAllBtn];
    deleteAllBtn.frame = CGRectMake(240/2-70, 49/2-15, 140, 30);
    _deleteView.hidden = YES;
    
    
    [deleteAllBtn addTarget:self action:@selector(deleteAll:) forControlEvents:UIControlEventTouchUpInside];
}

//删除全部
- (void)deleteAll:(UIButton *)deleteBtn {
    [[DataBaseManager shareDataBase] deleteAllEquation];
    
    _dataSource = [[DataBaseManager shareDataBase] getAllEquation];
    [_tableView reloadData];
    
    _tableView.editing = NO;
    
    _deleteView.hidden = YES;
    _rightBtn.selected = NO;

}

//保存值处理
- (void)saveTongzhi:(NSNotification *)text {
    NSLog(@"savetongzhi:%@",text.userInfo[@"arr"]);
    _dataSource = text.userInfo[@"arr"];
    [_tableView reloadData];
}

- (void)back {
    NSLog(@"dfa");
    [[self sliderViewController] hideRight];

}

- (void)edit:(UIButton *)btn {
    BOOL flag = _tableView.editing;
    if (flag) {
        //删除的操作
        //得到删除的索引
        _deleteView.hidden = YES;
        
        //下面一部分是多选删除
        NSMutableArray *indexArray = [NSMutableArray array];
        for (Equation *equation in _selectArr) {
            NSInteger num = [_dataSource indexOfObject:equation];
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:num inSection:0];
            [indexArray addObject:path];
        }
        
        //修改数据模型model（数据库）
//        [_dataSource removeObjectsInArray:_selectArr];
        for (Equation *equ in _selectArr) {
            [[DataBaseManager shareDataBase] removeEquation:equ];
        }
        
        _dataSource = [[DataBaseManager shareDataBase] getAllEquation];
        
        [_selectArr removeAllObjects];
        
        //刷新 UI删除
        [_tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        
        _tableView.editing = NO;
        btn.selected = NO;
    }
    else{
        _deleteView.hidden = NO;
        //开始选择行
        [_selectArr removeAllObjects];
        
        _tableView.editing = YES;
        btn.selected = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGSize strSize=CGSizeMake(200, MAXFLOAT);
//    NSDictionary *attr=@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
//    
//    CGSize labelSize = [self.saveLabel.text boundingRectWithSize:strSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
//    _equationModel.cellHeight = labelSize.height;
//
//    Equation *eModel = _dataSource[indexPath.section];
//    return eModel.cellHeight;
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCell];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Equation *eqModel = _dataSource[indexPath.section];
    cell.equationModel = eqModel;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       
    if (!_tableView.editing){
        [[self sliderViewController] hideRight];
        NSMutableArray *allArr = [[DataBaseManager shareDataBase] getAllEquation];
        Equation *eqModel = allArr[indexPath.section];
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:eqModel.resultstr,@"text", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"historyTongzhi" object:nil userInfo:dict];
        
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        return;
    }
    
    Equation *equation = [_dataSource objectAtIndex:indexPath.section];
    if (![_selectArr containsObject:equation]) {
        [_selectArr addObject:equation];
    }
}

#pragma mark 取消选中行
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_tableView.editing){
        return;
    }
    
    Equation *equation = _dataSource[indexPath.section];
    if ([_selectArr containsObject:equation]) {
        [_selectArr removeObject:equation];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {//删除
        
        NSMutableArray *allArr = [[DataBaseManager shareDataBase] getAllEquation];
        Equation *eqModel = allArr[indexPath.section];
        
        [[DataBaseManager shareDataBase] removeEquation:eqModel];
        
        _dataSource = [[DataBaseManager shareDataBase] getAllEquation];
        
        [_tableView reloadData];
    }

}

//侧滑出现的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
