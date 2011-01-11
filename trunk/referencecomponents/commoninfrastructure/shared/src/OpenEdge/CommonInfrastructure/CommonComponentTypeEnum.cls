/** ------------------------------------------------------------------------
    File        : ComponentTypeEnum
    Purpose     : Enumeration of common component types.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 20 10:49:14 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.CommonComponentTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.CommonComponentTypeEnum inherits EnumMember: 
    /** Non-specified application components (shouldn't be many of these though) */
    define public static property ApplicationComponent as CommonComponentTypeEnum no-undo get. private set.
    
    /** This component is a Service, and so is better described with the ServiceTypeEnum
        members (Common, Client & Server). */
    define public static property Service as CommonComponentTypeEnum no-undo get. private set.

    /** This component is a ServiceAdapter.  */
    define public static property ServiceAdapter as CommonComponentTypeEnum no-undo get. private set.

    constructor static CommonComponentTypeEnum():
        CommonComponentTypeEnum:ApplicationComponent = new CommonComponentTypeEnum('ApplicationComponent').
        CommonComponentTypeEnum:Service = new CommonComponentTypeEnum('Service').
    end constructor.
    
    constructor public CommonComponentTypeEnum(pcName as character):
        super(pcName).
    end constructor.
    
end class.