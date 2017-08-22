//
//  SkinTableViewCell.m
//  Calculator
//
//  Created by Scarlett on 2017/7/20.
//  Copyright © 2017年 zsh. All rights reserved.
//

#import "SkinTableViewCell.h"
#import "SCollectionViewCell.h"
#import "SModel.h"
#import "SkinModel.h"



@interface SkinTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SCollectionViewCell *cell;
@property (nonatomic, strong) NSIndexPath* index;
@end

static NSString *const sCell = @"SCollectionViewCell";


@implementation SkinTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    
//    _index = [NSIndexPath indexPathWithIndex:1];
    
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake(150, 300);  // 设置最小行间距
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;//水平方向
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, 300) collectionViewLayout:flow];
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
        [_collectionView registerNib:[UINib nibWithNibName:@"SCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:sCell];
    //    SkinModel *model = _dataArr[indexPath.section];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SkinModel *model = _dataArr[_section];
    return model.contentArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:sCell forIndexPath:indexPath];
    SkinModel *model = _dataArr[_section];
    SModel *mmodel = model.contentArr[indexPath.row];
    cell.model = mmodel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (SkinModel *model in _dataArr) {
        for (SModel *mmodel in model.contentArr) {
            mmodel.select = NO;
            [collectionView reloadData];
        }
    }
    
    SkinModel *model = _dataArr[_section];
    SModel *mmodel = model.contentArr[indexPath.row];
    mmodel.select = YES;
    
    [collectionView reloadData];
    _block(mmodel.content);

}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
