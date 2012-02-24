/** ------------------------------------------------------------------------
    File        : IDataAccess
    Purpose     : Interface for data access objects. Does not specify the 
                  format in which the data is stored.
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Feb 10 01:08:16 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.DataSource.IDataSource.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveResponse.

using OpenEdge.Lang.Collections.IMap.

interface OpenEdge.DataAccess.IDataAccess:
    
    /** A map of the IDataSource objects that this DataAccess objects knows about. */
    define public property DataSources as IMap no-undo get.
    
    /** Helper method for adding DataSource objects from InjectABL
        
        @param character The name of the datasource
        @param IDataSource The datasource object.   */
    method public void AddDataSource(input pcName as character, input poDataSource as IDataSource).
    
    /** Data retrieval method. This is simply a call to fetch. The response
        is retreived via the GetData() method.
        
        @param IFetchRequest The fetch request service message which defines
        parameters for the request.         */
    method public void FetchData(input poRequest as IFetchRequest).

    /** The response to a data retrieval request made in FetchData.
        @param character The message id for the request/response
        @return IFetchResponse */
    method public IFetchResponse GetData(input pcMessageId as longchar).
    
    /** A call to save data in the data source. 
        
        @param ISaveRequest The request message
        @return ISaveResponse The response message  */
    method public ISaveResponse SaveData(input poRequest as ISaveRequest).
    
end interface.