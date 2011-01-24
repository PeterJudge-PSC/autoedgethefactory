/** ------------------------------------------------------------------------
    File        : StandardConditionResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 29 10:05:25 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.

using OpenEdge.Lang.Assert.

using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Binding.Conditions.StandardConditionResolver implements IConditionResolver: 

    constructor public StandardConditionResolver():
    end constructor. 

    /** Evaluates the provided conditions. 
        
        @param ICondition The left-hand side argument for the clause
        @param ICondition The clause operator
        @param ICondition The right-hand side argument for the clause
        @return logical Whether the clause resolves to true or false
         */
    method public logical EvaluateClause(input poLHS as ICondition,
                                         input poOperator as ICondition,
                                         input poRHS as ICondition):
        define variable lConditionsMet as logical no-undo.
        
        case poOperator:
            when Condition:Is  then lConditionsMet = poLHS:Equals(poRHS).
            when Condition:Not then lConditionsMet = not poLHS:Equals(poRHS).
        end case.
        
        return lConditionsMet.
    end method.
        
    /** Factory method for new IConditionResolver instances.
        
        @param Class The typename of the condition resolver.
        @return IConditionResolver The new resolver to use.      */
    method static public IConditionResolver GetResolver(input poConditionResolverType as class Class):
        define variable oConditionResolver as IConditionResolver no-undo.
        
        Assert:ArgumentNotNull(poConditionResolverType, 'Condition Resolver Type').
        Assert:ArgumentIsType(poConditionResolverType,
                              Class:GetClass('OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver')).
        
        oConditionResolver = dynamic-new(poConditionResolverType:TypeName) ().
        
        return oConditionResolver.
    end method.
    
    
end class.