/*------------------------------------------------------------------------
    File        : TenantManager
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 06 11:40:51 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ITenantManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo. 
using OpenEdge.CommonInfrastructure.Common.Service.

class OpenEdge.CommonInfrastructure.Server.TenantManager inherits Service
    implements ITenantManager: 
    
    constructor public TenantManager (poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.

end class.