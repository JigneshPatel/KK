//
//  MapSearchViewController.h
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "LocationHelper.h"
#import "AppDelegate.h"


@interface MapSearchViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationDegrees latitude1,longitude1;
    MKCoordinateRegion mapRegion;
    NSMutableData *receivedData;
}
@property (strong,nonatomic) IBOutlet UILabel *lblTitle,*lblSubTitle;
@property (strong,nonatomic) IBOutlet UIView *viewAnnotation;
@property (strong, nonatomic) IBOutlet UITextField *txtLoc;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocation* currentLocation;
@property (strong, nonatomic) CLLocationManager *manager;
@end
