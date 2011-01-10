/** ------------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/service_userlogin.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Dec 16 09:17:18 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
/*routine-level on error undo, throw.*/

using OpenEdge.CommonInfrastructure.ISecurityManager.
using OpenEdge.CommonInfrastructure.CommonSecurityManager.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.CommonServiceManager.
using OpenEdge.CommonInfrastructure.IUserContext.

using OpenEdge.Core.System.ApplicationError.
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
define variable oOutput as ObjectOutputStream no-undo.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcUserName, 'User Name').
Assert:ArgumentNotNullOrEmpty(pcUserDomain, 'User Domain').
Assert:ArgumentNotNullOrEmpty(pcPassword, 'Password').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(CommonServiceManager:ServiceManagerType), IServiceManager).

oSecMgr = cast(oServiceMgr:StartService(CommonSecurityManager:SecurityManagerType), ISecurityManager).

/* log in and establish tenancy, user context */
oContext = oSecMgr:UserLogin(pcUserName, pcUserDomain, pcPassword).

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

finally:
    set-size(pmUserContext) = 0.
end finally.
/** -- eof -- **/