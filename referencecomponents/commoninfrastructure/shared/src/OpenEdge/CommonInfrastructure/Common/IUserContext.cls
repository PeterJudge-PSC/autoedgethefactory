/** ------------------------------------------------------------------------
    File        : IUserContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author      : pjudge
    Created     : Mon Jun 07 14:26:49 EDT 2010
    Notes       : 
  --------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.ITenantManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.Lang.Collections.IMap.

interface OpenEdge.CommonInfrastructure.Common.IUserContext:
    
    /* name of the user to whom this context applies */
    define public property UserName as character no-undo get.
    
    /* domain of the user to whom this context applies */
    define public property UserDomain as character no-undo get.
    
    /** Unique identifier for the client session */
    define public property ContextId as longchar no-undo get.
    
    /** The tenant to whom this user belongs */
    define public property TenantName as character no-undo get.
    
    /** A collection of tenant Ids for this User. 
        
        key   = Logical DB Name
        value = TenantId        */
    define public property TenantId as IMap no-undo get.
    
    /** A collection of properties associated with this context. These
        can be any key/value set of objects (key and value types should 
        be serialisable). */
    define public property UserProperties as IMap no-undo get.
    
    /** Sets up the user's tenancy (including the tenant name and id map).
        
        @param ITenantManager The session's tenant manager. */
    method public void EstablishTenancy(input poTenantManager as ITenantManager).
    
end interface.