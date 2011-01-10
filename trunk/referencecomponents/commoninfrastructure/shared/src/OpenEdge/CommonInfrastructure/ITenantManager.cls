/** ------------------------------------------------------------------------
    File        : ITenantManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 06 11:40:31 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Lang.Collections.IMap.

interface OpenEdge.CommonInfrastructure.ITenantManager:  
    
    /** Returns the tenant name for a given security domain.
    
        @param character The domain name.
        @return character The tenant name. */
    method public character GetDomainTenant(input pcDomain as character).
    
    /** Returns the tenant Ids associated with a tenant by name.
        
        @param character The tenant name
        @return IMap A map of the logical DB names and tenant Id's for the
                given tenant.   */
    method public IMap GetTenantId (input pcTenantName as character).

end interface.