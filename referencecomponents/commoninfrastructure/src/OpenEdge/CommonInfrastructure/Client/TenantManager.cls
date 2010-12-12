/*------------------------------------------------------------------------
    File        : TenantManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 06 11:40:51 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ITenantManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo. 
using OpenEdge.CommonInfrastructure.Common.Service.

class OpenEdge.CommonInfrastructure.Client.TenantManager inherits Service
    implements ITenantManager: 

    /** (mandatory) the current tenant id */
    define public property CurrentTenantId as longchar no-undo
        get():
            return 'ae90e4c7-57de-a780-e011-bd0361d4b88f'.
        end get. 
        
    constructor public TenantManager(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.

end class.    