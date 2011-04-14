/** ------------------------------------------------------------------------
    File        : AppServerConnectionParameters
    Purpose     : Parameter object for AppServer connections. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jan 13 13:01:22 EST 2011
    Notes       : * This object (and associated interface) should be refactored to be more 
                    specialised for AppServers (eg so that the connection string can be composed
                    from properties, say).
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IAppServerConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.ConnectionParameters.

class OpenEdge.CommonInfrastructure.Common.AppServerConnectionParameters inherits ConnectionParameters
        implements IAppServerConnectionParameters: 

	define public property AppServerInfo as character no-undo get. set. 

	define public property UserName as character no-undo get. set. 

	define public property UserPassword as character no-undo get. set. 

	constructor public AppServerConnectionParameters(  ):
		super ().
	end constructor.
	
end class.