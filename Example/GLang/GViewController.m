//
//  GViewController.m
//  GLang
//
//  Created by gaoyu on 07/23/2024.
//  Copyright (c) 2024 gaoyu. All rights reserved.
//

#import "GViewController.h"
#import "GTokenizer.h"

@interface GViewController ()

@end

@implementation GViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Hello");
    [self parse];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self parse];
}

- (void)parse {
    NSString *patchPath = [NSBundle.mainBundle pathForResource:@"source" ofType:@"js"];
    NSString *code = [NSString stringWithContentsOfFile:patchPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", code);
    
    NSArray<GToken *> *tokens = [GTokenizer lexWithCode:code];
    for (GToken *token in tokens) {
        NSLog(@"%@", token);
    }
}

@end
