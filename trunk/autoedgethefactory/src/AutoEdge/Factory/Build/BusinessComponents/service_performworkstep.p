/*------------------------------------------------------------------------
    File        : service_performworkstep.p
    Purpose     : 
    Syntax      :
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jul 19 11:33:46 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.BizLogicWorkStepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.ServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.UserContext.

using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- params, defs -- **/
/* AETF info */
define input parameter pcOrderId as character no-undo.
define input parameter pcContextId as longchar no-undo.

/* BizLogic info */
define input parameter pcProcessInstanceName as character no-undo.
define input parameter piProcessInstanceId as int64 no-undo.
define input parameter pcWorkstepName as character no-undo.             /* expecting 'ProcessComponents' or similar. */

/* return */
define output parameter pcBuildStatus as longchar no-undo.

define variable oServiceMessageManager as IServiceMessageManager no-undo.
define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oRequest as IWorkstepRequest extent 1 no-undo.
define variable oResponse as IWorkstepResponse extent 1 no-undo.
define variable oContext as IUserContext no-undo.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcProcessInstanceName, 'Process Instance Name').
Assert:ArgumentNotNullOrEmpty(pcWorkstepName, 'Workstep Name').
Assert:ArgumentNonZero(piProcessInstanceId, 'Process Instance Id').
Assert:ArgumentNotNullOrEmpty(pcOrderId, 'Order Id').
Assert:ArgumentNotNullOrEmpty(pcContextId, 'User Context Id').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:ServiceManagerType), IServiceManager).

/* Are we who we say we are? Note that this should really happen on activate. activate doesn't run for state-free AppServers */
oSecMgr = cast(oServiceMgr:StartService(SecurityManager:SecurityManagerType)
               ,ISecurityManager).

oContext = oSecMgr:ValidateSession(pcContextId).
/* add parameter values to the user context */

oServiceMessageManager = cast(oServiceMgr:StartService(ServiceMessageManager:ServiceMessageManagerType), IServiceMessageManager).

/* Create the WorkStepRequest */
oRequest[1] = new BizLogicWorkstepRequest(substitute('&1::&2',
                                                entry(1, pcProcessInstanceName, '#'),
                                                pcWorkstepName)).
oRequest[1]:Name = pcWorkstepName.
cast(oRequest[1], BizLogicWorkstepRequest):ProcessInstanceId = piProcessInstanceId.
cast(oRequest[1], BizLogicWorkstepRequest):ProcessInstanceName = pcProcessInstanceName.
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
    return error oError:GetMessage(1).
end catch.
/** -- eof -- **/