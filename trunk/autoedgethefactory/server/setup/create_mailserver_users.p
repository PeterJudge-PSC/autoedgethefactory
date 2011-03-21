/*------------------------------------------------------------------------
    File        : create_mailserver_users.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Tue Mar 08 15:23:43 EST 2011
    Notes       :
  ----------------------------------------------------------------------*/
define variable chMailServer as com-handle no-undo.
define variable chDomain as com-handle no-undo.
define variable chAccount as com-handle no-undo.
define variable cPassword as character no-undo.

function AddDomain returns com-handle(input pcDomain as char):
    define variable chDomain as com-handle no-undo.
    
    chDomain = chMailServer:Domains:ItemByName(pcDomain) no-error.
    if not valid-handle(chDomain) then
    do:
        chDomain = chMailServer:Domains:Add().
            chDomain:Name = pcDomain.
            chDomain:Active = true.
        chDomain:Save().
    end.
    
    return chDomain.
end function. 


/* since we're in demo-land :) the password is always a simple, constant value */
cPassword = 'letmein'.

find ContactType where ContactType.Name eq 'email-work' no-lock no-error.  

create "hMailServer.Application" chMailServer no-error.
if not valid-handle(chMailServer) then
do:
    message 'hMailServer not installed. Aborting.'.
    return.
end.

chMailServer:Authenticate("Administrator", "4mail").

/* add domain and salesrep accounts per dealer */
for each Dealer no-lock:
    
    find ContactXref where
         ContactXref.TenantId eq Dealer.TenantId and
         ContactXref.ParentId eq Dealer.DealerId and
         ContactXref.ContactType eq 'email-work'
         no-lock no-error.
     if available ContactXref then
        find ContactDetail where
             ContactDetail.ContactDetailId eq ContactXref.ContactDetailId
             no-lock no-error.
     if available ContactDetail then
     do:
        chDomain = AddDomain(entry(2, ContactDetail.Detail, '@')).
        
        chAccount = chDomain:Accounts:ItemByAddress(ContactDetail.Detail) no-error.
        if not valid-handle(chAccount) then
        do:
            chAccount = chDomain:Accounts:Add().
                chAccount:Address = ContactDetail.Detail.
                chAccount:PersonLastName = Dealer.Name.
                chAccount:Password = cPassword.
                chAccount:Active = true.
                chAccount:MaxSize = 100.    /* 100MB per user */
            chAccount:Save().
            release object chAccount.
            chAccount = ?.
        end.
    end.
    
    /* create the sales email */
    find ContactDetail where
         ContactDetail.ContactDetailId eq Dealer.SalesEmailContactId
         no-lock no-error.
    if available ContactDetail then
    do:
        chDomain = AddDomain(entry(2, ContactDetail.Detail, '@')).
        
        chAccount = chDomain:Accounts:ItemByAddress(ContactDetail.Detail) no-error.
        if not valid-handle(chAccount) then
        do:
            chAccount = chDomain:Accounts:Add().
                chAccount:Address = ContactDetail.Detail.
                chAccount:PersonLastName = Dealer.Name.
                chAccount:Password = cPassword.
                chAccount:Active = true.
                chAccount:MaxSize = 100.    /* 100MB per user */
            chAccount:Save().
            release object chAccount.
            chAccount = ?.
        end.
    end.
    
    /* create the info email */
    find ContactDetail where
         ContactDetail.ContactDetailId eq Dealer.InfoEmailContactId
         no-lock no-error.
    if available ContactDetail then
    do:
        chDomain = AddDomain(entry(2, ContactDetail.Detail, '@')).
        
        chAccount = chDomain:Accounts:ItemByAddress(ContactDetail.Detail) no-error.
        if not valid-handle(chAccount) then
        do:
            chAccount = chDomain:Accounts:Add().
                chAccount:Address = ContactDetail.Detail.
                chAccount:PersonLastName = Dealer.Name.
                chAccount:Password = cPassword.
                chAccount:Active = true.
                chAccount:MaxSize = 100.    /* 100MB per user */
            chAccount:Save().
            release object chAccount.
            chAccount = ?.
        end.
    end.
    
    for each Employee where
             Employee.TenantId eq Dealer.TenantId and 
             Employee.DealerId eq Dealer.DealerId 
             no-lock,
      first ContactXref where
            ContactXref.TenantId eq Employee.TenantId and
            ContactXref.ContactType eq ContactType.Name and
            ContactXref.ParentId eq Employee.EmployeeId
            no-lock,
      first ContactDetail where
            ContactDetail.ContactDetailId eq ContactXref.ContactDetailId
            no-lock:
        chAccount = chDomain:Accounts:ItemByAddress(ContactDetail.Detail) no-error.
        if not valid-handle(chAccount) then
        do:
            chAccount = chDomain:Accounts:Add().
                chAccount:Address = ContactDetail.Detail.
                chAccount:PersonFirstName = Employee.FirstName.
                chAccount:PersonLastName = Employee.LastName.
                chAccount:Password = cPassword.
                chAccount:Active = true.
                chAccount:MaxSize = 100.    /* 100MB per user */
            chAccount:Save().
            release object chAccount.
            chAccount = ?.
        end.
    end.
    
    release object chDomain.
    chDomain = ?.
end.

find ContactType where ContactType.Name eq 'email-home' no-lock no-error.
for each Customer no-lock,
    first CustomerContact where
          CustomerContact.TenantId eq Customer.TenantId and
          CustomerContact.CustomerId eq Customer.CustomerId and
          CustomerContact.ContactType eq ContactType.Name
          no-lock,
    first ContactDetail where
          ContactDetail.ContactDetailId eq CustomerContact.ContactDetailId
          no-lock:
    
    /* add customer domain and customer emails */
    chDomain = AddDomain(entry(2, ContactDetail.Detail, '@')).
    chAccount = chDomain:Accounts:ItemByAddress(ContactDetail.Detail) no-error.
    
    if not valid-handle(chAccount) then
    do:
        chAccount = chDomain:Accounts:Add().
            chAccount:Address = ContactDetail.Detail.
            chAccount:PersonFirstName = entry(1, Customer.Name, ' ').
            chAccount:PersonLastName = entry(num-entries(Customer.Name, ' '), Customer.Name, ' ').
            chAccount:Password = cPassword.
            chAccount:Active = true.
            chAccount:MaxSize = 100.    /* 100MB per user */
        chAccount:Save().
        release object chAccount.
        chAccount = ?.
    end.
end.

release object chMailServer.
chMailServer = ?.
release object chDomain.
chDomain = ?.
release object chAccount.
chAccount = ?.

/** -- eof -- **/
