// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from fingerprint.djinni

#import <Foundation/Foundation.h>
@class IPSIFingerprint;
@class IPSIMeasurement;
@class IPSIPosition;


@interface IPSIFingerprint : NSObject

+ (nullable IPSIFingerprint *)createFingerprint;

+ (nullable IPSIFingerprint *)createFingerprintWithParams:(nullable IPSIPosition *)position
                                             measurements:(nonnull NSArray *)measurements
                                                     date:(nonnull NSString *)date;

+ (nonnull NSString *)createBinaryFingerprint:(nullable IPSIPosition *)position
                                 measurements:(nonnull NSArray *)measurements
                                         date:(nonnull NSString *)date;

- (nonnull NSString *)getDate;

- (void)setDate:(nonnull NSString *)date;

/**
 *# is it really needed:
 * const get_measurements() : map<string, i_measurement>;
 */
- (void)setMeasurements:(nonnull NSArray *)measurements;

- (int32_t)getMeasurementsCount;

/**# end */
- (nullable IPSIPosition *)getPosition;

- (void)setPosition:(nullable IPSIPosition *)position;

@end