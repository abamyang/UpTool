//
//  UpModel.m
//  Qi
//
//  Created by 阳璟 on 15/11/26.
//  Copyright © 2015年 Yangjing. All rights reserved.
//

#import "UpModel.h"

@implementation UpModel

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.key forKey:@"key"];
    [encoder encodeObject:self.fileName forKey:@"fileName"];
    [encoder encodeObject:self.progress forKey:@"progress"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.error forKey:@"error"];
    [encoder encodeObject:self.imgData forKey:@"imgData"];
    [encoder encodeObject:self.isAlbumVedio forKey:@"isAlbumVedio"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.type forKey:@"typeId"];
    [encoder encodeObject:self.type forKey:@"imgTime"];
    [encoder encodeObject:self.type forKey:@"is_open"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.key = [decoder decodeObjectForKey:@"key"];
        self.fileName = [decoder decodeObjectForKey:@"fileName"];
        self.progress = [decoder decodeObjectForKey:@"progress"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.error = [decoder decodeObjectForKey:@"error"];
        self.imgData = [decoder decodeObjectForKey:@"imgData"];
        self.isAlbumVedio = [decoder decodeObjectForKey:@"isAlbumVedio"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.type = [decoder decodeObjectForKey:@"typeId"];
        self.type = [decoder decodeObjectForKey:@"imgTime"];
        self.type = [decoder decodeObjectForKey:@"is_open"];
    }
    return  self;
}

@end
