/** ------------------------------------------------------------------------
    File        : ConnectionCondition
    Purpose     : Session type and session code conditions for bindings.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 11:02:32 EST 2010
    Notes       : * We need a separate Condition class here since we want to 
                    have our own ConditionResolver, since there may be 
                    some special treatment
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Core.InjectABL.Binding.Conditions.ConnectionCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.StandardConditionResolver.

using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Conditions.ConnectionCondition inherits Condition:
    define static public property CurrentConnection as ICondition no-undo get. set.
    
    define static private property ConditionResolverType as class Class no-undo get. set.
    
    constructor static ConnectionCondition():
          ConnectionCondition:CurrentConnection = new ConnectionCondition('CURRENT_CONNECTIONS'). 
          ConnectionCondition:ConditionResolverType = Class:GetClass('OpenEdge.Core.InjectABL.Binding.Conditions.ConnectionConditionResolver').
    end constructor.
    
    constructor public ConnectionCondition (input pcValue as character):
        super(pcValue).
    end constructor.

    constructor public ConnectionCondition (input poValue as Object):
        super (input poValue).
    end constructor.
    
    method override public IConditionResolver GetResolver():
        return StandardConditionResolver:GetResolver(ConnectionCondition:ConditionResolverType). 
    end method.
    
end class.
