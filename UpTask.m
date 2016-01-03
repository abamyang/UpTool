//
//  UpTask.m
//  Qi
//
//  Created by 阳璟 on 15/11/26.
//  Copyright © 2015年 Yangjing. All rights reserved.
//

#import "UpTask.h"
#import <QiniuSDK.h>
#define UPLOADINFOPATH [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"vedio"]

//相册库

@implementation UpTask
-(void)up:(NSString *)token  path:(NSString *)path key:(NSString *) key assetsLibrary:(ALAssetsLibrary *)assetsLibrary isAlbumVedio:(BOOL) isAlbumVedio
{
    //dispatch_async(dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT), ^{
        
    
    QNFileRecorder *file = [QNFileRecorder fileRecorderWithFolder:[NSTemporaryDirectory() stringByAppendingString:@"qiniutest"] error:nil];
    __block BOOL flag=NO;
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler: ^(NSString *key, float percent)
    {
        
        flag=[self.isFlag intValue]==1;
        NSLog(@"progress %f", percent);
        if(self.progressAction)
        {
            flag=self.progressAction(percent);
        }
    } params:nil checkCrc:NO cancellationSignal: ^BOOL ()
    {
        return flag;
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithRecorder:file];
    
    if(isAlbumVedio)
    {
        [assetsLibrary assetForURL:[NSURL URLWithString:path] resultBlock:^(ALAsset *assetA)
         {
             [upManager putALAsset:assetA
                               key:key
                             token:token
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
              {
                  NSLog(@"---%@",info);
                  NSLog(@"===%@",resp);
                  
                  if(info.error&&info.error.code!=-999){
                      NSLog(@"%@", info.error.userInfo[@"error"]);
                      NSLog(@"%@", info.error.userInfo[@"NSLocalizedDescription"]);
                      if(self.errorAction)
                      {
                          self.errorAction(info.error);
                      }
                  }
                  if(resp&&self.successAction){
                      self.successAction(resp);
                  }
              } option:opt];
         } failureBlock:^(NSError *error)
         {
             
         }];
        
    }
    else
    {
        [upManager putFile:[UPLOADINFOPATH stringByAppendingPathComponent:path]  key:key token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
        {
                      if(info.error&&info.error.code!=-999)
                      {
                          NSLog(@"%@", info.error.userInfo[@"error"]);
                          NSLog(@"%@", info.error.userInfo[@"NSLocalizedDescription"]);
                          if(self.errorAction)
                          {
                              self.errorAction(info.error);
                          }
                      }
                      if(self.successAction)
                      {
                          self.successAction(resp);
                      }
                      //NSLog(@"%@", resp);
                  } option:opt];
    }
    //});
}




@end
