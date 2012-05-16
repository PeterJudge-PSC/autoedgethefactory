/** ------------------------------------------------------------------------
    File        : ServerConnectionActionEnum
    Purpose     : Enumerates server connection actions 
    Author(s)   : pjudge
    Created     : Thu Dec 08 14:02:04 EST 2011
    Notes       : * May want to add Create/Destroy actions too, in future.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.ServerConnectionActionEnum.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.Connection.ServerConnectionActionEnum inherits EnumMember: 
    
    define static public property Connect as ServerConnectionActionEnum no-undo get. private set.
    define static public property Disconnect as ServerConnectionActionEnum no-undo get. private set.
	
	constructor static ServerConnectionActionEnum():
	    ServerConnectionActionEnum:Connect = new ServerConnectionActionEnum('Connect').
	    ServerConnectionActionEnum:Disconnect = new ServerConnectionActionEnum('Disonnect').
    end constructor.
    
	constructor public ServerConnectionActionEnum ( input pcName as character ):
		super (input pcName).
	end constructor.
	
    method public static ServerConnectionActionEnum GetEnum(enumname as character):         
        return cast(EnumMember:GetEnumMember(enumname, Class:GetClass('OpenEdge.CommonInfrastructure.Common.ServerConnectionActionEnum'))
                , ServerConnectionActionEnum).
    end method.

end class.