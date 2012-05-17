/*------------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/as_disconnect.p
    Purpose     : AppServer Disconnect procedure. 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Fri Jun 04 16:04:42 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

/* ***************************  Main Block  *************************** */
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.AgentConnection.

using Progress.Lang.Class.
using Progress.Lang.Object.

define variable oServiceMgr as IServiceManager no-undo.

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).
               
cast(oServiceMgr:GetService(SecurityManager:ISecurityManagerType), ISecurityManager):EndSession().
               
oServiceMgr:Kernel:Clear(AgentConnection:Instance).

delete object AgentConnection:Instance.

/* eof */