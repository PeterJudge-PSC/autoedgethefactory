/*------------------------------------------------------------------------
    File        : as_disconnect.p
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
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.AgentConnection.

using Progress.Lang.Class.
using Progress.Lang.Object.

/* ***************************  Main Block  *************************** */
cast(ABLSession:Instance:SessionProperties:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager')),
        IServiceManager):Kernel:Clear(AgentConnection:Instance).

delete object AgentConnection:Instance.

/* eof */