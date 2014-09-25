/* 
 * TopicMessage.h
 *
 *  Created by dhudson on 22/05/2009.
 *  Copyright (c) 2009 Push Technology Ltd. All rights reserved.
 *
 */

/**
 The class for data messages that are created for a specific topic.
 */
@interface DFTopicMessage : NSObject {
	@private
	char			messageType;
	NSString		*topic;
	NSData			*content;
	NSString		*contentString;
	NSArray			*userHeaders;
	BOOL			ackRequired;
	int				ackTimeout;
	NSString		*ackID;
	int				encoding;
	NSArray			*records;
	
	BOOL			needsAcknowledge;
}

@property(nonatomic, retain) NSArray *userHeaders;	/**< The user headers found on this message, as an array of NSString objects */
@property(nonatomic,readonly) NSArray *records;		/**<  Tokenises the message payload by &lt;RD&gt;, and returns the result as an array of NSString objects */
@property(nonatomic, retain) NSString *topic;	/**< The topic of the message */
@property(nonatomic, readonly) NSData *asBytes;	/**< the message content */
@property(nonatomic, readonly) NSString *asString;	/**< the message content as a String*/

@property(nonatomic, retain) NSString *ackID;	/**< the Ack ID for this message, nil if not set */
@property(nonatomic, assign) int ackTimeout;	/**< The timeout in seconds */

/**
 An encoding method to use for this message. 
 Valid encoding values currently limited to DIFFUSION_MESSAGE_ENCODING_NONE_ENCODING, DIFFUSION_MESSAGE_ENCODING_ENCRYPTED_ENCODING or DIFFUSION_MESSAGE_ENCODING_COMPRESSED_ENCODING
 */
@property(nonatomic, assign) int encoding;

@property(nonatomic,assign) BOOL needsAcknowledge;	/**< YES if the implementation needs to acknowledge this message */
@property(nonatomic,readonly) BOOL isInitialLoad;	/**< YES if the message is an initialTopicLoad message */
@property(nonatomic,readonly) BOOL isDelta;			/**< YES if the message is a delta message */
@property(nonatomic,readonly) BOOL isAckMessage;	/**< YES if this message requires an acknowlegement */
@property(nonatomic,readonly) BOOL isServiceLoad;	/**< YES if this message is a service-topic-load */
@property(nonatomic,readonly) BOOL isPagedLoad;	/**< YES if a load message on a 'paged' Topic */

/**
 Initialiase a TopicMessage object
 @param topic	Topic for this message
 @param message	Content of the message
 @return A newly initialiased object ready for sending
 */
-(id)initWithTopic:(NSString *)topic andData:(NSData *)message;

/**
 Initialiase a TopicMessage object
 @param topic	Topic for this message
 @param message	String content of the message
 @return A newly initialiased object ready for sending
 */
-(id)initWithTopic:(NSString *)topic andString:(NSString *)message;


/**
 * getAckRequired
 * @return true if an Ack is required for this message
 */
-(BOOL)			getAckRequired;

/**
 * setAckRequired
 * @param timeout in seconds
 * @return an Ack ID
 */
-(NSString *)		setAckRequired : (int) timeout;

/**
 * @return the number of records held in this message
 */
-(int)getNumberOfRecords;

/**
 Fetch the given record as an NSArray of NSData*
 @param index
 @return An NSArray* holding the fields
 */
-(NSArray *)getFields:(int)index;

@end
