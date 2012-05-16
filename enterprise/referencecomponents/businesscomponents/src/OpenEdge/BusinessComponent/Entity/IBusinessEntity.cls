/** ------------------------------------------------------------------------
    File        : IBusinessEntity
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Feb 10 01:08:16 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveResponse.

interface OpenEdge.BusinessComponent.Entity.IBusinessEntity:
    
    /** The DataAccess object for this entity.
        The SetDataAccess method is a workaround for the lack of dynamic
        property invocation in the ABL.     */
    define public property DataAccess as IDataAccess no-undo get. set.
    method public void SetDataAccess (input poDataAccess as IDataAccess).
    
    /** Retrieve data according to the request
        
        @param IFetchRequest parameter for the request (query, batch/page, etc) */
    method public void FetchData(input poRequest as IFetchRequest).   
    
    /** Response complement method for FetchData above.
        
        @param character The message id for the request/response
        @return IFetchResponse */
    method public IFetchResponse GetData(input pcMessageId as longchar).
    
    /** Default data fetch retrieval. 
        
        @return IFetchResponse A message containing the fetched data. */
    method public IFetchResponse FetchData().
    
    /** Commit the data to the DataSource(s) through the DataAccess object.
        
        @param ISaveRequest The Save request parameter object for this request.
        @return ISaveReponse A save request parameter object. */
    method public ISaveResponse SaveData(input poChanges as ISaveRequest).
    /** Saves all (changed) data in the Entity.
        
        @return ISaveReponse A save request parameter object. */
    method public ISaveResponse SaveData().
    
    /** Defines the entity in terms of the schema that the underlying prodataset or
        temp-tables will have. This may be useful for example for binding UI before any data
        is requested.
        
        @return IFetchResponse The response containing the schema */
    method public IFetchResponse FetchSchema().
    
    /** Defines the entity in terms of the schema that the underlying prodataset or
        temp-tables will have. This is useful for example for binding UI before any data
        is requested.
        
        @param IFetchRequest The request containing the individual tablerequests 
        @return IFetchResponse The response containing the schema */
    method public IFetchResponse FetchSchema(input poDefineRequest as IFetchRequest).
    
end interface.