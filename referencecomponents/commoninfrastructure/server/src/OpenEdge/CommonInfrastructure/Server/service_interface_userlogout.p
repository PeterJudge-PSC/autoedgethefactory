/** ------------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/service_interface_userlogout.p
    Purpose     : 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Fri Jan 14 13:04:44 EST 2011
    Notes       :
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- params, defs -- **/
define input-output parameter pmUserContext as memptr no-undo.

define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oInput as IObjectInput no-undo.
define variable oOutput as IObjectOutput no-undo.
define variable oContext as IUserContext no-undo.

/** -- main -- **/
oInput = new ObjectInputStream().
oInput:Read(pmUserContext).
oContext = cast(oInput:ReadObject(), IUserContext).

Assert:ArgumentNotNull(oContext, 'User Context').

oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).
oSecMgr = cast(oServiceMgr:StartService(SecurityManager:ISecurityManagerType), ISecurityManager).

/* log out and establish tenancy, user context */
oSecMgr:UserLogout(oContext).

/* The logout may have added a payload so we need to pass that back */
oContext = oSecMgr:GetPendingContext().

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