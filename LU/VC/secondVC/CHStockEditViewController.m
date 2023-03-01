//
//  CHStockEditViewController.m
//  LU
//
//  Created by peng jin on 2019/4/24.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHStockEditViewController.h"
#import "CHSearchTableViewCell.h"

@interface CHStockEditViewController () <UIAlertViewDelegate>{
    BOOL y[1000];
    BOOL selectAll;
    NSInteger selectedNum;
}
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong)UIButton * selectAllBtn;
@property (nonatomic ,strong)UILabel * noBuyLabel;
@property (nonatomic ,strong)UIView  * bottomView;
@property (nonatomic ,strong)UIButton * delBtn;

@end

@implementation CHStockEditViewController
@synthesize tableView = _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.dataArray = [[NSMutableArray alloc]initWithArray: [CNManager loadByKey:HASBUYSTOCK]];
//    [self.view addSubview:self.noBuyLabel];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.noBuyLabel];
    [self.view addSubview:self.bottomView];
    // Do any additional setup after loading the view.
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [JPMyControl createViewWithFrame:CGRectMake(0, MAINHEIGHT - TabBarHeight, MAINWIDTH, TabBarHeight) bgColor:UIColorFromRGB(0xececec)];
        [_bottomView addSubview:self.selectAllBtn];
        [_bottomView addSubview:self.delBtn];
    }
    return _bottomView;
}

- (UIButton *)selectAllBtn{
    if (!_selectAllBtn) {
        _selectAllBtn = [JPMyControl createButtonWithFrame:CGRectMake(0, 10, 80, 20) Target:self SEL:@selector(selectAllClick) Title:@"    全选" ImageName:@"cirle-unselect" bgImage:@"" Tag:0];
        _selectAllBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_selectAllBtn setImageEdgeInsets: UIEdgeInsetsMake(0, 10, 0, -10)];
        _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _selectAllBtn;
}

- (UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [JPMyControl createButtonWithFrame:CGRectMake(MAINWIDTH - 120, 0, 110, 40) Target:self SEL:@selector(delBtnClick) Title:@" 删除自选(0)" ImageName:@"stock_del" bgImage:@"" Tag:0];
        [_delBtn setImageEdgeInsets: UIEdgeInsetsMake(0, -5, 0, 5)];
        _delBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_delBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _delBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [JPMyControl createTableViewWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight - _bottomView.height ) Target:self UITableViewStyle:UITableViewStylePlain separatorStyle:NO];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
    }
    return _tableView;
}

- (UILabel *)noBuyLabel{
    if (!_noBuyLabel) {
        _noBuyLabel = [JPMyControl createLabelWithFrame:CGRectMake(0, MAINHEIGHT/3., MAINWIDTH, 20) Font:20 Text:@"未收藏任何股票"];
        //        _noBuyLabel.center = _homeSC.center;
        _noBuyLabel.textColor = UIColorFromRGB(0x666666);
        _noBuyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noBuyLabel;
}

#pragma mark delegate of tableView

//段数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return 8;
    _noBuyLabel.hidden = _dataArray.count;
    return _dataArray.count;
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary * temp =self.dataArray[indexPath.row];
    
    CHSearchTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[CHSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell makeCellUIWithSelect];
    }
    cell.x = y[indexPath.row];
    [cell setCellWithDic:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    y[indexPath.row]=!y[indexPath.row];
    if (y[indexPath.row]) {
        selectedNum++;
    }else selectedNum --;
//    selectedNum = selectedNum + y[indexPath.row]? 1:(-1);
    [_delBtn setTitle:[NSString stringWithFormat:@"删除自选(%ld)",selectedNum] forState:UIControlStateNormal];
    [_tableView reloadData];
}

#pragma mark methods

- (void)selectAllClick{
    selectAll = !selectAll;
    for (int i = 0; i< _dataArray.count; i++) {
        y[i]= selectAll;
    }
    [_selectAllBtn setImage:[UIImage imageNamed:selectAll?@"cirle-select":@"cirle-unselect"] forState:UIControlStateNormal];
    selectedNum = selectAll?_dataArray.count:0;
    [_delBtn setTitle:[NSString stringWithFormat:@"删除自选(%ld)",selectedNum] forState:UIControlStateNormal];
    [_tableView reloadData];
}

- (void)delBtnClick{
    if (selectedNum) {
        UIAlertView*al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定删除自选股票？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title=@"自选管理";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 40, 40);
    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [backButton setImage:[UIImage imageNamed:@"back-btn"] forState:UIControlStateNormal];
    [backButton setTitle:@"完成" forState:UIControlStateNormal];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    moreItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = moreItem;
//
//    UIButton * _editBtn=[JPMyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) Target:self SEL:@selector(setClick) Title:@"关闭" ImageName:@"" bgImage:@"" Tag:0];
//    _editBtn.titleLabel.font=[UIFont systemFontOfSize:12];
//    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    UIBarButtonItem*right=[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
//    //    _editBtn.hidden=YES;
//    right.style=UIBarButtonItemStylePlain;
//    self.navigationItem.rightBarButtonItems=@[right];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        NSInteger x = _dataArray.count;
        for (NSInteger i = x-1; i>=0; i--) {
            if (y[i]) {
                y[i] = false;
                [_dataArray removeObjectAtIndex:i];
            }
        }
        [CNManager saveObject:_dataArray byKey:HASBUYSTOCK];
        selectedNum  = 0;
        selectAll = NO;
        [_selectAllBtn setImage:[UIImage imageNamed:selectAll?@"cirle-select":@"cirle-unselect"] forState:UIControlStateNormal];
        [_delBtn setTitle:[NSString stringWithFormat:@"删除自选(%ld)",selectedNum] forState:UIControlStateNormal];
        [_tableView reloadData];
    }
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
