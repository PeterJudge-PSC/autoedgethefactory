/*------------------------------------------------------------------------
    File        : IDatasetFetchRequest
    Purpose     : Interface for dataset fetch request  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Feb 09 14:28:13 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
 
interface OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetFetchRequest /* inherits IFetchRequest*/:
    
    /* handle of the dataset - can be unknown on first request */
    define property Handle as handle no-undo get. set.
    
end interface.