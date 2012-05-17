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
using OpenEdge.CommonInfrastructure.Common.Connection.AppServerConnectionParameters.

using OpenEdge.Lang.WidgetHandle.

class OpenEdge.CommonInfrastructure.Common.Connection.AppServerConnection inherits HandleBasedConnection:

	constructor public AppServerConnection(input poParameters as AppServerConnectionParameters):
		super(poParameters).
	end constructor.
    
	method override public void CreateConnection():
        define variable hServer as handle no-undo.
        
        create server hServer.
        
        Server = new WidgetHandle(hServer).
	end method.

    /** Connect to the server specified. 
        
        @param IConnectionParameters Parameters allowing us to make a connection        
               to a server connection */
    method override public void DoConnect():
        define variable oASParams as AppServerConnectionParameters no-undo.
        
        oASParams = cast(ConnectionParameters, AppServerConnectionParameters).
        
        cast(Server, WidgetHandle):Value:connect(string(ConnectionParameters:GetConnectionString()),
                        oASParams:UserName,
                        oASParams:UserPassword,
                        oASParams:AppServerInfo).
    end method.
    
end class.