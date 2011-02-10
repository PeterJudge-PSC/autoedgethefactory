/*------------------------------------------------------------------------
    File        : load_users.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Wed Dec 15 09:19:48 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
{routinelevel.i}

define variable cLoginName as character no-undo.
define variable cDomain as character no-undo.
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable cTenantUsers as character no-undo.

define buffer lbUser for ApplicationUser.

for each Customer no-lock,
    first Tenant where Tenant.TenantId = Customer.TenantId no-lock:

    cDomain  = 'customer.' + Tenant.Name.         
    cLoginName = entry(1, Customer.Name, ' ').
    
    if can-find(lbUser where lbUser.LoginDomain = cDomain and lbUser.LoginName = cLoginName) then
        cLoginName = string(Customer.CustNum).

    if can-find(lbUser where lbUser.LoginDomain = cDomain and lbUser.LoginName = cLoginName) then
        cLoginName = Tenant.Name + '.' + string(Customer.CustNum).
                    
    create ApplicationUser.
    assign ApplicationUser.ApplicationUserId = guid(generate-uuid)
           ApplicationUser.CustomerId = Customer.CustomerId
           ApplicationUser.EmployeeId = ''
           ApplicationUser.LocaleId = Customer.PrimaryLocaleId
           ApplicationUser.LoginDomain = lc(cDomain)
           ApplicationUser.LoginName = lc(cLoginName)
           ApplicationUser.Password = encode('letmein') 
           ApplicationUser.SupplierId = ''
           ApplicationUser.TenantId = Customer.TenantId
           .
end.

for each Employee no-lock,
    first Tenant where Tenant.TenantId = Employee.TenantId no-lock:
                
    cDomain  = 'employee.' + Tenant.Name.         
    cLoginName = Employee.FirstName + '.' + Employee.LastName.
    
    if can-find(lbUser where lbUser.LoginDomain = cDomain and lbUser.LoginName = cLoginName) then
        cLoginName = string(Employee.EmpNum).
    
    create ApplicationUser.
    assign ApplicationUser.ApplicationUserId = guid(generate-uuid)
           ApplicationUser.CustomerId = ''
           ApplicationUser.EmployeeId = Employee.EmployeeId
           ApplicationUser.LocaleId = Tenant.LocaleId 
           ApplicationUser.LoginDomain = lc(cDomain)
           ApplicationUser.LoginName = lc(cLoginName)
           ApplicationUser.Password = encode('letmein') 
           ApplicationUser.SupplierId = ''
           ApplicationUser.TenantId = Employee.TenantId
           .
end.

cTenantUsers = 'admin|guest|factory'.
iMax = num-entries(cTenantUsers, '|').

for each Tenant no-lock:
    do iLoop = 1 to iMax:
        cLoginName = entry(iLoop, cTenantUsers, '|').
        cDomain  = cLoginName + '.' + Tenant.Name.         
        
        create ApplicationUser.
        assign ApplicationUser.ApplicationUserId = guid(generate-uuid)
               ApplicationUser.CustomerId = ''
               ApplicationUser.EmployeeId = ''
               ApplicationUser.LocaleId = Tenant.LocaleId
               ApplicationUser.LoginDomain = lc(cDomain)
               ApplicationUser.LoginName = lc(cLoginName)
               ApplicationUser.Password = encode(cLoginName) 
               ApplicationUser.SupplierId = ''
               ApplicationUser.TenantId = Tenant.TenantId
               .
    end.
end.

/** -- eof -- **/