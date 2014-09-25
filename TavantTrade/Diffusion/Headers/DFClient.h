// DFClient.h
// Created by dhudson on 22/05/2009.
// Copyright (c) 2009 Push Technology Ltd. All rights reserved.

@class AsyncSocket, ByteBuffer;

#import "DFConnectionDetails.h"
#import "DFClientDelegate.h"
#import "DFPingMessage.h"
#import "DFTopicMessage.h"
#import "DFTopicListenerDelegate.h"
#import "DFCredentials.h"
#import "DFServiceTopicHandler.h"
#import "DFPagedTopicHandler.h"
#import "DFPagedTopicDelegate.h"

/**
 *  The main access to the Diffusion Client.
 *  An example would be to create a ConnectionDetails object and then call the connect method
 *  A DiffusionDelegate must be set on the ConnectionDetails object to receive any messages
 * 
 */

@interface DFClient : NSObject {
@private
	NSMutableArray			*theListeners;
	AsyncSocket				*theDiffusionSocket;
	ByteBuffer				*theInputBuffer;
	NSMutableDictionary     *theAliasMap;
	NSMutableDictionary		*theAckManager;
	int						theMessageSize;
	DFServerDetails *theCurrentServerDetails; 

//	Exposed as properties .. hence the different naming scheme
	DFConnectionDetails		*connectionDetails;
	BOOL					isConnected; /**< Client is connected & handshaken, or currently failing over */
	BOOL					isReconnected;	/**< Client is reconnected & handshaken, or currently failing over */
	BOOL					isDebugging;
	BOOL					isAborted; /**< Has this client been aborted (disconnected with prejudice) from the server */
	BOOL					isReconnecting; /**< Is this client reconnecting to an existing session */
	NSString				*clientID;
	int						serverProtocolVersion;
	
	NSObject<DFClientDelegate>	*delegate;
	NSTimeInterval			lastInteraction;
	
	NSMutableDictionary		*theFragmentedMessages;
}

@property(nonatomic,readonly) BOOL					isConnected;	/**< YES if the client is connected to a Diffusion Server */
@property(nonatomic,readonly) BOOL					isReconnected;	/**< YES if the client is reconnected to a Diffusion Server */
@property(nonatomic,assign) BOOL					isDebugging;	/**< YES if the client should output debug diagnostics while interacting with Diffusion */
@property(nonatomic,readonly) NSString				*clientID;		/**< After the client has connected to Diffusion this contains the unique Client ID */
@property(nonatomic,retain) DFConnectionDetails		*connectionDetails; /**< The DFConnectionDetails object that this client will use to connect to Diffusion */
@property(nonatomic,readonly) int serverProtocolVersion, clientProtocolVersion; /**< the protocol version for this client */
@property(nonatomic,retain) NSObject<DFClientDelegate>	*delegate;	/**< Delegate object to notify when interacting with Diffusion */
@property(nonatomic,readonly) NSTimeInterval lastInteraction; /**< Returns the time (in seconds since the epoch) of the last interaction (send or receive) with the server. Can be 0 if no interaction */


/**
 Close the connection
 */
-(void) close;

/**
 Connect to Diffusion using the pre supplied ConnectionDetails
 */
-(void) connect;


/**
 Reconnect to Diffusion and attempt to reestablish use of the previous session (if there is one)
 */
-(void)reconnect;

/**
 * sends a ping to the connected Diffusion Server, this will result in a onPing(PingMessage) to be sent to the DFClientDelegate
 * @return the timestamp string used
 */
-(NSString *) ping;

/**
 * send a message to the Diffusion Server for the given topic
 * @param topic the message topic
 * @param message the message
 */
-(void) send:(NSString *) topic message: (NSString *) message;

/**
 * send a TopicMessage to Diffusion
 * @param aTopicMessage the TopicMessage to send
 */
-(void) sendTopicMessage:(DFTopicMessage *) aTopicMessage;


/**
 * @param topicSet the topicSet to subscribe to
 */
-(void) subscribe:(NSString *) topicSet;

/**
 * @param topicSet the topicSet to unsubscribe to
 */
-(void) unsubscribe:(NSString *) topicSet;

/**
 * @param credentials send credentials to the server
 */
-(void) sendCredentials:(DFCredentials *) credentials;

/**
 * @param delegate add a DFTopicListenerDelegate, if the delegate topic matches the message topic, then onMessage function will be called
 */
-(void) addTopicListener:(NSObject<DFTopicListenerDelegate>*) delegate;


/**
 * @param delegate remove a DFTopicListenerDelegate
 */
-(void) removeTopicListener:(NSObject<DFTopicListenerDelegate>*) delegate;

/**
 * Remove all topic listeners
 */
-(void) removeAllTopicListeners;

/**
 * Issue a fetch request to the Diffusion server, for the given set of comma delimeted topic-names
 * @param topicSet Name of the topic to fetch
 * @throws DFException if the connected server implements less than protocol level 4
 */
-(void)fetch:(NSString *)topicSet;

/**
 * Issue a fetch request to the Diffusion server, for the given set of comma delimeted topic-names.
 * @param topicSet Name of the topic to fetch
 * @param headers NSArray of NSString that will be relayed back from the server to aid request correlation
 * @throws DFException if the connected server implements less than protocol level 4
 */
-(void)fetch:(NSString *)topicSet withCorrelation:(NSArray*)headers;

/**
 * Send a message acknowledgement back to the server.  This will be required if autoAck is set to false
 * @param message message to acknowledge
 */
-(void) acknowledge:(DFTopicMessage *) message;

/**
 * Create a new DFServiceTopicHandler
 * @param message a service-topic-load message
 * @param delegate an object that implements the DFTopicListenerDelegate protocol
 * @return a newly created DFServiceTopicHandler or nil in case of error
 *
 * @throws DFException if the connected server implements less than protocol level 4
 * @since 4.1
 */
-(DFServiceTopicHandler*)createServiceTopicHandlerWithMessage:(DFTopicMessage*)message andDelegate:(NSObject<DFServiceTopicDelegate>*)delegate;


/**
 * Creates a handler object for a 'paged' Topic.
 *
 * @param message the load message received from the Topic.
 * @param delegate an object that is to receive all notifications from the topic.
 * @return the handler which may be used to send requests to the Topic.
 * 
 * @throws DFException if the connected server implements less than protocol level 4
 * @since 4.1
 */
-(DFPagedTopicHandler*)createPagedTopicHandlerWithMessage:(DFTopicMessage*)message andDelegate:(NSObject<DFPagedTopicDelegate>*)delegate;


/**
 * Dictionary of optional values used when establishing SSL/DPTS connections.
 * Make the iOS device overlook self signed certificates with this, for example...
 * [[DFClient sslOptions] setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCFStreamSSLAllowsAnyRoot];
 */
+(NSMutableDictionary*)sslOptions;

@end

// ===================================
//	Documentation for the front page
// ===================================


/*! \mainpage Diffusion client library for iOS devices 

\section Porting Porting your existing Objective C code from the v3 Diffusion Client
 
With the advent of Diffusion v4 the opportunity was taken to rewrite many parts of the iOS client for Diffusion to make it
more consistent with other iOS libraries. Principally all Diffusion classes are now prefixed 'DF', and explicit 'setter' and
'getter' methods have been replaced with Objective C properties.
 
<table>
<tr>
	<th>v3 class name</th>
	<th>v4 class name</th>
</tr>
<tr>
	<td>DiffusionClient</td>
	<td>DFClient</td>
</tr>
 
 <tr>
 <td>AckProcess</td>
 <td>DFAckProcess</td>
 </tr>

 <tr>
 <td>DiffusionCredentials</td>
 <td>DFCredentials</td>
 </tr>

 <tr>
 <td>DiffusionDelegate</td>
 <td>DFClientDelegate</td>
 </tr>

 <tr>
 <td>DiffusionException</td>
 <td>DFException</td>
 </tr>

 <tr>
 <td>PingMessage</td>
 <td>DFPingMessage</td>
 </tr>

 <tr>
 <td>TopicMessage</td>
 <td>DFTopicMessage</td>
 </tr>

 <tr>
 <td>WebClientMessage</td>
 <td>Merged with DFTopicMessage (see below)</td>
 </tr>

 <tr>
 <td>ConnectionDetails</td>
 <td>DFConnectionDetails</td>
 </tr>

 <tr>
 <td>TopicListenerDelegate</td>
 <td>DFTopicListenerDelegate</td>
 </tr>

 </table>

\subsection WebClientMessage Replacing WebClientMessage
 
The WebClientMessage class has been merged into the DFTopicMessage class. All methods that used to pass a WebClientMessage now pass a DFTopicMessage instead.
All instances of WebClientMessage in 3rd party code should be replaced with DFTopicMessage instead.
 
\section Connecting Configuring and placing a connection to Diffusion
 
The v4 Diffusion client introduces the ability to connect to more than one Diffusion server. This is done with the new DFServerDetails class: DFClient object is given a single DFConnectionDetails object, which in turn contains an array of DFServerDetails. Each DFServerDetails object holds a URL to the Diffusion server in question. A connection might be established thusly ...

\code 
 NSURL *diffURL = [NSURL URLWithString:[NSString stringWithFormat:@"dpt://%@:%d", diffHost, diffPort]];
 DFConnectionDetails *connectionDetails = [[DFConnectionDetails alloc] initWithServer:[[DFServerDetails alloc] initWithURL:diffURL] topics:diffTopics andCredentials:nil];
 
 // Attempt a connection
 DFClient *diffClient = [[DFClient alloc] init];
 diffClient.connectionDetails = connectionDetails;
 diffClient.delegate = self;
 [diffClient connect];
\endcode
 
 */
