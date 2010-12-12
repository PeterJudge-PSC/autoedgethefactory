/*------------------------------------------------------------------------
    File        : ISecurityManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 18 11:53:52 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.IUserContext.
  
interface OpenEdge.CommonInfrastructure.Common.ISecurityManager:
    
    method public void ValidateSession(input pcSessionId as longchar).
    
    method public IUserContext GetPendingContext().
    
    method public void SetClientContext(input poUserContext as IUserContext).
    
end interface.