/*------------------------------------------------------------------------
    File        : SamuraiProvider
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 13:21:45 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Test.Samurai.

using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Binding.Parameters.PropertyValue.
using OpenEdge.Core.InjectABL.Binding.Parameters.ConstructorArgument.
using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Test.SamuraiProvider inherits StandardProvider: 
    
    constructor public SamuraiProvider(poClass as class Class):
        super(poClass).
    end constructor. 
    
    method override public Object Create(poContext as ILifecycleContext):
        def var oSamurai as Object.

        poContext:Parameters:Add(
            new ConstructorArgument(Class:GetClass('OpenEdge.Test.IWeapon'))).
        
        oSamurai = cast(super:Create(poContext), Samurai).
        
        return oSamurai.
    end method.
    
    method override protected void InjectViaProperty(poInstance as Object,
                                                     poPropertyValue as PropertyValue,
                                                     poContext as ILifecycleContext):
        define variable cValue as character no-undo.
        
        Assert:ArgumentIsType(poInstance, this-object:Type).
        
        case poPropertyValue:Name:
            when 'Dojo' then
            do:
                poPropertyValue:GetValue(poContext, output cValue). 
                cast(poInstance, OpenEdge.Test.Samurai):Dojo = cValue.
            end.
            when 'UseAlternate' then
            do:
                poPropertyValue:GetValue(poContext, output cValue).
                cast(poInstance, OpenEdge.Test.Samurai):UseAlternate = logical(cValue).
            end.
            otherwise
                super:InjectViaProperty(poInstance, poPropertyValue, poContext).
        end case.
    end method.
    
end class.