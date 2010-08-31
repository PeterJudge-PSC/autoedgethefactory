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
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Conditions.Condition implements ICondition:
    define private variable moObjectValue as Object no-undo.
    define private variable mcPrimitiveValue as character no-undo.    
    define private variable mlIsObjectValue as logical no-undo.
    
    /* Operators */
    define static public property And as ICondition no-undo get. private set.
    define static public property Or as ICondition no-undo get. private set.
    
    /* Comparers */
    define static public property When as ICondition no-undo get. private set.
    define static public property Is as ICondition no-undo get. private set.
    define static public property Not as ICondition no-undo get. private set.    
    
    constructor static Condition():
        define variable oType as class Class no-undo.
        
        assign Condition:And = new Condition('and')
               Condition:Or = new Condition('or')
               
               Condition:Is = new Condition('is')
               Condition:When = new Condition('when')
               Condition:Not = new Condition('not')
               .
    end constructor.
    
    constructor public Condition(pcValue as char):
        Assert:ArgumentNotNullOrEmpty(pcValue, 'Condition value').
        
        assign mlIsObjectValue = false
               mcPrimitiveValue = pcValue.
    end constructor.

    constructor public Condition(poValue as Object):
        Assert:ArgumentNotNull(poValue, 'Condition value').
        assign mlIsObjectValue = true
               moObjectValue = poValue.
    end constructor.
    
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
        
        if lEquals then
            lEquals = poCondition:ToString() eq this-object:ToString().
        
        return lEquals.
    end method.
    
    method override public character ToString():
        define variable cString as character no-undo.
        
        if mlIsObjectValue then
            cString = moObjectValue:ToString().
        else
            cString = mcPrimitiveValue.
        
        return cString.
    end method.
    
end class.