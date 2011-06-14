/*------------------------------------------------------------------------
    File        : list_users.p
    Purpose     : Lists application users , domains, passwords and emails 
    Author(s)   : pjudge
    Created     : Fri Feb 25 11:13:20 EST 2011
    Notes       :
  ----------------------------------------------------------------------*/
output to value(session:temp-dir + '/applicationusers.txt').

put unformatted
            'Login Name'       at 10
            'Login Domain'     at 40
            'Password'         at 75
            'Primary Email'    at 90
            skip
            fill('=', 130)
            skip.
            
put unformatted 'CUSTOMERS: ' skip.
for each Tenant 
         no-lock
         by Tenant.Name:
    
    if not can-find(first ApplicationUser where
                          ApplicationUser.TenantId eq Tenant.TenantId and             
                          ApplicationUser.CustomerId ne '') then
        next.
                      
    put unformatted caps(Tenant.Name) at 3 skip.
    
    for each ApplicationUser where
             ApplicationUser.TenantId eq Tenant.TenantId and             
             ApplicationUser.CustomerId ne ''
             no-lock
             by ApplicationUser.LoginName:
        /* clear out buffer */
        find ContactDetail where rowid(ContactDetail) eq ? no-lock no-error.
        
        find first CustomerContact where
                   CustomerContact.TenantId eq ApplicationUser.TenantId and
                   CustomerContact.CustomerId eq ApplicationUser.CustomerId and
                   CustomerContact.ContactType eq 'email-home'
                   no-lock no-error.
        if available CustomerContact then
            find ContactDetail where
                 ContactDetail.ContactDetailId eq CustomerContact.ContactDetailId
                 no-lock no-error.
        
        put unformatted
            ApplicationUser.LoginName       at 10
            ApplicationUser.LoginDomain     at 40
            'letmein'                       at 75.
    
        if available ContactDetail then
            put unformatted 
                ContactDetail.Detail        at 90
                skip.
    end.
    put unformatted '  ' skip.
end.
put unformatted '  ' skip.
            
put unformatted 'EMPLOYEES: ' skip.
for each Tenant no-lock by Tenant.Name:
    
    if not can-find(first ApplicationUser where
                          ApplicationUser.TenantId eq Tenant.TenantId and             
                          ApplicationUser.EmployeeId ne '') then
        next.
    
    put unformatted caps(Tenant.Name) at 3 skip.
    
    for each Department where
             Department.TenantId eq Tenant.TenantId
             no-lock
             by Department.Name:
    put unformatted caps(Department.Name) at 5 skip.                 
    
        for each Employee where
                 Employee.TenantId eq Department.TenantId and
                 Employee.DepartmentId eq Department.DepartmentId
                 no-lock,
            each ApplicationUser where                
                 ApplicationUser.TenantId eq Tenant.TenantId and
                 ApplicationUser.EmployeeId eq Employee.EmployeeId       
                 no-lock
                 by ApplicationUser.LoginName:
            
            find ContactDetail where rowid(ContactDetail) eq ? no-lock no-error.
            
            find first ContactXref where
                       ContactXref.TenantId eq ApplicationUser.TenantId and
                       ContactXref.ParentId eq ApplicationUser.EmployeeId and
                       ContactXref.ContactType eq 'email-work'
                       no-lock no-error.
            if available ContactXref then
                find ContactDetail where
                     ContactDetail.ContactDetailId eq ContactXref.ContactDetailId
                     no-lock no-error.
        
            put unformatted
                ApplicationUser.LoginName       at 10
                ApplicationUser.LoginDomain     at 40
                'letmein'                       at 75.
            
            if available ContactDetail then
                put unformatted            
                    ContactDetail.Detail        at 90
                    skip.
        end.
        put unformatted '  ' skip.
    end.
    put unformatted '  ' skip.
end.

put unformatted 'SYSTEM: ' skip.
for each Tenant no-lock by Tenant.Name:

    put unformatted caps(Tenant.Name) at 3 skip.    
    
    if not can-find(first ApplicationUser where
                          ApplicationUser.TenantId eq Tenant.TenantId and
                          ApplicationUser.CustomerId eq '' and
                          ApplicationUser.EmployeeId eq '') then
        next.
        
    for each ApplicationUser where
             ApplicationUser.TenantId eq Tenant.TenantId and
             ApplicationUser.CustomerId eq '' and
             ApplicationUser.EmployeeId eq ''
             no-lock
             by ApplicationUser.LoginName:         
        put unformatted
            ApplicationUser.LoginName       at 10
            ApplicationUser.LoginDomain     at 40
            'letmein'                       at 75
            skip.
    end.
    put unformatted '  ' skip.
end.
output close.