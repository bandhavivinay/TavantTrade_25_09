/*
 * DFCredentials.h
 *
 *  Created by dhudson on 22/05/2009.
 *  Copyright (c) 2009 Push Technology Ltd. All rights reserved.
 */

/**
 This class represents the credential details passed to the DFClient class.
 */
@interface DFCredentials : NSObject {
@private
	NSString	*username;
	NSString	*password;
}

@property(retain,nonatomic) NSString	*username;	/**<<  The username token */
@property(retain,nonatomic) NSString	*password;	/**<<  The password token */

/**
 Initialiase a DFCredentials object.
 @param username	Username for this object
 @param password	Password for this object
 @return An initialised DFCredentials object containing the given crendentials tokens
 */
-(id) initWithUsernameAndPassword:(NSString *)username password: (NSString *)password;


@end
