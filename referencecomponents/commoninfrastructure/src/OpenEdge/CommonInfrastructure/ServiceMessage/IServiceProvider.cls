/** ------------------------------------------------------------------------
    File        : IServiceProvider
    Purpose     : Provides an interface to an object that services a request.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 18 12:54:30 EDT 2010
    Notes       : * This interface can be implemented on the client and the server
                    (by a Service Adapter and a Business Entity, for instance). 
                  * A ServiceAdapter is thus an <i>implementation</i> of this interface.
                  * A single service may map to different implementations depending
                    on whether the code is client or server side; on the client the 
                    implementation will call across an AppServer. On the service, it 
                    will simply call into the business components layer.
                  * Note that this interface has nothing to do with the InjectABL concept 
                    of providers. This interface is a provider of data.
                  * A service provider instance is responsible for interacting
                    with a single service.
                  * Each request, however, can potentially interact with a different
                    ServiceMessageManager.
  --------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider:  
    /** (mandatory) The service for which this service adapter is servicing a request. */
    define public property Service as character no-undo get.
    
    /** Services a request. The service or adapter will call ExecuteResponse() in the ServiceMessageManager
        once it's done with the request. The object that implements this interface will call back to
        the ServiceMessageManager when it is done and it's ready with a response (IServiceResponse).
        
        @param poRequest The request to service.
        @param poServiceMessageManager The message manager controlling this request. */
    method public void ExecuteRequest(input poRequest as IServiceRequest extent,
                                      input poServiceMessageManager as IServiceMessageManager).
                                      
end interface.