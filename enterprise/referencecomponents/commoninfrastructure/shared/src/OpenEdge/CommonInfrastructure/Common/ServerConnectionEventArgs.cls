/** ------------------------------------------------------------------------
    File        : ServerConnectionEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 05 13:48:17 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.ServerConnectionActionEnum.
using OpenEdge.CommonInfrastructure.Common.Connection.IServerConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.
using OpenEdge.Core.System.EventArgs.
using OpenEdge.Lang.Assert.

class OpenEdge.CommonInfrastructure.Common.ServerConnectionEventArgs inherits EventArgs:
    
    define public property ServerConnection as IServerConnection no-undo get. set.
    define public property Action as ServerConnectionActionEnum no-undo get. set.
    define public property ActionSuccess as logical no-undo get. set.
    
	constructor public ServerConnectionEventArgs():
		super ().
	end constructor.
	
    constructor public ServerConnectionEventArgs(input poConnection as IServerConnection,
                                                 input poAction as ServerConnectionActionEnum,            
                                                 input plActionSuccess as logical):
        super().
        
        Assert:ArgumentNotNull(poConnection, 'Server Connection').
        Assert:ArgumentNotNull(poAction, 'Server Connection Action').
        
        assign ServerConnection = poConnection
               Action = poAction
               ActionSuccess = plActionSuccess.
    end constructor.
    
end class.