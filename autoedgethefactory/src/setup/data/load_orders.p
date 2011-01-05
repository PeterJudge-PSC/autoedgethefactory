/*------------------------------------------------------------------------
    File        : load_orders.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Wed Dec 15 10:08:54 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

routine-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */
function GetAddressId returns character 
    (input pcType as character,
     input pcCustomerId as character,
     input pcTenantId as character):
    
    find AddressType where AddressType.AddressType = pcType no-lock.
    
    find AddressXref where
         AddressXref.AddressType = AddressType.AddressType  and
         AddressXref.ParentId = pcCustomerId and
         AddressXref.TenantId = pcTenantId
         no-lock no-error.                        
    if not available AddressXref then         
        run addAddress(AddressType.AddressType, pcCustomerId, pcTenantId).
        
    find AddressXref where
         AddressXref.AddressType = AddressType.AddressType  and
         AddressXref.ParentId = pcCustomerId and
         AddressXref.TenantId = pcTenantId
         no-lock.
    
    return AddressXref.AddressDetailId.        
end function.         

/* ***************************  Main Block  *************************** */
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable dOrder as date no-undo.
define variable iNumTenants as integer no-undo.
define variable iNumAddresses as integer no-undo.

define query qryTenant for Tenant scrolling.
define query qryAddresses for AddressDetail scrolling.

open query qryAddresses preselect each AddressDetail.
iNumAddresses = query qryAddresses:num-results - 1.

open query qryTenant preselect each Tenant  no-lock.

iNumTenants = query qryTenant:num-results - 1.
imax = 100.

do iloop = 1 to iMax:
    reposition qryTenant to row random(0, iNumTenants).
    get next qryTenant no-lock.
    
    create Order.
    assign 
        Order.OrderId = guid(generate-uuid)
        Order.OrderNum = 285 + iLoop
        Order.TenantId = Tenant.TenantId.

    find Customer where
         Customer.TenantId = Tenant.TenantId and
         Customer.CustNum = random(1, 100)
         no-lock no-error.         
    if not available Customer then
        find Customer where
             Customer.TenantId = Tenant.TenantId and
             Customer.CustNum = random(1, 100)
             no-lock no-error.
    if not available Customer then
        find Customer where
             Customer.TenantId = Tenant.TenantId and
             Customer.CustNum = random(1, 100)
             no-lock no-error.
    if not available Customer then
        next.
            
    if iLoop < 33 then 
    do:
        find StatusDetail where StatusDetail.Code = 'order-build-complete' no-lock.
        dorder = today - 3.
    END.
    else if iLoop < 66 then 
    do:
        find StatusDetail where StatusDetail.Code = 'order-build-start' no-lock.
        dOrder = (today - 2) .
    END.
    else 
    do:
        find StatusDetail where StatusDetail.Code = 'order-new' no-lock.
            dOrder = (today - 1).
    END.

    assign Order.OrderDate = dOrder
           Order.StatusId = StatusDetail.StatusDetailId
           Order.CustomerId = Customer.CustomerId
           Order.BillingAddressId = GetAddressId('Billing', Customer.CustomerId, Tenant.TenantId)
           Order.ShippingAddressId = GetAddressId('Shipping', Customer.CustomerId, Tenant.TenantId)
           Order.InventoryTransId = ''
           Order.InvoiceId = ''.
end.

procedure AddAddress:
    define input parameter pcType as character no-undo.
    define input parameter pcCustomerId as character no-undo.
    define input parameter pcTenantId as character no-undo.
    
    reposition qryAddresses to row random(0, iNumAddresses).
    get next qryAddresses no-lock.
    
    find AddressType where  AddressType.AddressType = pcType no-lock.
    
    create AddressXref.
    assign AddressXref.AddressDetailId = AddressDetail.AddressDetailId
           AddressXref.AddressType = AddressType.AddressType
           AddressXref.ParentId = pcCustomerId
           AddressXref.TenantId = pcTenantId.
    
    close query qryAddresses.
end procedure.    
