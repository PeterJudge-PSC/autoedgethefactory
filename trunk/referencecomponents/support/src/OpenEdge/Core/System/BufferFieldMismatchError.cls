/*------------------------------------------------------------------------
    File        : BufferFieldMismatchError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:39:12 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.System.BufferFieldMismatchError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.BufferFieldMismatchError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
    
    constructor public BufferFieldMismatchError(pcArgs1 as char, pcArgs2 as char):
        this-object().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public BufferFieldMismatchError():
        super().
        
        this-object:ErrorTitle = 'Buffer Field Mismatch Error'.
        this-object:ErrorText = 'The buffers being compared have different fields. Buffer 1: &1; buffer 2: &2.'.
    end constructor.


end class.