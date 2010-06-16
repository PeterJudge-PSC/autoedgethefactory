/* *------------------------------------------------------------------------
    File        : IServiceAdapter
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sat Feb 20 02:54:06 EST 2010
    Notes       : * A service adapter instance is responsible for interacting
                    with a single service.
                  * Each request, however, can potentially interact with a different
                    ServiceMessageManager.
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter:
    /** (mandatory) The service for which this service adapter is servicing a request. */
    define public property Service as character no-undo get.
    
    /** (mandatory) Stores a reference to the session's Service Manager */
    define public property ServiceManager as IServiceManager no-undo get.
    
    /** Services a request. The service or adapter will call ExecuteResponse() in the ServiceMessageManager
        once it's done with the request. The object that implements this interface will call back to
        the ServiceMessageManager when it is done and it's ready with a response (IServiceResponse).
        
        @param poRequest The request to service.
        @param poServiceMessageManager The message manager controlling this request. */
    method public void ExecuteRequest(input poRequest as IServiceRequest extent,
                                      input poServiceMessageManager as IServiceMessageManager).
    
end interface.

