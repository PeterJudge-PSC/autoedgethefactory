/*------------------------------------------------------------------------
    File        : ServerConnection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Dec 08 11:37:02 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.ServerConnectionActionEnum.
using OpenEdge.CommonInfrastructure.Common.Connection.IServerConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.ServerConnectionEventArgs.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.Connection.ServerConnection abstract  
        implements IServerConnection:
            
/** Event fired before a connection is attempted  
        
        @param Object The object publishing the event
        @param ServerConnectionEventArgs Arguments/parameters for the event. */
    define public event ServerConnecting signature void (input poSender as Object, input poEventArgs as ServerConnectionEventArgs ).
    
    /** Event fired after a connection attempt is made.  
        
        @param Object The object publishing the event
        @param ServerConnectionEventArgs Arguments/parameters for the event. */
    define public event ServerConnected signature void (input poSender as Object, input poEventArgs as ServerConnectionEventArgs).
    
    /** Event fired before a connection disconnect is attempted  
                    
        @param Object The object publishing the event
        @param ServerConnectionEventArgs Arguments/parameters for the event. */
    define public event ServerDisconnecting signature void (input poSender as Object, input poEventArgs as ServerConnectionEventArgs).

    /** Event fired after a connection disconnect is attempted.
        
        @param Object The object publishing the event
        @param ServerConnectionEventArgs Arguments/parameters for the event. */
    define public event ServerDisconnected signature void (input poSender as Object, input poEventArgs as ServerConnectionEventArgs).
    
    /** (mandatory) The OO type that  the Server represents. */
    define abstract public property ServerType as class Class no-undo get.
    
    /** (mandatory) Reference to the actual server. The type of this property depends
        on the server type (since AppServers have HANDLEs, BPMServers have IBizLogicAPI 
        and databases none). */
    define public property Server as Object no-undo get.
        protected set(input poServer as Object):
            Assert:ArgumentIsType(poServer, ServerType).
            Server = poServer.
        end set.

    /** (mandatory) Parameters for this connection */
    define public property ConnectionParameters as IConnectionParameters no-undo get. private set.
    
    /** Is the server connected? */    
    define abstract public property IsConnected as logical no-undo get.

    constructor public ServerConnection(input poParameters as IConnectionParameters):
        super().
        
        Assert:ArgumentNotNull(poParameters, 'Connection Parameters').
        
        ConnectionParameters = poParameters.
    end constructor.

    /** Create/set-up the server specified. This will involve a CREATE {SERVER|SOCKET|etc} */ 
    method abstract public void CreateConnection().
    
    /** Destroy the server connection. This may involve a DELETE OBJECT of some sort */ 
    method public void DestroyConnection():
        if IsConnected then
            this-object:Disconnect().
    end method.

    /** Connect to the Handle specified. 
        
        @param IConnectionParameters Parameters allowing us to make a connection        
               to a handle-based connection */
    method final public void Connect():
        BeforeConnect().
        DoConnect().
        AfterConnect().
    end method.
    
    method protected void BeforeConnect():
        OnServerConnecting(
            new ServerConnectionEventArgs(
                this-object,
                ServerConnectionActionEnum:Connect,
                not IsConnected)).
    end method.
    
    method abstract protected void DoConnect().
    
    method protected void AfterConnect():
        OnServerConnected(
            new ServerConnectionEventArgs(
                this-object,
                ServerConnectionActionEnum:Connect,
                IsConnected /* success? */ )).
    end method.
    
    /**  Disconnect from the server */
    method final public void Disconnect():
        BeforeDisconnect().
        DoDisconnect().
        AfterDisconnect().
    end method.

    method protected void BeforeDisconnect():
        OnServerDisconnecting(
            new ServerConnectionEventArgs(
                this-object,
                ServerConnectionActionEnum:Disconnect,
                IsConnected)).
    end method.
    
    method abstract protected void DoDisconnect().
    
    method protected void AfterDisconnect():
        OnServerDisconnected(
            new ServerConnectionEventArgs(
                this-object,
                ServerConnectionActionEnum:Disconnect,
                not IsConnected /*success? */ )).
    end method.
    
    /** Allows raising of the ServerConnecting event by derived classes. 
        
        @param ServerConnectionEventArgs Arguments for the event.  */
    method protected void OnServerConnecting(input poEventArgs as ServerConnectionEventArgs):
        ServerConnecting:Publish(this-object, poEventArgs).
    end method.

    /** Allows raising of the ServerConnected event by derived classes. 
        
        @param ServerConnectionEventArgs Arguments for the event.  */
    method protected void OnServerConnected(input poEventArgs as ServerConnectionEventArgs):
        ServerConnected:Publish(this-object, poEventArgs).
    end method.
    
    /** Allows raising of the ServerDisconnecting event by derived classes. 
        
        @param ServerConnectionEventArgs Arguments for the event.  */
    method protected void OnServerDisconnecting(input poEventArgs as ServerConnectionEventArgs):
        ServerDisconnecting:Publish(this-object, poEventArgs).
    end method. 

    /** Allows raising of the ServerDisconnected event by derived classes. 
        
        @param ServerConnectionEventArgs Arguments for the event.  */
    method protected void OnServerDisconnected(input poEventArgs as ServerConnectionEventArgs):
        ServerDisconnected:Publish(this-object, poEventArgs).
    end method. 
end class.