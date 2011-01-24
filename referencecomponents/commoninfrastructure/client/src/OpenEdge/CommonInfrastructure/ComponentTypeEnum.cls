/** ------------------------------------------------------------------------
    File        : ComponentTypeEnum
    Purpose     : Enumeration of client-side component types 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 20 12:05:38 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.CommonInfrastructure.ComponentTypeEnum.
using OpenEdge.CommonInfrastructure.CommonComponentTypeEnum.

class OpenEdge.CommonInfrastructure.ComponentTypeEnum inherits CommonComponentTypeEnum:
    define public static property View as ComponentTypeEnum no-undo get. private set.
    
    constructor static ComponentTypeEnum():
        ComponentTypeEnum:View = new ComponentTypeEnum('View').
    end constructor.
    
    constructor public ComponentTypeEnum(pcName as character):
        super(pcName).
    end constructor.
    
end class.