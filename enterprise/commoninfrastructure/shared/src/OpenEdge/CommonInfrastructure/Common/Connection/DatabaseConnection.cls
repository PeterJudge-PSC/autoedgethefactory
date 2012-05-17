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

using OpenEdge.CommonInfrastructure.Common.Connection.DBConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.Connection.ServerConnection.

using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.Connection.DatabaseConnection inherits ServerConnection:

    /** (mandatory) The OO type that  the Server represents. */
    define override public property ServerType as class Class no-undo get.
    
    define public property LogicalName as character no-undo
        get():
            return cast(ConnectionParameters, DBConnectionParameters):LogicalName.
        end get.
        
    define public property PhysicalName as character no-undo
        get():
            return cast(ConnectionParameters, DBConnectionParameters):PhysicalName.
        end get.

    /** Is the Server connected? */    
    define override public property IsConnected as logical no-undo
        get():
            return connected(LogicalName).
        end get.
    
	constructor public DatabaseConnection(input poParameters as DBConnectionParameters):	    
		super(poParameters).
    end constructor.
    
	method override protected void DoConnect():
        connect value(string(ConnectionParameters:GetConnectionString())).
	end method.
	
	method override protected void DoDisconnect():	    
	    disconnect value(LogicalName).
	end method.

	method override public void CreateConnection():
	    /* no-op */
	end method.

	method override public void DestroyConnection():
        /* no-op */
    end method.

end class.