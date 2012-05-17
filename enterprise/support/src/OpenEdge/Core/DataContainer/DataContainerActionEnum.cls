/** ------------------------------------------------------------------------
    File        : DataContainerActionEnum
    Purpose     : Enumeration of actions a DataContainer can perform.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Oct 28 12:27:03 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.DataContainer.DataContainerActionEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.DataContainer.DataContainerActionEnum final inherits EnumMember:
    
    /* Local Actions */ 
    define static public property Add      as DataContainerActionEnum no-undo get. private set.
    define static public property Save     as DataContainerActionEnum no-undo get. private set.
    define static public property Delete   as DataContainerActionEnum no-undo get. private set.
    define static public property Navigate as DataContainerActionEnum no-undo get. private set.
    define static public property Fill     as DataContainerActionEnum no-undo get. private set.
    define static public property Commit   as DataContainerActionEnum no-undo get. private set.

    
    constructor static DataContainerActionEnum():
        DataContainerActionEnum:Add = new DataContainerActionEnum('Add').
        DataContainerActionEnum:Save = new DataContainerActionEnum('Save').
        DataContainerActionEnum:Delete = new DataContainerActionEnum('Delete').
        DataContainerActionEnum:Navigate = new DataContainerActionEnum('Navigate').
        DataContainerActionEnum:Fill = new DataContainerActionEnum('Fill').
        DataContainerActionEnum:Commit = new DataContainerActionEnum('Commit').
    end constructor.

    constructor public DataContainerActionEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class.