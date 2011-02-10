/*------------------------------------------------------------------------
    File        : TenantManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 06 11:40:51 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.ITenantManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo. 
using OpenEdge.CommonInfrastructure.Common.Service.

using OpenEdge.Core.System.InvalidActionError.
using OpenEdge.Lang.Collections.IMap.

class OpenEdge.CommonInfrastructure.Server.TenantManager inherits Service
        implements ITenantManager: 
    
    constructor public TenantManager(input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo):        
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    /** Returns the tenant name for a given security domain.
    
        @param character The domain name.
        @return character The tenant name. */
    method public character GetDomainTenant(input pcDomain as character):
        undo, throw new InvalidActionError(
                        substitute('method not implemented (&1:GetDomainTenant)', this-object:GetClass():TypeName)).
    end method.
    
    /** Returns the tenant Ids associated with a tenant by name.
        
        @param character The tenant name
        @return IMap A map of the logical DB names and tenant Id's for the
                given tenant.   */
    method public IMap GetTenantId(input pcTenantName as character):
        undo, throw new InvalidActionError(
                        substitute('method not implemented (&1:GetTenantId)', this-object:GetClass():TypeName)).
    end method.
    
    /** Determines whether the tenant is valid for the given domain
        
        @param character The domain name
        @param character The tenant name        
        @return logical Whether this is a valid tenant for the domain or not    */
    method protected logical IsValidTenant(input pcDomain as character,
                                           input pcTenantName as character):
        undo, throw new InvalidActionError(
                        substitute('method not implemented (&1:IsValidTenant)', this-object:GetClass():TypeName)).
    end method.
    
end class.