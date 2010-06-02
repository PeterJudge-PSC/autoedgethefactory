/*------------------------------------------------------------------------
    File        : DeleteActionEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 25 14:37:41 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Presenter.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Presenter.DeleteActionEnum final : 

    define public static property Default   as EnumMember no-undo get. private set.
    /* Delete is an update to the local buffer only */
    define public static property Delete    as EnumMember no-undo get. private set.
    /* Commit is an update to the Business Component, and includes Delete */
    define public static property Commit    as EnumMember no-undo get. private set.
    
    constructor static DeleteActionEnum():
        DeleteActionEnum:Delete = new EnumMember(1).
        DeleteActionEnum:Commit = new EnumMember(2).
        
        DeleteActionEnum:Default = DeleteActionEnum:Commit.
    end constructor.
    
end class.