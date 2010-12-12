/*------------------------------------------------------------------------
    File        : ITenantManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 06 11:40:31 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface OpenEdge.CommonInfrastructure.Common.ITenantManager:  

    /** (mandatory) the current tenant id */
    define public property CurrentTenantId as longchar no-undo get.
    
end interface.