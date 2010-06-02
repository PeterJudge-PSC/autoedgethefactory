/*------------------------------------------------------------------------
    File        : IServiceMessageManager
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 11:37:08 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundle.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor.
using OpenEdge.Core.System.ServiceMessageActionEnum.

interface OpenEdge.CommonInfrastructure.Common.IServiceMessageManager:
    
    /** Creates a message bundle for a given component. 
        
        @param  poRequestor
        @param  poMessageType OpenEdge.Core.System.MessageTypeEnum (Fetch, Save or Define)  
        @return Returns a ServiceMessageBundle instance, into which we can add ServiceMessages,
                and execute requests. 
      */
    method public ServiceMessageBundle CreateMessageBundle(poRequestor as IMessageRequestor,
                                                           poMessageType as ServiceMessageActionEnum).
    
    /** Add a request to the specified Request list
        @param poMessageBundle The message bundle in which to add the request 
        @param poRequest This is going to be a request specialised by the
                         request type: IFetchRequest, ISaveRequest, IDefineRequest
        @poMessageConsumer The component(s) that will consumer the message response.                         
      */
    method public void AddRequest(poMessageBundle as ServiceMessageBundle,
                                  poRequest as IServiceMessage,
                                  poMessageConsumer as IMessageConsumer).
    
    /** Remove a request from its message bundle
        @param poRequest
      */
    method public void RemoveRequest(poRequest as IServiceMessage).
    
    /** Execute the request for the component. The caller is subscribed
        to the DataFetched event.
        @param poRequestor
        @param poRequest
        @param poRequestType
      */
    method public void ExecuteRequest(poRequestor as IMessageRequestor,
                                      poRequest as IServiceMessage,
                                      poMessageConsumer as IMessageConsumer). 
    
    /** Executes responses for the message(s) requested earlier.
        @param poResponse An array of request responses. */
    method public void ExecuteResponse(poResponse as IServiceMessage extent).
    
    /** Executes responses for the message requested earlier.
        @param poResponse A response message */
    method public void ExecuteResponse(poResponse as IServiceMessage).
    
end interface.