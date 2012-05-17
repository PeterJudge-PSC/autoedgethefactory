/** ------------------------------------------------------------------------
    File        : ConnectionManagerActionEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 05 13:48:17 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.ConnectionTypeEnum.
using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.
using OpenEdge.Core.System.EventArgs.
using OpenEdge.Lang.Assert.

class OpenEdge.CommonInfrastructure.Common.ConnectionManagerActionEventArgs inherits EventArgs:
    
    define public property ConnectionType as ConnectionTypeEnum no-undo get. set.
    define public property ConnectionName as character no-undo get. set.
    define public property Parameters as IConnectionParameters no-undo get. set.
    define public property ActionFailed as logical no-undo get. set.
    
	constructor public ConnectionManagerActionEventArgs(  ):
		super ().
	end constructor.
	
    constructor public ConnectionManagerActionEventArgs(input poConnectionType as ConnectionTypeEnum,
                                                        input pcConnectionName as character,
                                                        input poParameters as IConnectionParameters,
                                                        input plActionFailed as logical):
        super().
        
        Assert:ArgumentNotNull(poConnectionType, 'Connection Type').
        Assert:ArgumentNotNullOrEmpty(pcConnectionName, 'Connection Name').
        
        assign ConnectionType = poConnectionType
               ConnectionName = pcConnectionName
               Parameters = poParameters
               ActionFailed = plActionFailed.
    end constructor.
    
end class.