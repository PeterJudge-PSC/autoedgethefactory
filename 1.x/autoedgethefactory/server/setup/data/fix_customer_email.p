/*------------------------------------------------------------------------
    File        : fix_customer_email.p
    Purpose     : Sets all customer email addresses to the same domain *customer.aetf'
    Author(s)   : pjudge
    Created     : 
    Notes       : * Also also prevents duplicates and ensure that there's a email-home
                    contact type.
  ----------------------------------------------------------------------*/
define buffer lbCustomer for Customer.
define buffer lbContactDetail for ContactDetail.
define buffer lbUpdateContactDetail for ContactDetail.
define buffer lbExistingContactDetail for ContactDetail.
define buffer lbCustomerContact for CustomerContact.
define buffer lbContactType for ContactType.

define variable cEmailName as character   no-undo.

find lbContactType where lbContactType.Name eq 'email-home' no-lock.

for each lbCustomer no-lock:
    
    find lbCustomerContact where
         lbCustomerContact.CustomerId eq lbCustomer.CustomerId and
         lbCustomerContact.TenantId eq lbCustomer.TenantId and
         lbCustomerContact.ContactType eq lbContactType.Name
         no-lock no-error.
    if not available lbCustomerContact then
    do:
        create lbCustomerContact.
        assign lbCustomerContact.CustomerId = lbCustomer.CustomerId
               lbCustomerContact.TenantId = lbCustomer.TenantId
               lbCustomerContact.ContactType = lbContactType.Name.
    end.
    
    find lbContactDetail where
         lbContactDetail.ContactDetailId = lbCustomerContact.ContactDetailId
         no-lock no-error.
    if available lbContactDetail then
        cEmailName = entry(1, lbContactDetail.Detail, '@')  + '@customer.aetf'.
    else
        cEmailName = trim(entry(1, lbCustomer.Name, ' '))  + '@customer.aetf'.
    
    if available lbContactDetail then
        find lbUpdateContactDetail where
             rowid(lbUpdateContactDetail) eq rowid(lbContactDetail)
             exclusive-lock.
    
    find first lbExistingContactDetail where
               lbExistingContactDetail.Detail eq cEmailName
               no-lock no-error.
    if available lbExistingContactDetail then
    do:
        find current lbCustomerContact exclusive-lock. 
        lbCustomerContact.ContactDetailId = lbExistingContactDetail.ContactDetailId.
        
        if available lbUpdateContactDetail and
           lbUpdateContactDetail.ContactDetailId ne lbExistingContactDetail.ContactDetailId then
            delete lbUpdateContactDetail.
    end.
    else
    do:
        if not available lbUpdateContactDetail then
        do:
            create lbUpdateContactDetail.
            lbUpdateContactDetail.ContactDetailId = guid(generate-uuid).
        end.
        
        /* update */
        lbUpdateContactDetail.Detail = cEmailName.
    end.        
end.
