/* ------------------------------------------------------------------------
    File        : IConditionSyntax
    Purpose     : Defines the syntax for operating with conditions used for
                  resolving InjectABL bindings 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 08 12:02:20 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.

interface OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax:
    define public property And as IConditionSyntax no-undo get.
    define public property Or as IConditionSyntax no-undo get.

    method public IConditionSyntax Condition(input poCondition as ICondition).
    
    method public IConditionSyntax Is(input poCondition as ICondition).
    method public IConditionSyntax Not(input poCondition as ICondition).
    
/*
    method public IConditionSyntax First(input poCondition as ICondition).
    method public IConditionSyntax Last(input poCondition as ICondition).
    method public IConditionSyntax Unique(input poCondition as ICondition).
*/
    
end interface.