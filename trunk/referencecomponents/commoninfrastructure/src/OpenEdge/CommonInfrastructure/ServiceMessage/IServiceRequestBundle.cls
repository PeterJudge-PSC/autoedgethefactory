/** ------------------------------------------------------------------------
    File        : IServiceRequestBundle
    Purpose     : Interface 
    Syntax      : 
    Description : 
    @author pjudge, Wed Jun 09 12:03:58 EDT 2010
    Notes       :  
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessageCollection.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundle:
    /** (mandatory) The ServiceMessageManager  managing the requests in this bundle. */
    define public property ServiceMessageManager as IServiceMessageManager no-undo get.
    
    /** (mandatory) The object making the requests contained in this bundle */
    define public property Requestor as IMessageRequestor no-undo get.
    
    /** (mandatory) The ServiceMessageActionEnum  type of action this bundle is performing */
    define public property ActionType as ServiceMessageActionEnum no-undo get.
    
    /* (derived) The total number of IServiceRequests this bundle is managing */
    define public property TotalRequests as integer no-undo get.
    
    /* (derived) The number of IServiceRequests that have outstanding requests */
    define public property OutstandingRequests as integer no-undo get.
    
    /** Add a request to an existing bundle
    
        @param poRequest The request to add to the bundle   */
    method public void AddRequest(input poRequest as IServiceRequest).
    
    /** Remove a request from the bundle
        @param poRequest The request to remove       */
    method public void RemoveRequest(input poRequest as IServiceRequest).

    /** A response has been received for a given message (by ID). The
        ServiceMessageManager informs the message consumer of the response.
        
        @param pcMessageId The unique identifier of the message.    */
    method public void ResponseReceived(pcMessageId as character).
    
    /** Execute all of a bundle's requests.  */
    method public void ExecuteBundle().
    
end interface.