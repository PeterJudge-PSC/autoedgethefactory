/*------------------------------------------------------------------------
    File        : IMessageRequestor
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 14:55:34 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundle.
  
interface OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor:
    
    method public void RequestCompleted(poBundle as ServiceMessageBundle).
    
end interface.