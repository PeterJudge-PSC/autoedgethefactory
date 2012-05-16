/** ------------------------------------------------------------------------
    File        : IConditionResolver
    Purpose     : InjectABL condition resolution interface.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 10 13:19:00 EST 2010
    Notes       : * Not all conditions resolve as simply as X:Equals(Y);
                    for example, the session type resolves may depend on
                    whether there are AppServers or DBs connected to determine
                    the validity of a clause.
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.

interface OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver:
    
    /** Evaluates the provided conditions. 
        
        @param ICondition The left-hand side argument for the clause
        @param ICondition The clause operator
        @param ICondition The right-hand side argument for the clause
        @return logical Whether the clause resolves to true or false
         */
    method public logical EvaluateClause(input poLHS as ICondition,
                                         input poOperator as ICondition,
                                         input poRHS as ICondition).
    
end interface.