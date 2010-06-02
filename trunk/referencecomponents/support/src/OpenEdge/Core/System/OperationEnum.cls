/*------------------------------------------------------------------------
    File        : OperationEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Sep 02 14:57:50 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.OperationEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.System.OperationEnum final: 
    
    define public static property Empty     as EnumMember no-undo get. private set.
    define public static property Create    as EnumMember no-undo get. private set.
    define public static property Delete    as EnumMember no-undo get. private set.
    define public static property Update    as EnumMember no-undo get. private set.
    
    constructor static OperationEnum():
        OperationEnum:Empty  = new EnumMember(1, 'empty').
        OperationEnum:Create = new EnumMember(2, 'create').
        OperationEnum:Delete = new EnumMember(3, 'delete').
        OperationEnum:Update = new EnumMember(4, 'update').
    end method.
    
end class.