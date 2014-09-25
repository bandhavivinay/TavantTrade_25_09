/*
 *  DFTopicListenerDelegate.h
 *
 *  Created by Darren Hudson on 24/05/2009.
 *  Copyright 2009 Push Technology Ltd. All rights reserved.
 *
 */

#import "DFTopicMessage.h"

/**
 Protocol for receiving messages from a particular topic.
 */
@protocol DFTopicListenerDelegate

/**
 * This method is called if the TopicMessage matches the message received from Diffusion
 *
 * @param message
 * @return YES if the message is 'consumed' and should not be relayed to subsequent DFTopicListenerDelegate, nor the default listener.
 */
- (BOOL) onMessage:(DFTopicMessage *) message;

/**
 * This is the topic used to see if the message from Diffusion matches (equals) this String
 */
- (NSString *) getTopic;

@end