/*------------------------------------------------------------------------
    File        : IBusinessEntity
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Wed Feb 10 01:08:16 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.

interface OpenEdge.BusinessComponent.Entity.IBusinessEntity: 
     define property DatasetHandle as handle no-undo get.
       
     method public void FetchData(poRequest as IFetchRequest).   
     method public IFetchResponse GetData().
     method public ISaveResponse SaveData(poChanges as ISaveRequest).
end interface.