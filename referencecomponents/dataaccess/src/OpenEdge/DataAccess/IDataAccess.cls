/** ------------------------------------------------------------------------
    File        : IDataAccess
    Purpose     : 
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
    
    method public void FetchData(input poRequest as IFetchRequest).
    
    method public IFetchResponse GetData().
    
    method public ISaveResponse SaveData(input poRequest as ISaveRequest).
    
end interface.