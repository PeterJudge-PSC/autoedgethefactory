/*------------------------------------------------------------------------
    File        : IFetchRequest
    Purpose     : Interface for data fetch request  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Feb 09 14:28:13 EST 2010
    Notes       : * Corresponds with OpenEdge.Core.System.ServiceMessageActionEnum:Fetch
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequestCollection.
 
interface OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest /* inherits IServiceMessage */:
    define public property TableRequests as ITableRequestCollection no-undo get.
    
    method public ITableRequest GetTableRequest(pcTableName as character).
    
end interface.