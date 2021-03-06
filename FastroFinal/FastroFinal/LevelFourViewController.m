//
//  LevelFourViewController.m
//  FastroFinal
//
//  Created by Ethan Hess on 5/24/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "LevelFourViewController.h"
#import "SoundController.h"
#import "SoundEffectsController.h"
#import "LevelController.h"
#import "ViewController.h"

int leftObstaclePosition;
int rightObstaclePosition;
extern int fastroFlight;
extern int coinPosition;
extern int score;

@interface LevelFourViewController ()

@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIButton *youDiedButton;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@property (weak, nonatomic) IBOutlet UIImageView *leftObstacleView;
@property (weak, nonatomic) IBOutlet UIImageView *rightObstacleView;
@property (weak, nonatomic) IBOutlet UIImageView *coin;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *fastronaut;

@property (nonatomic, strong) NSTimer *fastroTimer;
@property (nonatomic, strong) NSTimer *obstacleTimer;
@property (nonatomic, strong) NSTimer *coinTimer;

@end

@implementation LevelFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fastronaut.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Get 30 coins!" message:nil delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil];
    [alert show];
    
    self.beginButton.backgroundColor = [UIColor blackColor];
    self.beginButton.layer.cornerRadius = 37.5;
    self.beginButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.beginButton.layer.borderWidth = 3.0;
    
    self.youDiedButton.backgroundColor = [UIColor blackColor];
    self.youDiedButton.layer.cornerRadius = 37.5;
    self.youDiedButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.youDiedButton.layer.borderWidth = 3.0;
    
    self.proceedButton.backgroundColor = [UIColor blackColor];
    self.proceedButton.layer.cornerRadius = 37.5;
    self.proceedButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.proceedButton.layer.borderWidth = 3.0;
    
    self.homeButton.backgroundColor = [UIColor blackColor];
    self.homeButton.layer.cornerRadius = 37.5;
    self.homeButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.homeButton.layer.borderWidth = 3.0;
    
    
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
    
    self.obstacleTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(obstacleMoving) userInfo:nil repeats:YES];
    
    self.coinTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(coinMoving) userInfo:nil repeats:YES];
    
    [self playAudio];
}


- (void)obstacleMoving {
    
    self.leftObstacleView.center = CGPointMake(self.leftObstacleView.center.x + 1, self.leftObstacleView.center.y);
    
    self.rightObstacleView.center = CGPointMake(self.rightObstacleView.center.x - 1, self.rightObstacleView.center.y);

    
    if (self.leftObstacleView.center.x > 430) {
        
        [self placeObstacles];
    }

    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.leftObstacleView.frame)) {
        
        [self gameOver];
        [self playGameOverSound];
    }
    
    if (CGRectIntersectsRect(self.fastronaut.frame, self.rightObstacleView.frame)) {
        
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
    
    int frame = self.view.frame.size.height;
    
    leftObstaclePosition = arc4random() %frame;
    
    self.leftObstacleView.center = CGPointMake(-100, leftObstaclePosition);
    
    rightObstaclePosition = arc4random() %frame;
    
    self.rightObstacleView.center = CGPointMake(500, rightObstaclePosition);
    
    
}


- (void)fastroMoving {
    
    self.fastronaut.center = CGPointMake(self.fastronaut.center.x, self.fastronaut.center.y - fastroFlight);
    
    fastroFlight = fastroFlight - 8;
    
    if (fastroFlight < - 16.5) {
        fastroFlight = - 16.5;
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
        [self playBellSound];
    }
    
}


- (void)gameOver {
    
    [self.fastroTimer invalidate];
    [self.obstacleTimer invalidate];
    [self.coinTimer invalidate];
    
    self.youDiedButton.hidden = NO;
    self.leftObstacleView.hidden = YES;
    self.rightObstacleView.hidden = YES;
    self.coin.hidden = YES;
    self.homeButton.hidden = NO;
    self.fastronaut.hidden = YES;
    
    score = 0;

    
}


- (void)scoreChange {
    
    score = score + 1;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    if (score == 30) {
        
        [self.fastroTimer invalidate];
        [self.obstacleTimer invalidate];
        [self.coinTimer invalidate];
        
        self.proceedButton.hidden = NO;
        self.leftObstacleView.hidden = YES;
        self.rightObstacleView.hidden = YES;
        self.homeButton.hidden = NO;
        self.coin.hidden = YES;
        self.fastronaut.hidden = YES;
        
        [self playWinSound];
        
        if ([LevelController sharedInstance].arrayOfCompletedLevels.count >= 4) {
            
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
    self.youDiedButton.hidden = YES;
    self.homeButton.hidden = YES;
    self.fastronaut.hidden = NO;
    self.leftObstacleView.hidden = NO;
    self.rightObstacleView.hidden = NO;
    self.coin.hidden = NO; 
    
    self.fastronaut.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    
}



- (void)playAudio {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Exit the Premises" withExtension:@"mp3"];
    
    [[SoundController sharedInstance]playFileAtURL:url]; 
    
}

- (void)playBellSound {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ceramicBell" withExtension:@"wav"];
    
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
