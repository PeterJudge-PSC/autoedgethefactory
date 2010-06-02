/*------------------------------------------------------------------------
    File        : IServiceAdapter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Feb 20 02:54:06 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using Progress.Lang.Class.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter:
    define public property ServiceManager as IServiceManager no-undo get.
    
    /** The service for which this service adapter is servicing a request. */
    define public property Service as character no-undo get. set.
    /**  For external injection */ 
    method public void SetService (pcService as character).
    
    method public void Fetch(poRequest as IFetchRequest extent).
    method public void Save(poRequest as ISaveRequest extent).
    method public void Define(poRequest as IDefineRequest extent).
    
end interface.
