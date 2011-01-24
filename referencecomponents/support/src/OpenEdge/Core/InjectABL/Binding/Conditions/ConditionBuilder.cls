/** ------------------------------------------------------------------------
    File        : ConditionBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 08 11:50:07 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.IKernel.

using OpenEdge.Lang.Collections.ObjectStack.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.

class OpenEdge.Core.InjectABL.Binding.Conditions.ConditionBuilder implements IConditionSyntax:
    define public property BindingCondition as ObjectStack no-undo get. private set.
    define public property Kernel as IKernel no-undo get. private set.
    
    define public property And as IConditionSyntax no-undo
        get():
            BindingCondition:Push(Condition:And).
            return this-object.
        end get.

    define public property Or as IConditionSyntax no-undo
        get():
            BindingCondition:Push(Condition:Or).
            return this-object. 
        end get.

/*
    define public property Is as IConditionSyntax no-undo
        get():
            BindingCondition:Push(Condition:Is).
            return this-object. 
        end get.
        
    define public property Not as IConditionSyntax no-undo
        get():
            BindingCondition:Push(Condition:Not).
            return this-object. 
        end get.
*/
    
    constructor public ConditionBuilder(input poBindingCondition as ObjectStack):
        BindingCondition = poBindingCondition.
        BindingCondition:Push(Condition:And).
    end constructor.
    
    constructor public ConditionBuilder(input poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "Binding").
        
        /* Guesstimate at default depth. */
        BindingCondition = new ObjectStack(10).
        BindingCondition:AutoExpand = true.
        
        poBinding:Condition = BindingCondition.
        
        BindingCondition:Push(Condition:When).
    end constructor.
    
    method public IConditionSyntax Condition(input poCondition as ICondition).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
    method public IConditionSyntax Is(input poCondition as ICondition):
        BindingCondition:Push(Condition:Is).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
    method public IConditionSyntax Not(input poCondition as ICondition):
        BindingCondition:Push(Condition:Not).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
end class.