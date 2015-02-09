//
//  AnnotationDetailViewController.h
//  MapShapes
//
//  Created by Jon Vogel on 2/3/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AnnotationDetailViewController : UIViewController

@property (strong, nonatomic) MKPointAnnotation *theAnnotation;
@property (strong, nonatomic) CLLocationManager *theLocationManager;


@end
