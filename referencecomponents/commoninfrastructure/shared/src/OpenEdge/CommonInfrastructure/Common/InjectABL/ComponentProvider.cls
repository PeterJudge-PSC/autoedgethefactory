 /*------------------------------------------------------------------------
    File        : ComponentProvider
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 07 14:41:39 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ComponentInfo. 
using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.CommonInfrastructure.Common.Component.

using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.InjectABL.ComponentProvider inherits StandardProvider:
    
    constructor public ComponentProvider(poClass as class Class):
        super(poClass).
    end constructor.

    method override public Object Create(input poContext as ILifecycleContext):
        define variable oComponent as Object no-undo.
        define variable oNewParams as IParameter extent no-undo.
        define variable oRoutine as Routine no-undo.
        define variable oIterator as IIterator no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iOffset as integer no-undo init 1.
        
        if poContext:Arguments:Size eq 0 then
            poContext:Arguments:Add(new Routine(poContext:Binding:Service, '', RoutineTypeEnum:Constructor)).
        
        oIterator = poContext:Arguments:Iterator().
        do while oIterator:HasNext():
            oRoutine = cast(oIterator:Next(), Routine).
            
            /* We only care about constructors here */
            if not oRoutine:RoutineType:Equals(RoutineTypeEnum:Constructor) then
                next.
            
            extent(oNewParams) = ?.
            iMax = extent(oRoutine:Parameters) + iOffset.            
            if iMax eq ? then
                iMax = iOffset.
            extent(oNewParams) = iMax.
            
            oNewParams[1] = new Parameter(
                                new ComponentInfo(
                                    poContext:Binding:Service,
                                    poContext:Binding:Name,
                                    ComponentTypeEnum:ApplicationComponent,
                                    true),
                                ComponentInfo:IComponentInfoType).
            do iLoop = (iOffset + 1) to iMax:
                oNewParams[iLoop] = oRoutine:Parameters[iLoop - iOffset].
            end.
            
            /* replace old with new 
            oRoutine:Parameters = ?.
            */
            extent(oRoutine:Parameters) = ?.
            oRoutine:Parameters = oNewParams.
        end.
        
        oComponent = super:Create(poContext).
        
        /* Component:IComponentType. */
        Assert:ArgumentIsType(oComponent, Class:GetClass('OpenEdge.CommonInfrastructure.Common.IComponent')).
        
        return oComponent.
    end method.
    
end class.