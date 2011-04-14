/*------------------------------------------------------------------------
    File        : StackError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 14:44:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.StackError.
using Progress.Lang.AppError.

class OpenEdge.Lang.Collections.StackError inherits AppError: 
    define static public property OVERFLOW as character init 'Stack overflow' no-undo get.
    define static public property UNDERFLOW as character init 'Stack underflow' no-undo get.
    define static public property RESIZE as character init 'Stack resize smaller than contents' no-undo get.
    
    constructor public StackError():
        super().
    end constructor.

    constructor public StackError (pcArg1 as char):
        this-object().
        AddMessage(pcArg1, 1).
    end constructor.
    
end class.