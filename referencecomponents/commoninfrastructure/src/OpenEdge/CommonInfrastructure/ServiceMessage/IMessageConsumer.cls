/*------------------------------------------------------------------------
    File        : IMessageConsumer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 14:55:42 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer:
    
    method public void ActionCompleted(poResponse as IServiceMessage).
    
    /*
    method public void Defined(poResponse as IDefineResponse).
    method public void Fetched(poResponse as IFetchResponse).
    method public void Saved(poResponse as ISaveResponse).
    */
    
end interface.