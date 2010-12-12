/*------------------------------------------------------------------------
    File        : service_buildvehicle_performworkstep.p
    Purpose     : 
    Syntax      :
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jul 19 11:33:46 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.BizLogicWorkstepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.UserContext.

using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- params, defs -- **/
define input parameter pcWorkstepName as character no-undo. /* expecting 'ProcessComponents' or similar. */
define input parameter piProcessInstanceId as int64 no-undo.
define input parameter pcOrderId as character no-undo.
define input parameter pcContextId as longchar no-undo.
define output parameter pcBuildStatus as longchar no-undo.

define variable oServiceMessageManager as IServiceMessageManager no-undo.
define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oRequest as IWorkstepRequest extent 1 no-undo.
define variable oResponse as IWorkstepResponse extent 1 no-undo.
define variable oContext as IUserContext no-undo.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcWorkstepName, 'Workstep Name').
Assert:ArgumentNotNullOrEmpty(pcOrderId, 'Order Id').
Assert:ArgumentNotNullOrEmpty(pcContextId, 'User Context Id').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager'))
               , IServiceManager).

/* Are we who we say we are? Note that this should really happen on activate. activate doesn't run for state-free AppServers */
oSecMgr = cast(oServiceMgr:StartService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager'))
               ,ISecurityManager).

/* construct the user context from parameters */ 
oContext = new UserContext(pcContextId).

oSecMgr:ValidateSession(oContext:ClientSessionId).
oSecMgr:SetClientContext(oContext).

oServiceMessageManager = cast(oServiceMgr:StartService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceMessageManager'))
                        , IServiceMessageManager).

/* Create the WorkStepRequest */
oRequest[1] = new BizLogicWorkstepRequest('BuildVehicle::' + pcWorkstepName).
oRequest[1]:Name = pcWorkstepName.
cast(oRequest[1], BizLogicWorkstepRequest):ProcessInstanceId = piProcessInstanceId.
cast(oRequest[1], IServiceMessage):SetMessageData(pcOrderId).

/* Perform request. This is where the actual work happens. */
oResponse = cast(oServiceMessageManager:ExecuteRequest(cast(oRequest, IServiceRequest)), IWorkstepResponse).
if cast(oResponse[1], IServiceResponse):HasError then
do:
    pcBuildStatus = cast(oResponse[1], IServiceResponse):ErrorText.
    return error string(pcBuildStatus).
end.

pcBuildStatus = oResponse[1]:Status.

error-status:error = no.
return.

/** -- error handling -- **/
catch oApplError as ApplicationError:
    return error oApplError:ResolvedMessageText().
end catch.

catch oAppError as AppError:
    return error oAppError:ReturnValue. 
end catch.

catch oError as Error:
    message program-name(1) program-name(2) skip(2)
    oError:GetMessage(1) skip
    oerror:CallStack
    
    view-as alert-box error title '[PJ DEBUG]'.
    return error oError:GetMessage(1).
end catch.

/** -- eof -- **/