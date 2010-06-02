/*------------------------------------------------------------------------
    File        : IDatasetSaveResponse
    Purpose     : Interface for dataset save response message 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Feb 09 03:32:11 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

interface OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetSaveResponse:  /* inherits ISaveResponse */
    /* handle of the dataset, typically created with extract-changes on client and refreshed 
       after save on server. The dataset may contain errors  */
     define property Handle as handle no-undo get. set.
end interface.  
