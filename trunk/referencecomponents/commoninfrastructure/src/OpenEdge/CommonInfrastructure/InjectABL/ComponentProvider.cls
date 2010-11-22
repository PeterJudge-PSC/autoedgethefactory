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
using OpenEdge.CommonInfrastructure.Client.ComponentTypeEnum.

using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.

using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.InjectABL.ComponentProvider inherits StandardProvider:
    
    constructor public ComponentProvider(poClass as class Class):
        super(poClass).
    end constructor.
    
    method override public Object Create(poContext as ILifecycleContext):
        define variable oNewParams as IParameter extent no-undo.
        define variable oRoutine as Routine no-undo.
        define variable oIterator as IIterator no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        oIterator = poContext:Arguments:Iterator().
        do while oIterator:HasNext():
            oRoutine = cast(oIterator:Next(), Routine).            
            iMax = extent(oRoutine:Parameters) + 1.            
            if iMax eq ? then iMax = 1.
                extent(oNewParams) = iMax. 
            
            oNewParams[1] = new Parameter(
                                new ComponentInfo(
                                    poContext:Binding:Service,
                                    poContext:Binding:Name,
                                    ComponentTypeEnum:ApplicationComponent,
                                    true),
                                Class:GetClass('OpenEdge.CommonInfrastructure.Common.IComponentInfo')).
            do iLoop = 2 to iMax:
                oNewParams[iLoop] = oRoutine:Parameters[iLoop - 1].
            end.
            oRoutine:Parameters = oNewParams.
        end.
        
        return super:Create(poContext).
    end method.
    
end class.