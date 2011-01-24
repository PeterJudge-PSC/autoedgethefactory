/*------------------------------------------------------------------------
    File        : IConditionSyntax
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 08 12:02:20 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.

interface OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax:
    define public property And as IConditionSyntax no-undo get.
    define public property Or as IConditionSyntax no-undo get.
    
    method public IConditionSyntax Is(poCondition as ICondition).
    method public IConditionSyntax Not(poCondition as ICondition).
    
    method public IConditionSyntax First(poCondition as ICondition).
    method public IConditionSyntax Last(poCondition as ICondition).
    method public IConditionSyntax Unique(poCondition as ICondition).
    
    define public property Session as IConditionSyntax no-undo get.
    define public property Connection as IConditionSyntax no-undo get.
    
end interface.