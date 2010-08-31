/* ------------------------------------------------------------------------
    File        : ServiceManager
    Purpose     : Client-side service manager
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Feb 22 10:53:02 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.Core.InjectABL.IKernel. 

class OpenEdge.CommonInfrastructure.Client.ServiceManager inherits OpenEdge.CommonInfrastructure.Common.ServiceManager:
    
    constructor public ServiceManager(poKernel as IKernel):
        super(poKernel).
    end constructor.

	method override public IServiceProvider GetServiceProvider( input pcService as character ):	    
		return super:GetServiceProvider(input pcService).
	end method.
	
end class.