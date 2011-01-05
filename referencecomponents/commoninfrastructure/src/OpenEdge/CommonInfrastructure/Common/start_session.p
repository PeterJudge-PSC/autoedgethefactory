/** ------------------------------------------------------------------------
    File        : start_session.p
    Purpose     :  General / common session bootstrapping procedure.
    Syntax      :
    Description : 
    @author pjudge 
    Created     : Thu Dec 23 14:36:11 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.InjectABL.ComponentKernel.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.

/** -- defs -- **/
define variable cFilePattern as character extent 1 no-undo.
define variable oInjectABLKernel as IKernel no-undo.
define variable oServiceManager as IServiceManager no-undo.
define variable oSession as ABLSession no-undo.
 
/** -- main -- **/
cFilePattern[1] = 'load_injectabl_modules.p'.
oInjectABLKernel = new ComponentKernel().
oInjectABLKernel:Load(cFilePattern).

ABLSession:Instance:SessionProperties:Put(Class:GetClass('OpenEdge.Core.InjectABL.IKernel'), oInjectABLKernel).

oServiceManager = cast(oInjectABLKernel:Get(ServiceManager:ServiceManagerType), IServiceManager).
ABLSession:Instance:SessionProperties:Put(ServiceManager:ServiceManagerType, oServiceManager).

/** -- eof -- **/