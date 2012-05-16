/** ------------------------------------------------------------------------
    File        : IFetchResponse
    Purpose     : Interface for response for fetch request  
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Tue Feb 09 14:28:13 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableResponseCollection.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableRequestCollection.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.

interface OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchResponse inherits IServiceResponse:
    
    /** A collection of individual table responses for this larger request */
    define public property TableResponses as ITableResponseCollection no-undo get.
    
    /** Pre-populates the table response collection from the request's tablerequests */
    method public void InitTableResponseFromRequest(input poRequestCollection as ITableRequestCollection).
    
end interface.