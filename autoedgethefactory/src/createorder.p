def var i as int.
def var dOrder as date.

find first tenant no-lock.
find AddressType where  AddressType.AddressType eq 'billing' no-lock.

DO i = 1 to 100:
    create order.
    assign 
        order.orderid = guid(generate-uuid)
        order.ordernum = 285 + i
        order.tenantid = tenant.tenantid.

 find customer where
     customer.tenantid = tenant.tenantid and
     customer.custnum = random(1, 100)
     no-lock.
        
    if i < 33 then 
    do:
        find statusdetail where statusdetail.code = 'order-build-complete' no-lock.
        dorder = today - 3.
    END.
    else if i < 66 then 
    do:
        find statusdetail where statusdetail.code = 'order-build-start' no-lock.
        dOrder = (today - 2) .
    END.
    else 
    do:
        find statusdetail where statusdetail.code = 'order-build-new' no-lock.
            dOrder = (today - 1).
    END.

    run addBillingAddress(customer.customerid).
 
    find AddressXref where
        AddressXref.AddressType = AddressType.AddressType  and
        AddressXref.ParentId = customer.customerid and
        AddressXref.TenantId = Tenant.TenantId
        no-lock.

    assign Order.OrderDate = dOrder
        Order.StatusId = StatusDetail.StatusDetailId
        Order.CustomerId = Customer.CustomerId
        order.billingaddressid = AddressXref.AddressDetailId
        .
END.

procedure addBillingAddress:
    define input parameter pcCustomerId as character no-undo.
    
    define query qryAddresses for AddressDetail scrolling.
    open query qryAddresses preselect each AddressDetail.
    
    reposition qryAddresses to row random(1, query qryAddresses:num-results).
    
    find AddressType where  AddressType.AddressType eq 'billing' no-lock.
    
    create AddressXref.
    assign AddressXref.AddressDetailId = AddressDetail.AddressDetailId
           AddressXref.AddressType = AddressType.AddressType
           AddressXref.ParentId = pcCustomerId
           AddressXref.TenantId = Tenant.TenantId.
    
    close query qryAddresses.
end procedure.    


