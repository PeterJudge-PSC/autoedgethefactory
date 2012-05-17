@openapi.openedge.export FILE(type="BPM", operationName="%FILENAME%", useReturnValue="false", writeDataSetBeforeImage="false", executionMode="external").
/** ----------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/service_userlogin.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Dec 16 09:17:18 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

/** -- params, defs -- **/
define input  parameter pcUserName as character no-undo.
define input  parameter pcUserDomain as character no-undo.
define input  parameter pcPassword as character no-undo.
define output parameter pcUserContextId as longchar no-undo.

define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.

/** -- validate defs -- **/
if pcUserName eq 'Savvion::Test' then
do:
    pcUserContextId = 'pcUserContextId'.
    return.
end. 

Assert:ArgumentNotNullOrEmpty(pcUserName, 'User Name').
Assert:ArgumentNotNullOrEmpty(pcUserDomain, 'User Domain').
Assert:ArgumentNotNullOrEmpty(pcPassword, 'User Password').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).

oSecMgr = cast(oServiceMgr:GetService(SecurityManager:ISecurityManagerType), ISecurityManager).

/* log in and establish tenancy, user context */
oSecMgr:UserLogin(pcUserName,
                  pcUserDomain,
                  pcPassword).
pcUserContextId = oSecMgr:CurrentUserContext:ContextId.

Assert:ArgumentNotNullOrEmpty(pcUserContextId, 'User Context ID').

error-status:error = no.
return.

/** -- error handling -- **/
{OpenEdge/CommonInfrastructure/Server/service_returnerror.i}
/** -- eof -- **/