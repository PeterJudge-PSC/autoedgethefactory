/** ------------------------------------------------------------------------
    File        : BizLogicWorkFlow
    Purpose     : Savvion BizLogic workflow class. This can be used to decorate
                  any IWorkFlow class.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 06 11:50:45 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.EnterpriseServices.BizLogic.IBizLogicWorkFlow.
using OpenEdge.EnterpriseServices.BizLogic.IBizLogicServerParameters.
using OpenEdge.BusinessComponent.WorkFlow.WorkFlowDecorator.
using OpenEdge.BusinessComponent.WorkFlow.IBusinessWorkFlow.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.

class OpenEdge.BusinessComponent.WorkFlow.BizLogicWorkFlow inherits WorkFlowDecorator
        implements IBizLogicWorkFlow:
    
    /* The Savvion Session ID */
    define public property SessionId as longchar no-undo get.
    
    /* Currently-running Process' instance ID  */
    define public property ProcessInstanceId as int64 no-undo get.

    define public property ServerParameter as IBizLogicServerParameters no-undo get. set. 

    constructor public BizLogicWorkFlow(input poWorkFlow as IBusinessWorkFlow):
        super(input poWorkFlow).
    end constructor.
    
    method public void Login (input pcUsername as character,    
                              input pcPassword as character):
    end method.
    
    method public void Logout():
    end method.
    
end class.