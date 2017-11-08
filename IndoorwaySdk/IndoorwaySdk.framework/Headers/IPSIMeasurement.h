// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from measurement.djinni

#import <Foundation/Foundation.h>
@class IPSIMeasurement;


@interface IPSIMeasurement : NSObject

+ (nullable IPSIMeasurement *)createMeasurement;

+ (nullable IPSIMeasurement *)createMeasurementWithParams:(nonnull NSString *)ssid
                                                    bssid:(nonnull NSString *)bssid
                                                     rssi:(float)rssi
                                                timestamp:(int64_t)timestamp;

- (void)setBssid:(nonnull NSString *)bssid;

- (nonnull NSString *)getBssid;

- (void)setRssi:(float)rssi;

- (float)getRssi;

- (void)setSsid:(nonnull NSString *)ssid;

- (nonnull NSString *)getSsid;

- (void)setTimestamp:(int64_t)timestamp;

- (int64_t)getTimestamp;

- (BOOL)isEqual:(nullable IPSIMeasurement *)measurement;

@end