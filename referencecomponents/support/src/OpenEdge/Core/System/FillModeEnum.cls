/*------------------------------------------------------------------------
    File        : FillModeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 12 15:07:13 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*.
using OpenEdge.Lang.*.

class OpenEdge.Core.System.FillModeEnum final :
    
    define public static property Default       as EnumMember no-undo get. private set.
    define public static property Append        as EnumMember no-undo get. private set.
    define public static property Empty         as EnumMember no-undo get. private set.
    define public static property Merge         as EnumMember no-undo get. private set.
    define public static property NoFill        as EnumMember no-undo get. private set.
    define public static property Replace       as EnumMember no-undo get. private set.
    
    constructor static FillModeEnum():
        FillModeEnum:Append = new EnumMember(1, 'Append').
        FillModeEnum:Empty = new EnumMember(2, 'Empty').
        FillModeEnum:Merge = new EnumMember(3, 'Merge').
        FillModeEnum:NoFill = new EnumMember(4, 'No-Fill').
        FillModeEnum:Replace = new EnumMember(5, 'Replace').
        
        FillModeEnum:Default = FillModeEnum:Merge.
    end constructor.
    
end class.