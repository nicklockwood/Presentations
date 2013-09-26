//
//  VideoView.m
//  Presentation
//
//  Created by Nick Lockwood on 21/08/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "VideoView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>


@implementation VideoView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (void)awakeFromNib
{
    //get video URL
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"ship"
                                         withExtension:@"mp4"];
    
    //create player
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    playerLayer.player = [AVPlayer playerWithURL:URL];
    playerLayer.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
}

- (void)didMoveToWindow
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    
    if (self.window)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerLayer.player.currentItem];
        
        //play the video
        [playerLayer.player play];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:nil];
        
        //stop the video
        [playerLayer.player pause];
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    //loop
    AVPlayer *player = [notification object];
    [player seekToTime:kCMTimeZero];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
