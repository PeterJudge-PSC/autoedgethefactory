/*------------------------------------------------------------------------
    File        : ActionTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 01 16:39:43 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Common.ActionTypeEnum final:
         
    define public static property Default   as EnumMember no-undo get. private set.
    define public static property Label     as EnumMember no-undo get. private set.
    define public static property Separator as EnumMember no-undo get. private set.
    define public static property Group     as EnumMember no-undo get. private set.
    define public static property Toggle    as EnumMember no-undo get. private set.
    define public static property Option    as EnumMember no-undo get. private set.
    define public static property Launch    as EnumMember no-undo get. private set.
    define public static property Event     as EnumMember no-undo get. private set.
    
    constructor static ActionTypeEnum():
        ActionTypeEnum:Label = new EnumMember(1, 'Label').
        ActionTypeEnum:Separator = new EnumMember(2, 'Separator').
        ActionTypeEnum:Group = new EnumMember(3, 'Group').
        ActionTypeEnum:Toggle = new EnumMember(4, 'Toggle').
        ActionTypeEnum:Option = new EnumMember(5, 'Option').
        ActionTypeEnum:Launch = new EnumMember(6, 'Launch').
        ActionTypeEnum:Event = new EnumMember(7, 'Event').
        
        ActionTypeEnum:Default = ActionTypeEnum:Event.
    end constructor.
            
end class.