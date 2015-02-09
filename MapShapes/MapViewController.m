//
//  ViewController.m
//  MapShapes
//
//  Created by Jon Vogel on 2/2/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "MapViewController.h"
#import "AnnotationDetailViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()


@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) UIBarButtonItem *btnJumpToLocation;
@property (strong, nonatomic) UIAlertController *alertForNewLocation;
@property (strong, nonatomic) CLLocationManager *myLocationManager;
@property (strong, nonatomic) MKPointAnnotation *theSelectedAnnotation;
@property (strong, nonatomic) CLCircularRegion *myRegion;

@end

@implementation MapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //instatnitae the locaiton manager and set the delegate of the locaiton manager and the mapview
  self.myLocationManager = [[CLLocationManager alloc]init];
  self.myLocationManager.delegate = self;
  self.myMapView.delegate = self;
  
  //instantiate the region as a blank region
  self.myRegion = [[CLCircularRegion alloc]init];
  
  NSLog(@"Number Of Regions %lu", (unsigned long)self.myLocationManager.monitoredRegions.count);
  
  //Add NSNotification center handler
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geoReminderReceived:) name:@"geoReminder" object:nil];
  
  //See if the user has allowed the app to use their locaiton.
  if ([CLLocationManager locationServicesEnabled] == true){
    
    NSLog(@"CUrrent Status is %d", [CLLocationManager authorizationStatus]);
    if ([CLLocationManager authorizationStatus] == 0) {
      [self.myLocationManager requestAlwaysAuthorization];
    }else{
      [self.myLocationManager startUpdatingLocation];
      [self.myLocationManager startMonitoringSignificantLocationChanges];
    }
  }else{
    //Location Services Turned OFF
  }
  
  //Add gesture recognizer that detects someone holding on the screen
  UILongPressGestureRecognizer *addAnnotationGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addMapAnnotation:)];
  [self.myMapView addGestureRecognizer:addAnnotationGesture];
  
  
  
  //Make the bar button item and and alert view controller that will have three buttons. Each button will have an aciton that moves the user to a preDetermined new locaiton.
  self.btnJumpToLocation = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(showPopOver:)];
  
  [self.navigationItem setRightBarButtonItem:self.btnJumpToLocation animated:true];
  
  self.alertForNewLocation = [UIAlertController alertControllerWithTitle:@"Locations" message:@"Please Select A Location To Jump To" preferredStyle: UIAlertControllerStyleAlert];
  
  CLLocationCoordinate2D zoomLocation;
  zoomLocation.latitude = 47.6204;
  zoomLocation.longitude = -122.3491;
  MKCoordinateSpan mySpan;
  mySpan.latitudeDelta = 1;
  mySpan.longitudeDelta = 1;
  MKCoordinateRegion myLocation = MKCoordinateRegionMake(zoomLocation, mySpan);
  [self.myMapView setRegion:myLocation animated:true];
  
                              
  UIAlertAction *firstLocation = [UIAlertAction actionWithTitle:@"Sorrow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    CLLocationCoordinate2D firstLoc;
    firstLoc.latitude = 33.5275;
    firstLoc.longitude = -112.2625;
    MKCoordinateRegion firstRegion = MKCoordinateRegionMake(firstLoc,mySpan);
    [self.myMapView setRegion:firstRegion animated:true];
    
  }];
  
  UIAlertAction *secondLocation = [UIAlertAction actionWithTitle:@"Vacation" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    CLLocationCoordinate2D secondLoc;
    secondLoc.latitude = 12.5000;
    secondLoc.longitude = -69.9667;
    MKCoordinateRegion secondRegion = MKCoordinateRegionMake(secondLoc,mySpan);
    [self.myMapView setRegion:secondRegion animated:true];
    
  }];
  
  UIAlertAction *thirdLocation = [UIAlertAction actionWithTitle:@"End of Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    CLLocationCoordinate2D thirdLoc;
    thirdLoc.latitude = 31.0425;
    thirdLoc.longitude =  -104.8331;
    MKCoordinateRegion thirdRegion = MKCoordinateRegionMake(thirdLoc,mySpan);
    [self.myMapView setRegion:thirdRegion animated:true];
  }];
  
  
  [self.alertForNewLocation addAction:firstLocation];
  [self.alertForNewLocation addAction:secondLocation];
  [self.alertForNewLocation addAction:thirdLocation];
  
  
                              
  self.myMapView.rotateEnabled = false;
  // Do any additional setup after loading the view, typically from a nib.
}

//MARK: Message Receivers
-(void)addMapAnnotation:(id)sender{
  UILongPressGestureRecognizer *theGesture = (UILongPressGestureRecognizer *)sender;
  if (theGesture.state == 3){
    CGPoint touchedPoint = [theGesture locationInView: self.myMapView];
    CLLocationCoordinate2D theLocation = [self.myMapView convertPoint:touchedPoint toCoordinateFromView:self.myMapView];
    MKPointAnnotation *theAnnotation = [[MKPointAnnotation alloc] init];
    theAnnotation.coordinate = theLocation;
    theAnnotation.title = @"This is a reminder";
    [self.myMapView addAnnotation:theAnnotation];
    
  }
  
}

-(void)showPopOver: (id)sender{
  [self presentViewController:_alertForNewLocation animated:true completion:nil];
}


-(void)geoReminderReceived:(NSNotification * )notification{
  //self.myMapView.delegate = self;
  NSDictionary *userInfo = notification.userInfo;
  self.theSelectedAnnotation.title = userInfo[@"newName"];
  self.myRegion = userInfo[@"theReminder"];
  MKCircle *circleToOverlay = [MKCircle circleWithCenterCoordinate:self.myRegion.center radius:self.myRegion.radius];
  [self.myMapView addOverlay:circleToOverlay];
  //[self.myMapView rendererForOverlay:circleToOverlay];
}




//MARK: Location manager methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
  
        self.myMapView.showsUserLocation = true;
  
}

//MARK:Map View Functions
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
  if ([annotation isKindOfClass:[MKUserLocation class]]){
    return nil;
  }else{
  
  MKPinAnnotationView *thePinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"theAnnotationView"];
  thePinView.animatesDrop = true;
  thePinView.canShowCallout = true;
  thePinView.rightCalloutAccessoryView  = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  return thePinView;
  }
  
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control  {
  self.theSelectedAnnotation = view.annotation;
  
  [self performSegueWithIdentifier:@"showAnnotationDetail" sender:self];
  
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  MKCircleRenderer *theCircle = [[MKCircleRenderer alloc]initWithOverlay:overlay];
  theCircle.fillColor = [UIColor blueColor];
  theCircle.strokeColor = [UIColor yellowColor];
  theCircle.alpha = 0.5;
  return theCircle;
}

//MARK: Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([segue.identifier isEqualToString:@"showAnnotationDetail"]) {
    AnnotationDetailViewController *DVC = (AnnotationDetailViewController *)segue.destinationViewController;
    DVC.theAnnotation = self.theSelectedAnnotation;
    DVC.theLocationManager = self.myLocationManager;
  }
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
  UILocalNotification *note = [[UILocalNotification alloc]init];
  note.alertBody = self.myRegion.identifier;
  note.alertAction = @"Alert!!";
  [[UIApplication sharedApplication] presentLocalNotificationNow:note];
}


//MARK: Memory clean up
-(void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
