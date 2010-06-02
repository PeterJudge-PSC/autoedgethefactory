/*------------------------------------------------------------------------
    File        : ComponentTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 20 12:05:38 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Client.ComponentTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.Client.ComponentTypeEnum inherits OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum:
    define public static property View as ComponentTypeEnum no-undo get. private set.
    
    constructor static ComponentTypeEnum():
        ComponentTypeEnum:View = new ComponentTypeEnum('View').
    end constructor.

	constructor public ComponentTypeEnum(pcName as character):
		super(pcName).
	end constructor.
    
end class.