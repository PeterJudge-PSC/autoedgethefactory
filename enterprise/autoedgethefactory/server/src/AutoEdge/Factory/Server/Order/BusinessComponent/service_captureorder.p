@openapi.openedge.export FILE(type="BPM", operationName="%FILENAME%", useReturnValue="false", writeDataSetBeforeImage="false", executionMode="external").
/*------------------------------------------------------------------------
    File        : AutoEdge/Factory/Order/BusinessComponent/service_captureorder.p
    Purpose     :

    Syntax      :

    Description :

    Author(s)   : pjudge
    Created     : Mon Aug 02 09:37:10 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using AutoEdge.Factory.Server.Order.BusinessComponent.IOrderEntity.    

using AutoEdge.Factory.Common.CommonInfrastructure.UserTypeEnum.

using OpenEdge.CommonInfrastructure.Server.ISecurityManager.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.

using OpenEdge.Lang.ABLSession.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

/** -- params, variables -- **/
define input parameter piOrderNumber as integer no-undo.
define input parameter pcBrand as character no-undo.

define input parameter pcDealerCode as longchar no-undo.
define input parameter pcCustomerId as longchar no-undo.
define input parameter plOrderApproved as logical no-undo.
define input parameter pcInstructions as longchar no-undo.
define input parameter pcModel as longchar no-undo.
define input parameter pcInteriorTrimMaterial as longchar no-undo.
define input parameter pcInteriorTrimColour as longchar no-undo.
define input parameter pcInteriorAccessories as longchar no-undo.
define input parameter pcExteriorColour as longchar no-undo.
define input parameter pcMoonroof as longchar no-undo.
define input parameter pcWheels as longchar no-undo.

define output parameter pcOrderId as character no-undo.
define output parameter pdOrderAmount as decimal no-undo.

define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oOrderEntity as IOrderEntity no-undo.
define variable cInteriorAccessories as character extent no-undo.
define variable cSalesRepCode as character no-undo.
define variable iMax as integer no-undo.
define variable iLoop as integer no-undo.

/* ***************************  Functions  *************************** */
function GetSelectedOption returns character (input pcOptions as longchar):
    define variable cSelectedOption as character no-undo.
    define variable hTable as handle no-undo.
    define variable hQuery as handle no-undo.
    define variable hBuffer as handle no-undo.

    /* ABL needs to know the/some/any tt name before read-json() works */
    if substring(left-trim(pcOptions), 1, 1) eq '[' then
        pcOptions = '~{' + quoter("ttOptions")  + ':' + pcOptions + '~}'.
    else
        /* this is not JSON-formatted text */
        return ''.

    create temp-table hTable.
    hTable:read-json('longchar', pcOptions).
    hBuffer = hTable:default-buffer-handle.

    create query hQuery.
    hQuery:set-buffers(hBuffer).
    hQuery:query-prepare('for each ' + hBuffer:name + ' where selected = true ').
    hQuery:query-open().

    hQuery:get-first().
    do while hbuffer:available:
        cSelectedOption = cSelectedOption
                        + ',' + hBuffer:buffer-field('value'):buffer-value.
        hQuery:get-next().
    end.

    return left-trim(cSelectedOption, ',').

    finally:
        if valid-handle(hQuery) then
            hQuery:query-close().
        delete object hQuery no-error.
        delete object hBuffer no-error.
        delete object hTable no-error.
    end finally.
end function.

/** -- main block -- **/
/** Dummy return for modelling purposes (Savvion lets us make a test call to a WebService). */
if pcCustomerId eq 'Savvion::Test' then
do:
    assign pcOrderId = 'pcOrderId'
           pdOrderAmount = -1.
    return.
end.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcBrand, 'Brand').
Assert:ArgumentNotZero(piOrderNumber, 'Order Number').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType)
               , IServiceManager).

/* Are we who we say we are? Note that this should really happen on activate. activate doesn't run for state-free AppServers */
oSecMgr = cast(oServiceMgr:GetService(SecurityManager:ISecurityManagerType), ISecurityManager).

oSecMgr:UserLogin('admin',
                  substitute('&1.&2', UserTypeEnum:System:ToString(), pcBrand),
                  'letmein').

oSecMgr:AuthoriseServiceAction('CaptureOrder', ServiceMessageActionEnum:SaveData).

oServiceMessageManager = cast(oServiceMgr:GetService(ServiceMessageManager:IServiceMessageManagerType), IServiceMessageManager).
oOrderEntity = cast(oServiceMgr:GetService(Class:GetClass('AutoEdge.Factory.Server.Order.BusinessComponent.IOrderEntity')), IOrderEntity).

pcInteriorAccessories = trim(trim(pcInteriorAccessories, '['), ']').
iMax = num-entries(pcInteriorAccessories).
extent(cInteriorAccessories) = iMax.
do iLoop = 1 to iMax:
    cInteriorAccessories[iLoop] = trim(entry(iLoop, pcInteriorAccessories)).
end.

pcOrderId = oOrderEntity:CreateOrder(piOrderNumber,
                                     string(pcDealerCode),
                                     cSalesRepCode,
                                     int(pcCustomerId),
                                     plOrderApproved,
                                     pcInstructions,
                                     GetSelectedOption(pcModel), /* ModelId */
                                     string(pcInteriorTrimMaterial),
                                     string(pcInteriorTrimColour),
                                     cInteriorAccessories,
                                     string(pcExteriorColour),
                                     string(pcWheels),
                                     string(pcMoonroof)).                                         

pdOrderAmount = oOrderEntity:GetOrderAmount(piOrderNumber).

FetchSchema(output dataset-handle mhOrderDataset).

CreateEntityData(mhOrderDataset).

SaveData(BuildSaveRequest()).

/* Now get the amount of the newly-created order */
FetchData(output dataset-handle mhOrderDataset).

mhOrderBuffer = mhOrderDataset:get-buffer-handle('eOrder').

mhOrderBuffer:find-first().
pdOrderAmount = mhOrderBuffer::OrderAmount.
oSecMgr:UserLogout(oSecMgr:CurrentUserContext).
error-status:error = no.
return.

/** -- error handling -- **/
{OpenEdge/CommonInfrastructure/Server/service_returnerror.i
    &THROW-ERROR=true  }
/** -- eof -- **/