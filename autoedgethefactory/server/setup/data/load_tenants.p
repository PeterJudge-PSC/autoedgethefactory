/** ------------------------------------------------------------------------
    File        : load_tenants.p
    Purpose     : 

    Syntax      :

    Description : Loads tenants from XML

    Author(s)   : pjudge
    Created     : Wed Dec 15 08:53:20 EST 2010
    Notes       : * Tenants are car manufacturers
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{routinelevel.i}

define buffer lbParent for Tenant.

define variable cTenants as character no-undo.
define variable cParent as character no-undo.
define variable cBrand as character no-undo.
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.

cTenants = 'motorgroupeast:genericmotors|motorgroupeast:h2omotors|motorgroupeast:hinda|motorgroupeast:toyola|h2omotors:scubaroo|h2omotors:fjord|genericmotors:potomoc|genericmotors:chery'.

find first Locale no-lock.

iMax = num-entries(cTenants, '|').
do iLoop = 1 to iMax:
    if num-entries(entry(iLoop, cTenants, '|'), ':') eq 1 then
        assign cParent = ''
               cBrand = entry(iLoop, cTenants, '|').
    else
        assign cParent = entry(1, entry(iLoop, cTenants, '|'), ':')
               cBrand = entry(2, entry(iLoop, cTenants, '|'), ':').
    
    create Tenant.
    assign Tenant.TenantId = guid(generate-uuid)
           Tenant.Name = cBrand
           Tenant.LocaleId = Locale.LocaleId.
    
    find lbParent where
         lbParent.Name = cParent
         no-lock no-error.
    if available lbParent then
        Tenant.ParentTenantId = lbParent.TenantId.
    else
        Tenant.ParentTenantId = ''.        
end.
/* -- eof -- */