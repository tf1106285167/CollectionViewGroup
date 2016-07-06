//
//  BaseModel.m
//  MovieProject
//
//  Created by 玉女峰峰主 on 15-10-28.
//  Copyright (c) 2015年 玉女峰峰主. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(id)initWithDict:(NSDictionary *)dic{
    
    if (self=[super init]) {
        
        [self buildRelationShip:dic];
    }
 
    return self;
}


-(SEL)changeKeyStrToSetKey:(NSString *)key{
    
        //2.获得key字符串里面的第一个字母然后大写
    NSString *firstStr=[[key substringToIndex:1] uppercaseString];
    NSString *lastStr=[key substringFromIndex:1];
    NSString *setStr=nil;
    
    //拼接字符串
    if ([key isEqualToString:@"id"]) {
        
        //NSStringFromClass([self class])将本类的类名转化成字符串
        setStr=[NSString stringWithFormat:@"set%@%@%@:",NSStringFromClass([self class]),firstStr,lastStr];
//        TFLog(@"%@",setStr);
        
    }else{
        
        setStr=[NSString stringWithFormat:@"set%@%@:",firstStr,lastStr];
    }
    //   3. NSSelectorFromString 把字符串转化成方法
    return NSSelectorFromString(setStr);
}



-(void)buildRelationShip:(NSDictionary *)dict{
    
    /*
     1.拿到字典里面所有的key
     2.拼接字符串类型的setKey方法
     3.把setKey字符串转化成方法
     4.把字典里面的value值设置给model
     */
    
    //1.拿到字典里面所有的key
    NSArray *allkeys=[dict allKeys];
    
    for (NSString *key in allkeys) {
        
        SEL method=[self changeKeyStrToSetKey:key];
        
        id value=dict[key];
    
        if ([self respondsToSelector:method]) {
            
            [self performSelector:method withObject:value];
        }
    
    }
    
    
}

@end
