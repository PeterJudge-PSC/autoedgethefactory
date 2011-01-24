/*------------------------------------------------------------------------
    File        : as_disconnect.p
    Purpose     : AppServer Disconnect procedure. 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Fri Jun 04 16:04:42 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
{routinelevel.i}

/* ***************************  Main Block  *************************** */
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.CommonServiceManager.
using OpenEdge.CommonInfrastructure.ISecurityManager.
using OpenEdge.CommonInfrastructure.CommonSecurityManager.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.AgentConnection.

using Progress.Lang.Class.
using Progress.Lang.Object.

define variable oServiceMgr as IServiceManager no-undo.

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(CommonServiceManager:ServiceManagerType), IServiceManager).
               
cast(oServiceMgr:StartService(CommonSecurityManager:SecurityManagerType), ISecurityManager):EndSession().
               
oServiceMgr:Kernel:Clear(AgentConnection:Instance).

delete object AgentConnection:Instance.

/* eof */