/*------------------------------------------------------------------------
    File        : UpdateActionEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 26 14:16:16 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Presenter.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Presenter.UpdateActionEnum final: 

    define public static property Add       as EnumMember no-undo get. private set.
    define public static property Delete    as EnumMember no-undo get. private set.
    define public static property Save      as EnumMember no-undo get. private set.
    define public static property Commit    as EnumMember no-undo get. private set.
    define public static property Undo      as EnumMember no-undo get. private set.
    
    constructor static UpdateActionEnum():
        UpdateActionEnum:Add = new EnumMember(1, 'Add').
        UpdateActionEnum:Delete  = new EnumMember(2, 'Delete').
        UpdateActionEnum:Save = new EnumMember(3, 'Save').
        UpdateActionEnum:Commit = new EnumMember(4, 'Commit').
        UpdateActionEnum:Undo = new EnumMember(5, 'Undo').
    end constructor. 

    method public static EnumMember EnumFromValue(piUpdateAction as integer):        
        define variable oMember as EnumMember no-undo.
        
        case piUpdateAction:
            when UpdateActionEnum:Add:Value       then oMember = UpdateActionEnum:Add.
            when UpdateActionEnum:Delete:Value    then oMember = UpdateActionEnum:Delete.
            when UpdateActionEnum:Save:Value      then oMember = UpdateActionEnum:Save.
            when UpdateActionEnum:Commit:Value    then oMember = UpdateActionEnum:Commit.
            when UpdateActionEnum:Undo:Value      then oMember = UpdateActionEnum:Undo.
        end.
                
        return oMember.
    end method.
        
end class.