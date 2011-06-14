
/*------------------------------------------------------------------------
    File        : load_salesregion.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Dec 23 13:17:19 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

routine-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
run loadSalesRegions.

procedure loadSalesRegions:
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    
    define variable cRegions as character no-undo.
    
    cRegions = 'NorthAmerica|EMEA|APAC|SouthCentralAmerica'.
    iMax = num-entries(cRegions, '|').
    
    for each Tenant:
        do iLoop = 1 to iMax:
            if can-find(SalesRegion where
                        SalesRegion.Name eq entry(iLoop, cRegions, '|') and
                        SalesRegion.TenantId eq Tenant.TenantId) then
                next.
            
            create SalesRegion.
            assign SalesRegion.Name = entry(iLoop, cRegions, '|')
                   SalesRegion.TenantId = Tenant.TenantId.
        end.
    end.
end procedure.
