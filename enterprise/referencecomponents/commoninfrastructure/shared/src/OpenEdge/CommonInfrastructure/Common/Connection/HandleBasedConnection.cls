/*------------------------------------------------------------------------
    File        : HandleBasedConnection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Dec 08 10:59:17 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.ServerConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.

using OpenEdge.Lang.Assert.
using OpenEdge.Lang.WidgetHandle.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.Connection.HandleBasedConnection abstract inherits ServerConnection:
     
    /** (mandatory) The OO type that  the Server represents. */
    define override public property ServerType as class Class no-undo
        get():
            return Class:GetClass('OpenEdge.Lang.WidgetHandle').
        end get.
    
    /** Is the Socket connected? */    
    define override public property IsConnected as logical no-undo
        get():
            define variable lConnected as logical no-undo.
            define variable hServer as handle no-undo.
            
            assign hServer = cast(Server, WidgetHandle):Value
                   lConnected = valid-handle(hServer).
            if lConnected then
                lConnected = hServer:connected().
            
            return lConnected.
    end get.

    /** Destroy the server connection. This may involve a DELETE OBJECT of some sort */ 
    method override public void DestroyConnection():
        delete object cast(Server, WidgetHandle):Value no-error.
    end method.

    /** Connect to the Handle specified. 
        
        @param IConnectionParameters Parameters allowing us to make a connection        
               to a handle-based connection */
    method override public void DoConnect():
        cast(Server, WidgetHandle):Value:connect(string(ConnectionParameters:GetConnectionString())).
    end method.
	
    /**  Disconnect from the server */
    method override public void DoDisconnect():
        if IsConnected then
            cast(Server, WidgetHandle):Value:disconnect().
    end method.
    
    constructor public HandleBasedConnection(input poParameters as IConnectionParameters):
        super(poParameters).
    end constructor.
	
end class.