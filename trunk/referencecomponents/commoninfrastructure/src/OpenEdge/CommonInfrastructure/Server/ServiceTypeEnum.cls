 /*------------------------------------------------------------------------
    File        : ServiceTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 22 11:34:26 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Server.ServiceTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.Server.ServiceTypeEnum inherits OpenEdge.CommonInfrastructure.Server.ComponentTypeEnum: 
    define public static property BusinessEntity    as ServiceTypeEnum no-undo get. private set.
    define public static property BusinessTask      as ServiceTypeEnum no-undo get. private set.
    
    constructor static ServiceTypeEnum():
        ServiceTypeEnum:BusinessEntity = new ServiceTypeEnum('BusinessEntity').
        ServiceTypeEnum:BusinessTask   = new ServiceTypeEnum ('BusinessTask').
    end constructor.
    
	constructor public ServiceTypeEnum(pcName as character):
		super(pcName).
	end constructor.
    
end class.