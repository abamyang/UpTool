# UpTool
七牛上传的使用，包含断点续传
1,添加上传，需要将UpModel实例化并给(必要的)属性赋值
然后
[[UpCenter shareInstance]add:upModel];
2，删除
[[UpCenter shareInstance]del:upModel];
3，暂停
[[UpCenter shareInstance] pause:upLoadModel]；
4，重试
[[UpCenter shareInstance] tryAgain:upLoadModel]
5，读取所有上传的Model并开始上传
[[UpCenter shareInstance] read]
注：若只想读取所有上传的Model可直接使用UpCenter实例的downInfoGroup属性
6，代理
_upCenter =[ UpCenter shareInstance];
_upCenter.delegate = self;


-(void)downProgress:(UpModel *)taskEntity{
    NSUInteger index= [self.loadingList indexOfObject:taskEntity];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    UpLoadingCell *cell=[self.listTable cellForRowAtIndexPath:indexPath];
    cell.upLoadModel=taskEntity;
    //reaload会造成cell不可操作
}

-(void)downSuccess:(UpModel *)taskEntity{
   
}

-(void)downError:(UpModel *)taskEntity{
   
}

down还没该名称为up，不好意思。。
