/** ------------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/service_managed_async_response.p
    Purpose     : (Async) response procedure for ServiceAdapter calls.
    Syntax      :

    Description : 

    @author pjudge
    Created     : Fri Oct 29 15:15:39 EDT 2010
    Notes       :
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.
using OpenEdge.CommonInfrastructure.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.CommonServiceMessageManager.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.CommonServiceManager.
using OpenEdge.CommonInfrastructure.ISecurityManager.
using OpenEdge.CommonInfrastructure.CommonSecurityManager.
using OpenEdge.CommonInfrastructure.IUserContext.
using OpenEdge.CommonInfrastructure.ServiceAdapter.

using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.
 
/* ***************************  Main Block  *************************** */
define variable moServiceManager as IServiceManager no-undo.
define variable moSMM as IServiceMessageManager no-undo.
define variable moSecMgr as ISecurityManager no-undo.

assign moServiceManager = cast(ABLSession:Instance:SessionProperties:Get(CommonServiceManager:ServiceManagerType), IServiceManager)
       moSMM = cast(moServiceManager:GetService(CommonServiceMessageManager:ServiceMessageManagerType), IServiceMessageManager)
       moSecMgr = cast(moServiceManager:GetService(CommonSecurityManager:SecurityManagerType), ISecurityManager).

/* ***************************  Procedures *************************** */
procedure EventProcedure_FetchData:
    define input parameter phResponseDataset as handle extent no-undo.
    define input parameter pmResponse as memptr extent no-undo.
    define input parameter pmUserContext as memptr no-undo.
    
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    define variable mTemp as memptr no-undo.
    define variable oInput as IObjectInput no-undo.    
    define variable oResponse as IFetchResponse extent no-undo.
        
    assign iMax = extent(pmResponse)
           extent(oResponse) = iMax.
    
    do iLoop = 1 to iMax:
        oInput = new ObjectInputStream().
        oInput:Read(pmResponse[iLoop]).
        oResponse[iLoop] = cast(oInput:ReadObject(), IFetchResponse).
        
        cast(oResponse[iLoop], IServiceMessage):SetMessageData(
                phResponseDataset[iLoop],
                DataFormatEnum:ProDataSet).
    end.
    
    /* Set context in to ContextManager from the data received from the server call. */
    moSecMgr:ValidateSession(ServiceAdapter:DeserializeContext(pmUserContext)).
    
    moSMM:ExecuteResponse(cast(oResponse, IServiceResponse)).
    
    /* nothing more for this procedure to do, so we get rid of it. */
    if this-procedure:async-request-count eq 0 then
        delete object this-procedure.
end procedure.

procedure EventProcedure_SaveData:
    define input parameter phRequestDataset as handle extent no-undo.
    define input parameter pmResponse as memptr extent no-undo.
    define input parameter pmUserContext as memptr no-undo.
    
    define variable oResponse as ISaveResponse  extent no-undo.
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    define variable mTemp as memptr no-undo.
    define variable mRequest as memptr extent no-undo.
    define variable oInput as IObjectInput no-undo.
    define variable hDataset as handle no-undo.
    
    assign iMax = extent(pmResponse)
           extent(oResponse) = iMax.
    
    oInput = new ObjectInputStream().
    do iLoop = 1 to iMax:
        oInput:Reset().
        oInput:Read(pmResponse[iLoop]).
        oResponse[iLoop] = cast(oInput:ReadObjectArray(), ISaveResponse).
        
        cast(oResponse[iLoop], IServiceMessage):SetMessageData(
                phRequestDataset[iLoop],
                DataFormatEnum:ProDataSet).
    end.
    
    /* Set context in to ContextManager from the data received from the server call. */
    moSecMgr:ValidateSession(ServiceAdapter:DeserializeContext(pmUserContext)).
    
    moSMM:ExecuteResponse(cast(oResponse, IServiceResponse)).
    
    /* nothing more for this procedure to do, so we get rid of it. */
    if this-procedure:async-request-count eq 0 then
        delete object this-procedure.
end procedure.

/* *** EOF *** */
