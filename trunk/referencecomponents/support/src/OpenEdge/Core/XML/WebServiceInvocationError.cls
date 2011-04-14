/** ------------------------------------------------------------------------
    File        : WebServiceInvocationError
    Purpose     : Application error raised when errors are raised in a WebService call.  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 22 12:06:12 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.XML.WebServiceInvocationError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set. 
    define override protected property ErrorTitle as character no-undo get. set. 
    
    constructor public WebServiceInvocationError(input poInnerError as Error):
        super(poInnerError).
        
        this-object:ErrorTitle = 'WebService Invocation Error'.
        this-object:ErrorText = 'Error invoking &1 on WebService &2 &3'.
    end constructor.
    
    constructor public WebServiceInvocationError(input poErr as Error,
                                                 input pcArgs1 as character,
                                                 input pcArgs2 as character,
                                                 input pcArgs3 as character):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
        AddMessage(pcArgs3, 3).
    end constructor.

    constructor public WebServiceInvocationError(input pcArgs1 as character,
                                                 input pcArgs2 as character,
                                                 input pcArgs3 as character):
        this-object(?).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
        AddMessage(pcArgs3, 3).
    end constructor.
    
end class.