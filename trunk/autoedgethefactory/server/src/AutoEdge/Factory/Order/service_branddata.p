/*------------------------------------------------------------------------
    File        : AutoEdge/Factory/Build/service_branddata.p
    Purpose     : 

    Syntax      :

    Description : Vehicle and dealer info for a give brand

    Author(s)   : pjudge
    Created     : Wed Jul 28 16:50:34 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.CommonServiceManager.
using OpenEdge.CommonInfrastructure.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.CommonServiceMessageManager.
using OpenEdge.CommonInfrastructure.ISecurityManager.
using OpenEdge.CommonInfrastructure.CommonSecurityManager.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.IQueryDefinition.

using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- params, defs -- **/
define input  parameter pcBrand as character no-undo.

define output parameter pcDealerNameList as longchar no-undo.
define output parameter pcCompactModels as longchar no-undo.
define output parameter pcTruckModels as longchar no-undo.
define output parameter pcSuvModels as longchar no-undo.
define output parameter pcPremiumModels as longchar no-undo.
define output parameter pcSedanModels as longchar no-undo.
define output parameter pcInteriorTrimMaterial as longchar no-undo.
define output parameter pcInteriorTrimColour as longchar no-undo.
define output parameter pcInteriorAccessories as longchar no-undo.
define output parameter pcExteriorColour as longchar no-undo.
define output parameter pcMoonroof as longchar no-undo.
define output parameter pcWheels as longchar no-undo.

/** **/
define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oServiceMessageManager as IServiceMessageManager no-undo.
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable mTemp as memptr no-undo.
define variable oRequest as IFetchRequest extent 1 no-undo.
define variable oResponse as IServiceResponse extent no-undo.
define variable hDataSet as handle no-undo.
define variable cUserName as character no-undo.
define variable cUserDomain as character no-undo.
define variable cUserPassword as character no-undo.

/** -- functions -- **/
function BuildFetchRequest returns IFetchRequest ():
    
    define variable oFetchRequest as IFetchRequest no-undo.
    define variable oTableContext as ITableContext no-undo.
    define variable oTableRequest as ITableRequest no-undo.
    define variable iMax as integer no-undo.
    define variable iLoop as integer no-undo. 
    define variable cTableName as character no-undo.
    
    oFetchRequest = new FetchRequest('VehicleOptions').
    
    cTableName = 'eVehicle'.
    oTableRequest = new TableRequest(cTableName).
    oFetchRequest:TableRequests:Put(cTableName, oTableRequest).

    cTableName = 'eItem'.
    oTableRequest = new TableRequest(cTableName).
    oFetchRequest:TableRequests:Put(cTableName, oTableRequest).
    
    cTableName = 'eItemOption'.
    oTableRequest = new TableRequest(cTableName).
    oFetchRequest:TableRequests:Put(cTableName, oTableRequest).

    return oFetchRequest.
end function.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcBrand, 'Brand').

oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(CommonServiceManager:ServiceManagerType), IServiceManager).
oSecMgr = cast(oServiceMgr:StartService(CommonSecurityManager:SecurityManagerType), ISecurityManager).

/* log in and establish tenancy, user context */
assign cUserName = 'guest'
       cUserDomain = 'guest.' + pcBrand
       cUserPassword = encode(cUserName).
       
oSecMgr:UserLogin(cUserName, cUserDomain, cUserPassword).
oSecMgr:AuthenticateServiceAction('VehicleOptions', ServiceMessageActionEnum:FetchData).

oServiceMessageManager = cast(oServiceMgr:StartService(CommonServiceMessageManager:ServiceMessageManagerType)
                        , IServiceMessageManager).

/* Perform request. This is where the actual work happens. */
oRequest[1] = BuildFetchRequest().
oResponse = oServiceMessageManager:ExecuteRequest(cast(oRequest, IServiceRequest)).                         

/* Serialize requests, context */
iMax = extent(oResponse).

do iLoop = 1 to iMax:
    cast(oResponse[iLoop], IServiceMessage):GetMessageData(output hDataSet). 
end.

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


/* ***************************  Main Block  *************************** 
define variable oBrandData as VehicleBrandData no-undo.

oBrandData = new VehicleBrandData(pcBrand).
assign pcDealerNameList = oBrandData:DealerNames
       pcCompactModels  = oBrandData:CompactModels
       pcTruckModels = oBrandData:TruckModels
       pcSuvModels  = oBrandData:SuvModels
       pcPremiumModels  = oBrandData:PremiumModels
       pcSedanModels = oBrandData:SedanModels
       
       pcInteriorTrimMaterial = oBrandData:InteriorTrimMaterial
       pcInteriorTrimColour = oBrandData:InteriorTrimColour
       pcInteriorAccessories = oBrandData:InteriorAccessories
       pcExteriorColour = oBrandData:ExteriorColour
       pcMoonroof = oBrandData:Moonroof
       pcWheels = oBrandData:Wheels.
       
return.
**/
/** EOF **/