# UpTool
七牛上传的使用，包含断点续传
1,添加上传，需要将UpModel实例化并给(必要的)属性赋值</br>
然后<br/>
[[UpCenter shareInstance]add:upModel]

2，删除<br/>
[[UpCenter shareInstance]del:upModel]; 。<br/>
3，暂停</br>
[[UpCenter shareInstance] pause:upLoadModel]；。<br/>
4，重试</br>
[[UpCenter shareInstance] tryAgain:upLoadModel] 。<br/>
5，读取所有上传的Model并开始上传</br>
[[UpCenter shareInstance] read]</br>
注：若只想读取所有上传的Model可直接使用UpCenter实例的downInfoGroup属性<br/>
6，代理<br/>
_upCenter =[ UpCenter shareInstance];<br/>
_upCenter.delegate = self;<br/>


-(void)downProgress:(UpModel *)taskEntity{<br/>
    NSUInteger index= [self.loadingList indexOfObject:taskEntity];<br/>
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];<br/>
    UpLoadingCell *cell=[self.listTable cellForRowAtIndexPath:indexPath];<br/>
    cell.upLoadModel=taskEntity;<br/>
    //reaload会造成cell不可操作
}<br/>

-(void)downSuccess:(UpModel *)taskEntity{<br/>
   
}</br>

-(void)downError:(UpModel *)taskEntity{</br>
   
}</br>

down还没该名称为up，不好意思。。
