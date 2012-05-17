/*------------------------------------------------------------------------
    File        : load_contact_types.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Tue Jan 25 15:16:45 EST 2011
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

run load_ContactTypes.

procedure load_ContactTypes:
    
    define variable cTypes as character no-undo.
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    
    cTypes = 'email-sales|email-info|email-home|email-admin|email-work|fax-work|phone-work|phone-home|phone-mobile|fax-home'.
    
    iMax = num-entries(ctypes, '|').
    do iLoop = 1 to iMax:
        if can-find(ContactType where ContactType.Name eq entry(iLoop, ctypes, '|')) then
            next.
        
        create ContactType.
        assign ContactType.Name = entry(iLoop, ctypes, '|').
    end.
        
end procedure.
