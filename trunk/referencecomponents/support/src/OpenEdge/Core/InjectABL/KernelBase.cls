/** ------------------------------------------------------------------------
    File        : StandardKernel
    Purpose     : Standard/default InjectABL dependency injection kernel. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 12:56:53 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
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
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.LifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.ICache.
using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.IInjectionRequest.
using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.InjectABL.ComponentContainer.
using OpenEdge.Core.InjectABL.KernelSettings.
using OpenEdge.Core.System.InvalidValueSpecifiedError.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.IList.
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
    
    /** Stack of unique services (as define by their LiefcycleContext) being invoked. Used to prevent
        circular references. */
    @todo(task="implement", action="circ reference checks").
    define protected property InvocationStack as IList no-undo get. private set.
    
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
        
        @param Ibinding The binding to remove. */
    method override public void RemoveBinding(poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "binding").
        Bindings:Remove(poBinding).
    end.
    
    method public void Load(input poModules as IInjectionModuleCollection):
        define variable oIterator as IIterator no-undo.
        
        oIterator = poModules:Values:Iterator().
        do while oIterator:HasNext():
            this-object:Load(cast(oIterator:Next(), IInjectionModule)).
        end.
    end method.
    
    method public logical HasModule(pcName as character):
        return Modules:ContainsKey(pcName).
    end method.
    
    method public void Load(input poModule as IInjectionModule):
        if not Modules:ContainsValue(poModule) then
            Modules:Add(poModule).
        poModule:OnLoad(this-object).
    end method.
    
    /* InjectABLModuleLoaderModule */
    /** Loads IInjectionModules from files matching the pattern. 
        
        @param character A file pattern */
    method protected void Load(input pcFilePattern as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cOriginalExtension as character no-undo.
        define variable cFileBase as character no-undo.
        define variable cFolderBase as character no-undo.
        define variable cFile as character no-undo.
        define variable cPWD as character no-undo.
        define variable cFolder as character no-undo.
        define variable oModules as IInjectionModuleCollection no-undo.
        
        Assert:ArgumentNotNullOrEmpty(pcFilePattern, 'file pattern').
        
        /* Remove the extension, since we may only have the .R present. */
        iMax = num-entries(pcFilePattern, '.').
        case iMax:
            when 1 then cFileBase = pcFilePattern.
            otherwise
            do:
                cOriginalExtension = entry(iMax, pcFilePattern, '.'). 
                do iLoop = (iMax - 1) to 1 by -1:
                    cFileBase = entry(iLoop, pcFilePattern, '.')
                              + '.' +
                              cFileBase.
                end.
            end.
        end case.
        
        /* Resolve the working folder into something meaningful, since
           SEARCH() is significantly faster with a fully-qualified path  */
        file-info:file-name = '.'.
        cPWD = file-info:full-pathname. 
        
        iMax = num-entries(propath).
        do iLoop = 1 to iMax:
            cFolder = entry(iLoop, propath).
            
            if cFolder begins '.' and
               /* don't mess up relative pathing */
               not cFolder begins '..' then
            do:
                if cFolder eq '.' then
                    cFolder = cPWD.
                else
                    cFolder = cPWD + substring(cFolder, 2).
            end.
            
            /* Always looks for .R. We can write a specialised resolver here if we want 
               to get fancy and look for .r and .p */
            assign cFolderBase = right-trim(cFolder, '/') + '/' + cFileBase
                   cFile = search(cFolderBase + 'r').
            if cFile ne ? then
                /* run NO-ERROR in case theres a file matching the pattern
                   that doesn't match signatures. Move along in that case. */
                run value(cFile) (input this-object) no-error.
        end.
    end method.
    
    /** Loads IInjectionModules from files matching the pattern. 
        
        @param character[] An array of file patterns */    
    method public void Load(input pcFilePatterns as character extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        Assert:ArgumentHasDeterminateExtent(pcFilePatterns, 'file patterns').
        
        iMax = extent(pcFilePatterns).
        
        do iLoop = 1 to iMax:
            this-object:Load(pcFilePatterns[iLoop]).
        end.
    end method.                    
    
    @todo(task="implement", action="").
    method public void Unload(pcName as character):
    end method.
    
    method public Object Get(pcService as character):
        Assert:ArgumentIsValidType(pcService).
        return this-object:Get(Class:GetClass(pcService), '').
    end method.
    
    method public Object Get(poService as class Class):
        return this-object:Get(poService, '', ?).
    end method.

	method public Object extent Get(input poScope as StandardScopeEnum,
	                                input poScopeCallback as class Class ):
        define variable oBinding as IBinding no-undo.
        define variable oBindings as IBindingCollection no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oInstance as Object extent no-undo.
        define variable iExtent as integer no-undo.
        def var oContext as ILifecycleContext no-undo.
        
        oBindings = GetBindings(poScope, poScopeCallback).
        if oBindings:Size gt 0 then
        do:
            extent(oInstance) = oBindings:Size.
            
            oIterator = oBindings:Iterator().
            do while oIterator:HasNext():
                oBinding = cast(oIterator:Next(), IBinding).
                iExtent = iExtent + 1.
                
                /* [PJ] something buggy */
                oContext = CreateContext(oBinding).
                oInstance[iExtent] = oContext:Resolve().
            end.
        end.
        
        return oInstance.
	end method.
    
    method public Object Get(input poService as class Class,
                             input poArguments as ICollection):
        return this-object:Get(poService, '', poArguments).                                 
    end method.
    
    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module. 
    
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service   
        @return An instance of the requested service/interface    */
    method public Object Get(input poService as class Class,
                             input pcName as character):
        return this-object:Get(poService, pcName, ?).
    end method.
    
    method protected Object Get(input poService as class Class,
                                input pcName as character,
                                input poArguments as ICollection):
        define variable oBinding as IBinding no-undo.
        def var oContext as ILifecycleContext no-undo.
        
        Assert:ArgumentNotNull(poService, 'Service').
        Assert:ArgumentNotNull(pcName, 'Name').
        
        if poService:IsA(Class:GetClass('OpenEdge.Core.InjectABL.IKernel')) then
            return this-object.
        
        oBinding = SelectBinding(poService, pcName).
        
        if valid-object(poArguments) then
            oBinding:Arguments:AddAll(poArguments).

/*        return CreateContext(oBinding):Resolve().*/
        /* [PJ] something buggy */        
        oContext = CreateContext(oBinding).
        
        return oContext:Resolve().
    end method.
    
    /** Retrieve the binding to use for the service. */
    method protected IBinding SelectBinding(input poService as class Class,
                                            input pcName as character):
        define variable oBindings as IBindingCollection no-undo.
        define variable oBinding as IBinding no-undo.
        
        oBindings = GetBindings(poService, pcName).
        
        if oBindings:IsEmpty() then
            oBinding = CreateDefaultBinding(poService).
        else
            /* Always use the first matching binding, since we assume that the bindings
               are added in PROPATH order, and that the PROPATH is ordered in importance 
               from left to right.
               
               If this behaviour is undesirable, then a setting should be added to 
               the KernelSettings object to define it, or a BindingSelection component
               created and added to the kernel. */
            oBinding = cast(oBindings:Get(1), IBinding).
        
        /* Need to be able to invoke this type. */
        Assert:ArgumentNotAbstract(oBinding:TargetType).
        Assert:ArgumentNotInterface(oBinding:TargetType).
        
        return oBinding.
    end method.
    
    /** Injects (from outside) **/
    method public void Inject(poInstance as Object,
                              poArguments as ICollection):
        define variable oBinding as IBinding no-undo.
        define variable oCache as ICache no-undo.
        define variable oContext as ILifecycleContext no-undo. 
        
        Assert:ArgumentNotNull(poInstance, "instance").
        Assert:ArgumentNotNull(poArguments, "arguments").
        
        oContext = cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ICache'))
                , ICache):TryGetContext(poInstance).
        if not valid-object(oContext) then
            oContext = CreateContext(CreateDefaultBinding(poInstance:GetClass())).
        
        oContext:Binding:Arguments:AddAll(poArguments).
                
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
    
    method protected IBindingCollection GetBindings(input poService as class Class,
                                                    input pcName as character):
        return cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Binding.IBindingResolver'))
                             , IBindingResolver):Resolve(Bindings, poService, pcName).
    end method.
    
    method protected IBindingCollection GetBindings(input poScope as StandardScopeEnum,    
                                                    input poScopeCallback as class Class):
        
        return cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Binding.IBindingResolver'))
                             , IBindingResolver):Resolve(Bindings, poScopeCallback, poScope).
    end method.
        
    method protected IBinding CreateDefaultBinding(input poService as class Class):
        define variable oBinding as IBinding no-undo.
        define variable oBuilder as IBindingSyntax no-undo.
        
        if not TypeIsSelfBindable(poService) then
            undo, throw new InvalidValueSpecifiedError(
                                'default binding',
                                ': Type ' + poService:TypeName + ' cannot bind to itself').
        
        oBinding = new Binding(poService).
        AddBinding(oBinding).
        oBuilder = CreateBindingBuilder(oBinding).
        oBuilder:ToSelf().
        
        return oBinding.
    end method. 
    
    method override protected IBindingSyntax CreateBindingBuilder(poBinding as IBinding):
        return new BindingBuilder(poBinding, this-object).
    end method.    
    
    method protected ILifecycleContext CreateContext(poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "binding").
        
        return new LifecycleContext(this-object,
                                    poBinding,
                                    cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IPipeline')), IPipeline),
                                    cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ICache')), ICache)).
    end method.
    
    method protected logical TypeIsSelfBindable(poService as class Class):
        return (not poService:IsAbstract() and not poService:IsInterface() ).
    end method.
    
end class.
