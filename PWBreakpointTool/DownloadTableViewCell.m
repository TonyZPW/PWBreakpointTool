//
//  DownloadTableViewCell.m
//  PWBreakpointTool
//
//  Created by Tony_Zhao on 4/22/15.
//  Copyright (c) 2015 TonyZPW. All rights reserved.
//

#import "DownloadTableViewCell.h"

@interface DownloadTableViewCell()
{
    BOOL hasAddObserver;
}

@end

@implementation DownloadTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.backgroundColor = [UIColor clearColor];
        self.downloadBtn = [DownloadButton buttonWithType:UIButtonTypeCustom];
        self.downloadBtn.frame = CGRectMake(self.frame.size.width - 10 - DOWNLOADBUTTONWIDTH, self.center.y - DOWNLOADBUTTONHEIGHT / 3, DOWNLOADBUTTONWIDTH, DOWNLOADBUTTONHEIGHT);
        self.downloadBtn.selected = NO;
        [self.downloadBtn addTarget:self action:@selector(controlDownload:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.downloadBtn];
    }
    return self;
}

- (void)controlDownload:(DownloadButton *)sender{
    
    sender.selected = !sender.selected;
    
    NSAssert(_downloadModel != nil, @"model is nil");
    
    if(sender.selected){

        [self.downloadModel downloadRequestWithUrl:[NSURL URLWithString:_downloadModel.downloadUrl] success:^{
            self.progress = 0;
            self.downloadBtn.selected = NO;
            [self.downloadBtn setTitle:@"下载完成" forState:UIControlStateNormal];
        } fail:^(NSError *error) {
              self.progress = 0;
            self.downloadBtn.selected = NO;
            [self.downloadBtn setTitle:@"下载失败" forState:UIControlStateNormal];
        }];
    }else{

        [self.downloadModel pauseTask];
        [self.downloadBtn setTitle:@"继续" forState:UIControlStateNormal];
    }
    
}

- (void)setDownloadModel:(DownloadModel *)downloadModel
{
    _downloadModel = downloadModel;
    
    self.textLabel.text = _downloadModel.fileName;
    
    NSAssert(_downloadModel != nil, @"DownloadModel can't be nil");
    
    if(!hasAddObserver){
        [_downloadModel addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
        hasAddObserver = YES;
    }
    
}

- (void)setProgress:(CGFloat)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downloadBtn.progress = progress;
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"progress"]){
        
        self.progress = [change[@"new"] floatValue];
    }
}

- (void)dealloc
{
    [self.downloadModel removeObserver:self forKeyPath:@"progress"];
}

@end
