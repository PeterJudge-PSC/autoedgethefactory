/** ------------------------------------------------------------------------
    File        : ServiceMessageActionEnum
    Purpose     : Enumerates types of service messages (requests).
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sat Feb 20 03:38:25 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum inherits EnumMember: 
    
    define public static property Fetch    as ServiceMessageActionEnum no-undo get. private set.
    define public static property Save     as ServiceMessageActionEnum no-undo get. private set.
    define public static property Define   as ServiceMessageActionEnum no-undo get. private set.
    
    constructor static ServiceMessageActionEnum():
        ServiceMessageActionEnum:Fetch  = new ServiceMessageActionEnum('Fetch').
        ServiceMessageActionEnum:Save   = new ServiceMessageActionEnum('Save').
        ServiceMessageActionEnum:Define = new ServiceMessageActionEnum('Define'). 
    end method.
		
		    constructor public ServiceMessageActionEnum(pcName as character):
        		super(pcName).
    	end constructor.
	
end class.