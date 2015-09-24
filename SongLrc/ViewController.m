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
@interface ViewController ()
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
    [self play];
    
    
    
}
-(void)play
{
    _parse=[[ParsingLyrics alloc] init];
    [_parse readSongLrcsByFilepath:[[NSBundle mainBundle]pathForResource:@"贝加尔湖畔" ofType:@"lrc" ]];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(nslogLrcxin) userInfo:self repeats:YES];
    NSString *str=[[NSBundle mainBundle] pathForResource:@"贝加尔湖畔" ofType:@"mp3" ];
    NSURL *url= [NSURL fileURLWithPath:str];
    _audio=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_audio prepareToPlay];
    [_audio play];
    
}
-(void)nslogLrcxin
{
    static NSInteger index=-1;
    NSInteger s=[_parse returnSongLrcAccordingToTime:_audio.currentTime];
    if (s!=index) {
        index=s;
        LrcModel *m=_parse.dataArr[s];
        NSLog(@"%@",m.lrcstr);
    } ;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
