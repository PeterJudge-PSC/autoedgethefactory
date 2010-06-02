/*------------------------------------------------------------------------
    File        : IServiceManager
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 18 14:22:47 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.

interface OpenEdge.CommonInfrastructure.Common.IServiceManager /* inherits IManager */:
    define public property Kernel as IKernel no-undo get.
    
    @todo(doc="change sig in uml/doc ").
    @todo(doc="Add all below to OERA UML").
    
    method public void StartServices().
    
    method public IService StartService(poServiceType as EnumMember, pcServiceName as character).
    method public IService StartService(poService as class Class).
    
    method public void StopServices().
    method public void StopService(poServiceInstance as IService).
    
    @deprecated(version=0.0).
    @todo(task="doc", action="remove from OERA UML").
/*    method public character GetServiceFile(pcServiceName as character, poComponentType as EnumMember).*/

    method public IServiceAdapter GetServiceAdapter(pcService as character).
    
end interface.