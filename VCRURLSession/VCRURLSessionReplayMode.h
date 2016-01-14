//
//  VCRURLSessionReplayMode.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 07/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  VCRURLSessionReplayMode
 */
typedef NS_ENUM(NSUInteger, VCRURLSessionReplayMode) {
    /**
     *  Returns recorded response, if possible, otherwise makes network request.
     */
    VCRURLSessionReplayModeNormal,
    /**
     *  Returns recorded response, if possible, otherwise returns error.
     */
    VCRURLSessionReplayModeStrict,
};
