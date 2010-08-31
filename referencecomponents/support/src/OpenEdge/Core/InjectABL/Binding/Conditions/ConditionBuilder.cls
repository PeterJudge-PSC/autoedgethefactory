/*------------------------------------------------------------------------
    File        : ConditionBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 08 11:50:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.UITypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.Assert.
using OpenEdge.Lang.ObjectStack.

using OpenEdge.Core.InjectABL.Binding.Modules.*.
using Progress.Lang.*.


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

    define public property Session as IConditionSyntax no-undo
        get():
            BindingCondition:Push(SessionTypeCondition:CurrentSession).
            return this-object.
        end get.
    
    define public property Name as IConditionSyntax no-undo 
        get():
            return this-object. 
        end get.
    
    define public property UIType as IConditionSyntax no-undo
        get():
            BindingCondition:Push(UITypeCondition:Current).
            return this-object.
        end get.
    
    constructor public ConditionBuilder(poBindingCondition as ObjectStack):
        BindingCondition = poBindingCondition.
        BindingCondition:Push(Condition:And).
    end constructor.
    
    constructor public ConditionBuilder(poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "binding").
        
        /* Guesstimate at default depth. */
        BindingCondition = new ObjectStack(10).
        BindingCondition:AutoExpand = true.
        
        poBinding:Condition = BindingCondition.
        
        BindingCondition:Push(Condition:When).
    end constructor.
    
    method public IConditionSyntax First(poCondition as ICondition):
        BindingCondition:Push(poCondition).
        return this-object.
    end method.

    method public IConditionSyntax Last(poCondition as ICondition):
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
    method public IConditionSyntax Unique(poCondition as ICondition):
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
    method public IConditionSyntax Is(poCondition as ICondition):
        BindingCondition:Push(Condition:Is).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
    method public IConditionSyntax Not(poCondition as ICondition):
        BindingCondition:Push(Condition:Not).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
end class.