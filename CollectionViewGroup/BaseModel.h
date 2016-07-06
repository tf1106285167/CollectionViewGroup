//
//  BaseModel.h
//  MovieProject
//
//  Created by 玉女峰峰主 on 15-10-28.
//  Copyright (c) 2015年 玉女峰峰主. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//拼接setKey方法，然后把值设置给model
-(id)initWithDict:(NSDictionary *)dic;

@end
