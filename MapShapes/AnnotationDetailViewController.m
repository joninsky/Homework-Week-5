//
//  AnnotationDetailViewController.m
//  MapShapes
//
//  Created by Jon Vogel on 2/3/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "AnnotationDetailViewController.h"

@interface AnnotationDetailViewController ()

//Outlet that connects to the textfield that we will get the reason for the user geo reminder
@property (weak, nonatomic) IBOutlet UITextField *txtUserInput;
@property (weak, nonatomic) IBOutlet UILabel *lblSignificance;
@property (weak, nonatomic) UIAlertController *alertForNoText;

@end

@implementation AnnotationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.alertForNoText = [UIAlertController alertControllerWithTitle:@"Stop!" message:@"You need to tell us why you are creating this reminder." preferredStyle:UIAlertControllerStyleAlert];
}


//Function that will be called when the user sets a geoReminder.
- (IBAction)addGeoReminder:(id)sender {
  
  if (self.txtUserInput.text == nil){
    [self presentViewController:self.alertForNoText animated:true completion:nil];
  }else{
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
      
      NSLog(@"%@", self.txtUserInput.text);
      CLCircularRegion *myNewRegion = [[CLCircularRegion alloc] initWithCenter:self.theAnnotation.coordinate radius:200 identifier:self.txtUserInput.text];
      
      [self.theLocationManager startMonitoringForRegion:myNewRegion];
      NSLog(@"When Added New Number is %lu", self.theLocationManager.monitoredRegions.count);
      //NSLog(@"%@");
      NSString *newName = self.txtUserInput.text;
      [[NSNotificationCenter defaultCenter] postNotificationName:@"geoReminder" object:self userInfo:@{@"theReminder": myNewRegion, @"newName": newName,}];
      
      [self.navigationController popViewControllerAnimated:true];
    }
  }
}







@end
