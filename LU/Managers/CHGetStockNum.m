//
//  CHGetStockNum.m
//  LU
//
//  Created by peng jin on 2019/6/4.
//  Copyright © 2019 JinPeng. All rights reserved.
//

#import "CHGetStockNum.h"

@implementation CHGetStockNum

+ (void)getDetailStocks:(NSArray *)stocksNums Success:(void (^)(NSArray *array))success{
    success(nil);
    NSString *URLString = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=s_%@",[stocksNums componentsJoinedByString:@",s_"]];
    NSDictionary *parameters = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
//        DLog(@"%@ %@", responseObject, operation.originalRequest.URL);
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                        NSString *response = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:enc];
                        NSArray * tmpArr = [response componentsSeparatedByString:@"\""];
                        NSMutableArray * array = [[NSMutableArray alloc]init];
                        for (int i = 0; i<tmpArr.count; i++) {
                            if (i % 2 == 1) {
                                [array addObject:[tmpArr[i] componentsSeparatedByString:@","]];
                            }
                        }
            //            NSArray * array = @[response];
                        success(array);
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        DLog(@"Error: %@", error);
    }];
}


+ (void)getMarketIndexesSuccess:(void (^)(NSArray *array))success{
    NSString *URLString = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=s_sh000001,s_sz399001,s_sz399006"];
    NSDictionary *parameters = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
//        DLog(@"%@ %@", responseObject, operation.originalRequest.URL);
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *response = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:enc];
            NSArray * tmpArr = [response componentsSeparatedByString:@"\""];
            NSMutableArray * array = [[NSMutableArray alloc]init];
            for (int i = 0; i<tmpArr.count; i++) {
                if (i % 2 == 1) {
                    [array addObject:[tmpArr[i] componentsSeparatedByString:@","]];
                }
            }
//            NSArray * array = @[response];
            success(array);
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        DLog(@"Error: %@", error);
    }];
}
+ (void)getStock:(NSString *)stocksNum Success:(void (^)(NSDictionary * _Nonnull))success{
    NSString *URLString = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=s_%@",stocksNum];
    NSDictionary *parameters = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
//        DLog(@"%@ %@", responseObject, operation.originalRequest.URL);
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *response = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:enc];
            NSArray * tmpArr = [response componentsSeparatedByString:@"\""];
//            NSMutableArray * array = [[NSMutableArray alloc]init];
            NSDictionary * dic =@{@"name":@"",@"price":@"0.00",@"per":@"0.00",@"change":@"0.00"};
            if (tmpArr.count>=2) {
                NSArray * tmp2Arr=[tmpArr[1] componentsSeparatedByString:@","];
                if (tmp2Arr.count>=4) {
                    dic = @{@"name":tmp2Arr[0],@"price":tmp2Arr[1],@"per":tmp2Arr[3],@"change":tmp2Arr[2]};
                }
            }
            
//            [array addObject:dic];
            //            NSArray * array = @[response];
            success(dic);
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        DLog(@"Error: %@", error);
    }];
}
+ (void)getStocks:(NSArray *)stocksNums Success:(void (^)(NSArray *array))success{
    success(nil);
    NSString *URLString = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=s_%@",[stocksNums componentsJoinedByString:@",s_"]];
    NSDictionary *parameters = nil;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
//        DLog(@"%@ %@", responseObject, operation.originalRequest.URL);
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *response = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:enc];
            NSArray * tmpArr = [response componentsSeparatedByString:@"\""];
            NSMutableArray * array = [[NSMutableArray alloc]init];
            for (int i = 0; i<tmpArr.count; i++) {
                if (i%2 == 1) {
                    NSArray * tmp2Arr=[tmpArr[i] componentsSeparatedByString:@","];
                    NSDictionary * dic =@{@"price":@"0.00",@"per":@"0.00"};
                    if (tmp2Arr.count>=4) {
                        dic = @{@"price":tmp2Arr[1],@"per":tmp2Arr[3]};
                    }
                    [array addObject:dic];
                }
            }
            //            NSArray * array = @[response];
            success(array);
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        DLog(@"Error: %@", error);
    }];
}

+ (void)getShotMessage:(NSString *)phone type:(NSInteger)type Success: (void (^)(NSString * meg))success
{
    
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:phone forKey:@"telphone"];
    [dataDict setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"state"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/member/sendMsg",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
//    WEAKSELF
    
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
                    NSString * str = dic[@"code"];
                    success(str);
                }
                
            }else{
                [CNManager showWindowAlert:@"获取验证码失败"];
            }
        }
        //        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CNManager showWindowAlert:@"获取验证码失败"];
        NSLog(@"error slider");
    }];
}

+ (void)getUserInfobyPhone:(NSString *)phone Success:(void (^)(NSDictionary * _Nonnull))success{
    if (!phone.length) {
        [CNManager showWindowAlert:@"获取用户信息失败，请先登录"];
        return;
    }
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:phone forKey:@"phone"];
    //    [dataDict setObject:_password.text forKey:@"password"];
    //    [dataDict setObject:_name.text forKey:@"nick_name"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/member/getMemberInfo",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    //    WEAKSELF
    
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
                    NSDictionary * userdic = dic[@"memberInfo"];
                    if (userdic[@"id"]) {
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"id"]] byKey:USERID];
                    }
                    
                    [CNManager saveObject:phone byKey:USERPHONE];
                    
                    if (userdic[@"nick_name"]&&[userdic[@"nick_name"] length])
                    [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"nick_name"]] byKey:USERNAME];
                    
                    if (userdic[@"money"])
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"money"]] byKey:MONEY];
                    else
                        [CNManager saveObject:@"0" byKey:MONEY];
                    
                    if (userdic[@"tx_pwd"])
                        [CNManager saveObject:@"1" byKey:MONEYCODE];
                    else
                        [CNManager saveObject:nil byKey:MONEYCODE];
                    
                    if (userdic[@"rules"])
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"rules"]] byKey:RULES];
                    
                    if (userdic[@"realname"]&&[userdic[@"realname"] length])
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"realname"]] byKey:REALNAME];
                    else
                        [CNManager saveObject:nil byKey:REALNAME];
                    
                    if (userdic[@"idcard"]&&[userdic[@"idcard"] length])
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"idcard"]] byKey:REALCODE];
                    else
                        [CNManager saveObject:nil byKey:REALCODE];
                    
                    if (userdic[@"card"]&&[userdic[@"card"] length]){
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"card"]] byKey:BANKCARD];
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"bank_name"]] byKey:BANKNAME];
                    }else{
                        [CNManager saveObject:nil byKey:BANKCARD];
                        [CNManager saveObject:nil byKey:BANKNAME];
                    }
                    success(userdic);
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

+ (void)getUserPlanSuccess:(void (^)(NSDictionary *planDic))success{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
//    [dataDict setObject:phone forKey:@"phone"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/rules/getActivityRules",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    //    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
//                    NSDictionary * userdic = dic[@"memberInfo"];
                    success(dic);
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

+ (void)getUserPlan:(NSString *)phone Success:(void (^)(NSDictionary *planDic))success{
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:phone forKey:@"phone"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/rules/getDefaultRules",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    //    WEAKSELF
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    __weak CNDetailWebViewController * weakSelf = self;
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue]==0) {
                NSString * ref = [NSString stringWithFormat:@"%@",responseObject[@"ref"]];
                NSString * data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
                if ([data length]&&[ref length]&&(data)&&(ref)) {
                    JKEncrypt * en1 = [[JKEncrypt alloc]init];
                    NSString * str1 =   [en1 doDecEncryptStr:data withKey:ref];
                    
                    NSDictionary * dic = [CNManager dictionaryWithJsonString:str1];
//                    NSDictionary * userdic = dic[@"memberInfo"];
                    success(dic);
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

+ (void)getUserInfobyPhone:(NSString *)phone{
    if (!phone.length) {
    [CNManager showWindowAlert:@"获取用户信息失败，请先登录"];
    return;
}
    JKEncrypt * en = [[JKEncrypt alloc]init];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NewSettingsManager getGeneralParameters]];
    [dataDict setObject:phone forKey:@"phone"];
//    [dataDict setObject:_password.text forKey:@"password"];
    //    [dataDict setObject:_name.text forKey:@"nick_name"];
    NSString *dataString = [CNManager convertToJsonData:dataDict];
    [dataString URLEncodedString];
    NSString *dataStringEncoded = [en doEncryptStr: dataString] ;
    NSString *URLString =[NSString stringWithFormat:@"http://%@/Api/member/getMemberInfo",
                          [NewSettingsManager applicationServerURL]];
    NSDictionary *parameters = @{@"data": dataStringEncoded,
                                 @"ref": gkey};
    
    //    WEAKSELF
    
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
                    NSDictionary * userdic = dic[@"memberInfo"];
                   
                    if (userdic[@"id"]) {
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"id"]] byKey:USERID];
                    }
                    
                    [CNManager saveObject:phone byKey:USERPHONE];
                    
                    if (userdic[@"nick_name"]&&[userdic[@"nick_name"] length])
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"nick_name"]] byKey:USERNAME];
                    
                    if (userdic[@"money"])
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"money"]] byKey:MONEY];
                    else
                        [CNManager saveObject:@"0" byKey:MONEY];
                    
                    if (userdic[@"tx_pwd"])
                        [CNManager saveObject:@"1" byKey:MONEYCODE];
                    else
                        [CNManager saveObject:nil byKey:MONEYCODE];
                    
                    if (userdic[@"rules"])
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"rules"]] byKey:RULES];
                    
                    if (userdic[@"realname"]&&[userdic[@"realname"] length])
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"realname"]] byKey:REALNAME];
                    else
                        [CNManager saveObject:nil byKey:REALNAME];
                    
                    if (userdic[@"idcard"]&&[userdic[@"idcard"] length])
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"idcard"]] byKey:REALCODE];
                    else
                        [CNManager saveObject:nil byKey:REALCODE];
                    
                    if (userdic[@"card"]&&[userdic[@"card"] length]){
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"card"]] byKey:BANKCARD];
                        [CNManager saveObject:[NSString stringWithFormat:@"%@", userdic[@"bank_name"]] byKey:BANKNAME];
                    }else{
                        [CNManager saveObject:nil byKey:BANKCARD];
                        [CNManager saveObject:nil byKey:BANKNAME];
                    }
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

@end
