//
//  UpTask.h
//  Qi
//
//  Created by 阳璟 on 15/11/26.
//  Copyright © 2015年 Yangjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UpTask : NSObject
@property(nonatomic,strong)NSNumber *isFlag; //0 NO
-(void)up:(NSString *)token  path:(NSString *)path key:(NSString *) key assetsLibrary:(ALAssetsLibrary *)assetsLibrary isAlbumVedio:(BOOL) isAlbumVedio ;
/**
 *  文件上传进度的回调块
 */
@property (nonatomic,copy) BOOL (^progressAction)(float progress);

/**
 *  文件上传成功的回调块
 */
@property (nonatomic,copy) void (^successAction)(NSDictionary *resp);

/**
 *  文件上传失败的回调块
 */
@property (nonatomic,copy) void (^errorAction)(NSError *error);
@end
