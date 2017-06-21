//
//  CLLocation+ToBaidu.h
//  QQCar
//
//  Created by yilong zhang on 2017/4/14.
//  Copyright © 2017年 qqcy. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Transform)

/**地球坐标转火星坐标*/

- (CLLocation*)Earth2Spark;

/**火星坐标转百度坐标*/

- (CLLocation*)Spark2Baidu;

/**百度坐标转火星坐标*/

- (CLLocation*)Baidu2Spark;

@end
