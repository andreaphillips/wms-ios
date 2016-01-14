//
//  Widget.h
//  WMS
//
//  Created by Andrea Phillips on 14/01/2016.
//  Copyright © 2016 Tokbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Widget : UIViewController
@property (strong,nonatomic) NSMutableDictionary *meetingInfo;
- (id)initWithData:(NSMutableDictionary *)meetingInfo;

@end
