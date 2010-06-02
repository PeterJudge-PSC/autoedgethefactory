/*------------------------------------------------------------------------
    File        : ActionStateEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 25 14:29:10 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Common.ActionStateEnum inherits FlagsEnum final: 

    define public static property Enable  as EnumMember no-undo get. private set.
    define public static property Disable as EnumMember no-undo get. private set.
    define public static property View    as EnumMember no-undo get. private set.
    define public static property Hide    as EnumMember no-undo get. private set.
        
    constructor static ActionStateEnum():
        ActionStateEnum:Enable = new EnumMember(1).
        ActionStateEnum:Disable = new EnumMember(2).
        ActionStateEnum:Hide = new EnumMember(4).
        ActionStateEnum:View = new EnumMember(8).
        
    end constructor.

end class.