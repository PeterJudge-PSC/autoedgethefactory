/*------------------------------------------------------------------------
    File        : UndoOnConflictEnum
    Purpose     : Define behaviour on which client changes to undo when a 
                  commit fails due to an optimistic locking conflict
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 19 11:28:06 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Model.UndoOnConflictEnum final:
    define public static property Default as EnumMember get. private set.
    
    /* Overwrite before-image changes only. This mode keeps changes and 
       allows resave. Requires Undo/Reset to show server changes. */
    define public static property Before as EnumMember get. private set.
    
    /* Keeps all changes as well as the previous before-image record.
       A reread of data is required to save the record. */
    define public static property None as EnumMember get. private set.
    
    /* Discard only conflicting field changes. */
    define public static property Conflict as EnumMember get. private set.
    
    /* Discard all changes on confliciting record */
    define public static property All as EnumMember get. private set.
    
    define public static property Merge as EnumMember get. private set.
    
    constructor static UndoOnConflictEnum():
        UndoOnConflictEnum:Before = new EnumMember(1).
        UndoOnConflictEnum:None = new EnumMember(2).
        UndoOnConflictEnum:Conflict = new EnumMember(3).
        UndoOnConflictEnum:All = new EnumMember(4).
        UndoOnConflictEnum:Merge = new EnumMember(5).
        
        UndoOnConflictEnum:Default = UndoOnConflictEnum:Before.
    end constructor.

end class.