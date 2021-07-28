//
//  SoundfyPlayer.h
//  Soundfy
//
//  Created by Vinicius Mesquita on 19/07/21.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundfyPlayer: NSObject <AVAudioPlayerDelegate> {
    double volume;
    NSString *soundName;
}
@property(nonatomic, readwrite) double _volume;
- (void)playSound:(NSString *)soundName;
@end
