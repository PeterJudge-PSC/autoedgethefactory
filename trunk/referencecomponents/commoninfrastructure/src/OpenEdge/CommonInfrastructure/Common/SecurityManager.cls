/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 18 11:54:05 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo. 
using OpenEdge.CommonInfrastructure.Common.Service.

class OpenEdge.CommonInfrastructure.Common.SecurityManager inherits Service 
        implements ISecurityManager:
        
    constructor public SecurityManager(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    method public void ValidateSession(input pcSessionId as character):
        @todo(task="implement", action="").
        /* HappyPlace! */
    end method.
    
	method public IUserContext GetPendingContext(  ):
	    define variable oUC as IUserContext no-undo.
	    @todo(task="implement", action="").
        return oUC.
	end method.

	method public void SetClientContext(input poUserContext as IUserContext):
	end method.

end class.