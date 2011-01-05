/** ------------------------------------------------------------------------
    File        : simple_savedata.p
    Purpose     : 

    Syntax      :

    Description : Standard Service Interface procedure for the save method

    @@author john
    Created     : Tue Jan 27 16:17:52 EST 2009
    Notes       : * The vast bulk of this code is infrastructure - the only 'real'
                    work that this procedure does is the call to ExecuteSyncRequest().
                    The session validation should happen in the activation procedure (will as of 11.0.0);
                    the serialisation is also simply infrastructure.
                  * There are 3 separate loops that could be combined into 1 or 2 for performance reasons.
                    They remain separate here for illustrative purposes.

  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.ServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Lang.ABLSession.
using Progress.Lang.AppError.
using Progress.Lang.Error.
using Progress.Lang.Class.

/* ***************************  Main Block  *************************** */
define input        parameter pmRequest as memptr extent no-undo.
define input-output parameter phResponseDataset as handle extent no-undo.
define output       parameter pmResponse as memptr extent no-undo.
define input-output parameter pmUserContext as memptr no-undo.

define variable oServiceManager as IServiceManager no-undo.
define variable oServiceMessageManager as IServiceMessageManager no-undo.
define variable oSecMgr as ISecurityManager no-undo.
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable mTemp as memptr no-undo.
define variable oOutput as ObjectOutputStream no-undo.
define variable oInput as ObjectInputStream no-undo.
define variable oRequest as ISaveRequest extent no-undo.
define variable cRequestId as character extent no-undo.
define variable oResponse as IServiceResponse extent no-undo.
define variable oContext as IUserContext no-undo.
define variable hDataSet as handle no-undo.

/* Deserialize requests, context */
assign iMax = extent(pmRequest)
       extent(oRequest) = iMax
       extent(cRequestId) = iMax.

oInput = new ObjectInputStream().
do iLoop = 1 to iMax:
    oInput:Reset().
    oInput:Read(pmRequest[iLoop]).
    oRequest[iLoop] = cast(oInput:ReadObjectArray(), ISaveRequest).
end.

oInput:Reset().
oInput:Read(pmUserContext).
oContext = cast(oInput:ReadObjectArray(), IUserContext).

oServiceManager = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:ServiceManagerType),
                        IServiceManager).

/* Are we who we say we are? Note that this should really happen on activate. */
oSecMgr = cast(oServiceManager:StartService(SecurityManager:SecurityManagerType), ISecurityManager).

oContext = oSecMgr:ValidateSession(oContext:ContextId).

oServiceMessageManager = cast(oServiceManager:StartService(ServiceMessageManager:ServiceMessageManagerType), IServiceMessageManager).

/* Perform request. This is where the actual work happens.
   If this was a specialised service interface, we might construct the service request here, rather than
   taking it as an input. */
oResponse = oServiceMessageManager:ExecuteRequest(cast(oRequest, IServiceRequest)).

/* Serialize requests, context */
assign iMax = extent(oResponse)
       extent(pmResponse) = iMax
       extent(phResponseDataset) = iMax.

oOutput = new ObjectOutputStream().

do iLoop = 1 to iMax:
    cast(oResponse[iLoop], IServiceMessage):GetMessageData(output hDataSet). 
    phResponseDataset[iLoop] = hDataSet. 
    
    oOutput:Reset().
    oOutput:WriteObjectArray(oResponse[iLoop]).
    oOutput:Write(output mTemp).
    pmResponse[iLoop] = mTemp.
    /* no leaks! */
    set-size(mTemp) = 0.
end.

oOutput:Reset().
oOutput:WriteObjectArray(oContext).
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
    do iLoop = 1 to iMax:
        set-size(pmResponse[iLoop]) = 0.
    end.
    set-size(pmUserContext) = 0.
end finally.
/** -- eof -- **/