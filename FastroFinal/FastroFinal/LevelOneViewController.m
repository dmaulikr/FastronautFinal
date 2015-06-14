//
//  LevelOneViewController.m
//  FastroFinal
//
//  Created by Ethan Hess on 5/16/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "LevelOneViewController.h"
#import "SoundController.h"
#import <math.h>

static inline double radians (double degrees) {return degrees * M_PI/180;}

int obstaclePosition;
int coinPosition;
int fastroFlight;
int score; 

@interface LevelOneViewController ()

@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIButton *youDiedButton;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;

@property (weak, nonatomic) IBOutlet UIImageView *obstacleView;

@property (weak, nonatomic) IBOutlet UIImageView *fastronaut;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coin;

//@property (nonatomic, assign) int score;
@property (nonatomic, strong) NSTimer *fastroTimer;
@property (nonatomic, strong) NSTimer *obstacleTimer;
@property (nonatomic, strong) NSTimer *coinTimer;


@end

@implementation LevelOneViewController

//@synthesize score;


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.proceedButton.hidden = YES;
    self.youDiedButton.hidden = YES;
    score = 0;
    
    [[SoundController sharedInstance]cancelAudio];
    
}


- (IBAction)startGame:(id)sender {
    
    self.beginButton.hidden = YES;
    
    self.fastroTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fastroMoving) userInfo:nil repeats:YES];
    
    [self placeObstacle];
    
    [self placeCoin];
    
    self.obstacleTimer = [NSTimer scheduledTimerWithTimeInterval:0.0035 target:self selector:@selector(obstacleMoving) userInfo:nil repeats:YES];
    
    self.coinTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(coinMoving) userInfo:nil repeats:YES];
    
    [self playAudio];
}


- (void)obstacleMoving {
    
    self.obstacleView.center = CGPointMake(self.obstacleView.center.x - 1, self.obstacleView.center.y);
    [self animateView:self.obstacleView duration:10];
    
    if (self.obstacleView.center.x < - 35) {
        
        [self placeObstacle];
    }
    
//    if (self.obstacleView.center.x == 30) {
//        
//        [self score];
//    }
    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.obstacleView.frame)) {
        
        [self gameOver];
    }
    
    if (self.fastronaut.center.y > self.view.frame.size.height - self.fastronaut.frame.size.height / 2) {
        [self gameOver];
    }
    
    if (self.fastronaut.center.y < 0 + self.fastronaut.frame.size.height / 2) {
        [self gameOver];
    }
    
    
}


- (void)placeObstacle {
    
    int frame = self.view.frame.size.height;
    
    obstaclePosition = arc4random() %frame;
    
    self.obstacleView.center = CGPointMake(450, obstaclePosition);
    
    [self animateView:self.obstacleView duration:HUGE_VALF];
    
}


- (void)fastroMoving {
    
    self.fastronaut.center = CGPointMake(self.fastronaut.center.x, self.fastronaut.center.y - fastroFlight);
    
    fastroFlight = fastroFlight - 5;
    
    if (fastroFlight < -15) {
        fastroFlight = -15;
    }
    
    if (fastroFlight > 0) {
        self.fastronaut.image = [UIImage imageNamed:@"greenFastroLanded"];
    }
    
    if (fastroFlight < 0) {
        self.fastronaut.image = [UIImage imageNamed:@"GreenFastro"];
    }
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    fastroFlight = 30;
    
}

- (void)placeCoin {
    
    int frame = self.view.frame.size.height;
    
    coinPosition = arc4random() %frame;
    
    self.coin.center = CGPointMake(380, coinPosition);
    
    self.coin.hidden = NO;
    
    
}

- (void)coinMoving {
    
    self.coin.center = CGPointMake(self.coin.center.x - 1, self.coin.center.y);
    
    if (self.coin.center.x < - 35) {
        
        [self placeCoin];
    }
    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.coin.frame)) {
        
        self.coin.hidden = YES;
        [self placeCoin];
        [self scoreChange];
    }
    
}


- (void)gameOver {
    
    [self.fastroTimer invalidate];
    [self.obstacleTimer invalidate];
    [self.coinTimer invalidate];
    
    self.youDiedButton.hidden = NO;
    self.obstacleView.hidden = YES;
    self.fastronaut.hidden = YES;
    self.coin.hidden = YES; 
    
    score = 0;
    
}


- (void)scoreChange {
    
    score = score + 1;
    
//    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    if (score == 20) {
        
        [self.fastroTimer invalidate];
        [self.obstacleTimer invalidate];
        [self.coinTimer invalidate];
        
        self.proceedButton.hidden = NO;
        self.obstacleView.hidden = YES;
        self.coin.hidden = YES;
        self.fastronaut.hidden = YES;
        
        self.isComplete = YES;
    }
    
    
}


- (IBAction)resetGame:(id)sender {
    
    score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score]; 
    
    self.beginButton.hidden = NO;
    self.youDiedButton.hidden = YES;
    self.fastronaut.hidden = NO;
    self.obstacleView.hidden = NO;
    self.coin.hidden = NO;
    
    self.fastronaut.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    
}

- (void)animateView:(UIImageView *)view duration:(float)duration {
    
   
    CGAffineTransform rotate = CGAffineTransformMakeRotation(radians(180));
//    CGAffineTransform bigger = CGAffineTransformMakeScale(2, 2);
//    CGAffineTransform smaller = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:duration animations:^{
        
        view.transform = rotate;
//        view.transform = bigger;
//        view.transform = smaller;
        
    }];
    
}



- (void)playAudio {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Urban Gauntlet" withExtension:@"mp3"];
    
    [[SoundController sharedInstance]playFileAtURL:url];
    
}






@end
