/*------------------------------------------------------------------------
    File        : as_deactivate.p
    Purpose     : AppServer deactivation procedure 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Fri Jun 04 16:23:45 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.AgentRequest.

using Progress.Lang.Class.
using Progress.Lang.Object.

/* ***************************  Main Block  *************************** */
cast(ABLSession:Instance:SessionProperties:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager')),
        IServiceManager):Kernel:Clear(AgentRequest:Instance).

delete object AgentRequest:Instance.
/* eof */