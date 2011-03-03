
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
output to value(session:temp-dir + 'applicationusers.txt').

put unformatted
            'Login Name'       at 10
            'Login Domain'     at 40
            'Password'         at 80
            'Other'            at 120  
            skip
            fill('=', 150)
            skip.           

for each Tenant by Tenant.Name:
    put unformatted 'Brand/Tenant: ' Tenant.Name skip.

    
    for each ApplicationUser where
             ApplicationUser.TenantId = Tenant.TenantId              
             no-lock
             break by ApplicationUser.LoginDomain:
    
        put unformatted
            ApplicationUser.LoginName       at 10
            ApplicationUser.LoginDomain     at 40
            ApplicationUser.Password        at 80.

        find first Salesrep where
                   Salesrep.EmployeeId = ApplicationUser.EmployeeId and
                   Salesrep.TenantId = ApplicationUser.TenantId
                   no-lock no-error.
        if available Salesrep then
            put unformatted 
                'Salesrep Code: ' at 120 Salesrep.Code.
        
        put unformatted skip.
    end.    
    put unformatted skip(2).
end.

output close.