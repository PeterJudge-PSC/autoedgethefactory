/** ------------------------------------------------------------------------
    File        : IConnectionManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 29 09:58:46 EST 2010
    Notes       : * Connections are uniquely identifed by the ConnectionType and name.
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.ConnectionTypeEnum.
using OpenEdge.CommonInfrastructure.Common.IConnectionParameters.

using OpenEdge.Lang.Collections.IMap.

interface OpenEdge.CommonInfrastructure.Common.IConnectionManager:
    
    /** Connects to a server of the given type, with a unique name, for the
        provided parameters.
        
        @param ConnectionTypeEnum The type of connection
        @param character The unique name for this connection
        @return handle A handle to the server    */
    method public handle Connect(input poConnectionType as ConnectionTypeEnum,
                                 input pcConnectionName as character,
                                 input poParameters as IConnectionParameters).

    /** Disconnects from the specified connection
    
        @param ConnectionTypeEnum The type of connection
        @param character The unique name for this connection */
    method public void Disconnect(input poConnectionType as ConnectionTypeEnum,
                                  input pcConnectionName as character).

    /** Indicates whether the connection already exists.
    
        @param ConnectionTypeEnum The type of connection
        @param character The unique name for this connection */
    method public logical IsConnected(input poConnectionType as ConnectionTypeEnum,
                                      input pcConnectionName as character).

    /** Rreturns the handle to the specified connection.
    
        @param ConnectionTypeEnum The type of connection
        @param character The unique name for this connection 
        @return handle A handle to the server   */
    method public handle GetConnectionHandle(input poConnectionType as ConnectionTypeEnum,
                                             input pcConnectionName as character).
                                
end interface.