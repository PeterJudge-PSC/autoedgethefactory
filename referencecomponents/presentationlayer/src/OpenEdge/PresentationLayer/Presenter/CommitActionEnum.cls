/*------------------------------------------------------------------------
    File        : CommitActionEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 25 14:26:37 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Presenter.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Presenter.CommitActionEnum final: 

    define public static property Default   as EnumMember no-undo get. private set.
    /* Save is an update to the local buffer */
    define public static property Save      as EnumMember no-undo get. private set.
    /* Commit is an update to the Business Component, and includes Save */
    define public static property Commit    as EnumMember no-undo get. private set.
    
    constructor static CommitActionEnum():
        CommitActionEnum:Save = new EnumMember(1). 
        CommitActionEnum:Commit = new EnumMember(2).
        
        CommitActionEnum:Default = CommitActionEnum:Commit.
    end constructor.

end class.