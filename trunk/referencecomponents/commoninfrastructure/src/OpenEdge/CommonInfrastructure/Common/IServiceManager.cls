/** ------------------------------------------------------------------------
    File        : IServiceManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 18 14:22:47 EST 2010
    Notes       : 
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
    
    method public void StartServices().
    
    method public IService StartService(input poServiceType as ServiceTypeEnum, pcServiceName as character).
    method public IService StartService(input poService as class Class).
    
    method public void StopServices().
    method public void StopService(input poServiceInstance as IService).
    
    @deprecated(version=0.0).
    @todo(task="doc", action="remove from OERA UML").
/*    method public character GetServiceFile(pcServiceName as character, poComponentType as EnumMember).*/

/*    method public IServiceAdapter GetServiceAdapter(input pcService as character).*/

    method public IServiceProvider GetServiceProvider(input pcService as character).
    
end interface.