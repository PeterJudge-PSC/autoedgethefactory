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
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.CommonServiceManager.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.

/** -- defs -- **/
define input parameter pcSessionCode as character no-undo.

define variable cFilePattern as character extent 1 no-undo.
define variable oInjectABLKernel as IKernel no-undo.
define variable oServiceManager as IServiceManager no-undo.
define variable oSession as ABLSession no-undo.
 
/** -- main -- **/
/* Set the session code before loading the kernel, in case there are dependencies on the session code */
ABLSession:Instance:Name = pcSessionCode.

cFilePattern[1] = 'load_injectabl_modules.p'.
oInjectABLKernel = new ComponentKernel().
oInjectABLKernel:Load(cFilePattern).

ABLSession:Instance:SessionProperties:Put(Class:GetClass('OpenEdge.Core.InjectABL.IKernel'), oInjectABLKernel).

oServiceManager = cast(oInjectABLKernel:Get(CommonServiceManager:ServiceManagerType), IServiceManager).
ABLSession:Instance:SessionProperties:Put(CommonServiceManager:ServiceManagerType, oServiceManager).

/** -- eof -- **/