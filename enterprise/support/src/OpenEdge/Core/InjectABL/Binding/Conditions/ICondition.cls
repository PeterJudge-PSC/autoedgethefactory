/** ------------------------------------------------------------------------
    File        : ICondition
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 10:53:22 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Binding.Conditions.ICondition:
    
    /** Returns the resolver used for this condition.
        
        @return IConditionResolver The object used to evaluate a condition of this type. */
    method public IConditionResolver GetResolver().
    
end interface.