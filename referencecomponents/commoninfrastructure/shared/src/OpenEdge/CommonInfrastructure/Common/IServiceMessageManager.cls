/** ------------------------------------------------------------------------
    File        : IServiceMessageManager
    Purpose     : Interface for the ServiceMessageManager: a broker for data requests/responses 
                  (messages).
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 26 11:37:08 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IMessageConsumer.

interface OpenEdge.CommonInfrastructure.Common.IServiceMessageManager /* inherits IManager */:

    /** Executes the request(s) asynchroronously. Services a request. The service 
        provider will call ExecuteResponse() in the ServiceMessageManager once it's
        done with the request and ready with a response (IServiceResponse).
        
        @param IMessageConsumer The object initiating this request that will be
                                receive the responses as they are received by
                                the Service Message Manager.
        @param IServiceRequest An array of the request(s) to be executed.  */
    method public void ExecuteRequest (input poMessageConsumer as IMessageConsumer,
                                       input poRequests as IServiceRequest extent).
    
    /** Executes responses for the message requested earlier.
        
        @param poResponse A single response message */
    method public void ExecuteResponse(input poResponse as IServiceResponse).
    
    /** Executes responses for the message(s) requested earlier.
        
        @param poResponse An array of request responses. */
    method public void ExecuteResponse(input poResponse as IServiceResponse extent).
    
    /** A synchronous/linear/connected service request call. Services a 
        request in a synchronous manner. There are no no IMessageConsumers,
        and that whoever calls this method knows how to deal with the responses.
        
        @param IServiceRequest An array of the request(s) to be executed.
        @return IServiceResponse An array of response for the requests.     */
    method public IServiceResponse extent ExecuteRequest(input poRequests as IServiceRequest extent).
    
end interface.