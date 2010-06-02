 /*------------------------------------------------------------------------
    File        : BusinessEntity
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Aug 14 23:38:08 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.DataAccess.IDataAccess.

routine-level on error undo, throw.

class OpenEdge.BusinessComponent.Entity.BusinessEntity implements IBusinessEntity /* ?, IComponent*/ : 
    
    define public property DatasetHandle as handle no-undo 
        get():
            if not valid-handle(DatasetHandle) then
                CopyStaticDataset (output dataset-handle DatasetHandle).
            return DatasetHandle.   
        end.
        private set. /* constructor */
    
    define protected property StaticDatasetHandle as handle no-undo 
        get.
        protected set.
    
    define protected property DataAccess as IDataAccess no-undo 
        get.
        protected set.
    
    /* The current assumption is that the ServiceManager starts both this and the DAO */
    constructor public BusinessEntity(dsHandle as handle, poDAO as IDataAccess ):
        super ().   
        assign
            StaticDatasetHandle = dsHandle
            DataAccess = poDAO.        
    end constructor.

    method public void Create():            
    end method.
            
    method public void FetchData(poRequest as IFetchRequest):
  
        /* We assume new data 
           appending requests would possibly need direction to MERGE or APPEND in fill */
       /*        DatasetHandle:empty-dataset () .*/
        cast(poRequest, IDatasetFetchRequest):Handle = DatasetHandle.
        DataAccess:FetchData(poRequest).
    end method.

    method public IFetchResponse GetData():
        return DataAccess:GetData().
    end method.

    method public ISaveResponse SaveData(poChanges as ISaveRequest):
        return DataAccess:SaveData(poChanges).
    end method.
    
    method private handle CopyStaticDataset (output dataset-handle h):
        h = StaticDatasetHandle.
    end.    
    
end class.