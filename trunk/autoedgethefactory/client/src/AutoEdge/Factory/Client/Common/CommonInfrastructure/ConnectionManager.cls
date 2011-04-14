/** ------------------------------------------------------------------------
    File        : ConnectionManager
    Purpose     : AutoEdge|TheFactory client-side connection manager 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jan 14 12:32:56 EST 2011
    Notes       : 

  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Common.AppServerConnectionParameters.

using OpenEdge.CommonInfrastructure.Common.ConnectionTypeEnum.
using OpenEdge.CommonInfrastructure.Common.ConnectionManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

class AutoEdge.Factory.Client.Common.CommonInfrastructure.ConnectionManager inherits ConnectionManager: 
		
	constructor public ConnectionManager(input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo ):
		super (input poServiceManager, input poComponentInfo).
	end constructor.

	constructor public ConnectionManager(input poComponentInfo as IComponentInfo ):
		super (input poComponentInfo).
	end constructor.
	
	method override public void Initialize(  ):
		super:Initialize().
		
		this-object:Connect(ConnectionTypeEnum:AppServer, 'AutoEdgeTheFactory', new AppServerConnectionParameters()). 
	end method.
	
end class.