//
//  CHSettingViewController.m
//  LU
//
//  Created by peng jin on 2019/5/19.
//  Copyright © 2019 JinPeng. All rights reserved.
//
#import "GTMBase64.h"
#import "CHSettingViewController.h"
#import "CHEditMoneyCodeViewController.h"
#import "CHEditPasswordViewController.h"
#import "CropperViewController.h"
#import "CHGetStockNum.h"
#import "CHTureNameViewController.h"
#import "CHBankCardViewController.h"
#import "CHBankCardListViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f

@interface CHSettingViewController () <UIAlertViewDelegate,UIActionSheetDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CropperDelegate> {
    UITextField * tfName;
    UITextField * tfCode;
    
    BOOL hasRealName;
    BOOL hasBankCard;
    
}
@property (nonatomic ,strong)UIView  * tableHeader;
@property (nonatomic ,strong)NSArray * nameArray;
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong)UIButton * headPhoto;
@property (nonatomic ,strong)UILabel     * userName;
@property (nonatomic ,strong)UIView   * footView;
@property (nonatomic ,strong)UIView   * editName;
@property (nonatomic ,strong)UIButton * loginBtn;

@end

@implementation CHSettingViewController
@synthesize tableView = _tableView;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WEAKSELF
    
    [self upDate];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.nameArray = @[@"用户名",@"手机号",@"实名认证",@"银行卡",@"登录密码",@"提现密码",@"当前版本"];
//    self.dataArray = [[NSMutableArray alloc]initWithArray:@[@"小明",@"13011111111",@"未实名",@"未绑定",@"修改",@"未设置",@"v0.1.0"]];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [JPMyControl createViewWithFrame:CGRectMake(0, 0, MAINWIDTH, 80)];
        [_footView addSubview:self.loginBtn];
    }
    return _footView;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [JPMyControl createButtonWithFrame:CGRectMake(20, 40 , MAINWIDTH-40., 38) Target:self SEL:@selector(loginClick) Title:@"安全退出" ImageName:@"" bgImage:@"" Tag:0];
//        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = [UIColor orangeColor];
        _loginBtn.layer.cornerRadius = 4.;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

- (void)loginClick{
    //注册
    
//    if (_password.text.length&&_phone.text.length) {
    [CNManager loginOut];
    [CNManager showWindowAlert:@"退出成功"];
    [CNManager saveObject:@"1" byKey:@"showLogin"];
        [self.navigationController.tabBarController setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView= [JPMyControl createTableViewWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, MAINWIDTH, MAINHEIGHT - StatusBarAndNavigationBarHeight) Target:self UITableViewStyle:UITableViewStyleGrouped separatorStyle:YES];
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = .0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.contentSize = CGSizeMake(0, 0);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        }
        _tableView.tableHeaderView = self.tableHeader;
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}
- (UIView *)tableHeader
{
    if (!_tableHeader) {
        
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _MainScreen_Width, 70 )];
    bgView.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:bgView.bounds];
    bgImage.image = [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:300 topCapHeight:2];
    [bgView addSubview:bgImage];
    [bgView addSubview:self.headPhoto];
    [bgView addSubview:self.userName];
        _tableHeader = bgView;
    }
    return _tableHeader;
    
}

- (UIButton *)headPhoto
{
    if (!_headPhoto)
    {
        _headPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        _headPhoto.frame = CGRectMake(MAINWIDTH - 70 , 10, 50, 50);
        //        [_headPhoto setBackgroundColor:[UIColor blueColor]];
        _headPhoto.layer.masksToBounds = YES;
        _headPhoto.tag = 1;
        _headPhoto.layer.cornerRadius = _headPhoto.frame.size.width / 2;
        //        _headPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
        //        _headPhoto.layer.borderWidth = 3.0f;
        [_headPhoto addTarget:self action:@selector(logOffBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_headPhoto setBackgroundImage:[UIImage imageNamed:@"new_log_head_bg"] forState:UIControlStateNormal];
        if ([CNManager loadByKey:LOGINUSERPHOTO]) {
//            [_headPhoto setBackgroundImage:[UIImage imageWithData:[CNManager loadByKey:LOGINUSERPHOTO]] forState:UIControlStateNormal];
        }
//        [_headPhoto sd_setImageWithURL:[] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"new_log_head_bg"]];
    }
    return _headPhoto;
}
- (UILabel *)userName
{
    if (!_userName)
    {
        UILabel *loginLable = [[UILabel alloc] init];
        loginLable.text = [CNManager loadLanguage:@"头像"];
        loginLable.textColor = [UIColor blackColor];
        loginLable.font = [UIFont systemFontOfSize:16];
        loginLable.textAlignment = NSTextAlignmentLeft;
        _userName = loginLable;
        _userName.frame = CGRectMake(12, 0, 70, 70);
//        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logOffBtnAction)];
//        singleRecognizer.numberOfTapsRequired = 1; // 单击
//        [_userName addGestureRecognizer:singleRecognizer];
//        _userName.userInteractionEnabled = YES;
    }
    return _userName;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;//=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    UILabel * lb = [JPMyControl createLabelWithFrame:CGRectMake(MAINWIDTH - 200., 0, 170, 45) Font:14. Text:_dataArray[indexPath.row]];
    lb.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:lb];
    if (indexPath.row ==0||(indexPath.row>1&&indexPath.row<6)) {
        if (indexPath.row == 2) {
            if ((![CNManager hasRealName])) {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
        }else
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle=NO;
    cell.textLabel.text=self.nameArray[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.detailTextLabel.text  = self.dataArray[indexPath.row];
    
    //    CGSize itemSize = CGSizeMake(14., 14.);
    //
    //    UIGraphicsBeginImageContext(itemSize);
    //    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    //    [cell.imageView.image drawInRect:imageRect];
    //
    //    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    NSArray * tmp=_dataArray[section];
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self showEditName];
            break;
        case 2:
            if (![CNManager hasRealName]){
                [self realName:0];
            }
            break;
        case 3:
            if ([CNManager hasRealName]) {
                if (![CNManager hasBankCard]) {
                    [self realName:1];
                }else{
                    //去银行卡列表页
                    CHBankCardListViewController * vc = [[CHBankCardListViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
//                [self realName];
                [CNManager showWindowAlert:@"请先进行实名认证"];
            }
            
            break;
        case 4:{
            CHEditPasswordViewController * vc = [[CHEditPasswordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 5:
            [self moneyCode];
            break;
        default:
            break;
    }
}

- (void)moneyCode{
    CHEditMoneyCodeViewController *vc = [[CHEditMoneyCodeViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bankCode{
    
}

- (void)showEditName{
    return;
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"修改用户名" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.alertViewStyle = UIAlertViewStylePlainTextInput;
    al.tag = 200;
    [al show];
}

- (void)realName:(BOOL)x{
    if (x) {
        CHBankCardViewController * vc = [[CHBankCardViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        CHTureNameViewController * vc = [[CHTureNameViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"实名认证" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
////    tfName = [al textFieldAtIndex:0];
////    tfName.placeholder = @"请输入姓名";
////    tfCode = [al textFieldAtIndex:1];
////    tfCode.placeholder = @"请输入身份证号";
//    al.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//
//    al.tag = x?202:201;
//
//    [al show];
//    tfName = [al textFieldAtIndex:0];
//    tfName.placeholder = @"请输入姓名";
//    tfCode = [al textFieldAtIndex:1];
//    tfCode.keyboardType = UIKeyboardTypeNumberPad;
//    tfCode.placeholder = x?@"请输入银行卡号":@"请输入身份证号";
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    if (alertView.tag == 200) {
        if ([alertView textFieldAtIndex:0].text.length > 2 && [alertView textFieldAtIndex:0].text.length < 15) {
//            [_dataArray removeObjectAtIndex:0];
//            [_dataArray insertObject:[alertView textFieldAtIndex:0].text atIndex:0];
            return YES;
        }
    }
    if (alertView.tag == 201) {
        if ([alertView textFieldAtIndex:0].text.length > 1 && [alertView textFieldAtIndex:1].text.length > 0) {
//            [CNManager saveObject:@"1" byKey:REALNAME];
//            [_dataArray removeObjectAtIndex:2];
//            [_dataArray insertObject:@"已实名" atIndex:2];
            return YES;
        }
    }
    if (alertView.tag == 202) {
        if ([alertView textFieldAtIndex:0].text.length > 1 && [alertView textFieldAtIndex:1].text.length > 0) {
//            [CNManager saveObject:@"1" byKey:REALNAME];
//            [_dataArray removeObjectAtIndex:3];
//            [_dataArray insertObject:@"已绑定" atIndex:3];
            return YES;
        }
    }
    
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        if (alertView.tag == 200) {
            [CNManager saveObject:[alertView textFieldAtIndex:0].text byKey:USERNAME];
            [self changeNickName:[alertView textFieldAtIndex:0].text];
        }
        if (alertView.tag == 201) {
//            if ([alertView textFieldAtIndex:0].text.length > 1 && [alertView textFieldAtIndex:1].text.length > 0) {
                [CNManager saveObject:@"1" byKey:REALNAME];
//                [_dataArray removeObjectAtIndex:2];
//                [_dataArray insertObject:@"已实名" atIndex:2];
//                return YES;
//            }
        }
        if (alertView.tag == 202) {
                [CNManager saveObject:@"1" byKey:REALNAME];
//                [_dataArray removeObjectAtIndex:3];
//                [_dataArray insertObject:@"已绑定" atIndex:3];
        }
        [self upDate];
    }
}

- (void)upDate{
    WEAKSELF
    [CHGetStockNum getUserInfobyPhone:[CNManager loadByKey:USERPHONE] Success:^(NSDictionary * _Nonnull userDic) {
        weakself.userDic =userDic;
        [weakself refreshUI];
    }];
}
- (void)refreshUI{
    NSMutableString * real ;
    if ([CNManager hasRealName]) {
        real = [[NSMutableString alloc]initWithString: [CNManager loadByKey:REALCODE]];
        if (real.length > 10) {
            [real replaceCharactersInRange:NSMakeRange(4, real.length - 8) withString:@"**********"];
        }
    }else{
        real = [[NSMutableString alloc]initWithString: @"未实名"];
    }
    self.dataArray = [[NSMutableArray alloc]initWithArray:@[[CNManager loadByKey:USERNAME]?:@"",[CNManager loadByKey:USERPHONE]?:@"",real,[CNManager loadByKey:BANKCARD]?@"已绑定":@"未绑定",@"修改",[CNManager loadByKey:MONEYCODE]?@"修改":@"未设置",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [_tableView reloadData];
    
}

- (void)setupNav{
    self.view.backgroundColor=UIColorFromRGB(0xefefef);
    self.title= @"设置";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 40, 40);
    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [backButton setImage:[UIImage imageNamed:@"back-btn"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem* moreItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    moreItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = moreItem;
    
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logOffBtnAction{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [choiceSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 DLog(@"Picker View Controller is presented");
                             }];
        }
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 DLog(@"Picker View Controller is presented");
                             }];
        }
    } else {
        
    }
    
    
}

- (BOOL) isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) canUserPickVideosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) canUserPickPhotosFromPhotoLibrary {
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]) {
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        
        CropperViewController *imgCropperVC = [[CropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark -
#pragma mark - VPImageCropperDelegate

- (void)imageCropper:(CropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [_headPhoto setBackgroundImage:editedImage forState:UIControlStateNormal];
    [self cropImageFinish:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)cropImageFinish:(UIImage *)image {
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    UIImage *newImage = nil;
    CGFloat maxSize = 80;
//    if ((width > maxSize) || (height > maxSize)) {
//
//        newImage = [CNManager scaleToFillSize:CGSizeMake(maxSize, maxSize) image:image]; //UIImage+Resizing.h
//    } else {
        newImage = image;
//    }
    NSData *binaryImageData = UIImagePNGRepresentation(newImage);
    [self p_uploadUserAvatar:binaryImageData];
}

- (void)imageCropperDidCancel:(CropperViewController *)cropperViewController {
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark -
#pragma mark - image scale utility

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) DLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)p_uploadUserAvatar:(NSData *)data {
    [CNManager saveObject:data byKey:LOGINUSERPHOTO];
    NSString *imgStr = [[GTMBase64 stringByEncodingData:data] URLEncodedString];
//    [[GTMBase64 stringByEncodingData:data] URLEncodedString]
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    //更新头像，参数说明：photo_content base64图片 photo_extension 扩展名 id 用户ID
    [dataDict setObject:imgStr forKey:@"photo_content"];
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"id"];
        [dataDict setObject:@"png" forKey:@"photo_extension"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/member/UploadPhoto",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
                    [CNManager saveObject:data byKey:LOGINUSERPHOTO];
                }
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
        NSLog(@"error slider");
    }];
    

}

- (NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

#pragma mark networking

- (void)changeNickName:(NSString *)nickName{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:nickName forKey:@"newName"];
    [dataDict setObject:[CNManager loadByKey:USERID] forKey:@"id"];
    //    [dataDict setObject:_name.text forKey:@"nick_name"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/member/updateMember",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                [CNManager showWindowAlert:@"修改成功"];
                
                
            }else{
                [CNManager showWindowAlert:responseObject[@"msg"]];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"操作失败"];
        NSLog(@"error slider");
    }];
    
    
    
}


@end
