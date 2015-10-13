//
//  SJDetailViewController.m
//  SJLocation
//
//  Created by shejun.zhou on 15/10/12.
//  Copyright © 2015年 shejun.zhou. All rights reserved.
//

#import "SJDetailViewController.h"

@interface SJDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *hintTextView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation SJDetailViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.fileName;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *path = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"txt"];
    _hintTextView.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (_locationText) {
        _locationLabel.text = _locationText;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - delegate


#pragma mark - event response


#pragma mark - private methods


#pragma mark - getters and setters


@end
