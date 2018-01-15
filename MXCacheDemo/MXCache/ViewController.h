//
//  ViewController.h
//  MXCache
//
//  Created by kuroky on 2018/1/12.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

@interface TestModel : NSObject

@property (copy, nonatomic) NSString *name;

@property (strong, nonatomic) NSNumber *age;

@property (copy, nonatomic) NSString *address;

@end
