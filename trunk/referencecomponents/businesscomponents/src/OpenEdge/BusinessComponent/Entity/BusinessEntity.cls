/** ------------------------------------------------------------------------
    File        : BusinessEntity
    Purpose     : General Business entity class. The Business Entity is the primary
                  unit of business logic and data in the OERA.
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Fri Aug 14 23:38:08 EDT 2009
    Notes       : * This class is abstract class since the Business Entity's 
                    data store could be a prodataset, temp-table or some other 
                    construct.
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.BusinessComponent.Entity.BusinessEntity.
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.

using OpenEdge.CommonInfrastructure.Service.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.IComponentInfo.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.BusinessComponent.Entity.BusinessEntity abstract inherits Service 
        implements IBusinessEntity:
    
    define static public property IBusinessEntityType as class Class no-undo get. private set.            
    
    define public property DataAccess as IDataAccess no-undo get. set.
    method public void SetDataAccess (input poDataAccess as IDataAccess):
        DataAccess = poDataAccess.
    end method.
    
    constructor static BusinessEntity():        
        BusinessEntity:IBusinessEntityType = Class:GetClass('OpenEdge.BusinessComponent.Entity.IBusinessEntity').
    end constructor.
    
    constructor public BusinessEntity(input poServiceManager as IServiceManager,
                                      input poComponentInfo as IComponentInfo,
                                      input poDAO as IDataAccess):
        this-object(poServiceManager, poComponentInfo).
        
        Assert:ArgumentNotNull(poDAO, 'Data Access Object').
        DataAccess = poDAO.
    end constructor.
    
    constructor public BusinessEntity(input poServiceManager as IServiceManager,
                                      input poComponentInfo as IComponentInfo):
        super(input poServiceManager, input poComponentInfo).
    end constructor.
    
    method public void FetchData(poRequest as IFetchRequest):
        DataAccess:FetchData(poRequest).
    end method.
    
    /** Response complement method for FetchData above.
        
        @param character The message id for the request/response
        @return IFetchResponse */
    method public IFetchResponse GetData(input pcMessageId as longchar):
        return DataAccess:GetData(pcMessageId).
    end method.
    
    method public ISaveResponse SaveData(poChanges as ISaveRequest):
        return DataAccess:SaveData(poChanges).
    end method.
    
    /* Abstract since we don't know the data store (temp-table, prodataset, etc). */
    method abstract public IFetchResponse FetchSchema(input poDefineRequest as IFetchRequest).
    
end class.