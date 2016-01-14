//
//  ViewController.m
//  WMS
//
//  Created by Andrea Phillips on 14/01/2016.
//  Copyright © 2016 Tokbox. All rights reserved.
//

#import "ViewController.h"
#import "Widget.h"


@interface ViewController ()
@property Widget *widgetController;
@end

@implementation ViewController

NSMutableDictionary *connectionInfo;


- (void)viewDidLoad {
    [super viewDidLoad];
    connectionInfo = [self getEventToken];
}

-(void)viewDidAppear:(BOOL)animated{
    if(connectionInfo){
        connectionInfo[@"user"] = [NSMutableDictionary
                                   dictionaryWithDictionary:@{
                                                              @"name":@"Justin Melene",
                                                              @"id":@"123",
                                                              @"role":@"client"
                                                              }];
        self.widgetController = [[Widget alloc] initWithData:connectionInfo];
        [self presentViewController:self.widgetController animated:NO completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/// we get the connection data
- (NSMutableDictionary*) getEventToken{
    NSMutableDictionary *connectionData;
    //we can change wich appointment we are connecting to
    NSString *url = [NSString stringWithFormat:@"https://wmsstaging.herokuapp.com/api/get-tokens/appointment1"];
    
    //Create the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSError * error = nil;
    
    
    __block NSDictionary *json;
    
    NSURLResponse * response = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        json = [NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:nil];
        
        NSError * errorDictionary = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorDictionary];
        return connectionData = [dictionary mutableCopy];
    }else{
        return connectionData;
    }
}

@end
