/** ------------------------------------------------------------------------
    File        : ComponentTypeEnum
    Purpose     : Enumeration of server-side component types
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 20 12:12:37 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.CommonComponentTypeEnum.
using OpenEdge.CommonInfrastructure.ComponentTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.ComponentTypeEnum inherits CommonComponentTypeEnum:
     
    define public static property DataAccessObject  as ComponentTypeEnum no-undo get. private set.
    define public static property DataSourceObject  as ComponentTypeEnum no-undo get. private set.
    
    constructor static ComponentTypeEnum():
        ComponentTypeEnum:DataAccessObject = new ComponentTypeEnum('DataAccessObject').
        ComponentTypeEnum:DataSourceObject = new ComponentTypeEnum('DataSourceObject').
    end constructor.

    constructor public ComponentTypeEnum(pcName as character ):
        super(pcName).
    end constructor.

end class.