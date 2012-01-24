/** ----------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/service_interface_userlogin.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Dec 16 09:17:18 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Server.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.ObjectOutputStream.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

/** -- params, defs -- **/
define input  parameter pcUserName as character no-undo.
define input  parameter pcUserDomain as character no-undo.
define input  parameter pcPassword as character no-undo.
define output parameter pmUserContext as memptr no-undo.

define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oContext as IUserContext no-undo.
define variable oOutput as IObjectOutput no-undo.
define variable cContextId as longchar no-undo.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcUserName, 'User Name').
Assert:ArgumentNotNullOrEmpty(pcUserDomain, 'User Domain').
Assert:ArgumentNotNullOrEmpty(pcPassword, 'Password').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).

oSecMgr = cast(oServiceMgr:GetService(SecurityManager:ISecurityManagerType), ISecurityManager).

/* log in and establish tenancy, user context */
cContextId = cast(oSecMgr, OpenEdge.CommonInfrastructure.Common.ISecurityManager):UserLogin(pcUserName, pcUserDomain, pcPassword).

oContext = oSecMgr:GetPendingContext(cContextId).

oOutput = new ObjectOutputStream().
oOutput:WriteObject(oContext).
oOutput:Write(output pmUserContext).

error-status:error = no.
return.

/** -- error handling -- **/
{OpenEdge/CommonInfrastructure/Server/service_returnerror.i}
/** -- eof -- **/