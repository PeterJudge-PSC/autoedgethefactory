/*------------------------------------------------------------------------
    File        : Condition
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 08 15:22:04 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.StandardConditionResolver.

using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Conditions.Condition implements ICondition:
    
    define static private property ConditionResolverType as class Class no-undo get. set.
    
    define private variable moValue as Object no-undo.
    
    /* Operators */
    define static public property And as ICondition no-undo get. private set.
    define static public property Or as ICondition no-undo get. private set.
    
    /* Comparers */
    define static public property When as ICondition no-undo get. private set.
    define static public property Is as ICondition no-undo get. private set.
    define static public property Not as ICondition no-undo get. private set.    
    
    constructor static Condition():
        define variable oType as class Class no-undo.
        
        assign Condition:ConditionResolverType = Class:GetClass('OpenEdge.Core.InjectABL.Binding.Conditions.StandardConditionResolver')
               
               Condition:And = new Condition('and')
               Condition:Or = new Condition('or')
               
               Condition:Is = new Condition('is')
               Condition:When = new Condition('when')
               Condition:Not = new Condition('not')
               .
    end constructor.
    
    constructor public Condition(input pcValue as char):
        this-object(new String(pcValue)).
    end constructor.
    
    constructor public Condition(poValue as Object):
        Assert:ArgumentNotNull(poValue, 'Condition value').
        moValue = poValue.
    end constructor.
    
    method public IConditionResolver GetResolver():
        return StandardConditionResolver:GetResolver(Condition:ConditionResolverType). 
    end method.
    
    method static public logical Equals(poCondition1 as ICondition, poCondition2 as ICondition):
        define variable lEquals as logical no-undo.
        
        if not valid-object(poCondition1) or
           not valid-object(poCondition2) then
           lEquals = false.
        
        if lEquals then
            lEquals = poCondition1:Equals(poCondition2).
        
        return lEquals.
    end method.
    
    method override public logical Equals(poCondition as Object):
        define variable lEquals as logical no-undo.
        
        lEquals = valid-object(poCondition).
        
        /* need to match types */
        if lEquals then
            lEquals = poCondition:GetClass():IsA(this-object:GetClass()).
        
        if lEquals then
            lEquals = poCondition:ToString() eq this-object:ToString().
        
        return lEquals.
    end method.
    
    method override public character ToString():
        return moValue:ToString().
    end method.
    
end class.