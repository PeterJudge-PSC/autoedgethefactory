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
                    of providers. This interface is a provider of data from a service
                    (OERA Business Component).
                  * A service provider instance is responsible for interacting
                    with a single service.
  --------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider:  
    /** (mandatory) The service for which this provider is servicing a request. */
    define public property Service as character no-undo get.
    
    /** Services a request. The service provider will call ExecuteResponse() in 
        the ServiceMessageManager once it's done with the request and ready with 
        a response (IServiceResponse); typically this will happen in a callback of
        some sort.
        
        @param IServiceRequest An array of requests to service. */
    method public void ExecuteRequest(input poRequest as IServiceRequest extent).
    
    /** Services a request in a synchronous manner. The responses are returned from the
        ExecuteSyncRequest() call, rather than the service provider calling ExecuteResponse() in the
        ServiceMessageManager at a later time.
        
        @param IServiceRequest An array of requests to service.
        @return IServiceResponse An array of responses to the request.  */
    method public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent).
    
end interface.