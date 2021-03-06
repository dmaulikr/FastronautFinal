//
//  LevelElevenViewController.m
//  FastroFinal
//
//  Created by Ethan Hess on 5/31/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "LevelElevenViewController.h"
#import "SoundController.h"
#import "SoundEffectsController.h"
#import "ViewController.h"
#import "LevelController.h"

#define IS_IPHONE_4 ([UIScreen mainScreen].bounds.size.height == 480.0)
#define IS_IPHONE_6 ([UIScreen mainScreen].bounds.size.height == 736.0)

extern int topObstaclePosition;
extern int bottomObstaclePosition;
extern int fastroFlight;
extern int coinPosition;
extern int score;
extern int diamondPosition;

@interface LevelElevenViewController ()

@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIButton *youDiedButton;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@property (weak, nonatomic) IBOutlet UIImageView *topObstacleView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomObstacleView;
@property (weak, nonatomic) IBOutlet UIImageView *coin; 
@property (weak, nonatomic) IBOutlet UIImageView *greenDiamond;

@property (weak, nonatomic) IBOutlet UIImageView *fastronaut;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic, strong) NSTimer *fastroTimer;
@property (nonatomic, strong) NSTimer *obstacleTimer;
@property (nonatomic, strong) NSTimer *coinTimer;
@property (nonatomic, strong) NSTimer *diamondTimer; 


@end

@implementation LevelElevenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fastronaut.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Get 60 points!" message:nil delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil];
    [alert show];
    
    self.beginButton.backgroundColor = [UIColor whiteColor];
    self.beginButton.layer.cornerRadius = 37.5;
    self.beginButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.beginButton.layer.borderWidth = 3.0;
    
    self.youDiedButton.backgroundColor = [UIColor whiteColor];
    self.youDiedButton.layer.cornerRadius = 37.5;
    self.youDiedButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.youDiedButton.layer.borderWidth = 3.0;
    
    self.proceedButton.backgroundColor = [UIColor whiteColor];
    self.proceedButton.layer.cornerRadius = 37.5;
    self.proceedButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.proceedButton.layer.borderWidth = 3.0;
    
    self.homeButton.backgroundColor = [UIColor whiteColor];
    self.homeButton.layer.cornerRadius = 37.5;
    self.homeButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.homeButton.layer.borderWidth = 3.0;
    
    [[SoundController sharedInstance] cancelAudio];
    
    self.proceedButton.hidden = YES;
    self.youDiedButton.hidden = YES;
    self.homeButton.hidden = YES;
    score = 0;
    
}


- (IBAction)startGame:(id)sender {
    
    self.beginButton.hidden = YES;
    
    self.fastroTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fastroMoving) userInfo:nil repeats:YES];
    
    [self placeObstacles];
    
    [self placeCoin];
    
    [self placeDiamond];
    
    self.obstacleTimer = [NSTimer scheduledTimerWithTimeInterval:0.007 target:self selector:@selector(obstacleMoving) userInfo:nil repeats:YES];
    
    self.coinTimer = [NSTimer scheduledTimerWithTimeInterval:0.003 target:self selector:@selector(coinMoving) userInfo:nil repeats:YES];
    
    self.diamondTimer = [NSTimer scheduledTimerWithTimeInterval:0.004 target:self selector:@selector(diamondMoving) userInfo:nil repeats:YES];
    
    [self playAudio];
}


- (void)obstacleMoving {
    
    self.topObstacleView.center = CGPointMake(self.topObstacleView.center.x - 1, self.topObstacleView.center.y);
    
    self.bottomObstacleView.center = CGPointMake(self.bottomObstacleView.center.x + 1, self.bottomObstacleView.center.y);
    
    if (self.topObstacleView.center.x < - 30) {
        
        [self placeObstacles];
    }
    
    
    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.topObstacleView.frame)) {
        
        [self gameOver];
        [self playGameOverSound];
    }
    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.bottomObstacleView.frame)) {
        
        [self gameOver];
        [self playGameOverSound];
    }
    
    if (self.fastronaut.center.y > self.view.frame.size.height - self.fastronaut.frame.size.height / 2) {
        [self gameOver];
        [self playGameOverSound];
    }
    
    if (self.fastronaut.center.y < 0 + self.fastronaut.frame.size.height / 2) {
        [self gameOver];
        [self playGameOverSound];
    }
    
    
}


- (void)placeObstacles {
    
    if (IS_IPHONE_4) {
        
        topObstaclePosition = arc4random() %330;
        topObstaclePosition = topObstaclePosition - 225;
        bottomObstaclePosition = topObstaclePosition + 570;
        
        self.topObstacleView.center = CGPointMake(520, topObstaclePosition);
        self.bottomObstacleView.center = CGPointMake(-140, bottomObstaclePosition);
        
    }
    
    else if (IS_IPHONE_6) {
        
        topObstaclePosition = arc4random() %400;
        topObstaclePosition = topObstaclePosition - 225;
        bottomObstaclePosition = topObstaclePosition + 820;
        
        self.topObstacleView.center = CGPointMake(520, topObstaclePosition);
        self.bottomObstacleView.center = CGPointMake(-140, bottomObstaclePosition);
        
    }
    
    else {
    
    topObstaclePosition = arc4random() %380;
    topObstaclePosition = topObstaclePosition - 225;
    bottomObstaclePosition = topObstaclePosition + 690;
    
    self.topObstacleView.center = CGPointMake(520, topObstaclePosition);
    self.bottomObstacleView.center = CGPointMake(-140, bottomObstaclePosition);
    
    }
}

- (void)diamondMoving {
    
    self.greenDiamond.center = CGPointMake(self.greenDiamond.center.x + 1, self.greenDiamond.center.y);
    
    if (self.greenDiamond.center.x > 450) {
        
        [self placeDiamond];
    }
    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.greenDiamond.frame)) {
        
        self.greenDiamond.hidden = YES;
        [self placeDiamond];
        [self scoreChangeTwo];
        [self playLoudBellSound];
        
    }
    
}

- (void)placeDiamond {
    
    int frame = self.view.frame.size.height;
    
    diamondPosition = arc4random() %frame;
    
    self.greenDiamond.center = CGPointMake(-50, diamondPosition);
    
    self.greenDiamond.hidden = NO;
    
}


- (void)fastroMoving {
    
    self.fastronaut.center = CGPointMake(self.fastronaut.center.x, self.fastronaut.center.y - fastroFlight);
    
    fastroFlight = fastroFlight - 8;
    
    if (fastroFlight < -18) {
        fastroFlight = -18;
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
    
    self.coin.center = CGPointMake(450, coinPosition);
    
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
        [self playBellSound];
    }
    
}


- (void)gameOver {
    
    [self.fastroTimer invalidate];
    [self.obstacleTimer invalidate];
    [self.coinTimer invalidate];
    [self.diamondTimer invalidate];
    
    self.youDiedButton.hidden = NO;
    self.homeButton.hidden = NO;
    self.topObstacleView.hidden = YES;
    self.bottomObstacleView.hidden = YES;
    self.coin.hidden = YES;
    self.fastronaut.hidden = YES;
    self.greenDiamond.hidden = YES;
    
    score = 0;
    
}


- (void)scoreChange {
    
    score = score + 1;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    if (score == 60) {
        
        [self.fastroTimer invalidate];
        [self.obstacleTimer invalidate];
        [self.coinTimer invalidate];
        [self.diamondTimer invalidate];
        
        self.proceedButton.hidden = NO;
        self.homeButton.hidden = NO;
        self.topObstacleView.hidden = YES;
        self.bottomObstacleView.hidden = YES;
        self.fastronaut.hidden = YES;
        self.coin.hidden = YES;
        self.greenDiamond.hidden = YES;
        
        self.isComplete = YES;
        
        [[LevelController sharedInstance]saveBool:self.isComplete];
        
        [self playWinSound];
    }
    
    
}

- (void)scoreChangeTwo {
    
    score = score + 3;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    if (score >= 60) {
        
        [self.fastroTimer invalidate];
        [self.obstacleTimer invalidate];
        [self.coinTimer invalidate];
        [self.diamondTimer invalidate];
        
        self.proceedButton.hidden = NO;
        self.homeButton.hidden = NO;
        self.topObstacleView.hidden = YES;
        self.bottomObstacleView.hidden = YES;
        self.coin.hidden = YES;
        self.fastronaut.hidden = YES;
        self.greenDiamond.hidden = YES;
        
        [self playWinSound];
        
        if ([LevelController sharedInstance].arrayOfCompletedLevels.count >= 11) {
            
            return;
        }
        
        else {
            
            self.isComplete = YES;
            
            [[LevelController sharedInstance]saveBool:self.isComplete];
            
        }
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
    self.bottomObstacleView.hidden = NO;
    self.greenDiamond.hidden = NO;
    self.coin.hidden = NO;
    
    self.fastronaut.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    
}



- (void)playAudio {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"The Complex" withExtension:@"mp3"];
    
    [[SoundController sharedInstance]playFileAtURL:url];
    
}

- (void)playBellSound {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ceramicBell" withExtension:@"wav"];
    
    [[SoundEffectsController sharedInstance]playFileAtURL:url];
    
}

- (void)playLoudBellSound {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ding" withExtension:@"wav"];
    
    [[SoundEffectsController sharedInstance]playFileAtURL:url];
    
    
}

- (void)playGameOverSound {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"gameOver" withExtension:@"wav"];
    
    [[SoundEffectsController sharedInstance]playFileAtURL:url];
    
}

- (void)playWinSound {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"winSound" withExtension:@"wav"];
    
    [[SoundEffectsController sharedInstance]playFileAtURL:url];
    
}


- (IBAction)goHome:(id)sender {
    
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
    
    [self.navigationController pushViewController:viewController animated:YES];

    
}




@end

