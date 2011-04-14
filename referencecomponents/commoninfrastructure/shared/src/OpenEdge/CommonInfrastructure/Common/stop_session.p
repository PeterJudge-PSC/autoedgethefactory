/** ------------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Common/stop_session.p
    Purpose     : 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Tue Dec 28 11:01:25 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.InjectABL.ComponentKernel.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.

/** -- defs -- **/
define variable oInjectABLKernel as IKernel no-undo.
define variable oServiceManager as IServiceManager no-undo.
 
/** -- main -- **/
oServiceManager = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).

/* shutdown the session */
cast(oServiceManager:StartService(SecurityManager:ISecurityManagerType), ISecurityManager):EndSession().

/* close the service manager */
oInjectABLKernel = cast(ABLSession:Instance:SessionProperties:Get(Class:GetClass('OpenEdge.Core.InjectABL.IKernel')), IKernel).              
oInjectABLKernel:Release(oServiceManager).

delete object ABLSession:Instance no-error.
/** -- eof -- **/