/** ------------------------------------------------------------------------
    File        : ProcessInstanceStateEnum
    Purpose     : Enumeration or process instance states
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 24 13:28:56 EST 2010
    Notes       : * As per Savvion documentation
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.EnterpriseServices.BizLogic.ProcessInstanceStateEnum.
using OpenEdge.Lang.EnumMember.


class OpenEdge.EnterpriseServices.BizLogic.ProcessInstanceStateEnum inherits EnumMember: 
    
    define static public property Created as ProcessInstanceStateEnum no-undo get. private set.
    define static public property Activated as ProcessInstanceStateEnum no-undo get. private set.
    define static public property Suspended as ProcessInstanceStateEnum no-undo get. private set.
    define static public property Complete as ProcessInstanceStateEnum no-undo get. private set.

    constructor static ProcessInstanceStateEnum():
        ProcessInstanceStateEnum:Created = new ProcessInstanceStateEnum('PI_CREATED').
        ProcessInstanceStateEnum:Activated = new ProcessInstanceStateEnum('PI_ACTIVATED').
        ProcessInstanceStateEnum:Suspended = new ProcessInstanceStateEnum('PI_SUSPENDED').
        ProcessInstanceStateEnum:Created = new ProcessInstanceStateEnum('PI_COMPLETE').
    end constructor.
    
    constructor public ProcessInstanceStateEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public ProcessInstanceStateEnum EnumFromString(input pcName as character):
        define variable oEnum as ProcessInstanceStateEnum no-undo.
        case pcName:
            when ProcessInstanceStateEnum:Created:ToString() then oEnum = ProcessInstanceStateEnum:Created.
            when ProcessInstanceStateEnum:Activated:ToString() then oEnum = ProcessInstanceStateEnum:Activated.
            when ProcessInstanceStateEnum:Suspended:ToString() then oEnum = ProcessInstanceStateEnum:Suspended.
            when ProcessInstanceStateEnum:Complete:ToString() then oEnum = ProcessInstanceStateEnum:Complete.
        end case.
        return oEnum.
    end method. 

end class.