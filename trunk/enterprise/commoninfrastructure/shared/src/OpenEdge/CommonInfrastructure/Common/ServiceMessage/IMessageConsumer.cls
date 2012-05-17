/** ------------------------------------------------------------------------
    File        : IMessageConsumer
    Purpose     : Interface defined for a message consumer: someone who acts on
                  a response from a service request
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 26 14:55:42 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.

interface OpenEdge.CommonInfrastructure.Common.ServiceMessage.IMessageConsumer:
    
    /** Method called upon completion of the action for the ServiceMessage. 
        The actual action type is contained within the response.
        
        @param IServiceResponse The response to the request.      */
    method public void ReceiveMessageResponse(input poResponse as IServiceResponse).
    
end interface.