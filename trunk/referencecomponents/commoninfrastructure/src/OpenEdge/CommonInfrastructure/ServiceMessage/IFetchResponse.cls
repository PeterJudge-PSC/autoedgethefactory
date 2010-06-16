/** ------------------------------------------------------------------------
    File        : IFetchResponse
    Purpose     : Interface for response for fetch request  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Feb 09 14:28:13 EST 2010
    Notes       : * Corresponds with OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum:Fetch
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext. 
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContextCollection.
 
interface OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse /* inherits IServiceMessage*/:
    define public property TableResponses as ITableContextCollection no-undo get.
    
    method public ITableContext GetTableContext(input pcTableName as character).
    
end interface.