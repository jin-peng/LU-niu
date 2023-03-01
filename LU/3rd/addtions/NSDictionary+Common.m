//
//  NSDictionary+Common.m
//  CloudApp
//
//  Created by 周良才 on 16/11/21.
//  Copyright © 2016年 Flybor. All rights reserved.
//

#import "NSDictionary+Common.h"

@implementation NSDictionary (Common)


- (NSDictionary *)sortByKey{
    NSArray *keys = [self.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i = 0; i<keys.count; i++) {
        [dict setObject:self[keys[i]] forKey:keys[i]];
    }
    return dict;
}
- (NSString *)getDictStringAndSortByKey{
    NSArray *keys = [self.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *appendString = @"";
    NSString *receiveString = @"";
    for (int i = 0; i<keys.count; i++) {
        receiveString = [NSString stringWithFormat:@"%@=%@",keys[i],self[keys[i]]];
        if (appendString.length == 0) {
            appendString = receiveString;
        }else{
            appendString = [NSString stringWithFormat:@"%@&%@",appendString,receiveString];
        }
    }
    return appendString;
    
}


- (NSArray *)getSortNKeyArrayFromDict{
    
    return [self.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if (obj1 && obj2)
        {
            if ([obj1 integerValue] < [obj2 integerValue])
                return NSOrderedAscending;
            
            else if ([obj1 integerValue] > [obj2 integerValue])
                return NSOrderedDescending;
            
            else
                return NSOrderedSame;
        }
        else
            return NSOrderedSame;
    }];
}
- (NSArray *)getArrayFromSortKeyNDict{
    NSMutableArray *sortData = [NSMutableArray array];

    NSArray *sortedArr = [self getSortNKeyArrayFromDict];
//    NSLog(@"%@",sortedArr);
    for (int i = 0; i<sortedArr.count; i++) {
        [sortData addObject:self[sortedArr[i]]];
    }

    
    return sortData;
}

- (NSArray *)getArrayFromSortKeyDict{
    NSMutableArray *sortData = [NSMutableArray array];
    NSArray *keys = [self.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
//    NSLog(@"%@",keys);
    
    for (int i = 0; i<keys.count; i++) {
        [sortData addObject:self[keys[i]]];
    }
    return sortData;
    
}
- (BOOL)containsKey:(NSString *)key{
    for (id obj in self.allKeys) {
        NSString *ob = [NSString stringWithFormat:@"%@",obj];
        if ([ob isEqualToString:key]) {
            return YES;
        }
    }
    return NO;
}
@end
