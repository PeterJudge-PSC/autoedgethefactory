/** ------------------------------------------------------------------------
    File        : IMessageRequestor
    Purpose     : Interface defined for a message requestor: someone who initiates
                  a bundle/series of requests 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 26 14:55:34 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundle.
  
interface OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor:

    /** Notification that all requests within a bundle are complete. 
        
        @param poBundle The request bundle whose request are now complete   */
    method public void RequestCompleted(input poBundle as IServiceRequestBundle).
    
    /** Notification that all requests within a bundle are about to be executed. 
        
        @param poBundle The request bundle whose requests are being acted upon. */    
    method public void RequestStarted(input poBundle as IServiceRequestBundle).
    
end interface.