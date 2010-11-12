/*------------------------------------------------------------------------
    File        : IConditionResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 10 13:19:00 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.

interface OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver:
    
    method public logical AreEqual(poLHS as ICondition, poRHS as ICondition).
    
    /*
    method public logical IsFirst(poCondition as ICondition).
    method public logical IsLast(poCondition as ICondition).
    method public logical IsUnique(poCondition as ICondition).
    */
    
end interface.