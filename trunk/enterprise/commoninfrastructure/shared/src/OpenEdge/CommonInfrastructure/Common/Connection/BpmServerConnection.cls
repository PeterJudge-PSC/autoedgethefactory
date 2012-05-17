/** ------------------------------------------------------------------------
    File        : BpmServerConnection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Apr 20 12:40:20 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.ServerConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.BpmServerConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.

using OpenEdge.Lang.BPM.BPMService.
using OpenEdge.Lang.BPM.IBizLogicAPI.

using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.Connection.BpmServerConnection inherits ServerConnection:
    
    /** (mandatory) The OO type that  the Server represents. */
    define override public property ServerType as class Class no-undo
        get():
            return Class:GetClass('OpenEdge.Lang.BPM.IBizLogicAPI').
        end get.
    
    /** Is the Server connected? */
    define override public property IsConnected as logical no-undo
        get():
            return valid-object(this-object:Server) and cast(this-object:Server, BPMService):IsConnected.
        end get.
        
	constructor public BpmServerConnection (input poParameters as BpmServerConnectionParameters):
        super (poParameters).
    end constructor.

	method override public void CreateConnection():
        define variable oBpmServerParams as BpmServerConnectionParameters no-undo.
        
        oBpmServerParams = cast(ConnectionParameters, BpmServerConnectionParameters).
        
        Server = new BPMService(oBpmServerParams:Protocol,
                                oBpmServerParams:Host,
                                oBpmServerParams:Port).
	end method.

    method override public void DestroyConnection():
        this-object:Server = ?.
    end method.
    
    /** Connect to the server specified, based on the ConnectionParameters (passed in to the ctor) */
    method override protected void DoConnect():
        cast(this-object:Server, BPMService):Connect().
    end method.
    
    /**  Disconnect from the Server */
    method override protected void DoDisconnect():
        cast(this-object:Server, BPMService):Disconnect().
    end method.
    
end class.