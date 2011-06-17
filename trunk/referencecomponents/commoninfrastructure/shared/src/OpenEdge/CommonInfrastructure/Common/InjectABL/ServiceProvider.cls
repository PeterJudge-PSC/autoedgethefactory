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

using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.InjectABL.ComponentProvider.
using OpenEdge.CommonInfrastructure.Common.ComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.

using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.InjectABL.ServiceProvider inherits StandardProvider:
    
    constructor public ServiceProvider(poClass as class Class):
        super(poClass).
    end constructor.
    
    method override public Object Create(input poContext as ILifecycleContext):
        define variable oService as Object no-undo.
        define variable oServiceManager as IServiceManager no-undo.
        define variable oRoutine as Routine no-undo.
        define variable oIterator as IIterator no-undo.
        define variable lHasCtorArgs as logical no-undo.

        oServiceManager = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).
        
        oIterator = poContext:Arguments:Iterator().
        do while oIterator:HasNext():
            oRoutine = cast(oIterator:Next(), Routine).
            
            /* We only care about constructors here */
            if not oRoutine:RoutineType:Equals(RoutineTypeEnum:Constructor) then
                next.
            
            /* need at least one constructor */
            lHasCtorArgs = true.
            
            AddCommonArguments(oRoutine, poContext).
        end.
        
        if not lHasCtorArgs then
        do:
            oRoutine = new Routine(poContext:Binding:Service, '', RoutineTypeEnum:Constructor).
            AddCommonArguments(oRoutine, poContext).
            
            poContext:Arguments:Add(oRoutine).
        end.
        
        oService = super:Create(poContext).
        
        /* Service:IServiceType. */
        Assert:ArgumentIsType(oService, Class:GetClass('OpenEdge.CommonInfrastructure.Common.IService')).
        
        return oService.
    end method.
    
    method protected void AddCommonArguments(input poRoutine as Routine,
                                             input poContext as ILifecycleContext):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iOffset as integer no-undo init 2.
        define variable oNewParams as IParameter extent no-undo.
        
        iMax = extent(poRoutine:Parameters) + iOffset.
        if iMax eq ? then
            iMax = iOffset.
        extent(oNewParams) = iMax.
        
        oNewParams[1] = new Parameter(ServiceManager:IServiceManagerType).
        oNewParams[2] = new Parameter(
                            new ComponentInfo(
                                poContext:Binding:Service,
                                poContext:Binding:Name,
                                ComponentTypeEnum:Service,
                                true),
                            ComponentInfo:IComponentInfoType). 
        do iLoop = (iOffset + 1) to iMax:
            oNewParams[iLoop] = poRoutine:Parameters[iLoop - iOffset].
        end.
        
        /* replace old with new */
        extent(poRoutine:Parameters) = ?.
        poRoutine:Parameters = oNewParams.        
    end method.
    
end class.