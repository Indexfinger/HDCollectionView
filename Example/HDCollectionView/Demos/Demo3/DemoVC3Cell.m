//
//  DemoVC3Cell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC3Cell.h"
#import "DemoVC3CellModel.h"
//#import "UIView+gesture.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "DemoVC3.h"

@interface DemoVC3Cell()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *detailL;
@property (nonatomic, strong) UILabel *bottomLeft;
@property (nonatomic, strong) UILabel *bottomRight;
@property (nonatomic, strong) UIImageView *rightImageV;
@property (nonatomic, strong) UIView *bottomLine;
@end
@implementation DemoVC3Cell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleL.numberOfLines = 2;
        [self.contentView addSubview:self.titleL];
        
        self.detailL = [[UILabel alloc] initWithFrame:self.bounds];
        self.detailL.numberOfLines = 0;
        [self.contentView addSubview:self.detailL];
        
        self.rightImageV = [UIImageView new];
        self.rightImageV.hidden = YES;
//        self.rightImageV.contentMode = uicon
        [self.contentView addSubview:self.rightImageV];
        
        self.bottomLeft = [[UILabel alloc] initWithFrame:self.bounds];
        self.bottomLeft.numberOfLines = 1;
        [self.contentView addSubview:self.bottomLeft];
        
        self.bottomRight = [[UILabel alloc] initWithFrame:self.bounds];
        self.bottomRight.numberOfLines = 1;
        [self.contentView addSubview:self.bottomRight];
        
        self.bottomLine = [UIView new];
        self.bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.bottomLine];
    }
//    __weak typeof(self) weakS = self;
//    self.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
//    [self setTapActionWithBlock:^(UITapGestureRecognizer *tap) {
//        [weakS clickSelf];
//    }];

    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}
- (void)setLayoutWithModel:(HDCellModel*)cellModel
{
    DemoVC3CellModel *cellM = cellModel.orgData;
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        //        make.bottom.mas_equalTo(-10);
    }];
    if (cellM.imageUrl) {
        [self.rightImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.titleL);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(self.rightImageV.mas_width).multipliedBy(0.7);
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(5);

        }];
        
        [self.detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleL);
            make.centerY.mas_equalTo(self.rightImageV);
            make.right.mas_equalTo(self.rightImageV.mas_left).offset(-5);
            make.height.mas_equalTo(self.rightImageV);
        }];
    }else{
        [self.detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.titleL);
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(10);
        }];
    }
    [self.bottomLeft setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.bottomLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailL.mas_bottom).offset(15);
        make.left.mas_equalTo(self.titleL);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.bottomRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleL);
        make.centerY.mas_equalTo(self.bottomLeft);
        make.left.mas_greaterThanOrEqualTo(self.bottomLeft.mas_right).offset(5);
        make.width.mas_greaterThanOrEqualTo(70);
        make.height.mas_equalTo(self.bottomLeft);
    }];
    
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)cacheSubviewsFrameBySetLayoutWithCellModel:(HDCellModel *)cellModel
{
    /*
     0、前提条件：该cell所在的段(HDSectionModel)
     secModel.isNeedAutoCountCellHW  = YES;
     secModel.isNeedCacheSubviewsFrame = YES;
     
     1、当你想缓存cell子view Frame时，实现cacheSubviewsFrameBySetLayoutWithCellModel函数即可，
     在此cell内部无需调用cacheSubviewsFrameBySetLayoutWithCellModel和setLayoutWithModel方法，
     此时最后展示到界面上的cell没有设置任何约束，但其所有frame是通过一个相同类的tempCell在设置约束后计算而来的
     
     2、当该段设置isNeedCacheSubviewsFrame为NO时，你需要在cell的- (instancetype)initWithFrame:(CGRect)frame中调用setLayoutWithModel方法
     此时的展示与常规方式相同，每个cell均设置有约束，滑动列表时autoLayout会重新计算子view新的frame。而情况1滑动列表时只是在重设所有子view的frame。
     
     3、需要注意的是，当cell内嵌套了collectionView时。该cell建议不要开启isNeedCacheSubviewsFrame,因为此时遍历的子view数量可能会太多了。。
     isNeedCacheSubviewsFrame是以段为单位的，同一段内的某种类型的cell不想开启缓存子view frame功能，不实现
     - (void)cacheSubviewsFrameBySetLayoutWithCellModel:(HDCellModel *)cellModel 方法即可。
     */
    [self setLayoutWithModel:cellModel];
}
-(void)updateCellUI:(__kindof id<HDCellModelProtocol>)model
{
    uint64_t dispatch_benchmark(size_t count, void (^block)(void));//GCD私有API
    if (!isDemoVC3OpenCellSubviewFrameCache) {
        uint64_t ns = dispatch_benchmark(1, ^{
            //写在updateCellUI中会在滑动时创建约束，这会损耗一些时间（因为这里约束需要根据model来做变更）
            [self setLayoutWithModel:model];
        });
        double time1 = ns/(pow(10, 6));
        printf("重建约束消耗时间为%f毫秒\n",time1);
    }
    //这里的示例相当于将DemoVC3CellModel与cell进行了绑定，后期适配其他model会变得困难
    //更好的适配方式见 QQDemo2 ，QQDemoFriendCell绑定的将是一个viewModel。后期很容易让容易cell适配不同原始model
    DemoVC3CellModel *cellM = model.orgData;
    self.titleL.attributedText = cellM.title;
    self.detailL.attributedText = cellM.detail;
    self.bottomLeft.attributedText = cellM.leftText;
    self.bottomRight.attributedText = cellM.rightText;
    self.rightImageV.hidden = !cellM.imageUrl;
    if (cellM.imageUrl) {
        [self.rightImageV sd_setImageWithURL:[NSURL URLWithString:cellM.imageUrl]];
    }
    
}
- (void)clickSelf
{
    self.callback(self.hdModel);
}

- (void)dealloc
{
    
}
@end
