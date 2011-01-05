/*------------------------------------------------------------------------
    File        : service_captureorder.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Mon Aug 02 09:37:10 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using AutoEdge.Factory.Build.BusinessComponents.VehicleBrandData.

define input parameter pcOrderId as character no-undo.
define input parameter plOrderApproved as logical no-undo.
define input parameter pcCustomerName as character no-undo.
define input parameter pcCustomerEmail as character no-undo.
define input parameter pcBrand as character no-undo.
define input parameter pcDealer as longchar no-undo.
define input parameter pcModel as longchar no-undo.
define input parameter pcInteriorTrimMaterial as longchar no-undo.
define input parameter pcInteriorTrimColour as longchar no-undo.
define input parameter pcInteriorAccessories as longchar no-undo.
define input parameter pcExteriorColour as longchar no-undo.
define input parameter pcMoonroof as longchar no-undo.
define input parameter pcWheels as longchar no-undo.

define output parameter pdOrderAmount as decimal no-undo.

/***

define variable oServiceMessageManager as IServiceMessageManager no-undo.
define variable oServiceMgr as IServiceManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable oRequest as IFetchRequest extent 1 no-undo.
define variable oResponse as IFetchResponse extent 1 no-undo.
define variable oContext as IUserContext no-undo.

/** -- validate defs -- **/
Assert:ArgumentNotNullOrEmpty(pcContextId, 'User Context Id').

/** -- main -- **/
oServiceMgr = cast(ABLSession:Instance:SessionProperties:Get(Service:ServiceManagerType)
               , IServiceManager).

/* Are we who we say we are? Note that this should really happen on activate. activate doesn't run for state-free AppServers */
oSecMgr = cast(oServiceMgr:StartService(SecurityManager:SecurityManagerType)
               ,ISecurityManager).

oContext = oSecMgr:ValidateSession(pcContextId).
/* add parameter values to the user context */ 

oServiceMessageManager = cast(oServiceMgr:StartService(ServiceMessageManager:ServiceMessageManagerType)
                        , IServiceMessageManager).

/* Create the WorkStepRequest */
oRequest[1] = new FetchRequest('Order').

/* Perform request. This is where the actual work happens. */
oResponse = cast(oServiceMessageManager:ExecuteRequest(cast(oRequest, IServiceRequest)), IFetchResponse).
if cast(oResponse[1], IServiceResponse):HasError then
    return error string(cast(oResponse[1], IServiceResponse):ErrorText).

cast(oResponse[1], IServiceMessage):GetMessageData(output phOrders).

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

***/
/* ***************************  Definitions  ************************** */
define temp-table ttOrder no-undo
    field OrderId as character
    field OrderApproved as logical initial no
    field VehicleOnHand as logical initial no
    field CustomerName as character
    field CustomerEmail as character
    field Brand as character
    field DealerId as character
    field Model as character
    field InteriorTrimMaterial as character
    field InteriorTrimColour as character
    field InteriorAccessories as character
    field ExteriorColour as character
    field Moonroof as character
    field Wheels as character
    .


/* ***************************  Functions  *************************** */
function GetSelectedOption returns character (input pcOptions as longchar):
    define variable cSelectedOption as character no-undo.
    define variable hTable as handle no-undo.
    define variable hQuery as handle no-undo.
    define variable hBuffer as handle no-undo.
    
    if pcOptions eq '' or pcOptions eq ? then
        return ''. 
        
    /* ABL needs to know the/some/any tt name before read-json() works */
    if substring(left-trim(pcOptions), 1, 1) eq '[' then
        pcOptions = '~{' + quoter("ttOptions")  + ':' + pcOptions + '~}'.                
    
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

/* ***************************  Main Block  *************************** */
define variable cJSON as longchar no-undo.

pcOrderId = entry(num-entries(pcOrderId, '#'), pcOrderId,'#').
if pcOrderId eq ? then
    pcOrderId = 'null'.

if pcCustomerName eq '' or pcCustomerName eq ? then
    pcCustomerName = pcCustomerEmail.

create ttOrder.
assign ttOrder.OrderId = pcOrderId
       ttOrder.OrderApproved = plOrderApproved 
       ttOrder.CustomerName = pcCustomerName
       ttOrder.CustomerEmail = pcCustomerEmail
       ttOrder.Brand = pcBrand
       ttOrder.DealerId = pcDealer
       ttOrder.Model = pcModel
       ttOrder.InteriorTrimColour = GetSelectedOption(pcInteriorTrimColour)
       ttOrder.InteriorTrimMaterial = GetSelectedOption(pcInteriorTrimMaterial)
       ttOrder.InteriorAccessories = GetSelectedOption(pcInteriorAccessories)
       ttOrder.ExteriorColour = GetSelectedOption(pcExteriorColour)
       ttOrder.Moonroof = GetSelectedOption(pcMoonroof)
       ttOrder.Wheels = GetSelectedOption(pcWheels)
       .

buffer ttOrder:write-xml('file', 'data/customerorder_' +  pcOrderId + '.xml', yes, ?).
buffer ttOrder:write-json('longchar', cJSON).
copy-lob cJSON to file 'data/customerorder_' + pcOrderId + '.json'.

pdOrderAmount = VehicleBrandData:PriceVehicle(cJSON).

return.

catch oError as Progress.Lang.Error:
    message oError:GetMessage(1).
    return error oError:GetMessage(1).
end catch.
/** EOF **/