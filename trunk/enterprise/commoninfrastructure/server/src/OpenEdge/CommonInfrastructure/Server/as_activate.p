/** -----------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/as_activate.p
    Purpose     : 

    Syntax      :

    Description : AppServer Activation routine

    @author     : pjudge 
    Created     : Fri Jun 04 16:21:40 EDT 2010
    Notes       :
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Server.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.AgentRequest.

using Progress.Lang.OERequestInfo.
using Progress.Lang.Class.

/* ***************************  Main Block  *************************** */
define variable oServiceMgr as IServiceManager no-undo.
define variable oRequestInfo as OERequestInfo no-undo.

/* This starts the request object and sets its ID */
OpenEdge.Lang.AgentRequest:Instance.

/*
oRequestInfo = cast(session:current-request-info, OERequestInfo).
if valid-object(oRequestInfo) and oRequestInfo:ClientContextId ne ? then
do:
    oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).
    cast(oServiceMgr:GetService(SecurityManager:ISecurityManagerType), ISecurityManager):EstablishSession(oRequestInfo:ClientContextId).
end.
*/
/* eof */