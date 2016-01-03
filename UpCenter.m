//
//  UpCenter.m
//  Qi
//
//  Created by 阳璟 on 15/11/26.
//  Copyright © 2015年 Yangjing. All rights reserved.
//

#import "UpCenter.h"
#import "UpTask.h"
#import "UploadInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ShareUtils.h"

#define UPLOADINFOPATH [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"vedio"]
static ALAssetsLibrary *assetsLibrary;
@implementation UpCenter
+(instancetype) shareInstance{
    static UpCenter *upCenter=nil;
    static dispatch_once_t onceup;
    dispatch_once(&onceup, ^{
        upCenter = [[self alloc] init];
        upCenter.upInfoGroup=[[NSMutableArray alloc] init];
        assetsLibrary=[[ALAssetsLibrary alloc] init];
        [[NSFileManager defaultManager] createDirectoryAtPath: UPLOADINFOPATH attributes:nil];
        
        NSData *myEncodedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[UPLOADINFOPATH stringByAppendingPathComponent:@"uparchiver"]];
        if(myEncodedObject)
        {
            upCenter.upInfoGroup = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        }
        else
        {
            upCenter.upInfoGroup=[[NSMutableArray alloc] init];
        }
    });
    return upCenter;
}

/**
 *  新增
 *
 *  @param url   url description
 *  @param title title description
 */
- (void)add:(UpModel *)upEntity{
    if(upEntity)
    {
        NSPredicate *pre=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"fileName=='%@'",upEntity.fileName ]];
        NSArray *arr= [self.upInfoGroup filteredArrayUsingPredicate:pre];
        if(arr.count==0){
            upEntity.state=[NSNumber numberWithInt:0];
            upEntity.isAlbumVedio=upEntity.isAlbumVedio!=nil?upEntity.isAlbumVedio:[NSNumber numberWithInt:0];
            UpTask *upTask=[[UpTask alloc]init];
            [upTask up:upEntity.token path:upEntity.fileName
                   key:upEntity.key
         assetsLibrary:assetsLibrary
          isAlbumVedio:[upEntity.isAlbumVedio intValue]==1]
            ;
            upEntity.task=upTask;
            [self addBlocks:upEntity];
            
            [self.upInfoGroup addObject:upEntity];
        }
        else
        {
            UpModel *entity=arr.firstObject;
            entity.title=upEntity.title;
            //[upEntity.task start];
        }
        [self save];
    }
    
}

/**
 *  为下载任务添加回调
 *
 *  @param upEntity upEntity description
 */
-(void)addBlocks:(UpModel *)upEntity
{
    //if(self.delegate){return;}
    __block UpModel *blockupEntity=upEntity;
    if(!upEntity.task.progressAction)
    {
        upEntity.task.progressAction= ^(float percent)
        {
            
            blockupEntity.progress= [NSNumber numberWithFloat:percent];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if([self.delegate respondsToSelector:@selector(upProgress:)])
                               {
                                   [self.delegate upProgress:blockupEntity];
                               }
                           });
            BOOL flag=[blockupEntity.state intValue]==1;
            return flag;
            
        };
    }
    
    if(!upEntity.task.successAction)
    {
        
        upEntity.task.successAction=^(NSDictionary *resp)
        {
            blockupEntity.state=[NSNumber numberWithInt:5];
            float size=[self fileSizeAtKey:blockupEntity.fileName];
            [self toService:resp size:size upLoadModel:blockupEntity];
            
        };
        
    }
    
    if(!upEntity.task.errorAction)
    {
        upEntity.task.errorAction=^(NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               blockupEntity.state=[NSNumber numberWithInt:6];
                               blockupEntity.error=error;
                               if([self.delegate respondsToSelector:@selector(upError:)])
                               {
                                   [self.delegate upError:blockupEntity];
                               }
                           });
        };
    }
}

-(void) toService:(NSDictionary *) dic size:(float) size upLoadModel:(UpModel *)upLoadModel{
    if(dic){
        UploadInfo *uploadInfo=[[UploadInfo alloc] init];
        uploadInfo.hashcode=dic[@"hash"];//
        uploadInfo.duration=dic[@"duration"];//
        uploadInfo.key=dic[@"key"];//
        uploadInfo.width=dic[@"width"];//
        uploadInfo.height=dic[@"height"];//
        uploadInfo.video_name=upLoadModel.title;
        uploadInfo.video_content=upLoadModel.title;;
        uploadInfo.typetwo_name=upLoadModel.type;
        uploadInfo.typetwo_id=upLoadModel.typeId;
        uploadInfo.is_open=[upLoadModel.is_open intValue]==1?@"":@"open";//@"open";
        uploadInfo.user_id=@"12";//FIXME:注释了这行2015、12、16
        uploadInfo.bitrate=dic[@"bit_rate"];//
        //uploadInfo.locale_language=@"zh_CN";
        uploadInfo.rotate=dic[@"rotate"];//
        uploadInfo.imagetime=[NSNumber numberWithInt:2];
        uploadInfo.create_by_name=@"12";
        uploadInfo.specialedition=upLoadModel.playList;
        uploadInfo.imagetime=upLoadModel.imgTime;
        uploadInfo.validateKey=GetDataManager.userModel.validatekey;
        
        NSLog(@"%@",dic);
        [BaseModel postDataResponsePath:@"video/uploadvideo" params:[uploadInfo getDictionary] networkHUD:NetworkHUDBackground target:self success:^(StatusModel *data1) {
            if(data1.flag==1){
                upLoadModel.progress=[NSNumber numberWithFloat:1.0];
                upLoadModel.state=[NSNumber numberWithInt:5];
                if([self.delegate respondsToSelector:@selector(upSuccess:)])
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       [self.delegate upSuccess:upLoadModel];
                                       
                                   });
                    //成功了分享
                    ShareUtils *shareUtil = [[ShareUtils alloc]init];
                    NSDictionary *dic = [shareUtil getShareDictionaryWithTitle:@"标题" content:@"内容" imageUrl:@"" shareUrl:@""];
                    if([upLoadModel.isSharetoFB intValue]==1)
                    {
                        [shareUtil showShareMenuWithData:dic shareType:ShareTypeFacebook controller:nil];
                    }
                    if([upLoadModel.isSharetoWB intValue]==1)
                    {
                        [shareUtil showShareMenuWithData:dic shareType:ShareTypeSinaWeibo controller:nil];
                    }
                    
                    
                    
                    [self del:upLoadModel];
                }
            }
            else
            {
                upLoadModel.state=[NSNumber numberWithInt:6];
                NSError *error=[[NSError alloc] initWithDomain:@"up" code:400 userInfo:@{@"error":data1.msg}];
                upLoadModel.error=error;
                if([self.delegate respondsToSelector:@selector(upError:)])
                {
                    [self.delegate upError:upLoadModel];
                }
            }
        }];
    }
}

/**
 *  读取
 *
 *  @return return value description
 */
-(NSMutableArray *) read
{
    for(UpModel *upEntity in self.upInfoGroup)
    {
        if(upEntity.task)
        {
        }
        else
        {
            UpTask *upTask=[[UpTask alloc]init];
            [upTask up:upEntity.token path:upEntity.fileName
                   key:upEntity.key
         assetsLibrary:assetsLibrary
          isAlbumVedio:[upEntity.isAlbumVedio intValue]==1];
            upEntity.task=upTask;
        }
        
        [self addBlocks:upEntity];
        
    }
    return self.upInfoGroup;
}
/**
 *  暂停/取消
 *
 *  @param upEntity upEntity description
 */
-(void) pause:(UpModel *)upEntity
{
    upEntity.state=[NSNumber numberWithInt:1];
    upEntity.task=nil;
    [self save];
}

/**
 *  开始/继续
 *
 *  @param upEntity upEntity description
 */
-(void) resume:(UpModel *)upEntity{
    UpTask *upTask=[[UpTask alloc]init];
    [upTask up:upEntity.token path:upEntity.fileName
           key:upEntity.key
 assetsLibrary:assetsLibrary
  isAlbumVedio:[upEntity.isAlbumVedio intValue]==1];
    upEntity.task=upTask;
    upEntity.state=[NSNumber numberWithInt:0];
    [self addBlocks:upEntity];
    [self save];
}

/**
 *  重试
 *
 *  @param upEntity upEntity description
 */
- (void)tryAgain:(UpModel *)upEntity{
    upEntity.error=nil;
    [self pause:upEntity];
    [self resume:upEntity];
}



/**
 *  删除
 *
 *  @param upEntity upEntity description
 */
- (NSMutableArray *)del:(UpModel *)upEntity{
    [self pause:upEntity];
    //删除文件
    if([upEntity.isAlbumVedio intValue]!=1){
        [self deleteFile:upEntity.fileName];
    }
    [self.upInfoGroup removeObject:upEntity];
    [self save];
    return self.upInfoGroup;
}

-(void)deleteFile:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path= [UPLOADINFOPATH stringByAppendingPathComponent:fileName];
    BOOL res=[fileManager removeItemAtPath:path error:nil];
    if (res)
    {
        NSLog(@"文件删除成功");
    }else
        NSLog(@"文件删除失败");
}

-(void)save{
    NSData *itemsData = [NSKeyedArchiver archivedDataWithRootObject:self.upInfoGroup];
    NSString *filePath = [UPLOADINFOPATH stringByAppendingPathComponent:@"uparchiver"];
    BOOL success = [NSKeyedArchiver archiveRootObject:itemsData toFile:filePath];
    if(success){
        NSLog(@"归档成功");
    }
}

//获取文件大小
-(long long) fileSizeAtKey:(NSString*) fileName{
    float size=0.0f;
    NSString *path= [UPLOADINFOPATH stringByAppendingPathComponent:fileName];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path])
    {
        size= [[manager attributesOfItemAtPath:path error:nil] fileSize];
        
    }
    return size;
}


/**
 *  防止初始化成NSArray
 *
 *  @param upInfoGroup upInfoGroup description
 */
-(void)setUpInfoGroup:(NSMutableArray *)upInfoGroup
{
    _upInfoGroup=[upInfoGroup mutableCopy];
}
@end
