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

using OpenEdge.CommonInfrastructure.Common.Connection.IServerConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.AppServerConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.

using OpenEdge.Lang.WidgetHandle.
using Progress.Lang.Object.


class OpenEdge.CommonInfrastructure.Common.Connection.AppServerConnection implements IServerConnection:
    /** (mandatory) Reference to the actual server. The type of this property depends
        on the server type (since AppServers have HANDLEs, BPMServers have IBizLogicAPI 
        and databases none). */
    define public property Server as Object no-undo get. protected set.

    /** (mandatory) Parameters for this connection */
    define public property ConnectionParameters as IConnectionParameters no-undo get. private set.
    
    /** Is the Server connected? */
    define public property IsConnected as logical no-undo
        get():
            define variable lConnected as logical no-undo.
            define variable hServer as handle no-undo.
            
            assign hServer = cast(Server, WidgetHandle):Value
                   lConnected = valid-handle(hServer).
            if lConnected then
                lConnected = hServer:connected().
            
            return lConnected.
        end get.
    
	constructor public AppServerConnection(input poParameters as AppServerConnectionParameters):
		super ().
		
		ConnectionParameters = poParameters.
	end constructor.
    
    /** Connect to the server specified. 
        
        @param IConnectionParameters Parameters allowing us to make a connection        
               to a server connection */
    method public void Connect():
        define variable oASParams as AppServerConnectionParameters no-undo.
        define variable hServer as handle no-undo.
        
        oASParams = cast(ConnectionParameters, AppServerConnectionParameters).
        
        create server hServer.
        
        Server = new WidgetHandle(hServer).
        
        hServer:connect(string(ConnectionParameters:GetConnectionString()),
                        oASParams:UserName,
                        oASParams:UserPassword,
                        oASParams:AppServerInfo).
    end method.
    
    /**  Disconnect from the BpmServer */
    method public void Disconnect():
        if IsConnected then
            cast(Server, WidgetHandle):Value:disconnect().
    end method.
    
end class.