/*------------------------------------------------------------------------
    File        : IDatasetSaveRequest
    Purpose     : Interface for dataset save request  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Feb 09 03:28:13 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

interface OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetSaveRequest /* inherits ISaveRequest */:  
     /* handle of the dataset, typically created with extract-changes from the client dataset */
     define property Handle as handle no-undo get. set.
end interface.