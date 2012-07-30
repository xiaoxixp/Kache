//
//  KCHMainViewController.m
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KCHMainViewController.h"

#import "KCH.h"

@interface KCHMainViewController ()

@property (strong, nonatomic) Kache         *kache;
@property (strong, nonatomic) UILabel       *banner;
@property (strong, nonatomic) UILabel       *body;
@property (strong, nonatomic) UIScrollView  *bodyBackground;
@property (assign, nonatomic) NSInteger     offset;
@property (assign, nonatomic) NSInteger     timmer;
@property (assign, nonatomic) NSInteger     counter;

@end

@implementation KCHMainViewController

@synthesize kache                           = _kache;
@synthesize banner                          = _banner;
@synthesize body                            = _body;
@synthesize bodyBackground                  = _bodyBackground;
@synthesize offset                          = _offset;
@synthesize timmer                          = _timmer;
@synthesize counter                         = _counter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.kache      = [[Kache alloc] init];
        self.timmer     = 0;
        self.offset     = 0;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.banner = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 20.0f)];
    self.banner.backgroundColor = [UIColor clearColor];
    self.banner.textAlignment = UITextAlignmentCenter;
    self.banner.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:self.banner];
    
    self.body = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 410.0f)];
    self.body.backgroundColor = [UIColor clearColor];
    self.body.numberOfLines = 0;
    self.body.lineBreakMode = UILineBreakModeWordWrap;
    self.body.textAlignment = UITextAlignmentLeft;
    self.body.text = @"";
    [self.body sizeToFit];
    self.body.frame = CGRectMake(0.0f, 0.0f, 300.0f, self.body.bounds.size.height);
    
    [self countDown];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];

    self.bodyBackground = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 40.0f, 320.0f, 410.0f)];
    self.bodyBackground.contentSize = CGSizeMake(300.0f, self.body.bounds.size.height);
    
    [self.bodyBackground addSubview:self.body];
    [self.view addSubview:self.bodyBackground];

    // Begin Test.
    [self printLog:@"===== Test Begin ====="];
    [self performSelector:@selector(simpleTest) withObject:nil afterDelay:1.0f];
    [self performSelector:@selector(queueTest) withObject:nil afterDelay:16.0f];
    [self performSelector:@selector(poolTest) withObject:nil afterDelay:33.0f];
    
    [self performSelector:@selector(saveTest) withObject:nil afterDelay:43.0f];
    [self performSelector:@selector(loadTest) withObject:nil afterDelay:50.0f];
    
    [self performSelector:@selector(printLog:) withObject:@"===== All Test Down =====" afterDelay:60.0f];
}

- (void)simpleTest
{
    [self printLog:@"====== Begin Simple Test. ======"];
    // Set Simple Cache.
    [self printLog:@"Set 12 Simple Cache Value:\nkey_0 ~ key_11."];
    
    [self setValueWithLifeDuration:9];
    [self setValueWithLifeDuration:8];
    [self setValueWithLifeDuration:7];
    [self setValueWithLifeDuration:6];
    [self setValueWithLifeDuration:5];
    [self setValueWithLifeDuration:4];
    [self setValueWithLifeDuration:3];
    [self setValueWithLifeDuration:10];
    [self setValueWithLifeDuration:15];
    [self setValueWithLifeDuration:20];
    [self setValueWithLifeDuration:25];
    [self setValueWithLifeDuration:30];
    
    [self printLog:[NSString stringWithFormat:@"Value of key_6: \"%@\"", [self.kache valueForKey:@"key_6"]]];
    [self printLog:[NSString stringWithFormat:@"Value of key_0: \"%@\"", [self.kache valueForKey:@"key_0"]]];
    
    [self printLog:@"Waiting..."];
    
    [self performSelector:@selector(runAfter6Seconds) withObject:nil afterDelay:6.0f];
    [self performSelector:@selector(runAfter10Seconds) withObject:nil afterDelay:10.0f];
}

- (void)queueTest
{
    [self printLog:@"====== Begin Queue Test. ======"];
    // Set a Queue with Default Size 10.
    [self printLog:@"Push 10 values to the default queue."];

    [self.kache pushValue:@"QueueValue-0" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-1" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-2" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-3" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-4" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-5" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-6" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-7" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-8" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-9" toQueue:nil]; // Default Queue.

    [self performSelector:@selector(delayPop) withObject:nil afterDelay:1.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:2.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:3.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:4.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:5.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:6.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:7.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:8.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:9.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:10.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:11.0f];

    [self performSelector:@selector(pushMore) withObject:nil afterDelay:12.0f];
    
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:13.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:14.0f];
    [self performSelector:@selector(delayPop) withObject:nil afterDelay:15.0f];
}

- (void)poolTest
{
    [self printLog:@"====== Begin Pool Test. ======"];
    // Pool Test
    [self printLog:@"Set 10 values to the default pool."];
    
    self.offset = 0;
    [self setPoolValueWithLifeDuration:9];
    [self setPoolValueWithLifeDuration:8];
    [self setPoolValueWithLifeDuration:7];
    [self setPoolValueWithLifeDuration:6];
    [self setPoolValueWithLifeDuration:5];
    [self setPoolValueWithLifeDuration:4];
    [self setPoolValueWithLifeDuration:3];
    [self setPoolValueWithLifeDuration:10];
    [self setPoolValueWithLifeDuration:15];
    [self setPoolValueWithLifeDuration:20];

    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Value of pool_key_6: \"%@\"", [self.kache valueForKey:@"pool_key_6"]]
               afterDelay:1.0f];
    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Value of pool_key_0: \"%@\"", [self.kache valueForKey:@"pool_key_0"]]
               afterDelay:2.0f];
    
    [self performSelector:@selector(delaySetPool) withObject:nil afterDelay:3.0f];
    [self performSelector:@selector(delayGetPool) withObject:nil afterDelay:4.0f];
}

- (void)saveTest
{
    [self printLog:@"====== Begin Save Test. ======"];
    
    [self printLog:@"Set 10 simple values."];

    self.offset = 0;

    [self setValueWithLifeDuration:0];
    [self setValueWithLifeDuration:0];
    [self setValueWithLifeDuration:0];
    [self setValueWithLifeDuration:0];
    [self setValueWithLifeDuration:0];
    [self setValueWithLifeDuration:0];
    [self setValueWithLifeDuration:0];
    [self setValueWithLifeDuration:0];
    [self setValueWithLifeDuration:0];
    [self setValueWithLifeDuration:0];

    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Value of \"key_0\"\n\"%@\"",
                           [self.kache valueForKey:@"key_0"]]
               afterDelay:1.0f];

    [self performSelector:@selector(printLog:) withObject:@"Push 10 values to the Queue." afterDelay:2.0f];

    [self.kache pushValue:@"QueueValue-0" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-1" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-2" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-3" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-4" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-5" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-6" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-7" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-8" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"QueueValue-9" toQueue:nil]; // Default Queue.

    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Do one Pop:\n\"%@\"",
                           [self.kache popFromQueue:nil]]
               afterDelay:3.0f];
    
    [self performSelector:@selector(printLog:) withObject:@"Set 10 values to the Pool." afterDelay:4.0f];
    
    self.offset = 0;

    [self setPoolValueWithLifeDuration:0];
    [self setPoolValueWithLifeDuration:0];
    [self setPoolValueWithLifeDuration:0];
    [self setPoolValueWithLifeDuration:0];
    [self setPoolValueWithLifeDuration:0];
    [self setPoolValueWithLifeDuration:0];
    [self setPoolValueWithLifeDuration:0];
    [self setPoolValueWithLifeDuration:0];
    [self setPoolValueWithLifeDuration:0];
    [self setPoolValueWithLifeDuration:0];

    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Value of \"pool_key_0\"\n\"%@\"",
                           [self.kache valueForKey:@"pool_key_0"]]
               afterDelay:5.0f];

    [self performSelector:@selector(printLog:) withObject:@"Save to Disk." afterDelay:6.0f];

    [self.kache save];
}

- (void)loadTest
{
    [self printLog:@"====== Begin Load Test. ======"];
    
    Kache *tmpKache = [[Kache alloc] init];

    [tmpKache load];
    [self printLog:@"New Kache instance load from disk."];

    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Value of \"key_0\"\n\"%@\"",
                           [tmpKache valueForKey:@"key_0"]]
               afterDelay:1.0f];
        
    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Do one Pop:\n\"%@\"",
                           [tmpKache popFromQueue:nil]]
               afterDelay:2.0f];
    
    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Value of \"pool_key_0\"\n\"%@\"",
                           [tmpKache valueForKey:@"pool_key_0"]]
               afterDelay:3.0f];
}

- (void)delaySetPool
{
    [self printLog:@"Set 2 more values to the default pool."];
    
    [self setPoolValueWithLifeDuration:15];
    [self setPoolValueWithLifeDuration:20];
}

- (void)delayGetPool
{
    [self printLog:@"The \"pool_key_6\" will be removed."];
    
    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Value of pool_key_6: \"%@\"", [self.kache valueForKey:@"pool_key_6"]]
               afterDelay:1.0f];
    [self performSelector:@selector(printLog:)
               withObject:[NSString stringWithFormat:@"Value of pool_key_0: \"%@\"", [self.kache valueForKey:@"pool_key_0"]]
               afterDelay:2.0f];
}

- (void)pushMore
{
    [self.kache pushValue:@"MoreQueueValue-0" toQueue:nil]; // Default Queue.
    [self.kache pushValue:@"MoreQueueValue-1" toQueue:nil]; // Default Queue.
    [self printLog:@"Push 2 more value to the Default Queue."];    
}

- (void)delayPop
{
    [self printLog:[NSString stringWithFormat:@"Pop a Value:\n\"%@\"", [self.kache popFromQueue:nil]]];
    self.counter ++;
}

- (void)setValueWithLifeDuration:(NSInteger)seconds
{
    [self.kache setValue:[NSString stringWithFormat:@"ValueWithLifeDuration-%d-AndOffset-%d", seconds, self.offset]
                  forKey:[NSString stringWithFormat:@"key_%d", self.offset]
            expiredAfter:seconds];
    self.offset ++;
}

- (void)setPoolValueWithLifeDuration:(NSInteger)seconds
{
    [self.kache setValue:[NSString stringWithFormat:@"PoolValueWithLifeDuration-%d-AndOffset-%d", seconds, self.offset]
                 inPool:nil
                  forKey:[NSString stringWithFormat:@"pool_key_%d", self.offset]
            expiredAfter:seconds];
    self.offset ++;
}

- (void)countDown
{
    self.banner.text = [NSString stringWithFormat:@"Kache Demo, %d second(s)", self.timmer];
    self.timmer ++;
}

- (void)printLog:(NSString *)log
{
    NSLog(@"%@", log);
    self.body.text = [NSString stringWithFormat:@"%@\n\n%@", log, self.body.text];
    [self.body sizeToFit];
    self.body.frame = CGRectMake(0.0f, 0.0f, 300.0f, self.body.bounds.size.height);
    self.bodyBackground.contentSize = CGSizeMake(300.0f, self.body.bounds.size.height);
}

- (void)runAfter6Seconds
{
    [self printLog:@"After 6 seconds.\nObject: \"key_6\" has been expired."];
    [self printLog:[NSString stringWithFormat:@"Value of key_6: \"%@\"", [self.kache valueForKey:@"key_6"]]];
}

- (void)runAfter10Seconds
{
    [self printLog:@"After 10 seconds.\nObject: \"key_0\" has been expired."];
    [self printLog:[NSString stringWithFormat:@"Value of key_0: \"%@\"", [self.kache valueForKey:@"key_0"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
