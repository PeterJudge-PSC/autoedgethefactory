/*------------------------------------------------------------------------
    File        : load_contacts.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Tue Jan 25 15:16:45 EST 2011
    Notes       :
  ----------------------------------------------------------------------*/
{routinelevel.i}

/* ***************************  Definitions  ************************** */



/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
procedure load_ContactTypes:
    
    define variable ctypes as character no-undo.
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    
    ctypes = 'email-sales|email-info|email-home|email-work|fax|phone-work|phone-home|phone-mobile'.
    
    iMax = num-entries(ctypes, '|').
    do iLoop = 1 to iMax:
        create ContactType.
        assign ContactType.Name = entry(iLoop, ctypes, '|').
    end.
        
end procedure.
