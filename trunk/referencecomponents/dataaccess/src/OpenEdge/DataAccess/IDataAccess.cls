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
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.

interface OpenEdge.DataAccess.IDataAccess:
    /** Data retrieval method. This is simply a call to fetch. The response
        is retreived via the GetData() method.
        
        @param IFetchRequest The fetch request service message which defines
        parameters for the request.         */
    method public void FetchData(input poRequest as IFetchRequest).
    
    /** The response to a data retrieval request made in FetchData.
        
        @return IFetchResponse */
    method public IFetchResponse GetData().
    
    /** A call to save data in the data source. 
        
        @param ISaveRequest The request message
        @return ISaveResponse The response message  */
    method public ISaveResponse SaveData(input poRequest as ISaveRequest).
    
end interface.