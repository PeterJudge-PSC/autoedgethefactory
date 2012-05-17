/** ------------------------------------------------------------------------
    File        : UndoOnConflictEnum
    Purpose     : Define behaviour on which client changes to undo when a 
                  commit fails due to an optimistic locking conflict
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 19 11:28:06 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.UndoOnConflictEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.PresentationLayer.Model.UndoOnConflictEnum final inherits EnumMember:
    define public static property Default as UndoOnConflictEnum get. private set.
    
    /** Overwrite before-image changes only. This mode keeps changes and 
       allows resave. Requires Undo/Reset to show server changes. */
    define public static property Before as UndoOnConflictEnum get. private set.
    
    /** Keeps all changes as well as the previous before-image record.
       A reread of data is required to save the record. */
    define public static property None as UndoOnConflictEnum get. private set.
    
    /** Discard only conflicting field changes. */
    define public static property Conflict as UndoOnConflictEnum get. private set.
    
    /** Discard all changes on confliciting record */
    define public static property All as UndoOnConflictEnum get. private set.
    
    define public static property Merge as UndoOnConflictEnum get. private set.
    
    constructor static UndoOnConflictEnum():
        UndoOnConflictEnum:Before = new UndoOnConflictEnum('Before').
        UndoOnConflictEnum:None = new UndoOnConflictEnum('None').
        UndoOnConflictEnum:Conflict = new UndoOnConflictEnum('Conflict').
        UndoOnConflictEnum:All = new UndoOnConflictEnum('All').
        UndoOnConflictEnum:Merge = new UndoOnConflictEnum('Merge').
        
        UndoOnConflictEnum:Default = UndoOnConflictEnum:Before.
    end constructor.

    constructor public UndoOnConflictEnum ( input pcName as character ):
        super (input pcName).
    end constructor.

end class.