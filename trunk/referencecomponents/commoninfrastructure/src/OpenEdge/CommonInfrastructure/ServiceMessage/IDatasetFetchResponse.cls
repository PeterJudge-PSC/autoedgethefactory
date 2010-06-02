/*------------------------------------------------------------------------
    File        : IDatasetFetchResponse
    Purpose     : Interface for response for dataset fetch request  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Feb 09 14:28:13 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

interface OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetFetchResponse /* inherits IFetchResponse */:  
    /* handle of the dataset  */
    define property Handle as handle no-undo get. set.
end interface.