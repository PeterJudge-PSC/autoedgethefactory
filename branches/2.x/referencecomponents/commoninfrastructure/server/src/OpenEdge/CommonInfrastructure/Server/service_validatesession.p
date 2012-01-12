/** ------------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/service_validatesession.p
    Purpose     : 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Fri Jan 14 13:04:44 EST 2011
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Server.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

using OpenEdge.Core.System.UnhandledError.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IObjectOutput.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- params, defs -- **/
define input  parameter pcContextId as longchar no-undo.

define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.

/** -- main -- **/
Assert:ArgumentNotNullOrEmpty(pcContextId, 'User Context ID').

oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).
oSecMgr = cast(oServiceMgr:GetService(SecurityManager:ISecurityManagerType), ISecurityManager).

/* log out and establish tenancy, user context */
oSecMgr:EstablishSession(pcContextId).

error-status:error = no.
return.

/** -- error handling -- **/
catch oApplError as ApplicationError:
    return error oApplError:ResolvedMessageText().
end catch.
catch oError as Error:
    define variable oUHError as UnhandledError no-undo.
    oUHError = new UnhandledError(oError).
    return error oUHError:ResolvedMessageText().
end catch.

/** -- eof -- **/