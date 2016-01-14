//
//  Widget.m
//  WMS
//
//  Created by Andrea Phillips on 14/01/2016.
//  Copyright © 2016 Tokbox. All rights reserved.
//

#import "Widget.h"
#import <Opentok/OpenTok.h>


@interface Widget ()
<OTSessionDelegate, OTSubscriberKitDelegate, OTPublisherDelegate>
@property (strong, nonatomic) IBOutlet UIView *publisherView;
@property (strong, nonatomic) IBOutlet UIView *subscriberView;
@end

@implementation Widget

OTSession* _session;
OTPublisher* _publisher;
OTSubscriber* _subscriber;

- (id)initWithData:(NSMutableDictionary *)meetingInfo{
    //NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    if( self = [self initWithNibName:@"Widget" bundle:[NSBundle mainBundle]])    {
        self.meetingInfo = meetingInfo;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _session = [[OTSession alloc] initWithApiKey:[NSString stringWithFormat:@"%@", self.meetingInfo[@"api"] ]
                                       sessionId:self.meetingInfo[@"sessionId"]
                                        delegate:self];
    
    [self doConnect];
}

- (void)doConnect
{
    OTError *error = nil;
    
    [_session connectWithToken:self.meetingInfo[@"token"] error:&error];
    if (error)
    {
        NSLog(@"do connect error");
    }
}


# pragma mark - OTSession delegate callbacks

- (void)sessionDidConnect:(OTSession*)session{
    //Here we start calling the components, for now just gonna place here...
    [self doPublish];
}

- (void) session:(OTSession *)session streamCreated:(OTStream *)stream{
    NSLog(@"session streamCreated (%@)", stream.streamId);
    [self doSubscribe:stream];
}

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
    assert(_subscriber == subscriber);
    
    (_subscriber.view).frame = CGRectMake(0, 0, self.subscriberView.bounds.size.width,self.subscriberView.bounds.size.height);
        
    [self.subscriberView addSubview:_subscriber.view];
}


///Methods that need to be in a component??? ===>

- (void)doPublish{
    
    if(!_publisher){
        _publisher = [[OTPublisher alloc] initWithDelegate:self name:[UIDevice currentDevice].name];
    }
    
    OTError *error = nil;
    if (error)
    {
        NSLog(@"publish error");
    }
    [_session publish:_publisher error:&error];
    
    [self.publisherView addSubview:_publisher.view];
    (_publisher.view).frame = CGRectMake(0, 0, self.publisherView.bounds.size.width, self.publisherView.bounds.size.height);
}

- (void)doSubscribe:(OTStream*)stream
{
    
        _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
    
        OTError *error = nil;
        [_session subscribe: _subscriber error:&error];
        if (error)
        {
            NSLog(@"subscribe error");
        }
    
}

/// <------- End of Component Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
