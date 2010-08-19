/*------------------------------------------------------------------------
    File        : StandardKernel
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 12:56:53 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.BindingRoot.
using OpenEdge.Core.InjectABL.Binding.IBindingRoot.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.Binding.
using OpenEdge.Core.InjectABL.Binding.BindingBuilder.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.IBindingResolver.
using OpenEdge.Core.InjectABL.Binding.IBindingCollection.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.LifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.ICache.
using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.IInjectionRequest.
using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.InjectABL.ComponentContainer.
using OpenEdge.Core.InjectABL.KernelSettings.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.KernelBase inherits BindingRoot 
    implements IKernel, IBindingRoot /*, IResolutionRoot*/ :        
    
    define public property Settings as KernelSettings no-undo get. private set.
    
    /** Gets the modules that have been loaded into the kernel. **/
    define public property Modules as IInjectionModuleCollection no-undo get. private set.
    define override public property Bindings as IBindingCollection no-undo get. private set.
    
    /** Gets the component container, which holds components that contribute to InjectABL. **/
    define public property Components as ComponentContainer no-undo get. private set.
    
    /** Stack of unique services (as define by their Context) being invoked. Used to prevent
        circular references. 
    define protected property InvocationStack as List no-undo get. private set.
        */
    
    destructor public KernelBase():
        /* Clean up all the singletons (ie those scoped to this Kernel) */
        cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ICache'))
                , ICache):Clear(this-object).
    end destructor.
    
    constructor public KernelBase():
        this-object(new ComponentContainer(this-object),
                    new IInjectionModuleCollection(),
                    new KernelSettings()).
    end constructor. 
    
    constructor public KernelBase(poModules as IInjectionModuleCollection):
        this-object(new ComponentContainer(this-object),
                    poModules,
                    new KernelSettings()).
    end constructor.
    
    constructor protected KernelBase(poComponents as ComponentContainer, 
                                     poModules as IInjectionModuleCollection,
                                     poSettings as KernelSettings):
        Assert:ArgumentNotNull(poComponents, "components").
        Assert:ArgumentNotNull(poModules, "modules").
        Assert:ArgumentNotNull(poSettings, "settings").

        assign Components = poComponents
               Modules = poModules
               Settings = poSettings.

        AddComponents().
        
        Bindings = new IBindingCollection().

        this-object:Load(Modules).
    end constructor.
    
    method protected void AddComponents():
    end method.
    
    method override public void AddBinding(poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "binding").
        Bindings:Add(poBinding).
    end.
    
    /** Unregisters the specified binding.
        <param name="binding">The binding to remove.</param>
      **/
    method override public void RemoveBinding(poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "binding").
        Bindings:Remove(poBinding).
    end.
    
    method public void Load(poModules as IInjectionModuleCollection):
        define variable oIterator as IIterator no-undo.
        
        oIterator = poModules:Iterator().
        do while oIterator:HasNext():
            this-object:Load(cast(oIterator:Next(), IInjectionModule)).
        end.
    end method.

    method public logical HasModule(pcName as character):
    end method.
    
    method public void Load(poModule as IInjectionModule):
        if not Modules:Contains(poModule) then
            Modules:Add(poModule).
        
        poModule:OnLoad(this-object).
    end method.
    
    method public void Load(pcFilePatterns as character extent):

    end method.
    
    method public void Unload(pcName as character):

    end method.
    
    method public Object Get(pcService as character):
        define variable oService as class Class no-undo.
        
        /* no-error since we want to ensure that the class name actually exists. */
        oService = Class:GetClass(pcService) no-error.
        
        Assert:ArgumentNotNull(oService, 'Service ' + pcService).
        
        return this-object:Get(oService).
    end method.
    
    method public Object Get(poService as class Class):
        return this-object:Get(poService, ?).
    end method.
    
    method public Object Get(input poService as class Class,
                             input poParameters as IParameterCollection):
        define variable oInstance as Object no-undo.
        define variable oBinding as IBinding no-undo.
        
        Assert:ArgumentNotNull(poService, 'Service').
        
        if poService:IsA(Class:GetClass('OpenEdge.Core.InjectABL.IKernel')) then
            return this-object.
        
        oBinding = SelectBinding(poService).
        /* Will fail gracefully if no params added */        
        oBinding:Parameters:AddAll(poParameters).
        
        oInstance = cast(CreateContext(oBinding), ILifecycleContext):Resolve().
        
        return oInstance.
    end method.
    
    method protected IBinding SelectBinding(poService as class Class):
        define variable oBindings as IBindingCollection no-undo.
        define variable oBinding as IBinding no-undo.
        
        oBindings = GetBindings(poService).
        
        if oBindings:IsEmpty() then
            oBinding = CreateDefaultBinding(poService).
        else
            /* always use the first matching binding */
            oBinding = cast(oBindings:Iterator():Next(), IBinding).
        
        return oBinding.
    end method.
    
    /** Injects (from outside) **/
    method public void Inject(poInstance as Object,
                              poParameters as IParameterCollection):
        define variable oBinding as IBinding no-undo.
        define variable oCache as ICache no-undo.
        define variable oContext as ILifecycleContext no-undo. 
        
        Assert:ArgumentNotNull(poInstance, "instance").
        Assert:ArgumentNotNull(poParameters, "parameters").
        
        oContext = cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ICache'))
                , ICache):TryGetContext(poInstance).
        if not valid-object(oContext) then
            oContext = CreateContext(CreateDefaultBinding(poInstance:GetClass())).
        
        oContext:Binding:Parameters:AddAll(poParameters).
                
        cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IPipeline'))
                , IPipeline):Activate(oContext, poInstance).
    end method.
    
    method public logical Release(poInstance as Object):
        Assert:ArgumentNotNull(poInstance, "instance").
        
        return cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ICache'))
                , ICache):Release(poInstance).
    end method.

    method public void Clear(poScope as Object):
        Assert:ArgumentNotNull(poScope, "instance").
        
        cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ICache'))
                , ICache):Clear(poScope).
    end method.
    
    method public IBindingCollection GetBindings(poService as class Class):
        define variable oResolvedBindings as IBindingCollection no-undo.
        
        oResolvedBindings = cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Binding.IBindingResolver'))
                             , IBindingResolver):Resolve(Bindings, poService).
        
        return oResolvedBindings.
    end method.
    
    method public IBindingCollection GetBindings(poScopeCallback as class Class,
                                                 poScope as StandardScopeEnum):
        define variable oResolvedBindings as IBindingCollection no-undo.
        
        oResolvedBindings = cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Binding.IBindingResolver'))
                             , IBindingResolver):Resolve(Bindings, poScopeCallback, poScope).
        
        return oResolvedBindings.
    end method.
    
        
    method protected IBinding CreateDefaultBinding(poService as class Class):
        define variable oBinding as IBinding no-undo.
        define variable oBuilder as IBindingSyntax no-undo.
        
        oBinding = new Binding(poService).
        AddBinding(oBinding).
        oBuilder = CreateBindingBuilder(oBinding).
        
        if not TypeIsSelfBindable(poService) then
            undo, throw new AppError('Type ' + poService:TypeName + ' cannot bind to itself').
        
        oBuilder:ToSelf().
        
        return oBinding.
    End method. 
    
    method override protected IBindingSyntax CreateBindingBuilder(poBinding as IBinding):
        return new BindingBuilder(poBinding, this-object).
    end method.    
    
    method protected ILifecycleContext CreateContext(poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "binding").
        
        return new LifecycleContext(this-object,
                                    poBinding,
                                    cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IPipeline')), IPipeline),
                                    cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ICache')), ICache)
                                    ).
    end method.
    
    method protected logical TypeIsSelfBindable(poService as class Class):
        return (not poService:IsAbstract() and
                not poService:IsInterface() ).
    end method.

end class.
