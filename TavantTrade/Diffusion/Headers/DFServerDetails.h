//
//  DFServerDetails.h
//  DiffusionTransport
//
//  Created by Martin Cowie on 14/04/2011.
//  Copyright 2011 Push Technology. All rights reserved.
//

#import "DFBaseConnectionProperties.h"
@class AsyncSocket, DFClient;

/**
 An object to contain details required to connect to a single instance of Diffusion.
 */
@interface DFServerDetails : DFBaseConnectionProperties {
@private
    NSURL *url;
}

/**
 Initialise an DFServerDetails object.
 
 URLs given must be of the form dpt://push.acme.com:443. 
 Currently only DPT is supported as a URL scheme.
 The port number is mandatory as no default port number if assumed.
 
 @param url URL of the required Diffusion server. Currently only URLs starting "dpt://" are supported.
 @return an initialiased DFServerDetails object
 @throws DFException if the URL scheme is unsupported or is missing the port number.
 */
-(id)initWithURL:(NSURL*)url;

/**
 Get a connection to the server described by this object.
 N.B. This will not place a TCP connection straightaway, when a connection is placed or fails, the delegate is notified
 @param error Error object to populate in the possibility that is method call should fail
 @param delegate DFDelegate to associate with this connection
 @return An initialised DFServerDetails object
 */
-(AsyncSocket*)getConnection:(NSError**)error forDelegate:(DFClient*)delegate;

@property(nonatomic,readonly) NSURL *url;
@property(nonatomic,readonly) int portNumber;
@property(nonatomic,readonly) NSString *hostName, *protocol;

@end
