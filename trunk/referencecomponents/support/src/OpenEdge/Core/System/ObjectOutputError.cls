/*-----------------------------------------------------------------------
    File        : ObjectOutputError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 21 14:03:44 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ObjectOutputError.
using Progress.Lang.Error.

class OpenEdge.Core.System.ObjectOutputError inherits ApplicationError:
    define static public property STREAM as character no-undo init 'stream' get.
    define static public property TYPE as character no-undo init 'type' get.
    define static public property API_CALL as character no-undo init 'API call' get.
    define static public property ARRAY_SIZE as character no-undo init 'array size' get.
    define static public property DB_REFS as character no-undo init 'references to database fields' get.
    
    define override protected property ErrorTitle as character no-undo get. set. 
    define override protected property ErrorText as character no-undo get. set.
    
    constructor public ObjectOutputError ( ):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
    constructor public ObjectOutputError (poErr as Error):
       super(poErr).      
       ErrorTitle = 'Object Output Error'.
       ErrorText = 'Invalid &1 encountered. Expecting &2'.       
    end constructor.
   
    constructor public ObjectOutputError (poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public ObjectOutputError (pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1,pcArgs2).
    end constructor.
    
end class.