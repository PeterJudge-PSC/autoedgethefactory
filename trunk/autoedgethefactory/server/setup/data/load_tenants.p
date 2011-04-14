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
routine-level on error undo, throw.

define buffer lbParent for Tenant.

define variable cTenants as character no-undo.
define variable cParent as character no-undo.
define variable cBrand as character no-undo.
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable cDomainType as character no-undo.

cTenants = 'motorgroupeast:genericmotors|motorgroupeast:h2omotors|motorgroupeast:hinda|motorgroupeast:toyola|h2omotors:scubaroo|h2omotors:fjord|genericmotors:potomoc|genericmotors:chery'.

run CreateSecurityAuthenticationSystem(output cDomainType).

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
    
    run CreateSecurityAuthenticationDomain(cDomainType, Tenant.Name, Tenant.TenantId).                    
end.

procedure CreateSecurityAuthenticationSystem:
    define output parameter pcDomainType as character no-undo.
    
    create _sec-authentication-system.
    assign pcDomainType = 'TABLE-ApplicationUser'
           _sec-authentication-system._Domain-type = pcDomainType
           _sec-authentication-system._Domain-type-description = 'The AutoEdge|TheFactory ApplicationUser serves as the authentication domain'
           .
end procedure.

procedure CreateSecurityAuthenticationDomain:
    define input  parameter pcDomainType as character no-undo.
    define input  parameter pcTenantName as character no-undo.
    define input  parameter pcTenantId as character no-undo.
    
    create _sec-authentication-domain.
    assign _sec-authentication-domain._Domain-name = lc(pcTenantName)
           _sec-authentication-domain._Domain-type = pcDomainType
           _sec-authentication-domain._Domain-description = substitute('Authentication Domain for the &1 tenant', pcTenantName)
           _sec-authentication-domain._Domain-access-code = audit-policy:encrypt-audit-mac-key(substitute('&1::&2', pcDomainType, pcTenantId))
           _sec-authentication-domain._Domain-enabled = true
           .
end procedure.
    

/* -- eof -- */