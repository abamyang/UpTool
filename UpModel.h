//
//  UpModel.h
//  Qi
//
//  Created by 阳璟 on 15/11/26.
//  Copyright © 2015年 Yangjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpTask.h"


@interface UpModel : NSObject
//必须字段
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *key;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) UpTask *task;
@property(nonatomic,strong) NSNumber *progress;
@property(nonatomic,strong) NSNumber *state;//0上传中1暂停5完成6错误
@property(nonatomic,strong) NSError *error;
@property(nonatomic,strong) NSNumber *isAlbumVedio; //1是来自相册

// 图片
@property (nonatomic, copy) NSData *imgData;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *typeId;
@property(nonatomic,strong) NSString *playList;
@property(nonatomic,strong) NSNumber *isSharetoWB; //1是分享到微博
@property(nonatomic,strong) NSNumber *isSharetoFB; //1是分享到FB
@property(nonatomic,strong) NSNumber *imgTime; //1是分享到FB
@property(nonatomic,strong) NSNumber *is_open; //1是加锁
@end
