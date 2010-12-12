/*------------------------------------------------------------------------
    File        : service_buildvehicle.p
    Purpose     : 
    Syntax      :
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jul 19 11:33:46 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.BizLogicWorkFlowRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkflowRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkflowResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.UserContext.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.ABLSession.

using Progress.Lang.Class.

/* ***************************  parameters, definitions  *************************** */
define input parameter pcOrderId as character no-undo.
define input parameter piProcessInstanceId as int64 no-undo.
define input parameter pcContextId as longchar no-undo.

define variable oInjectABLKernel as IKernel no-undo.
define variable oServiceMessageManager as IServiceMessageManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oRequest as BizLogicWorkFlowRequest extent 1 no-undo.
define variable oResponse as IWorkflowResponse extent 1 no-undo.
define variable oContext as IUserContext no-undo.

/* ***************************  Main Block  *************************** */
oInjectABLKernel = cast(ABLSession:Instance:SessionProperties:Get(Class:GetClass('OpenEdge.Core.InjectABL.IKernel')),
                        IKernel).

/* Are we who we say we are? Note that this should really happen on activate. activate doesn't run for state-free AppServers */
oSecMgr = cast(oInjectABLKernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager'))
               ,ISecurityManager).

/* construct the user context from parameters */ 
oContext = new UserContext(pcContextId).

oSecMgr:ValidateSession(oContext:ClientSessionId).
oSecMgr:SetClientContext(oContext).

oServiceMessageManager = cast(oInjectABLKernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceMessageManager'))
                        , IServiceMessageManager).

/* Create the WorkFlowRequest */
oRequest[1] = new BizLogicWorkFlowRequest('BuildVehicle').
oRequest[1]:ProcessInstanceId = piProcessInstanceId.
cast(oRequest[1], IServiceMessage):SetMessageData(pcOrderId).

/* Perform request. This is where the actual work happens. */
oResponse = cast(oServiceMessageManager:ExecuteRequest(oRequest), IWorkflowResponse).

if cast(oResponse[1], IServiceResponse):HasError then
    return error string(cast(oResponse[1], IServiceResponse):ErrorText).

error-status:error = no.
return.
/* EOF */