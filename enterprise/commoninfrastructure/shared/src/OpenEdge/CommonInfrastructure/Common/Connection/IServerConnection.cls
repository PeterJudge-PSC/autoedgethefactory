/** ------------------------------------------------------------------------
    File        : IServerConnection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 20 08:55:22 EDT 2011
    Notes       : * Naming conventions for Events
                    EventName:  ServerConnecting
                    EventArgs:  ServerConnectingEventArgs
                    Handler:    ServerConnectingHandler
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.ServerConnectionEventArgs.

using Progress.Lang.Object.
using Progress.Lang.Class.

interface OpenEdge.CommonInfrastructure.Common.Connection.IServerConnection:
    
    /** Event fired before a connection is attempted  
        
        @param Object The object publishing the event
        @param ServerConnectionEventArgs Arguments/parameters for the event. */
    define public event ServerConnecting signature void (input poSender as Object, input poEventArgs as ServerConnectionEventArgs).
    
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
    
    /** (mandatory) Reference to the actual server. The type of this property depends
        on the server type (since AppServers have HANDLEs, BPMServers have IBizLogicAPI 
        and databases none). */
    define public property Server as Object no-undo get.
    
    /** (mandatory) The OO type that  the Server represents. */
    define public property ServerType as class Class no-undo get.
    
    /** (mandatory) Parameters for this connection */
    define public property ConnectionParameters as IConnectionParameters no-undo get.
    
    /** Is the Server connected? */
    define public property IsConnected as logical no-undo get. 

    /** Create/set-up the server specified. This may involve a CREATE {SERVER|SOCKET|etc}, or a NEW <class> */ 
    method public void CreateConnection().

    /** Destroy the server connection. This may involve a DELETE OBJECT of some sort */ 
    method public void DestroyConnection().
    
    /** Connect to the server specified, based on the ConnectionParameters (passed in to the ctor) */ 
    method public void Connect().
    
    /**  Disconnect from the Server  */
    method public void Disconnect().
    
end interface.