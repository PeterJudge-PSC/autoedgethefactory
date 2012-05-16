/** ------------------------------------------------------------------------
    File        : IServerConnection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 20 08:55:22 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.
using Progress.Lang.Object.

interface OpenEdge.CommonInfrastructure.Common.Connection.IServerConnection:
    
    /** (mandatory) Reference to the actual server. The type of this property depends
        on the server type (since AppServers have HANDLEs, BPMServers have IBizLogicAPI 
        and databases none). */
    define public property Server as Object no-undo get.
    
    /** (mandatory) Parameters for this connection */
    define public property ConnectionParameters as IConnectionParameters no-undo get.
    
    /** Is the Server connected? */
    define public property IsConnected as logical no-undo get. 
    
    /** Connect to the server specified, basedon the ConnectionParameters (passed in to the ctor) */ 
    method public void Connect().
    
    /**  Disconnect from the Server  */
    method public void Disconnect().
    
end interface.