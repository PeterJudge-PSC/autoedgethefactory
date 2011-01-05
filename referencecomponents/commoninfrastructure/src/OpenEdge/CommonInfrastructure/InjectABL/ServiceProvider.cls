 /** ------------------------------------------------------------------------
    File        : ServiceProvider
    Purpose     : InjectABL provider for objects of type IService.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 07 14:41:39 EDT 2010
    Notes       : * The Create() override adds the common IServiceManager and
                    IComponentInfo overrides to the constructor arguments.                    
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.InjectABL.ComponentProvider.
using OpenEdge.CommonInfrastructure.Common.ComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.

using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.Collections.IIterator.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider inherits StandardProvider:
    
    constructor public ServiceProvider(poClass as class Class):
        super(poClass).
    end constructor.
    
    method override public Object Create(poContext as ILifecycleContext):
        define variable oNewParams as IParameter extent no-undo.
        define variable oRoutine as Routine no-undo.
        define variable oIterator as IIterator no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iOffset as integer no-undo init 2.
        
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
            oNewParams[1] = new Parameter(ServiceManager:ServiceManagerType).
            oNewParams[2] = new Parameter(
                                new ComponentInfo(
                                    poContext:Binding:Service,
                                    poContext:Binding:Name,
                                    ComponentTypeEnum:ApplicationComponent,
                                    true),
                                ComponentInfo:ComponentInfoType). 
            do iLoop = (iOffset + 1) to iMax:
                oNewParams[iLoop] = oRoutine:Parameters[iLoop - iOffset].
            end.
            
            /* replace old with new */
            /*oRoutine:Parameters = ?.*/
            extent(oRoutine:Parameters) = ?.
            oRoutine:Parameters = oNewParams.
        end.
        
        return super:Create(poContext).
    end method.
    
end class.