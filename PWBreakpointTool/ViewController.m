//
//  ViewController.m
//  PWBreakpointTool
//
//  Created by Tony_Zhao on 4/22/15.
//  Copyright (c) 2015 TonyZPW. All rights reserved.
//

#import "ViewController.h"
#import "DownloadTableViewCell.h"
#import "DownloadModel.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataList;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[DownloadTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self setUpDatas];
}

- (void)setUpDatas{
    NSMutableArray *mtArray = [NSMutableArray array];
    DownloadModel *model = [[DownloadModel alloc] init];
    model.fileName = @"file1";
    model.downloadUrl = @"http://nj.baidupcs.com/file/479c9bb2aa50699ddd8ca24ecb063453?bkt=p2-nb-196&fid=386762388-250528-1023117810320904&time=1429684749&sign=FDTAXERLBH-DCb740ccc5511e5e8fedcff06b081203-%2BfAQHJatNyQjuWiEKNlfjyaVck0%3D&to=nb&fm=Nan,B,T,t&newver=1&newfm=1&flow_ver=3&sl=80019532&expires=8h&rt=pr&r=179084536&mlogid=3046841989&vuk=386762388&vbdid=3403389969&fin=learning_opengl_es_for_ios.pdf&fn=learning_opengl_es_for_ios.pdf&slt=pm&uta=0";
    [mtArray addObject:model];
    
    DownloadModel *model2 = [[DownloadModel alloc] init];
    model2.fileName = @"file2";
    model2.downloadUrl = @"http://www.colorado.edu/conflict/peace/download/peace.zip";
    [mtArray addObject:model2];
    
    self.dataList = [mtArray copy];
    
    mtArray = nil;
    
    [self.tableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellID = @"Cell";
    
    DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    DownloadModel *model = self.dataList[indexPath.row];

    cell.downloadModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}


@end
