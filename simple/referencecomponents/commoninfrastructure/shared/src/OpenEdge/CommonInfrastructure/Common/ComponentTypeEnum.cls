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

using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum inherits EnumMember: 
    /** Non-specified application components (shouldn't be many of these though) */
    define public static property ApplicationComponent as ComponentTypeEnum no-undo get. private set.
    
    /** This component is a Service, and so is better described with the ServiceTypeEnum
        members (Common, Client & Server). */
    define public static property Service as ComponentTypeEnum no-undo get. private set.

    /** This component is the ServiceManager for the session. It's not a service nor a manager, strictly speaking. */
    define public static property ServiceManager as ComponentTypeEnum no-undo get. private set.

    constructor static ComponentTypeEnum():
        ComponentTypeEnum:ApplicationComponent = new ComponentTypeEnum('ApplicationComponent').
        ComponentTypeEnum:Service = new ComponentTypeEnum('Service').
        ComponentTypeEnum:ServiceManager = new ComponentTypeEnum('ServiceManager').
    end constructor.
    
    constructor public ComponentTypeEnum(pcName as character):
        super(pcName).
    end constructor.
    
end class.