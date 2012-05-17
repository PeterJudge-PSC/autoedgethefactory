/** ------------------------------------------------------------------------
    File        : ServerConnection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 20 09:12:46 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.HandleBasedConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.

using OpenEdge.Lang.WidgetHandle.

class OpenEdge.CommonInfrastructure.Common.Connection.WebServiceConnection inherits HandleBasedConnection:
   
    constructor public WebServiceConnection(input poParameters as IConnectionParameters):
        super(poParameters).
    end constructor.
    
    method override public void CreateConnection():
        define variable hServer as handle no-undo.
        
        create server hServer.
        
        Server = new WidgetHandle(hServer).
    end method.

end class.