/*------------------------------------------------------------------------
    File        : IServiceMessageManager
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 11:37:08 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundle.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

interface OpenEdge.CommonInfrastructure.Common.IServiceMessageManager:
    
    /** Factory method that creates a message bundle for a given component.
        
        @param poRequestor The object making the request.
        @param  poMessageType OpenEdge.Core.System.MessageTypeEnum (Fetch, Save or Define)  
        @return Returns an IServiceRequestBundle instance, into which we can add ServiceRequests,
                and execute requests.   */
    method public IServiceRequestBundle CreateMessageBundle(input poRequestor as IMessageRequestor,
                                                            input poMessageType as ServiceMessageActionEnum).
    
    /** Add a request to the specified Request list
        @param poMessageBundle The message bundle in which to add the request 
        @param poRequest This is going to be a request specialised by the
                         request type: IFetchRequest, ISaveRequest, IDefineRequest
        @param poMessageConsumer The component that will consumer the message response.                         
      */
    method public void AddRequest(input poMessageBundle as IServiceRequestBundle,
                                  input poRequest as IServiceRequest,
                                  input poMessageConsumer as IMessageConsumer).
    
    /** Remove a request from its message bundle
        @param poRequest The request to remove from its bundle */
    method public void RemoveRequest(input poRequest as IServiceRequest).
    
    /** Execute the request for the component. This method creates a bundle
        and executes the request in one call. It's a wrapper around 
        CreateMessageBundle, AddRequest and ExecuteBundle.
         
        @param poRequestor The object making the request. 
        @param poRequest The Service request being made
        @param poMessageConsumer The component that will consumer the message response. */
    method public void ExecuteRequest(input poRequestor as IMessageRequestor,
                                      input poRequest as IServiceRequest,
                                      input poMessageConsumer as IMessageConsumer).
    
    /** A synchronous/linear/connected/combined request and response call.
        
        @param poRequest An array of service requests. 
        @return Returns an array of responses for the provided requests
      */
    method public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent).
    
    /** Executes responses for the message(s) requested earlier.
        @param poResponse An array of request responses. */
    method public void ExecuteResponse(input poResponse as IServiceResponse extent).
    
    /** Executes responses for the message requested earlier.
        
        @param poResponse A single response message */
    method public void ExecuteResponse(input poResponse as IServiceResponse).
    
end interface.