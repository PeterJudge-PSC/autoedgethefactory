/** ------------------------------------------------------------------------
    File        : ServerConnectionError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 20 15:09:25 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.CommonInfrastructure.Common.Connection.ServerConnectionError inherits ApplicationError: 
    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
            
    constructor public ServerConnectionError(pcArgs1 as char, pcArgs2 as longchar):
        this-object(?, pcArgs1, pcArgs2).
    end constructor.
    
    constructor public ServerConnectionError (poErr as Error, pcArgs1 as char, pcArgs2 as longchar):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(string(pcArgs2), 2).
    end constructor.
    
    constructor public ServerConnectionError (poErr as Error):
        super(poErr).
        
        ErrorText = 'Unable to connect to server &1 with connection string &2'.
        ErrorTitle = 'Server Connection Error'.
    end constructor.
    
    constructor public ServerConnectionError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
end class.