/** ------------------------------------------------------------------------
    File        : ProcessTemplateStateEnum
    Purpose     : State enumeration for Process Template objects 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 24 13:22:26 EST 2010
    Notes       : * As per Savvion documentation
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.ProcessTemplateStateEnum.
using OpenEdge.Lang.EnumMember.


class OpenEdge.Lang.BPM.ProcessTemplateStateEnum inherits EnumMember: 

    define static public property Created as ProcessTemplateStateEnum no-undo get. private set.
    define static public property Installed as ProcessTemplateStateEnum no-undo get. private set.
    define static public property Suspended as ProcessTemplateStateEnum no-undo get. private set.

    constructor static ProcessTemplateStateEnum():
        ProcessTemplateStateEnum:Created = new ProcessTemplateStateEnum('P_CREATED').
        ProcessTemplateStateEnum:Installed = new ProcessTemplateStateEnum('P_INSTALLED').
        ProcessTemplateStateEnum:Suspended = new ProcessTemplateStateEnum('P_SUSPENDED').
    end constructor.
    
    constructor public ProcessTemplateStateEnum ( input pcName as character ):
        super (input pcName).
    end constructor.

    method static public ProcessTemplateStateEnum EnumFromString(input pcName as character):
        define variable oEnum as ProcessTemplateStateEnum no-undo.
        
        case pcName:
            when ProcessTemplateStateEnum:Created:ToString() then oEnum = ProcessTemplateStateEnum:Created.
            when ProcessTemplateStateEnum:Installed:ToString() then oEnum = ProcessTemplateStateEnum:Installed.
            when ProcessTemplateStateEnum:Suspended:ToString() then oEnum = ProcessTemplateStateEnum:Suspended.
        end case.
        
        return oEnum.
    end method.
    
end class.