/** ------------------------------------------------------------------------
    File        : StandardBusinessEntity
    Purpose     : Standard ProDataSet-based business entity 
    Syntax      : 
    Description : 
    @author pjudge
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.BusinessComponent.Entity.BusinessEntity.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Lang.CallbackNameEnum.

class OpenEdge.BusinessComponent.Entity.StandardBusinessEntity inherits BusinessEntity:
    
    define protected property DatasetHandle as handle no-undo
        get():
            if not valid-handle(this-object:DatasetHandle) then
                CopyStaticDataset(output dataset-handle DatasetHandle).
            
            return DatasetHandle.
        end.
        private set.
    
    define protected property StaticDatasetHandle as handle no-undo 
        get.
        private set.
    
    constructor public StandardBusinessEntity(input poDAO as IDataAccess,
                                              input poServiceManager as IServiceManager,
                                              input poComponentInfo as IComponentInfo):
        this-object(input poDAO, input poServiceManager, input poComponentInfo).
    end constructor.
    
	constructor public StandardBusinessEntity(input poServiceManager as IServiceManager,
	                                          input poComponentInfo as IComponentInfo):
		super(input poServiceManager, input poComponentInfo).
	end constructor.
	
    method override public void FetchData(poRequest as IFetchRequest):
        /* We assume new data 
           appending requests would possibly need direction to MERGE or APPEND in fill */
        /*        DatasetHandle:empty-dataset () .*/
        cast(poRequest, IServiceMessage):SetMessageData(DatasetHandle, DataFormatEnum:ProDataSet).
        
        super:FetchData(poRequest).                        
    end method.
    
    /* Override example */
    method override public ISaveResponse SaveData(input poRequest as ISaveRequest):
        /* Make any pre-save BusinessEntity validation calls here. No need for a generic
          'dataset+PreSave' name, since each BE will add its own overrides. 
          
          The DataAccess and DataSources take care of ProDataSet- and Buffer-level events/
          callbacks if needed. */
        
        super:SaveData(poRequest).
        
        /* make post-save BusinessEntity  validation calls here */
    end method.
    
	method override public IFetchResponse FetchSchema(input poDefineRequest as IFetchRequest):
	    define variable oFetchSchemaResponse as IFetchResponse no-undo.
	    
        oFetchSchemaResponse = new FetchResponse(poDefineRequest).
        cast(oFetchSchemaResponse, IServiceMessage):SetMessageData(DatasetHandle, DataFormatEnum:ProDataSet).
        
        return oFetchSchemaResponse.
	end method.
    
    method private handle CopyStaticDataset (output dataset-handle phDataset):
        phDataset = StaticDatasetHandle.
    end method.
    
end class.