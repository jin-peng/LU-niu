//
//  NSDictionary+Common.h
//  CloudApp
//
//  Created by 周良才 on 16/11/21.
//  Copyright © 2016年 Flybor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Common)

- (NSDictionary *)sortByKey;
//获取词典字符串，字符串key按字母排序
- (NSString *)getDictStringAndSortByKey;

//key全为数字
- (NSArray *)getSortNKeyArrayFromDict;
//key全为数字
- (NSArray *)getArrayFromSortKeyNDict;
////key为字母
- (NSArray *)getArrayFromSortKeyDict;


- (BOOL)containsKey:(NSString *)key;
@end
