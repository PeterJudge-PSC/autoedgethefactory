/*------------------------------------------------------------------------
    File        : StandardServiceAdapter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 08:43:10 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineResponse.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.

using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter
        implements IServiceAdapter:
    
    define public property ServiceManager as IServiceManager no-undo get. private set.
   
    define public property Service as character no-undo get. set.
    method public void SetService(pcService as character):
        Service = pcService.
    end method.
    
    constructor public StandardServiceAdapter(poServiceManager as IServiceManager):
        Assert:ArgumentNotNull(poServiceManager, 'Service Manager').
        
        ServiceManager = poServiceManager. 
    end constructor.
    
    method public void ExecuteResponse(poServiceMessage as IServiceMessage extent):
        /* call back to service message manager to process the fetch response */
        cast(ServiceManager:StartService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceMessageManager'))
            , IServiceMessageManager):ExecuteResponse(poServiceMessage).
    end method.
    
    method public void Fetch(poRequest as IFetchRequest extent):
        define variable oResponse as IFetchResponse extent no-undo.
        
        /* These calls are (barely) illustrative. they won't work 
                run SampleApp/OERA/Services/simple_fetchdata.p (pcEntityName,
                                              input-output dataset-handle phDataset,
                                              input-output cContext).
        */
        run do_fetch.p (input poRequest, output oResponse).
        
        define variable mRequest as memptr no-undo.
        define variable mResponse as memptr no-undo.
        define variable hRequestDataset as handle no-undo.
        define variable hResponseDataset as handle no-undo.        
        define variable oOutput as ObjectOutputStream no-undo.
        define variable oInput as ObjectInputStream no-undo.
        
        oOutput = new ObjectOutputStream().
        oOutput:WriteObjectArray(poRequest).
        oOutput:Write(output mRequest).
        
        run OpenEdge/CommonInfrastructure/ServiceMessage/simple_fetchdata.p
                           (input  mRequest,
                            input  hRequestDataset,
                            output hResponseDataset,
                            output mResponse).
        
        oInput = new ObjectInputStream().
        oInput:Read(mResponse).
        oResponse = cast(oInput:ReadObjectArray(), IFetchResponse).
        
        ExecuteResponse(cast(oResponse, IServiceMessage)).
    end method.
    
    method public void Save(poRequest as ISaveRequest extent):
        define variable oResponse as ISaveResponse extent no-undo.
        
        /* These calls are (barely) illustrative. they won't work
                run SampleApp/OERA/Services/simple_savedata.p (pcEntityName,
                                             input-output dataset-handle phDataset,
                                             input-output cContext).
         */
        run do_save.p (input poRequest, output oResponse).
        
        
        
        ExecuteResponse(cast(oResponse, IServiceMessage)).
    end method.
    
    method public void Define(input poRequest as IDefineRequest extent):
        define variable oResponse as IDefineResponse extent no-undo.
        
        /* These calls are (barely) illustrative. they won't work 
        run SampleApp/OERA/Services/simple_getdefinition.p (pcEntityName, output dataset-handle hDataset).
        */
        run do_define.p (input poRequest, output oResponse).
        
        
        ExecuteResponse(cast(oResponse, IServiceMessage)).
    end method.
    
end class.