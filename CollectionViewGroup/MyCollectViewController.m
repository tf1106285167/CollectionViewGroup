//
//  ViewController.m
//  XLPlainFlowLayoutDemo
//
//    Created by TuFa on 16/7/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyCollectViewController.h"
#import "ReusableView.h"
#import "XLPlainFlowLayout.h"
#import "TenMainMaterialModel.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"


#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MyCollectViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *muArr;
    NSMutableArray *mulArrR;
    int midCount;
    CGFloat imgh;
    NSInteger font;
    UIView *viewTop;
    NSInteger scrolH;
}
@end

@implementation MyCollectViewController

static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";

-(instancetype)init
{
    imgh = KScreenWidth/2-15-10 + 117;
    if (KScreenWidth<375) {
        font = 11;
    }else{
        font =13;
    }
    
    
    XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
    layout.itemSize = CGSizeMake((KScreenWidth-30)/2, imgh);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 20);
    return [self initWithCollectionViewLayout:layout];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    UIButton *btnNabvi = [[UIButton alloc]initWithFrame:CGRectMake(0, 4, 60, 36)];
    [self.navigationController.navigationBar addSubview:btnNabvi];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.top = self.collectionView.top+64;
    self.collectionView.height = self.collectionView.height-64;
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:.93 alpha:1];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    [self.collectionView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:footerID];
    
    muArr = [NSMutableArray array];
    mulArrR = [NSMutableArray array];
    [self pageNo];
    scrolH = 30;
}

-(void)pageNo{

    NSString *url = @"http://m.zlifan.com/api/getMaterialTypeList?pid=1";
    NSDictionary *jasonDic ;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(response != nil){
        jasonDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
    }
        
    for (NSDictionary *dict in jasonDic) {
        
        [muArr addObject:dict];
    }
    
    viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    [self.view addSubview:viewTop];
    viewTop.backgroundColor = [UIColor blackColor];
    
    for (int i=0; i<muArr.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i%5*KScreenWidth/5, i/5*32, KScreenWidth/5, 32)];
        [btn setTitle:muArr[i][@"fname"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if (KScreenWidth <= 320) {
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        
        [viewTop addSubview:btn];
        [btn addTarget:self action:@selector(btnTopAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 500+i;
        
        if (i==0) {
            btn.selected = YES;
            btn.backgroundColor = [UIColor colorWithRed:0.912 green:0.000 blue:0.009 alpha:1.000];
        }
        
        if (i==6) {
            
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, KScreenWidth, 1)];
            lineLabel.backgroundColor = [UIColor whiteColor];
            [viewTop addSubview:lineLabel];
        }
        
        NSString *url1 = [NSString stringWithFormat:@"http://m.zlifan.com/api/getMaterialList?ftypeId=%@&pageSize=999",muArr[i][@"fid"]];
        NSDictionary *jasonDic1;
        NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:url1]];
        //将请求的url数据放到NSData对象中
        NSData *response1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
        if(response1 != nil){
            jasonDic1 = [NSJSONSerialization JSONObjectWithData:response1 options:NSJSONReadingMutableLeaves error:nil];
        }
        
        NSMutableArray *mulAr = [NSMutableArray array];
        for (NSDictionary *dict2 in jasonDic1[@"list"]) {
            
            TenMainMaterialModel *model = [[TenMainMaterialModel alloc]initWithDict:dict2];
            [mulAr addObject:model];
        }
        [mulArrR addObject:mulAr];
    }
}

-(void)btnTopAction:(UIButton *)btn{
    
    for (int i=0; i<muArr.count; i++) {
        
        UIButton *button = [viewTop viewWithTag:500+i];
        button.backgroundColor = [UIColor clearColor];
    }
    
    btn.selected = YES;
    btn.backgroundColor = [UIColor colorWithRed:0.912 green:0.000 blue:0.009 alpha:1.000];
    
    if (btn.tag-500 > 0) {
        
        //collectionView滚动到某一组
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:btn.tag-500] animated:NO scrollPosition:UICollectionViewScrollPositionBottom];
    }
    
    if (btn.tag-500 == 0) {
        
        //向上滚动64
        [self.collectionView scrollRectToVisible:CGRectMake(0, -64, KScreenWidth, KScreenHeight) animated:NO];
    }else{

        [self.collectionView scrollRectToVisible:CGRectMake(0, self.collectionView.contentOffset.y+scrolH, KScreenWidth, KScreenHeight) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self performSelector:@selector(delayClearColor) withObject:nil afterDelay:3];
}

-(void)delayClearColor{
    
    for (int i=0; i<muArr.count; i++) {
        
        UIButton *button = [viewTop viewWithTag:500+i];
        button.backgroundColor = [UIColor clearColor];
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return muArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = mulArrR[section];
    return arr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: cellID forIndexPath:indexPath];
    
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth/2-15, imgh)];
    imgV.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:imgV];
    
    UIImageView *imgV2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, imgV.width-20, imgV.width-20)];
    [imgV addSubview:imgV2];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://m.zlifan.com/uploadImg/material/%@",[mulArrR[indexPath.section][indexPath.item] fimg]];
    [imgV2 sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_img01"]];
    
    UILabel *labelTilte = [[UILabel alloc]initWithFrame:CGRectMake(10, imgV2.bottom+5, imgV2.width, 20)];
    labelTilte.font = [UIFont systemFontOfSize:font];
    labelTilte.textColor = [UIColor blackColor];
    labelTilte.text = [mulArrR[indexPath.section][indexPath.item] fname];
    [imgV addSubview:labelTilte];
    
    NSString *fmodel1 = [NSString stringWithFormat:@"型号：%@",[mulArrR[indexPath.section][indexPath.item] fmodel]];
    if ([[mulArrR[indexPath.section][indexPath.item] fmodel] length] <= 0) {
        
        fmodel1 = @"";
    }
    
    NSString *fspec1 = [NSString stringWithFormat:@"规格：%@",[mulArrR[indexPath.section][indexPath.item] fspec]];
    if ([[mulArrR[indexPath.section][indexPath.item] fspec] length] <= 0) {
        
        fspec1 = @"";
    }
    
    NSString *fpriceEx1 = [NSString stringWithFormat:@"市场价：%@元/平方",[mulArrR[indexPath.section][indexPath.item] fpriceEx]];
    
    
    NSArray *arrContent = @[fmodel1,fspec1,fpriceEx1];
    
    int j = 0;
    for (int i=0; i<arrContent.count; i++) {
        
        
        UILabel *labelC = [[UILabel alloc]initWithFrame:CGRectMake(10, labelTilte.bottom+3+j*18, imgV2.width, 18)];
        labelC.text = arrContent[i];
        labelC.font = [UIFont systemFontOfSize:font-1];
        labelC.textColor = [UIColor darkGrayColor];
        labelC.tag = 300+i;
        [imgV addSubview:labelC];
        
        
        j++;
        if ([[NSString stringWithFormat:@"%@",arrContent[i]] length] <= 0) {
            j--;
        }
    }
    
    UILabel *laeblQ = [[UILabel alloc]initWithFrame:CGRectMake(10, labelTilte.bottom+3+3*18+5, 55, 20)];
    laeblQ.font = [UIFont systemFontOfSize:font-1];
    if ([[mulArrR[indexPath.section][indexPath.item] fisDef] integerValue] == 1) {
        
        laeblQ.text = @"默认品牌";
        laeblQ.textColor = [UIColor darkGrayColor];
        laeblQ.layer.borderColor = [[UIColor grayColor]CGColor];
    }else{
        
        laeblQ.text = @"定制品牌";
        laeblQ.textColor = [UIColor redColor];
        laeblQ.layer.borderColor = [[UIColor redColor]CGColor];
    }
    laeblQ.textAlignment = NSTextAlignmentCenter;
    laeblQ.layer.cornerRadius = 5;
    laeblQ.layer.borderWidth = 1;
    [imgV addSubview:laeblQ];
    
    UILabel *laeblD = [[UILabel alloc]initWithFrame:CGRectMake(imgV.width-70, labelTilte.bottom+3+3*18+5, 60, 20)];
    laeblD.font = [UIFont systemFontOfSize:font];
    laeblD.textColor = [UIColor blackColor];
    laeblD.text = @"查看详情";
    laeblD.textAlignment = NSTextAlignmentRight;
    [imgV addSubview:laeblD];
    

    [cell sizeToFit];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < muArr.count) {
        
        ReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth*250/1200)];
            imgV.backgroundColor = [UIColor whiteColor];

            NSString *urlStr = [NSString stringWithFormat:@"http://m.zlifan.com/uploadImg/materialType/%@",muArr[indexPath.section][@"fimgUrl"]];
            [imgV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon_loading_img01"]];
            [header addSubview:imgV];
            return header;
    }
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (section<muArr.count) {

        return CGSizeMake(KScreenWidth, KScreenWidth*250/1200);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{

    return CGSizeMake(0, 20);
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    if (self.isViewLoaded && !self.view.window) {
        
        self.view = nil;
    }
}

@end
