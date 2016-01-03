//
//  UpCenter.h
//  Qi
//
//  Created by 阳璟 on 15/11/26.
//  Copyright © 2015年 Yangjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpModel.h"
/**
 *  上传中心代理
 */
@protocol upDelegate <NSObject>

/**
 *  进度更新
 *
 *  @param taskEntity taskEntity description
 */
-(void)upProgress:(UpModel *)taskEntity;

/**
 *  上传成功
 *
 *  @param taskEntity taskEntity description
 */
-(void)upSuccess:(UpModel *)taskEntity;

/**
 *  上传失败
 *
 *  @param taskEntity taskEntity description
 */
-(void)upError:(UpModel *)taskEntity;

@end

@interface UpCenter : NSObject
@property(nonatomic,copy) NSMutableArray *upInfoGroup;//上传列表
@property(nonatomic,weak) id<upDelegate> delegate;//代理
+(instancetype) shareInstance;

/**
 *  新增
 *
 *  @param url   url description
 *  @param title title description
 */
- (void)add:(UpModel *)upEntity;

/**
 *  暂停/取消
 *
 *  @param upEntity upEntity description
 */
-(void) pause:(UpModel *)upEntity;

/**
 *  开始/继续
 *
 *  @param upEntity upEntity description
 */
-(void) resume:(UpModel *)upEntity;

/**
 *  重试
 *
 *  @param upEntity upEntity description
 */
- (void)tryAgain:(UpModel *)upEntity;

/**
 *  保存
 */
- (void)save;

/**
 *  删除
 *
 *  @param upEntity upEntity description
 */
- (NSMutableArray *)del:(UpModel *)upEntity;

/**
 *  读取
 *
 *  @return return 下载列表
 */
-(NSMutableArray *) read;
@end
