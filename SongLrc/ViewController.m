//
//  ViewController.m
//  SongLrc
//
//  Created by 韩金波 on 15/9/22.
//  Copyright (c) 2015年 Psylife. All rights reserved.
//

#import "ViewController.h"
#import "ParsingLyrics.h"
#import "LrcModel.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ParsingLyrics *_parse;
    AVAudioPlayer *_audio;
    __weak IBOutlet UITableView *tableview;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    
    tableview.delegate=self;
    tableview.dataSource=self;
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (indexPath.row==0) {
        cell.textLabel.text=@"贝加尔湖畔";
        
    }else{
        cell.textLabel.text=@"是否";
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self play:@"贝加尔湖畔"];
    }else{
         [self play:@"是否"];
    }
}
-(void)play:(NSString *)name
{
    _parse=nil;
    _parse=[[ParsingLyrics alloc] init];
    [_parse readSongLrcsByFilepath:[[NSBundle mainBundle]pathForResource:name ofType:@"lrc" ]];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(nslogLrcxin) userInfo:self repeats:YES];
    NSString *str=[[NSBundle mainBundle] pathForResource:name ofType:@"mp3" ];
    NSURL *url= [NSURL fileURLWithPath:str];
    _audio=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_audio prepareToPlay];
    [_audio play];
    
}
-(void)nslogLrcxin
{
    static NSString *ss=nil;;
    NSInteger s=[_parse returnSongLrcAccordingToTime:_audio.currentTime];

        LrcModel *m=_parse.dataArr[s];
    if (![ss isEqualToString:m.lrcstr]) {
        ss=m.lrcstr;
        NSLog(@"%f:%@",m.time,m.lrcstr);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
