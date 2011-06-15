/** ------------------------------------------------------------------------
    File        : IFetchRequest
    Purpose     : Interface for data fetch request  
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Tue Feb 09 14:28:13 EST 2010
    Notes       : 
  --------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableRequestCollection.

interface OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchRequest /* inherits IServiceRequest */:
    
    /** (mandatory) A collection of one of more tables for this request. */
    define public property TableRequests as ITableRequestCollection no-undo get.
    
end interface.