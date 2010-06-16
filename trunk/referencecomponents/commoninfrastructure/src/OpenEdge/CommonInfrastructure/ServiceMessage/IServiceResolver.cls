/** -----------------------------------------------------------------------
    File        : IServiceResolver
    Purpose     : Provides an interface for resolving a service name into an 
                  executable reference (handle or object).
    Syntax      : 
    Description : 
    @Author     : pjudge
    Created     : Mon Jun 07 10:29:10 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResolver.
using OpenEdge.CommonInfrastructure.Common.IService.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResolver:
    
    /** Resolves a service into an executable handle, for remote (to this session)
        execution.
        
        @param pcServiceName The name of the service being resolved.
        @return The handle of the remote service (AppServer etc) on which to make the 
        call.      */
    method public handle ResolveRemoteService(input pcServiceName as character).

    /** Resolves a service into an reference, for local execution.
        
        @param pcServiceName The name of the service being resolved.
        @return The IService object representing the service.       */
    method public IService ResolveLocalService(input pcServiceName as character).
    
end interface.