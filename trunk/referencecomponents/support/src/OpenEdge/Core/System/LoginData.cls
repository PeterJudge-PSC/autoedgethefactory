/*------------------------------------------------------------------------
    File        : LoginData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jun 12 13:44:10 EDT 2009
    Notes       : * This is a sample LoginData: ILoginData could have 
                    anything in it, really. 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*.

class OpenEdge.Core.System.LoginData  implements ILoginData :
         
    define public property UserName as character no-undo get. set.
    define public property Password as character no-undo get. set. 
    
    constructor public LoginData (  ):
        super ().
        
    end constructor.

    constructor public LoginData (pcUserName as char, pcPassword as char):
        super ().
        
        UserName = pcUserName.
        Password = pcPassword.
    end constructor.
    
end class.