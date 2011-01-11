/** ------------------------------------------------------------------------
    File        : stop_session.p
    Purpose     : 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Tue Dec 28 11:01:25 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.InjectABL.ComponentKernel.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.CommonServiceManager.
using OpenEdge.CommonInfrastructure.ISecurityManager.
using OpenEdge.CommonInfrastructure.CommonSecurityManager.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.

/** -- defs -- **/
define variable oInjectABLKernel as IKernel no-undo.
define variable oServiceManager as IServiceManager no-undo.
 
/** -- main -- **/
oServiceManager = cast(ABLSession:Instance:SessionProperties:Get(CommonServiceManager:ServiceManagerType), IServiceManager).

/* shutdown the session */
cast(oServiceManager:StartService(CommonSecurityManager:SecurityManagerType), ISecurityManager):EndSession().

/* close the service manager */
oInjectABLKernel = cast(ABLSession:Instance:SessionProperties:Get(Class:GetClass('OpenEdge.Core.InjectABL.IKernel')), IKernel).              
oInjectABLKernel:Release(oServiceManager).

delete object ABLSession:Instance no-error.
/** -- eof -- **/