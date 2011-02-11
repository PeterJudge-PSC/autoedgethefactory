/** ----------------------------------------------------------------------
    File        : AutoEdge/Factory/Common/CommonInfrastructure/service_customerlogin.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Dec 16 09:17:18 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.String.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- params, defs -- **/
define input  parameter pcBrand as character no-undo.
define input  parameter pcUserName as character no-undo.
/* plain-text. ugh. */
define input  parameter pcPassword as character no-undo.

define output parameter pcUserContextId as longchar no-undo.
define output parameter pcCustomerId as longchar no-undo.
define output parameter pcCustomerEmail as longchar no-undo.
define output parameter pdCreditLimit as decimal no-undo.

define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oContext as IUserContext no-undo.
define variable cUserDomain as character no-undo.

/** Dummy return for modelling purposes (Savvion lets us make a test call to a WebService). */
if pcUserName eq 'Savvion::Test' then
do:
    assign pcUserContextId = 'pcUserContextId'
           pcCustomerId = 'pcCustomerId '
           pcCustomerEmail = 'pcCustomerEmail '
           pdCreditLimit = -1.
    return.
end.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcUserName, 'User Name').
Assert:ArgumentNotNullOrEmpty(pcBrand, 'Brand').
Assert:ArgumentNotNullOrEmpty(pcPassword, 'User Password').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).

oSecMgr = cast(oServiceMgr:StartService(SecurityManager:ISecurityManagerType), ISecurityManager).

/* log in and establish tenancy, user context */
cUserDomain = 'customer.' + pcBrand.
oContext = oSecMgr:UserLogin(pcUserName,
                             cUserDomain,
                             encode(pcPassword)).
Assert:ArgumentNotNull(oContext, 'User Context').

assign pcUserContextId = oContext:ContextId
       pcCustomerEmail = cast(oContext:UserProperties:Get(new String('PrimaryEmailAddress')), String):Value
       pcCustomerId = cast(oContext:UserProperties:Get(new String('CustomerId')), String):Value
       pdCreditLimit = decimal(cast(oContext:UserProperties:Get(new String('CreditLimit')), String):Value)
       .
       
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