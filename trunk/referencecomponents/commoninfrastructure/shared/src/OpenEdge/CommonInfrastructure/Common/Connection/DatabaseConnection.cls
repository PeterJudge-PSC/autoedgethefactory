/** ------------------------------------------------------------------------
    File        : ABLDatabaseConnection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 20 09:01:19 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.IServerConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.Connection.DBConnectionParameters.

using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.Connection.DatabaseConnection 
        implements IServerConnection:

    /** (mandatory) Reference to the actual server. The type of this property depends
        on the server type (since AppServers have HANDLEs, BPMServers have IBizLogicAPI 
        and databases none). */
    define public property Server as Object no-undo get. protected set.

    /** (mandatory) Parameters for this connection */
    define public property ConnectionParameters as IConnectionParameters no-undo get. private set.
    
    define public property LogicalName as character no-undo
        get():
            return cast(ConnectionParameters, DBConnectionParameters):LogicalName.
        end get.
        
    define public property PhysicalName as character no-undo
        get():
            return cast(ConnectionParameters, DBConnectionParameters):PhysicalName.
        end get.

    /** Is the Server connected? */    
    define public property IsConnected as logical no-undo
        get():
            return connected(LogicalName).
        end get.
    
	constructor public DatabaseConnection(input poParameters as DBConnectionParameters):	    
		super().
		
		ConnectionParameters = poParameters. 
    end constructor.
    
	method public void Connect():
        connect value(string(ConnectionParameters:GetConnectionString())).
	end method.
	
	method public void Disconnect():	    
	    disconnect value(LogicalName).
	end method.

end class.