//
//  LevelTwentyViewController.m
//  FastroFinal
//
//  Created by Ethan Hess on 6/12/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "LevelTwentyViewController.h"
#import "SoundController.h"
#import "SoundEffectsController.h"
#import "ViewController.h"


extern int topObstaclePosition;
extern int bottomObstaclePosition;
extern int middleObstaclePosition;
extern int coinPosition;
extern int fastroFlight;
extern int score;

@interface LevelTwentyViewController ()

@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIButton *youDiedButton;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@property (weak, nonatomic) IBOutlet UIImageView *topObstacleView;
@property (weak, nonatomic) IBOutlet UIImageView *middleObstacleView; 
@property (weak, nonatomic) IBOutlet UIImageView *bottomObstacleView;
@property (weak, nonatomic) IBOutlet UIImageView *coin;

@property (weak, nonatomic) IBOutlet UIImageView *fastronaut;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic, strong) NSTimer *fastroTimer;
@property (nonatomic, strong) NSTimer *obstacleTimer;
@property (nonatomic, strong) NSTimer *coinTimer;

@end

@implementation LevelTwentyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fastronaut.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Get 35 coins!" message:nil delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil];
    [alert show];
    
    self.proceedButton.hidden = YES;
    self.youDiedButton.hidden = YES;
    self.homeButton.hidden = YES;
    score = 0;
    
    [[SoundController sharedInstance]cancelAudio];
}


- (IBAction)startGame:(id)sender {
    
    self.beginButton.hidden = YES;
    
    self.fastroTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fastroMoving) userInfo:nil repeats:YES];
    
    [self placeObstacles];
    
    [self placeCoin];
    
    self.obstacleTimer = [NSTimer scheduledTimerWithTimeInterval:0.0055 target:self selector:@selector(obstacleMoving) userInfo:nil repeats:YES];
    
    self.coinTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(coinMoving) userInfo:nil repeats:YES];
    
    [self playAudio];
    
}


- (void)obstacleMoving {
    
    self.topObstacleView.center = CGPointMake(self.topObstacleView.center.x + 1, self.topObstacleView.center.y);
    
    self.middleObstacleView.center = CGPointMake(self.middleObstacleView.center.x + 1.25, self.middleObstacleView.center.y);
    
    self.bottomObstacleView.center = CGPointMake(self.bottomObstacleView.center.x + 1.5, self.bottomObstacleView.center.y);
    
    if (self.topObstacleView.center.x > 400) {
        
        [self placeObstacles];
    }
    
    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.topObstacleView.frame)) {
        
        [self gameOver];
    }
    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.bottomObstacleView.frame)) {
        
        [self gameOver];
    }
    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.middleObstacleView.frame)) {
        
        [self gameOver];
    }
    
    if (self.fastronaut.center.y > self.view.frame.size.height - self.fastronaut.frame.size.height / 2) {
        [self gameOver];
    }
    
    if (self.fastronaut.center.y < 0 + self.fastronaut.frame.size.height / 2) {
        [self gameOver];
    }
    
    
}


- (void)placeObstacles {
    
    topObstaclePosition = arc4random() %350;
    
    middleObstaclePosition = topObstaclePosition + 300;
    
    bottomObstaclePosition = topObstaclePosition + 600;
    
    self.topObstacleView.center = CGPointMake(- 100, topObstaclePosition);
    self.middleObstacleView.center = CGPointMake(- 100, middleObstaclePosition);
    self.bottomObstacleView.center = CGPointMake(- 100, bottomObstaclePosition);
    
}


- (void)fastroMoving {
    
    self.fastronaut.center = CGPointMake(self.fastronaut.center.x, self.fastronaut.center.y - fastroFlight);
    
    fastroFlight = fastroFlight - 8;
    
    if (fastroFlight < -15) {
        fastroFlight = -15;
    }
    
    if (fastroFlight > 0) {
        self.fastronaut.image = [UIImage imageNamed:@"Fastrozontal"];
    }
    
    if (fastroFlight < 0) {
        self.fastronaut.image = [UIImage imageNamed:@"FastrozontalDown"];
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
    self.homeButton.hidden = NO;
    self.topObstacleView.hidden = YES;
    self.bottomObstacleView.hidden = YES;
    self.middleObstacleView.hidden = YES;
    self.coin.hidden = YES;
    self.fastronaut.hidden = YES;
    
    score = 0;
    
}


- (void)scoreChange {
    
    score = score + 1;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    if (score == 35) {
        
        [self.fastroTimer invalidate];
        [self.obstacleTimer invalidate];
        [self.coinTimer invalidate];
        
        self.proceedButton.hidden = NO;
        self.homeButton.hidden = NO;
        self.topObstacleView.hidden = YES;
        self.bottomObstacleView.hidden = YES;
        self.middleObstacleView.hidden = YES;
        self.coin.hidden = YES;
        self.fastronaut.hidden = YES;
        
        self.isComplete = YES;
    }
    
    
}


- (IBAction)resetGame:(id)sender {
    
    score = 0;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    self.beginButton.hidden = NO;
    self.homeButton.hidden = YES; 
    self.youDiedButton.hidden = YES;
    self.fastronaut.hidden = NO;
    self.topObstacleView.hidden = NO;
    self.middleObstacleView.hidden = NO;
    self.bottomObstacleView.hidden = NO;
    self.coin.hidden = NO;
    
    self.fastronaut.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    
}



- (void)playAudio {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"EDM Detection Mode" withExtension:@"mp3"];
    
    [[SoundController sharedInstance]playFileAtURL:url];
    
}

- (IBAction)goHome:(id)sender {
    
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
    
    [self.navigationController pushViewController:viewController animated:YES];

}





@end

