/** ------------------------------------------------------------------------
    File        : IServiceManager
    Purpose     : The ServiceManager provides access into a session's services.
                  Services are things that are exposed internally to the application
                  - such as a ContextManager - and also externally such as to a WebService.
                  These services can be composed of Components (and are in fact specialised
                  Components).
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 18 14:22:47 EST 2010
    Notes       : * The ServiceManager typically bootstraps the session.
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.Common.ServiceTypeEnum.
using OpenEdge.Core.InjectABL.IKernel.
using Progress.Lang.Class.

interface OpenEdge.CommonInfrastructure.Common.IServiceManager /* inherits IManager */:
    /** (mandatory) Contains the InjectABL kernel that's responsible for mapping 
        services (in the sense of Interfaces) to concrete instances. */
    define public property Kernel as IKernel no-undo get.
    
    @todo(doc="change sig in uml/doc ").
    @todo(doc="Add all below to OERA UML").
    
    /** Starts all registered services */
    method public void StartServices().
    
    /** Starts a service
        @param poServiceType component type; ignored when InjectABL used, since we work off interfaces, which are
               unique within the application.
        @param pcComponentName 
        @return An IService instance of the requested service */    
    method public IService StartService(input poServiceType as ServiceTypeEnum,
                                        input pcServiceName as character).

    /** Starts a service using the InjectABL dependency injection container.
        @param poService The class of the service to start 
        @return An IService instance of the requested service */
    method public IService StartService(input poService as class Class).
    
    /** Returns an instance of a service, if one exists. May AutoStart
        an instance.
        @param poService The class of the service to start 
        @return An IService instance of the requested service */
    method public IService GetService(input poService as class Class).
    
    /** Stop all services */
    method public void StopServices().
    
    /** Stops a running service.
        @param poServiceInstance A running service instance */
    method public void StopService(input poServiceInstance as IService).
    
    @deprecated(version=0.0).
    @todo(task="doc", action="remove from OERA UML").
/*    method public character GetServiceFile(pcServiceName as character, poComponentType as EnumMember).*/

/*    method public IServiceAdapter GetServiceAdapter(input pcService as character).*/


    /** Returns a service provider for a given service. This service p
    
        See OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider for more details.         
        
        @param pcService The 
        @return An IServiceProvider instance */
    method public IServiceProvider GetServiceProvider(input pcService as character).
    
end interface.
