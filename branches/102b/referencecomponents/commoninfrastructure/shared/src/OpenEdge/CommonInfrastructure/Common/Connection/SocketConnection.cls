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

using OpenEdge.CommonInfrastructure.Common.Connection.IServerConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.Connection.ConnectionParameters.

using OpenEdge.Lang.WidgetHandle.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.Connection.SocketConnection 
        implements IServerConnection: 

    /** (mandatory) Reference to the actual server. The type of this property depends
        on the server type (since AppServers have HANDLEs, BPMServers have IBizLogicAPI 
        and databases none). */
    define public property Server as Object no-undo get. protected set.

    /** (mandatory) Parameters for this connection */
    define public property ConnectionParameters as IConnectionParameters no-undo get. private set.
    
    /** Is the Socket connected? */    
    define public property IsConnected as logical no-undo
        get():
            define variable lConnected as logical no-undo.
            define variable hSocket as handle no-undo.
            
            assign hSocket = cast(Server, WidgetHandle):Value
                   lConnected = valid-handle(hSocket).
            if lConnected then
                lConnected = hSocket:connected().
            
            return lConnected.
    end get.
    
    constructor public SocketConnection(input poParameters as IConnectionParameters):
        super ().
        
        ConnectionParameters = poParameters.
    end constructor.
    
    /** Connect to the Socket specified. 
        
        @param IConnectionParameters Parameters allowing us to make a connection        
               to a Socket connection */
    method public void Connect():
        define variable hSocket as handle no-undo.
        
        create Socket hSocket.
        
        Server = new Widgethandle(hSocket).
        
        hSocket:connect(string(ConnectionParameters:GetConnectionString())).
    end method. 
    
    /**  Disconnect from the BpmSocket */
    method public void Disconnect():
        if IsConnected then
            cast(Server, WidgetHandle):Value:disconnect().
    end method.

end class.