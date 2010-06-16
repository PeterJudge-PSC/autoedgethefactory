/** ------------------------------------------------------------------------
    File        : simple_getdefinition.p
    Purpose     :  
    
    Syntax      :
        
    Description : Standard Service Interface procedure for the fetchdata method
    
    @author pjudge
    Created     : Tue Jan 27 16:17:52 EST 2009
    Notes       : * The vast bulk of this code is infrastructure - the only 'real'
                    work that this procedure does is the call to ServiceMessageManager:ExecuteSyncRequest().
                    The session validation should happen in the activation procedure (will as of 11.0.0);
                    the serialisation is also simply infrastructure.
                  * There are 3 separate loops that could be combined into 1 or 2 for performance reasons.
                    They remain separate here for illustrative purposes.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.

using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.

/* ***************************  Main Block  *************************** */
define input        parameter pmRequest as memptr extent no-undo.
define output       parameter phResponseDataset as handle extent no-undo.
define output       parameter pmResponse as memptr extent no-undo.
define input-output parameter pmUserContext as memptr no-undo.

define variable oInjectABLKernel as IKernel no-undo.
define variable oServiceMessageManager as IServiceMessageManager no-undo.
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable mTemp as memptr no-undo.
define variable oOutput as ObjectOutputStream no-undo.
define variable oInput as ObjectInputStream no-undo.
define variable oRequest as IDefineRequest extent no-undo.
define variable cRequestId as character extent no-undo.
define variable oResponse as IDefineResponse extent no-undo.
define variable oContext as IUserContext no-undo.

/* Deserialize requests, context */
assign iMax = extent(pmRequest)
       extent(oRequest) = iMax
       extent(cRequestId) = iMax.

oInput = new ObjectInputStream().
do iLoop = 1 to iMax:
    oInput:Reset().
    oInput:Read(pmRequest[iLoop]).
    oRequest[iLoop] = cast(oInput:ReadObjectArray(), IDefineRequest).
end.

oInput:Reset().
oInput:Read(pmUserContext).
oContext = cast(oInput:ReadObjectArray(), IUserContext).

oInjectABLKernel = cast(ABLSession:Instance:SessionProperties:Get(Class:GetClass('OpenEdge.Core.InjectABL.IKernel')),
                        IKernel).

/* Are we who we say we are? Note that this should really happen on activate. */
cast(oInjectABLKernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager'))
                        ,ISecurityManager):ValidateSession(oContext:ClientSessionId).

/* Perform request. This is where the actual work happens. */
oServiceMessageManager = cast(oInjectABLKernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceMessageManager'))
                        , IServiceMessageManager).

/* Perform request. This is where the actual work happens. */
oResponse = cast(oServiceMessageManager:ExecuteSyncRequest(cast(oRequest, IServiceRequest)), IDefineResponse).                         

/* Serialize requests, context */
assign iMax = extent(oResponse)
       extent(pmResponse) = iMax
       extent(phResponseDataset) = iMax.

oOutput = new ObjectOutputStream().

do iLoop = 1 to iMax:
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
/* EOF */