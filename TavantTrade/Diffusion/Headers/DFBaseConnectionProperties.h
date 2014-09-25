//
//  DFBaseConnectionDetails.h
//  DiffusionTransport
//
//  Created by Martin Cowie on 15/04/2011.
//  Copyright 2011 Martin Cowie Ltd. All rights reserved.
//

#import "DFCredentials.h"

/**
 Base set of properties common to both ServerDetails and ConnectionDetails.
 */
@interface DFBaseConnectionProperties : NSObject 
{
	@private
	NSNumber *timeout; // Pointer used to disambiguate between no-timeout & timeout-of-zero
	DFCredentials *credentials;
	NSString *topicSet;
	
	DFBaseConnectionProperties *defaults;
}

@property(nonatomic,assign) NSNumber *timeout;			/**<  Connection timeout in seconds, if unset defers to the defaults object */
@property(nonatomic,retain) DFCredentials *credentials;	/**<  Optional credentials object, if unset defers to the defaults object */
@property(nonatomic,retain) NSString *topicSet;			/**<  Comma seperated string of topic names and selectors, if unset defers to the defaults object */
@property(nonatomic,retain) DFBaseConnectionProperties *defaults;	/**<  A set of defaults to draw upon when a property is unset */

/**
 Basic initialisation method.
 Sets all contents to nil
 */
-(id)init;

@end
