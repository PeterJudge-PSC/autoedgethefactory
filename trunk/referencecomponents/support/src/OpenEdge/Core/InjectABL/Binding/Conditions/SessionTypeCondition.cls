/** ------------------------------------------------------------------------
    File        : SessionTypeCondition
    Purpose     : Session type and session code conditions for bindings.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 11:02:32 EST 2010
    Notes       : * We need a separate Condition class here since we want to 
                    have our own ConditionResolver, since there may be 
                    some special treatment
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.StandardConditionResolver.

using OpenEdge.Lang.String.
using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition inherits Condition:
    define static private property ConditionResolverType as class Class no-undo get. set.
    
    constructor static SessionTypeCondition():
          SessionTypeCondition:ConditionResolverType = Class:GetClass('OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeConditionResolver').
    end constructor.
    
    constructor public SessionTypeCondition (input pcValue as character):
        super (new String(pcValue)).
    end constructor.

    constructor public SessionTypeCondition (input poValue as Object):
        super (input poValue).
    end constructor.
    
    method override public IConditionResolver GetResolver():
        return StandardConditionResolver:GetResolver(SessionTypeCondition:ConditionResolverType). 
    end method.
    
end class.