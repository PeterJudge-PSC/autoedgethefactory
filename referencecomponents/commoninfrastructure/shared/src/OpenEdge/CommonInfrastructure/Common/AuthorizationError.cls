/** ------------------------------------------------------------------------
    File        : AuthorizationError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 25 10:16:03 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.AuthorizationError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.CommonInfrastructure.Common.AuthorizationError inherits ApplicationError: 
    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.

    constructor public AuthorizationError(poErr as Error, pcArgs1 as char, pcArgs2 as char, pcArgs3 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
        AddMessage(pcArgs3, 3).
    end constructor.
    
    constructor public AuthorizationError(pcArgs1 as char, pcArgs2 as char, pcArgs3 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown, pcArgs1, pcArgs2, pcArgs3).
    end constructor.
    
    constructor public AuthorizationError(poErr as Error):
        super(poErr).
        
        this-object:ErrorTitle = 'Authorization Error'.
        this-object:ErrorText  = 'User &1 not authorised to perform action &2 on operation &3'.
    end constructor.
    
end class.