//
//  DFServiceTopicResponse.h
//  DiffusionTransport
//
//  Created by MARTIN COWIE on 23/12/2011.
//  Copyright (c) 2011 Martin Cowie Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFServiceTopicHandler, DFTopicMessage;


/**
 * Encapsulates a response from a service request.
 * <P>
 * This encapsulates the details of a response from a call to [DFServiceTopicHandler sendRequest:withRequestType:]
 */

@interface DFServiceTopicResponse : NSObject {
	DFServiceTopicHandler *handler;
	NSString *requestID, *responseType;
	DFTopicMessage *responseMessage;
}


@property(nonatomic,readonly) DFServiceTopicHandler *handler; /**< Parent handler object */
@property(nonatomic,readonly) NSString *responseType; /**< This identifies the type of response and is as defined by the service itself */
@property(nonatomic,readonly) NSString *requestID; /**< This returns the original identifier that was passed with the request */
@property(nonatomic,readonly) DFTopicMessage *responseMessage; /**< Return details of the response in the form of a Message containing headers and/or data returned from the server */

@end
