/** ------------------------------------------------------------------------
    File        : service_listorderstatus.p
    Purpose     : 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Thu Dec 16 09:11:58 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest.
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
using OpenEdge.CommonInfrastructure.Common.Service.

using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- params, defs -- **/
/* AETF info */
define input parameter pcContextId as longchar no-undo.

/* return */
define output parameter dataset-handle phOrders.

define variable oServiceMessageManager as IServiceMessageManager no-undo.
define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oRequest as IFetchRequest extent 1 no-undo.
define variable oResponse as IFetchResponse extent 1 no-undo.
define variable oContext as IUserContext no-undo.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcContextId, 'User Context Id').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:ServiceManagerType), IServiceManager).

/* Are we who we say we are? Note that this should really happen on activate. activate doesn't run for state-free AppServers */
oSecMgr = cast(oServiceMgr:StartService(SecurityManager:SecurityManagerType), ISecurityManager).

oContext = oSecMgr:ValidateSession(pcContextId).
/* add parameter values to the user context */ 

oServiceMessageManager = cast(oServiceMgr:StartService(ServiceMessageManager:ServiceMessageManagerType)
                        , IServiceMessageManager).

/* Create the WorkStepRequest */
oRequest[1] = new FetchRequest('Order').

/* Perform request. This is where the actual work happens. */
oResponse = cast(oServiceMessageManager:ExecuteRequest(cast(oRequest, IServiceRequest)), IFetchResponse).
if cast(oResponse[1], IServiceResponse):HasError then
    return error string(cast(oResponse[1], IServiceResponse):ErrorText).

cast(oResponse[1], IServiceMessage):GetMessageData(output phOrders).

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