/** ------------------------------------------------------------------------
    File        : SocketConnection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 20 10:48:10 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.Connection.HandleBasedConnection.

using OpenEdge.Lang.WidgetHandle.

class OpenEdge.CommonInfrastructure.Common.Connection.SocketConnection inherits HandleBasedConnection:
    
    constructor public SocketConnection(input poParameters as IConnectionParameters):
        super(poParameters).
    end constructor.
    
    method override void CreateConnection():
        define variable hSocket as handle no-undo.
        
        create socket hSocket.
        Server = new WidgetHandle(hSocket).
    end method.        
    
end class.