/*------------------------------------------------------------------------
    File        : ServiceTypeEnum
    Purpose     : Lists known components in reference components
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 18 14:26:28 EST 2010
    Notes       : * Not final because an application may extend this
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ServiceTypeEnum.
using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.Common.ServiceTypeEnum inherits OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum:
    
    /** Common Infrastructure */
    define public static property Manager as ServiceTypeEnum no-undo get. private set.
    
    /** Non-specified application services (shouldn't be many of these though) */
    define public static property AppService as ServiceTypeEnum no-undo get. private set.
    
    constructor static ServiceTypeEnum():
        ServiceTypeEnum:Manager = new ServiceTypeEnum('Manager').
        ServiceTypeEnum:AppService = new ServiceTypeEnum('AppService').
    end constructor.
    
	constructor public ServiceTypeEnum(pcName as character):
		super(pcName).
	end constructor.
    
end class.