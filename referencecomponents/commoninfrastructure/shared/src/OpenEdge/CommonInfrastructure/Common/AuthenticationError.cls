/** ------------------------------------------------------------------------
    File        : AuthenticationError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 18 19:00:08 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.AuthenticationError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.CommonInfrastructure.Common.AuthenticationError inherits ApplicationError: 
    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.

    constructor public AuthenticationError(poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public AuthenticationError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown, pcArgs1, pcArgs2).
    end constructor.
    
    constructor public AuthenticationError(poErr as Error):
        super(poErr).
        
        this-object:ErrorTitle = 'Authentication Error'.
        this-object:ErrorText  = 'Unable to authentication &1 : &2'.
    end constructor.

end class.