//
//  TenMainMaterialModel.h
//  装立方
//
//  Created by 广州动创 on 16/5/16.
//  Copyright © 2016年 广州动创. All rights reserved.
//

#import "BaseModel.h"

@interface TenMainMaterialModel : BaseModel

/*
 {"pageSize":999,"pageNO":1,"pageCount":1,"rowCount":4,"list":
    [{"fid":146,"fname":"大自然 银丝龙芭杜","fimg":"I3Szv2AP5xcmMFNM.jpg","ftypeId":10,"fpriceEx":0.0,"fbrand":"大自然","fisDef":1,"fmodel":"VJ20081","fspec":"805*125*12.2mm","fprice":216.0,"funit":"㎡","fdesc":"","fmimg":""},
      {"fid":208,"fname":"大自然 番龙眼 ","fimg":"v7lV3Sa9LfzVAzWp.gif","ftypeId":10,"fpriceEx":210.0,"fbrand":"大自然","fisDef":0,"fmodel":"D069C","fspec":"610*122*18mm","fprice":508.0,"funit":"㎡","fdesc":"天生好木，取材独到，曾领略巴西亚马逊的广袤，专心治木20年  细节体现价值，尊贵一目了然，以20年的福于经验的专业视角探寻世界优质可采木材。","fmimg":""},
 */


@property(nonatomic,copy)NSString *fid;
@property(nonatomic,copy)NSString *fname;
@property(nonatomic,copy)NSString *fimg;
@property(nonatomic,copy)NSString *ftypeId;
@property(nonatomic,copy)NSString *fpriceEx; //0.0
@property(nonatomic,copy)NSString *fbrand; //fbrand
@property(nonatomic,copy)NSString *fisDef; //fisDef
@property(nonatomic,copy)NSString *fmodel; //VJ20081
@property(nonatomic,copy)NSString *fspec; //805*125*12.2mm


@end
