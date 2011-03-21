/*------------------------------------------------------------------------
    File        : list_users.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Fri Feb 25 11:13:20 EST 2011
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* ***************************  Main Block  *************************** */
output to value(session:temp-dir + '/applicationusers.txt').

put unformatted
            'Login Name'       at 10
            'Login Domain'     at 40
            'Password'         at 75
            'Primary Email'    at 90
            'Other'            at 130
            skip
            fill('=', 160)
            skip.           

for each Tenant by Tenant.Name:
    put unformatted 'Brand/Tenant: ' Tenant.Name skip.
    
    for each ApplicationUser where
             ApplicationUser.TenantId = Tenant.TenantId              
             no-lock
             break by ApplicationUser.LoginDomain:

        find ContactDetail where rowid(ContactDetail) eq ? no-lock no-error.
                         
        if ApplicationUser.CustomerId ne '' then
        do:
            find first CustomerContact where
                       CustomerContact.TenantId eq ApplicationUser.TenantId and
                       CustomerContact.CustomerId eq ApplicationUser.CustomerId and
                       CustomerContact.ContactType eq 'email-home'
                       no-lock no-error.
            if available CustomerContact then
            find ContactDetail where
                 ContactDetail.ContactDetailId eq CustomerContact.ContactDetailId
                 no-lock no-error.                       
       end.
       else
       if ApplicationUser.EmployeeId ne '' then
       do:
            find first ContactXref where
                       ContactXref.TenantId eq ApplicationUser.TenantId and
                       ContactXref.ParentId eq ApplicationUser.EmployeeId and
                       ContactXref.ContactType eq 'email-work'
                       no-lock no-error.
            if available ContactXref then                       
                find ContactDetail where
                     ContactDetail.ContactDetailId eq ContactXref.ContactDetailId
                     no-lock no-error.
            find first Salesrep where
                       Salesrep.EmployeeId = ApplicationUser.EmployeeId and
                       Salesrep.TenantId = ApplicationUser.TenantId
                       no-lock no-error.
        end.
    
        put unformatted
            ApplicationUser.LoginName       at 10
            ApplicationUser.LoginDomain     at 40
            'letmein'                       at 75.
        
        if available ContactDetail then
            put unformatted            
                ContactDetail.Detail        at 90.

        if available Salesrep then
            put unformatted 
                'Salesrep Code: ' at 130 Salesrep.Code.
        
        put unformatted skip.
    end.    
    put unformatted skip(2).
end.

output close.