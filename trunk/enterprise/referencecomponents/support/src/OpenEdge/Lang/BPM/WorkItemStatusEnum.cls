/** ------------------------------------------------------------------------
    File        : WorkItemWorkItemStatusEnum
    Purpose     : Enumeration of BixLogic Status types  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 24 13:14:52 EST 2010
    Notes       : * As per Savvion doc.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.WorkItemStatusEnum. 
using OpenEdge.Lang.EnumMember.


class OpenEdge.Lang.BPM.WorkItemStatusEnum inherits EnumMember: 

    define static public property Created as WorkItemStatusEnum no-undo get. private set.
    define static public property Assigned as WorkItemStatusEnum no-undo get. private set.
    define static public property Available as WorkItemStatusEnum no-undo get. private set.
    define static public property Suspended as WorkItemStatusEnum no-undo get. private set.
    define static public property Completed as WorkItemStatusEnum no-undo get. private set.
    define static public property Removed as WorkItemStatusEnum no-undo get. private set.
    
    constructor static WorkItemStatusEnum():
        WorkItemStatusEnum:Created = new WorkItemStatusEnum('I_CREATED').
        WorkItemStatusEnum:Assigned = new WorkItemStatusEnum('I_ASSIGNED').
        WorkItemStatusEnum:Available = new WorkItemStatusEnum('I_AVAILABLE').
        WorkItemStatusEnum:Suspended  = new WorkItemStatusEnum('I_SUSPENDED').
        WorkItemStatusEnum:Completed  = new WorkItemStatusEnum('I_COMPLETED').
        WorkItemStatusEnum:Removed = new WorkItemStatusEnum('I_REMOVED').
    end constructor.
    
    constructor public WorkItemStatusEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public WorkItemStatusEnum EnumFromString(input pcName as character):
        define variable oEnum as WorkItemStatusEnum no-undo.
        
        case pcName:
            when WorkItemStatusEnum:Created:ToString() then oEnum = WorkItemStatusEnum:Created.
            when WorkItemStatusEnum:Assigned:ToString() then oEnum = WorkItemStatusEnum:Assigned.
            when WorkItemStatusEnum:Available:ToString() then oEnum = WorkItemStatusEnum:Available.
            when WorkItemStatusEnum:Suspended:ToString() then oEnum = WorkItemStatusEnum:Suspended.
            when WorkItemStatusEnum:Completed:ToString() then oEnum = WorkItemStatusEnum:Completed.
            when WorkItemStatusEnum:Removed:ToString() then oEnum = WorkItemStatusEnum:Removed. 
        end case.
        
        return oEnum.
    end method.
    
end class.