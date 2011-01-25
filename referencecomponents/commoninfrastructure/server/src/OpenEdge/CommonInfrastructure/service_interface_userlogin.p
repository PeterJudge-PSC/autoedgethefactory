/** ----------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/service_interface_userlogin.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Dec 16 09:17:18 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.ISecurityManager.
using OpenEdge.CommonInfrastructure.CommonSecurityManager.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.CommonServiceManager.
using OpenEdge.CommonInfrastructure.IUserContext.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.ObjectOutputStream.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- params, defs -- **/
define input  parameter pcUserName as character no-undo.
define input  parameter pcUserDomain as character no-undo.
define input  parameter pcPassword as character no-undo.
define output parameter pmUserContext as memptr no-undo.

define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oContext as IUserContext no-undo.
define variable oOutput as IObjectOutput no-undo.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcUserName, 'User Name').
Assert:ArgumentNotNullOrEmpty(pcUserDomain, 'User Domain').
Assert:ArgumentNotNullOrEmpty(pcPassword, 'Password').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(CommonServiceManager:ServiceManagerType), IServiceManager).

oSecMgr = cast(oServiceMgr:StartService(CommonSecurityManager:SecurityManagerType), ISecurityManager).

/* log in and establish tenancy, user context */
oContext = oSecMgr:UserLogin(pcUserName, pcUserDomain, pcPassword).

    def var okeys as Progress.Lang.Object extent.
    def var ovals as Progress.Lang.Object extent.

okeys = oSecMgr:CurrentUserContext:TenantId:KeySet:ToArray().
ovals = oSecMgr:CurrentUserContext:TenantId:Values:ToArray().

message '>>>>>>> oSecMgr:CurrentUserContext:UserName' oSecMgr:CurrentUserContext:UserName. 
message '>>>>>>> okeys[1]' okeys[1]. 
message '>>>>>>> ovals[1]' ovals[1]. 


oOutput = new ObjectOutputStream().
oOutput:WriteObject(oContext).
oOutput:Write(output pmUserContext).

error-status:error = no.
return.

/** -- error handling -- **/
catch oApplError as ApplicationError:
    return error oApplError:ResolvedMessageText().
end catch.

catch oAppError as AppError:
    return error oAppError:ReturnValue. 
end catch.

catch oError as Error:
    return error oError:GetMessage(1).
end catch.
/** -- eof -- **/