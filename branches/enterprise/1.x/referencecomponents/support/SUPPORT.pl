�iso8859-1               e� �     ��    /** ------------------------------------------------------------------------
    File        : load_injectabl_modules.p
    Purpose     : InjectABL module loader for the OERA Support layer
    Syntax      :
    Description : 
    @author pjudge
    Created     : Mon Dec 13 13:40:24 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.IKernel.

/** -- defs  -- **/
define input parameter poKernel as IKernel no-undo.

/** -- main -- **/

/** -- eof -- **/
/** ------------------------------------------------------------------------
    File        : routinelevel.i
    Purpose     : Toggles all ROUTINE-LEVEL ON ERROR UNDO, THROW statements on or off.  
                  Use an include in leiu of a switch on the AVM command line (since that
                  doesn't exist).
    @author pjudge
    Created     : Fri Jan 21 14:02:16 EST 2011
    Notes       : * Default is to use ROUTINE-LEVEL
  ---------------------------------------------------------------------- */

/* ********************  Preprocessor Definitions  ******************** */
&if defined(USE-ROUTINE-LEVEL) eq 0 &then
    &global-define USE-ROUTINE-LEVEL false
&endif 

&if "{&USE-ROUTINE-LEVEL}" eq "true" &then
routine-level on error undo, throw.
&endif <html>
<body>
OpenEdge.Core package

<h2>Package Description</h2>
<p>
<p>The OpenEdge.Core package holds components of general nature that are used in more than one of the OERA layers, and could potentially be used by other ABL applications.</p>


</body></html>
/** ------------------------------------------------------------------------
    File        : Cache
    Purpose     : Tracks instances for re-use in certain scopes. 
    Syntax      : 
    Description : 
    @Author   : pjudge
    Created     : Thu Mar 04 17:08:02 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.ICache.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Lang.DateTimeAddIntervalEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Cache use-widget-pool
        implements ICache:
    
    define private temp-table InstanceCache no-undo
        field Binding as Object                 /* IBinding */
        
        field LifecycleContext  as Object
        field Instance          as Object
        field Scope             as integer      /* weak reference */
        
        field CachedAt          as datetime-tz
        
        index idx1 as unique Instance
        index idx2 Scope CachedAt
        index idx3 Binding.
    
    /** Gets the activation pipeline in use for this kernel */
    define public property Pipeline as IPipeline no-undo get. private set.
    
    /** Gets the number of entries currently stored in the cache. */
    define public property Count as integer no-undo 
        get():
            define variable iCount as integer no-undo.
            
            define buffer lbCache for InstanceCache.
            define query qryCache for lbCache.
            
            open query qryCache preselect each lbCache.
            iCount = query qryCache:num-results.
            close query qryCache.
            
            return iCount.
        end get.
    
    define public property PruningInterval as integer no-undo get. set.    
    define public property PruningUnit as DateTimeAddIntervalEnum no-undo get. set.
    
    constructor public Cache(poPipeline as IPipeline,
                             piLifespan as integer,
                             poLifespanUnit as DateTimeAddIntervalEnum):
        Assert:ArgumentNotNull(poLifespanUnit, 'Lifespan unit').
        Assert:ArgumentNotNull(poPipeline, 'Pipeline').
        
        assign PruningInterval = piLifespan
               PruningUnit = poLifespanUnit
               Pipeline = poPipeline.
    end constructor.

    /** Stores the specified context in the cache.
        
        @param context The context to store.
        @param reference The instance reference.    */
    method public void Remember(poContext as ILifecycleContext, poInstance as Object):
        define buffer lbCache for InstanceCache.
        
        Assert:ArgumentNotNull(poContext, "Context").
        Assert:ArgumentNotNull(poInstance, "Instance").
        
        create lbCache.
        assign lbCache.LifecycleContext =  poContext
               lbCache.Scope = integer(poContext:GetScope())
               lbCache.Binding = poContext:Binding
               lbCache.Instance = poInstance
               lbCache.CachedAt = now.
    end method.
    
    /** Tries to retrieve an instance to re-use in the specified context.
    
        @param ILifecycleContext The context that is being activated.
        @return Object The instance for re-use, or unknown if none has been stored. */
    method public Object TryGet(input poContext as ILifecycleContext):
        define variable oInstance as Object no-undo.
        define variable oScope as Object no-undo.
        
        define buffer lbCache for InstanceCache.
        
        Assert:ArgumentNotNull(poContext, "Context").
        oScope = poContext:GetScope().
        
        for each lbCache where 
                 lbCache.Scope eq int(oScope)
                 while not valid-object(oInstance):
            if lbCache.Binding:Equals(poContext:Binding) then
                oInstance = lbCache.Instance.
        end.
        
        return oInstance.
    end method.
    
    /** Tries to find an ILifecycleContext object for a running instance.
        
        @param Object The running instance on which to check.
        @return ILifecycleContext The lifecycle context for the running object, if available */
    method public ILifecycleContext TryGetContext(poInstance as Object):
        define variable oContext as ILifecycleContext no-undo.
        
        define buffer lbCache for InstanceCache.
        
        Assert:ArgumentNotNull(poInstance, "Instance").
        
        find first lbCache where lbCache.Instance eq poInstance no-error.
        if available lbCache then
            oContext = cast(lbCache.LifecycleContext, ILifecycleContext).
        
        return oContext.
    end method.
    
    /** Deactivates and releases the specified instance from the cache.
    
        @param Object The instance to release.
        @return logical True if the instance was found and released; otherwise false. */
    method public logical Release(poInstance as Object):
        /* When releasing this object, make sure we let go of anything
           scoped to this instance. */
        this-object:Clear(poInstance).
        
        return Forget(poInstance).
    end method.
    
    /** Removes instances from the cache which should no longer be re-used. */
    method public void Prune():
        if PruningInterval ne -1 then
            ForgetAllWhere('CachedAt lt ' + quoter(add-interval(now, PruningInterval * -1, PruningUnit:ToString()))).
    end method.
    
    /** Immediately deactivates and removes all instances in the cache that are owned by
        the specified scope.
        @param scope The scope whose instances should be deactivated.
     */
    method public void Clear(poScope as Object):
        ForgetAllWhere('Scope eq ' + quoter(int(poScope)) ).
    end method.
    
    /** Immediately deactivates and removes all instances in the cache, regardless of scope. */
    method public void Clear():
        ForgetAllWhere('true').
    end.
    
    method private void ForgetAllWhere(pcClause as char):
        define variable hQuery as handle no-undo.
        
        define buffer lbCache for InstanceCache.
        define query qryCache for lbCache.
        
        hQuery = query qryCache:handle.
        /* Use preselect since we're deleting records */
        hQuery:query-prepare('preselect each lbCache where ' + pcClause).
        hQuery:query-open().
        
        hQuery:get-first().
        do while not hQuery:query-off-end:
            Forget(buffer lbCache).
            hQuery:get-next().
        end.
        hQuery:query-close().
    end.
    
    method private logical Forget(buffer pbCache for InstanceCache):
        define variable lCached as logical no-undo.
        
        lCached = available pbCache.
        
        if lCached then
        do:
            Pipeline:Deactivate(cast(pbCache.LifecycleContext, ILifecycleContext),
                                pbCache.Instance).
            /* Don't explicitly delete the object; let garbage colleciton take care of it. */
            delete pbCache.
        end.
        
        return lCached.
    end method.
    
    method private logical Forget(poInstance as Object):
        define buffer lbCache for InstanceCache.
        
        find lbCache where lbCache.Instance eq poInstance no-error.
        return Forget(buffer lbCache).
    end.
    
end class./*------------------------------------------------------------------------
    File        : ComponentContainer
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 08:39:42 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.*.
using OpenEdge.Core.InjectABL.Binding.Modules.*.
using OpenEdge.Core.InjectABL.*.
using OpenEdge.Lang.Collections.*.
using Progress.Lang.*.

class OpenEdge.Core.InjectABL.ComponentContainer: 
    define public property Size as integer no-undo get. private set.
    define public property Kernel as IKernel no-undo get. private set.
    
    define private temp-table ttMap no-undo
        field KeyMember as Object
        field ValueMember as Object
        field Instance as Object
        index idx1 as primary KeyMember. 
    
    constructor public ComponentContainer(poKernel as IKernel):
        Kernel = poKernel.
    end constructor.
    
    method public logical Add(poKey as class Class, poValue as class Class):
        define buffer lbMap for ttMap.
        
        create lbMap.
        assign lbMap.KeyMember = poKey
               lbMap.ValueMember = poValue
               this-object:Size = this-object:Size + 1.
    end method.
    
    method public void Clear():
        empty temp-table ttMap.
        Size = 0.
    end method.
    
    method public logical Contains(poKey as class Class, poValue as class Class):
       define buffer lbMap for ttMap.
        
       return can-find(lbMap where
             lbMap.KeyMember = poKey and
             lbMap.ValueMember = poValue).
    end method.
        
    method public logical IsEmpty(  ):
        return (Size gt 0).
    end method.
    
    method public logical RemoveAll(poKey as class Class):
        define buffer lbMap for ttMap.
                
        for each lbMap where lbMap.KeyMember = poKey:
            delete lbMap.
            Size = Size - 1.
        end.
        return true.
    end method.
    
    method public logical RemoveFirst(poKey as class Class):
        define buffer lbMap for ttMap.
        
        find first lbMap where lbMap.KeyMember = poKey no-error.
        if available lbMap then
        do:
            delete lbMap.
            Size = Size - 1.
            
            return true.
        end.
        return false.
    end method.

    method public logical RemoveValue(poKey as class Class,
                                      poValue as class Class):
        define buffer lbMap for ttMap.
        
        find first lbMap where 
                   lbMap.KeyMember = poKey and
                   lbMap.ValueMember = poValue 
                   no-error.
        if available lbMap then
        do:
            delete lbMap.
            Size = Size - 1.
            
            return true.
        end.
        return false.
    end method.
        
    method public class Class GetType(poService as class Class):
        define variable oImplentingType as class Class no-undo.
        define buffer lbMap for ttMap.
        
        find first lbMap where  
                   lbMap.KeyMember eq poService 
                   no-error.
        if available lbMap then
            oImplentingType = cast(lbMap.ValueMember, Class).
        
        return oImplentingType.
    end method.
    
    method public Object Get(poService as class Class):
        define variable oImplentingType as class Class no-undo.
        define variable oComponent as Object no-undo.
        
        define buffer lbMap for ttMap.
        
        if poService:IsA('OpenEdge.Core.InjectABL.IKernel') then
            return Kernel.
        
        find first lbMap where
                   lbMap.KeyMember eq poService 
                   no-error.
        if available lbMap then
        do:
            if valid-object(lbMap.Instance) then
                oComponent = lbMap.Instance.
            else
            do:
                oImplentingType = cast(lbMap.ValueMember, Class).
                
                case poService:TypeName:
                    when 'OpenEdge.Core.InjectABL.Lifecycle.IPipeline' then                    
                        oComponent = GetPipeline(oImplentingType).
                    when 'OpenEdge.Core.InjectABL.ICache' then
                        oComponent = GetCache(oImplentingType).
                    otherwise
                        oComponent = oImplentingType:New().
                end case.
                
                lbMap.Instance = oComponent.
            end.
        end.
        
        return oComponent.
    end method.
    
    method protected ICache GetCache(poService as class Class):
        define variable oCache as ICache no-undo.
        
        oCache = dynamic-new(poService:TypeName) (
                    this-object:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IPipeline')),
                    Kernel:Settings:CachePruningInterval,
                    Kernel:Settings:CachePruningUnit ).
        
        return oCache.
    end method.
    
    /** Factory method for invoking kernel components. We can't really use the Kernel,
        since these components are central to using the Kernel. We still use dependency
        injection though :) **/
    method protected IPipeline GetPipeline(poService as class Class):
        define variable oStrategies as ILifecycleStrategyCollection no-undo.
        define variable oPipeline as IPipeline no-undo.
        define variable oStrategyType as class Class no-undo.
        
        define buffer lbMap for ttMap.
        
        oStrategies = new ILifecycleStrategyCollection().
        oStrategyType = Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy').
        
        for each lbMap where lbMap.KeyMember = oStrategyType:
            oStrategies:Add(GetLifecycleStrategy(cast(lbMap.ValueMember, Class))).
        end.
        
        oPipeline = dynamic-new(poService:TypeName) (oStrategies).
        
        return oPipeline.
    end method.
    
    method protected ILifecycleStrategy GetLifecycleStrategy(poService as class Class):
        define variable oStrategy as ILifecycleStrategy no-undo.
        
        oStrategy = dynamic-new(poService:TypeName) ().
        
        return oStrategy. 
    end method.
end class./** ------------------------------------------------------------------------
    File        : ICache
    Purpose     : 
    Syntax      : Tracks instances for re-use in certain scopes. 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 17:03:02 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.DateTimeAddIntervalEnum.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.ICache:
    /** The interval between pruning attempts; the unit in which this is denominated is
        defined by the PruningUnit property. */
    define public property PruningInterval as integer no-undo get. set.
    
    /** Defines the uniit of measure for the PruningInterval proeprty. */
    define public property PruningUnit as DateTimeAddIntervalEnum no-undo get. set.
    
    /** Gets the activation pipeline in use for this kernel */
    define public property Pipeline as IPipeline no-undo get.
    
    /** Gets the number of entries currently stored in the cache. */
    define public property Count as integer no-undo get.
    
    /** Stores the specified instance in the cache.
         
        @param ILifecycleContext The context to store.
        @param Object The instance reference.    */
    method public void Remember(input poContext as ILifecycleContext, input poReference as Object).
    
    /** Tries to retrieve an instance to re-use in the specified context.
         
        @param ILifecycleContext The context that is being activated.
        @returns The instance for re-use, or unknown if none has been stored. */
    method public Object TryGet(input poContext as ILifecycleContext).
    
    /** Tries to get an instance's Context for use with additional decoration/injection. **/
    method public ILifecycleContext TryGetContext(input poInstance as Object).
    
    /** Deactivates and releases the specified instance from the cache. 
        @param Object The instance to release.
        @return true if the instance was found and released. otherwise false. */
    method public logical Release(input poInstance as Object).

    /** Removes instances from the cache which should no longer be re-used. */
    method public void Prune().
    
    /** Immediately deactivates and removes all instances in the cache that are owned by
        the specified scope.
        
        @param Object The scope whose instances should be deactivated. */
    method public void Clear(poScope as Object).
    
    /** Immediately deactivates and removes all instances in the cache, regardless of scope. */
    method public void Clear().
    
end interface./*------------------------------------------------------------------------
    File        : IInjectionRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 19 15:58:31 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.IInjectionRequest:
    /** The
      */         
    define public property ServiceType as class Class no-undo get.
    
    /** (optional) If a service is named in the binding, allow specification of the name
        for the request.  */
    define public property Name as character no-undo get.
    
    /** (optional) Gets the parameters that were passed to manipulate the activation process. 
    define public property Parameters as IParameterCollection no-undo get. set.
    */
  
end interface./** ------------------------------------------------------------------------
    File        : IKernel
    Purpose     : InjectABL Kernel interface
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:24:26 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */

using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.IInjectionRequest.
using OpenEdge.Core.InjectABL.ComponentContainer.
using OpenEdge.Core.InjectABL.KernelSettings.

using OpenEdge.Lang.Collections.ICollection.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.IKernel: /* inherits IBindingRoot */
    
    /** Gets the injection kernel settings  */
    define public property Settings as KernelSettings no-undo get.
    
    /** Gets the component container, which holds components that contribute to InjectABL.  */
    define public property Components as ComponentContainer no-undo get.

    /** Gets the modules that have been loaded into the kernel.  */
    define public property Modules as IInjectionModuleCollection no-undo get.

    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module.
        
        @param character A string version of a class/interface type name. 
        @return An instance of the requested service/interface    */
    method public Object Get(input pcService as character).
    
    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module. 
    
        @param Class A service represented by a Progress.Lang.Class type instance.
        @return An instance of the requested service/interface    */
    method public Object Get(input poService as class Class).
        
    /** Instantiates an instance of an object that matches the passed service and
        name, as determined by the bindings in a loaded module. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service   
        @return An instance of the requested service/interface    */
    method public Object Get(input poService as class Class,
                             input pcName as character).
    
    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module. 
    
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param ICollection A collection of arguments to add to the bindings for the
                            object being instantiated.  
        @return Object An instance of the requested service/interface    */
    method public Object Get(input poService as class Class,
                             input poArguments as ICollection).
    
    /** Determines whether a module with the specified name has been loaded in the kernel.
        
        @param character The name of the module.
        @return True if the specified module has been loaded. otherwise, <c>false</c>. */
    method public logical HasModule(input pcName as character).

    /** Loads module(s) into the kernel.
        
        @param IInjectionModuleCollection The modules to load. */
    method public void Load(input poModules as IInjectionModuleCollection).
    
    /** Loads a single module into the kernel.
        
        @param IInjectionModule The module to load. */
    method public void Load(input poModules as IInjectionModule).

    /** Loads modules from the files that match the specified pattern(s).
        @param character An array of file patterns (i.e. "*.dll", "modules/ *.rb") 
                         to match. */
    method public void Load(input pcFilePatterns as character extent).
    
    /** Unloads the plugin with the specified name.
        @param character The plugin's name. */
    method public void Unload(input pcName as char).
    
    /** Injects the specified existing instance, without managing its lifecycle.
        @param Object The instance to inject.
        @param ICollection A collection of arguments to add to the bindings for the
                            object being instantiated.  */
    method public void Inject(input poInstance as Object,
                              input poArguments as ICollection).

    /** Deactivates and releases the specified instance if it is currently managed by InjectABL.
        
        @param Object The instance to release.
        @return logical True if the instance was found and released. otherwise false. */
    method public logical Release(input poInstance as Object).

    /** Deactivates and releases all instances scoped to the specified object.
    
        @param Object The scope object for which to release instances.  */
    method public void Clear(input poScope as Object).
    
    /** Indicates whether a service is cached or not. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service
        @return Logical Returns true if the service is being cached ; false if not in cache.
                Note that a true return value doesn't mean there isn't a running instance of the service -
                since transient instances aren't cached - but only that there are no cached instances. */        
    method public logical IsCached(input poService as class Class,
                                   input pcName as character).

    /** Indicates whether a service is cached or not. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service
        @param ICollection A collection of arguments to add to the bindings for the
                            object being instantiated.        
        @return Logical Returns true if the service is being cached ; false if not in cache.        
                Note that a true return value doesn't mean there isn't a running instance of the service -
                since transient instances aren't cached - but only that there are no cached instances. */        
    method public logical IsCached(input poService as class Class,
                                   input pcName as character,
                                   input poArguments as ICollection).
    
end interface./*------------------------------------------------------------------------
    File        : InjectionRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 19 14:39:18 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.InjectionRequest:
    
    @todo(task="implement", action="implement this, so that a request can be made (pass into KernelBase:Inject() ").
    
    define public property ServiceType as class Class no-undo get. private set.
    define public property Name as character no-undo get. private set.
    
    /** (optional) Gets the parameters that were passed to manipulate the activation process. 
    define public property Parameters as IParameter extent no-undo get. set.
    */
    
    constructor public InjectionRequest(poService as class Class, pcName as char):        
        assign this-object:Name = pcName
               this-object:ServiceType = poService.
    end constructor.

    /*
    constructor public InjectionRequest(poService as class Class, pcName as char, poParameters as IParameter extent):
        this-object(poService, pcName).        
        assign this-object:Parameters = poParameters.
    end constructor.
    */
    
end class./** ------------------------------------------------------------------------
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
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.LifecycleContext.
using OpenEdge.Core.InjectABL.ICache.
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
using OpenEdge.Lang.Collections.List.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.SysError.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.KernelBase inherits BindingRoot 
        implements IKernel:        
    
    define public property Settings as KernelSettings no-undo get. private set.
    
    /** Gets the modules that have been loaded into the kernel. **/
    define public property Modules as IInjectionModuleCollection no-undo get. private set.
    
    /* Collection of bindings registered in this kernel  */
    define override public property Bindings as IMap no-undo get. private set.
    
    /** Gets the component container, which holds components that contribute to InjectABL. **/
    define public property Components as ComponentContainer no-undo get. private set.
    
    /** Stack of unique services (as define by their LifecycleContext) being invoked. Used to prevent
        circular references. */
    @todo(task="implement", action="circ reference checks").
    define protected property InvocationStack as IList no-undo get. private set.
    
    destructor public KernelBase():
        /* Clean up all the singletons (ie those scoped to this Kernel) */
        cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.ICache'))
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
        
        Bindings = new Map().

        this-object:Load(Modules).
    end constructor.
    
    @method(virtual="true").
    method protected void AddComponents():
    end method.
    
    method override public void AddBinding(input poBinding as IBinding):
        define variable oBindings as IList no-undo.
        
        Assert:ArgumentNotNull(input poBinding, "binding").
        
        oBindings = cast(Bindings:Get(input poBinding:Service), IList).
        if not valid-object(oBindings) then
        do:
            oBindings = new List().
            Bindings:Put(poBinding:Service, oBindings).
        end.
        
        oBindings:Add(input poBinding).
    end.
    
    /** Unregisters the specified binding.
        
        @param Ibinding The binding to remove. */
    method override public void RemoveBinding(input poBinding as IBinding):
        define variable oBindings as IList no-undo.
        
        Assert:ArgumentNotNull(input poBinding, "binding").
        oBindings = cast(Bindings:Get(input poBinding:Service), IList).
        if valid-object(oBindings) then
            oBindings:Remove(input poBinding).
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
        do iLoop = 1 to iMax on error undo, throw:
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
            
            /*if cFile eq ? then
                cFile = search(cFolderBase + cOriginalExtension).*/
            
            if cFile ne ? then
                run value(cFile) (input this-object).
            
            catch eSysErr as SysError:             
                case eSysErr:GetMessageNum(1):
                /* Skip cases where we have a parameter mismatch. We cannot be sure that a file on the
                   propath that matches the file pattern is definitively ours. 
                   
                   Procedure <proc> passed parameters to <proc>, which didn't expect any. (1005) */
                when 1005 then . /* Ignore these */
                otherwise undo, throw eSysErr.                                                    
                end case.
            end catch.
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
        define variable oBindings as IList no-undo.
        define variable oBinding as IBinding no-undo.
        
        oBindings = GetBindings(poService, pcName).
        
        if oBindings:IsEmpty() then
            oBinding = CreateDefaultBinding(poService).
        else
        /* if there's only one matching binding, use that one. Ahem. */
        if oBindings:Size eq 1 then
            oBinding = cast(oBindings:Get(1), IBinding).
        else
            /* Always use the first matching binding, since we assume that the bindings
               are added in PROPATH order, and that the PROPATH is ordered in importance 
               from left to right.
               
               If this behaviour is undesirable, then a setting should be added to 
               the KernelSettings object to define it, or a BindingSelection component
               created and added to the kernel. */
            oBinding = cast(oBindings:Get(1), IBinding).
        
        Assert:ArgumentNotNull(
                oBinding,
                substitute('Binding for service &1 &2', poService:TypeName, pcName)).
        
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
        
        oContext = cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.ICache'))
                , ICache):TryGetContext(poInstance).
        if not valid-object(oContext) then
            oContext = CreateContext(CreateDefaultBinding(poInstance:GetClass())).
        
        oContext:Binding:Arguments:AddAll(poArguments).
                
        cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IPipeline'))
                , IPipeline):Activate(oContext, poInstance).
    end method.
    
    method public logical Release(poInstance as Object):
        Assert:ArgumentNotNull(poInstance, "instance").
        
        return cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.ICache'))
                , ICache):Release(poInstance).
    end method.


    /** Indicates whether a service is cached or not. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service
        @return Logical Returns true if the service is being cached ; false if not in cache.
                Note that a true return value doesn't mean there isn't a running instance of the service -
                since transient instances aren't cached - but only that there are no cached instances. */        
    method public logical IsCached(input poService as class Class,
                                   input pcName as character):
        return IsCached(poService, pcName, ?).
    end method.
        
    /** Indicates whether a service is cached or not. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service
        @param ICollection A collection of arguments to add to the bindings for the
                            object being instantiated.        
        @return Logical Returns true if the service is being cached ; false if not in cache.        
                Note that a true return value doesn't mean there isn't a running instance of the service -
                since transient instances aren't cached - but only that there are no cached instances. */        
    method public logical IsCached(input poService as class Class,
                                   input pcName as character,
                                   input poArguments as ICollection):
    
        define variable oBinding as IBinding no-undo.
        define variable oContext as ILifecycleContext no-undo.
        define variable lIsCached as logical no-undo.
        
        Assert:ArgumentNotNull(poService, 'Service').
        Assert:ArgumentNotNull(pcName, 'Name').
        
        if poService:IsA(Class:GetClass('OpenEdge.Core.InjectABL.IKernel')) then
            return true.
        
        oBinding = SelectBinding(poService, pcName).
        
        if valid-object(poArguments) then
            oBinding:Arguments:AddAll(poArguments).
        
        oContext = CreateContext(oBinding).
        
        lIsCached = valid-object(
                        cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.ICache'))
                            , ICache):TryGet(oContext)).
        return lIsCached.                                                
    end method.
    
    method public void Clear(poScope as Object):
        Assert:ArgumentNotNull(poScope, "instance").
        
        cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.ICache'))
                , ICache):Clear(poScope).
    end method.
    
    method protected IList GetBindings(input poService as class Class,
                                       input pcName as character):
        return cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Binding.IBindingResolver'))
                             , IBindingResolver):Resolve(Bindings, poService, pcName).
    end method.

    method protected IBinding CreateDefaultBinding(input poService as class Class):
        define variable oBinding as IBinding no-undo.
        define variable oBuilder as IBindingSyntax no-undo.
        
        if not TypeIsSelfBindable(poService) then
            undo, throw new InvalidValueSpecifiedError(
                                'default binding',
                                ': Type ' + poService:TypeName + ' cannot bind to itself').
        
        oBuilder = Bind(poService).
        oBuilder:ToSelf().
        
        return oBinding.
    end method. 
    
    method override protected IBindingSyntax CreateBindingBuilder(input poBinding as IBinding):
        return new BindingBuilder(poBinding, this-object).
    end method.    
    
    method protected ILifecycleContext CreateContext(input poBinding as IBinding):
        Assert:ArgumentNotNull(input poBinding, "binding").
        
        return new LifecycleContext(this-object,
                                    poBinding,
                                    cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IPipeline')), IPipeline),
                                    cast(Components:Get(Class:GetClass('OpenEdge.Core.InjectABL.ICache')), ICache)).
    end method.
    
    method protected logical TypeIsSelfBindable(poService as class Class):
        return (not poService:IsAbstract() and not poService:IsInterface() ).
    end method.
    
end class.
 /** ------------------------------------------------------------------------
    File        : KernelSettings
    Purpose     : Flags/settings for the InjectABL kernel
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 11 12:05:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.KernelSettings.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.DateTimeAddIntervalEnum.

class OpenEdge.Core.InjectABL.KernelSettings inherits Map:
    
    define static public property NO_PRUNE_INTERVAL as integer init -1 no-undo get. private set.
    
    define public property CachePruningInterval as integer no-undo get. set.    
    define public property CachePruningUnit as DateTimeAddIntervalEnum no-undo get. set.
    
    constructor public KernelSettings():

        CachePruningInterval = KernelSettings:NO_PRUNE_INTERVAL.
        CachePruningUnit = DateTimeAddIntervalEnum:Default.
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : StandardKernel
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 11:23:20 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.InjectABL.KernelBase.
using OpenEdge.Core.InjectABL.ComponentContainer.
using OpenEdge.Core.InjectABL.KernelSettings.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.StandardKernel inherits KernelBase: 
    
    method protected override void AddComponents():
        /* these are mappings */
        
        /* Cache */
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.ICache'), 
                       Class:GetClass('OpenEdge.Core.InjectABL.Cache')).

        /* Pipeline */
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IPipeline'),
                       Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.StandardPipeline')).

        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy'),
                       Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.PropertyInjectionLifecycleStrategy')).
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy'),
                       Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.MethodInjectionLifecycleStrategy')).
        
        /* Binding */        
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Binding.IBindingResolver'), 
                       Class:GetClass('OpenEdge.Core.InjectABL.Binding.StandardBindingResolver')).
    end method.
    
    constructor public StandardKernel():
        super().
    end constructor.

    constructor public StandardKernel(poModules as IInjectionModuleCollection):
        super(poModules).
    end constructor.
        
    constructor protected StandardKernel (poComponents as ComponentContainer,
                                          poModules as IInjectionModuleCollection,
                                          poSettings as KernelSettings):
        super(poComponents, poModules, poSettings).
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : Binding
    Purpose     : 
    Syntax      : Contains information about a service registration.
    Description : 
    @author pjudge
    Created     : Wed Mar 03 14:28:18 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Binding.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScope.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.Lifecycle.IProvider.
using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.

using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.Collections.ObjectStack.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.TypedCollection.
using OpenEdge.Lang.Assert.
using Progress.Lang.ParameterList.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Binding implements IBinding: 
    /** Gets the service type that is controlled by the binding. */
    define public property Service as class Class no-undo get. private set.
    
    /** Gets or sets the condition defined for the binding. */
    define public property Condition as ObjectStack no-undo get. set. 
    
    /** Gets a value indicating whether the binding has a condition associated with it. */
    define public property IsConditional as logical no-undo
        get():            
            return (valid-object(Condition) and Condition:Size gt 0).
        end get.
    
    /** Gets or sets the type of target for the binding. */
    define public property Target as BindingTargetEnum no-undo get. set.
    
    /** Gets or sets the callback that returns the object that will act as the binding's scope. */
    define public property Scope as StandardScopeEnum no-undo get. set.
    define public property ScopeCallbackType as class Class no-undo
        get():
            if not valid-object(ScopeCallbackType) then
                ScopeCallbackType = Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.StandardScope').
            
            return ScopeCallbackType.
        end get.
        set.
    
    /** Gets or sets the callback that returns the provider that should be used by the binding. */
    define public property ProviderType as class Class no-undo 
        get():
            /* Default to StandardProvider */
            if not valid-object(ProviderType) then
                ProviderType = Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.StandardProvider').
            
            return ProviderType.
        end get.
        set.
    
    /** The target type of the binding. Must be a concrete class. */
    define public property TargetType as class Class no-undo get.
        set(poTargetType as class Class):
            Assert:ArgumentNotAbstract(poTargetType).
            
            TargetType = poTargetType.            
        end set.
    
    /** Gets the parameters defined for the binding. */
    define public property Arguments as ICollection no-undo get. private set.
    
    /** Gets or sets the optional name defined for the binding. */
    define public property Name as character no-undo get. set.
    
    constructor public Binding(poService as class Class):
        Assert:ArgumentNotNull(poService, "service").
        
        /* Binding defaults to self-binding */
        
        assign Service = poService
               Arguments = new TypedCollection(Class:GetClass('OpenEdge.Core.InjectABL.Binding.Parameters.Routine'))
               Scope = StandardScopeEnum:Transient.
    end constructor.
    
    /** Gets the provider for the binding.
        
        @return IProvider The provider to use.    */        
    method public IProvider GetProvider():
        define variable oProvider as IProvider no-undo.
        
        oProvider = StandardProvider:GetProvider(this-object:ProviderType, this-object:Service).
        
        return oProvider.
    end method.
    
    /** Gets the scope for the binding, if any.
        @param context The context.
        @return The object that will act as the scope, or unknown if the service is transient.
     */
    method public Object GetScope(poContext as ILifecycleContext):
        Assert:ArgumentNotNull(poContext, "context").
        
        /** Unfortunately, we can't do any type-checking, since the GetScope() call is
            make statically. */
        return dynamic-invoke(ScopeCallbackType:TypeName, 'GetScope', poContext, Scope).
    end method.
    
    /** Determines whether the specified request satisfies the conditions defined on this binding.
        @param request The request.
        @return <c>True</c> if the request satisfies the conditions. otherwise <c>false</c>.
     */
    method public logical Matches(poBinding as IBinding):
        define variable lMatches as logical no-undo.
        
        Assert:ArgumentNotNull(poBinding, "binding").
        
        return lMatches.
    end method.
    
    method override public Object Clone():
        define variable oClone as IBinding no-undo.
        define variable oPL as ParameterList no-undo.
                
        oPL = new ParameterList(1).
        oPL:SetParameter(1,
                         DataTypeEnum:Class:ToString(),
                         IOModeEnum:Input:ToString(),
                         this-object:Service).
        
        assign oClone = cast(this-object:GetClass():New(oPL), IBinding)
               
               oClone:Condition = cast(this-object:Condition:Clone(), ObjectStack)
               oClone:Target = this-object:Target
               oClone:Scope = this-object:Scope
               oClone:ScopeCallbackType = this-object:ScopeCallbackType
               oClone:ProviderType = this-object:ProviderType
               oClone:TargetType = this-object:TargetType
               oClone:Name = this-object:Name.
        
        /* Create a new set of arguments, but keep the actual arguments the same
           (ie this is a reasonably shallow copy)  */
        oClone:Arguments:Add(this-object:Arguments).
        
        return oClone. 
    end method.
    
end class.
/*------------------------------------------------------------------------
    File        : BindingBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 14:51:10 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.ConditionBuilder.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.UITypeCondition.
using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.

using OpenEdge.Lang.SessionClientTypeEnum.
using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.BindingBuilder implements IBindingSyntax:
    
    /** Gets the binding being built.  */
    define public property Binding as IBinding no-undo get. private set.
    
    /** Gets the kernel.  */
    define public property Kernel as IKernel no-undo get. private set.
    
    /** Initializes a new instance of the BindingBuilder&lt.T&gt. class.
        @param IBinding The binding to build.
        @param IKernel The kernel. */
    constructor public BindingBuilder(input poBinding as IBinding, input poKernel as IKernel):
        Assert:ArgumentNotNull(poBinding, "binding").
        Assert:ArgumentNotNull(poKernel, "kernel").
        
        Binding = poBinding.
        Kernel = poKernel.
    end constructor.
    
    /** Indicates that the service should be self-bound.
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax ToSelf():   
        Binding:TargetType = Binding:Service.
        Binding:Target = BindingTargetEnum:Self.
                
        return this-object.
    end method.
    
    /** Indicates that the service should be bound to the specified implementation type.
        @param character The implementation type name.
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax To(input pcImplementation as character):
        Assert:ArgumentIsValidType(pcImplementation).
        
        return this-object:To(Class:GetClass(pcImplementation)).
    end method.

    /** Indicates that the service should be bound to the specified implementation type.
        
        @param Class The implementation type. This has to be a concrete type (ie not abstract 
               or an interface). 
        @return IBindingSyntax The current binding builder (for fluent syntax) */    
    method public IBindingSyntax To(input poImplementation as class Class):
        Binding:TargetType = poImplementation.
        Binding:Target = BindingTargetEnum:Type.
        
        return this-object.
    end method.
    
    /** Indicates that the service should be bound to an instance of the specified provider type.
        The instance will be activated via the kernel when an instance of the service is activated.
        
        @param poProviderTypecharacter The type name of provider to activate.
        @return IBindingSyntax The current binding builder (for fluent syntax)  */
    method public IBindingSyntax Using(input pcProviderType as character):
        Assert:ArgumentIsValidType(pcProviderType).
        
        return this-object:Using(Class:GetClass(pcProviderType)).
    end method.
    
    /** Indicates that the service should be bound to an instance of the specified provider type.
        The instance will be activated via the kernel when an instance of the service is activated.
        
        @param Class The type of provider to activate.
        @return IBindingSyntax The current binding builder (for fluent syntax)  */    
    method public IBindingSyntax Using(input poProviderType as class Class):
        Binding:ProviderType = poProviderType.
        return this-object.
    end method.
        
    /** Indicates that only a single instance of the binding should be created, and then
        should be re-used for all subsequent requests.  */
    method public IBindingSyntax InSingletonScope():
        Binding:Scope = StandardScopeEnum:Singleton.        
        return this-object.
    end method.
    
    /** Indicates that instances activated via the binding should not be re-used, nor have
        their lifecycle managed by InjectABL.  
        
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax InTransientScope():
        Binding:Scope = StandardScopeEnum:Transient.
        return this-object.
    end method.
    
    /** Indicates that an instance will be reused across an AppServer connection. 
        Meaningless for statefree AppServers. 
        
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax InAgentConnectionScope():
        Binding:Scope = StandardScopeEnum:AgentConnection.
        return this-object.
    end method.
    
    /** Indicates that an instance will be reused across an AppServer request.
     
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax InAgentRequestScope():
        Binding:Scope = StandardScopeEnum:AgentRequest.
        return this-object.
    end method.
    
    /** Generic scope binding
        
        @param Class The type providing the scope
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax InScope(input poScopeCallback as class Class, poScope as StandardScopeEnum):
        Assert:ArgumentNotNull(poScopeCallback, 'Custom scope callback type').
        Assert:ArgumentNotNull(poScope, 'Custom scope').
                
        /* Even though this is statically-called, we can still type-check */
        Assert:ArgumentIsType(poScopeCallback, Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.StandardScope')).
        
        Binding:Scope = poScope.
        Binding:ScopeCallbackType = poScopeCallback.
        
        return this-object.
    end method.
    
/* WithConstructorArgument */
    /* generalised case; all other WithConstructorArgument() methods pass through this one. */
    method public IBindingSyntax WithConstructorArgument(input poParameter as IParameter extent):    
        define variable oRoutine as Routine no-undo.
        
        oRoutine = new Routine(Binding:Service, '', RoutineTypeEnum:Constructor).
        oRoutine:Parameters = poParameter.
        
        Binding:Arguments:Add(oRoutine).
        return this-object.
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as class Class, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        oParameter[1]:ServiceInstanceName = pcInstanceName.
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as class Class, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poValue as class Class, poDataType as DataTypeEnum, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDataType).
        oParameter[1]:ServiceInstanceName = pcInstanceName.
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poService as class Class extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poService as class Class extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poValue as Object, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent):
        define variable oParameter as IParameter extent 1 no-undo.
        
        /* compiler should call WithConstructorArg(IParameter[]) not this one! */
        Assert:ArgumentNotType(poValue[1], Class:GetClass('OpenEdge.Core.InjectABL.Binding.Parameters.IParameter')).

        oParameter[1] = new Parameter(poValue).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(pcValue as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(pcValue as character, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(pcValue as character extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(pcValue as character extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
/* WithPropertyValue */
    /** Generalised case for more complex scenarios; all other WithPropertyValue() methods pass through this one. This method will probably never be called directly, but
        it doesn't hurt to have here. */
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character,
                                                   input poParameter as IParameter extent).    
        define variable oRoutine as Routine no-undo.
        
        oRoutine = new Routine(Binding:Service, pcPropertyName, RoutineTypeEnum:PropertySetter).
        oRoutine:Parameters = poParameter.
        
        Binding:Arguments:Add(oRoutine).
        return this-object.
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, pcInstanceName).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class, poDataType as DataTypeEnum, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType, pcInstanceName).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class  Class extent ):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object ):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).

        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.
        
        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object extent, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
        
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character ):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
/* WithMethodValue */
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poService as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poService).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poService as class Class, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, pcInstanceName).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poService as class Class extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poService).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDeclaringType).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object):
        define variable oParameter as IParameter extent 1 no-undo.
        
        oParameter[1] = new Parameter( poValue).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
        
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as class Class, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDataType).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as class Class, poDataType as DataTypeEnum, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDataType, pcInstanceName).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object extent, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDeclaringType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as class Class extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDataType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( pcValue).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( pcValue).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( pcValue, poDataType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character,
                                                 input poParameter as IParameter extent):
        define variable oRoutine as Routine no-undo.
        
        oRoutine = new Routine(Binding:Service, pcMethodName, RoutineTypeEnum:Method).
        oRoutine:Parameters = poParameter.
        
        Binding:Arguments:Add(oRoutine).
        return this-object.
    end method.
    
    /* When */    
    method public IConditionSyntax When():
        define variable oConditionBuilder as IConditionSyntax no-undo.
        
        if valid-object(Binding:Condition) then
            oConditionBuilder = new ConditionBuilder(Binding:Condition).
        else
            oConditionBuilder = new ConditionBuilder(Binding).
        
        return oConditionBuilder.
    end method.
    
    /** Binding is applicable to a client session. This is typically a GUI or thin-client of some sort */
    method public IBindingSyntax OnThinClientSession():
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        oConditionSyntax = this-object:When().
        oConditionSyntax:Condition(Condition:Type):Is(SessionTypeCondition:ThinClient).

        return this-object.
    end method.

    /** Binding applicable to a server session. This is any headless backend - appserver, webserver etc */
    method public IBindingSyntax OnServerSession():
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        oConditionSyntax = this-object:When().
        oConditionSyntax:Condition(Condition:Type):Is(SessionTypeCondition:Server).

        return this-object.
    end method.

    /** Binding is applicable to a complete client/server session. Typically a development environment, or fat client */
    method public IBindingSyntax OnFatClientSession():
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        oConditionSyntax = this-object:When().
        oConditionSyntax:Condition(Condition:Type):Is(SessionTypeCondition:FatClient).

        return this-object.
    end method.
    
    /** Indicates that the binding is valid for a session as identified by an application-specific code/name */
    method public IBindingSyntax OnNamedSession(input pcSessionCode as character).
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        oConditionSyntax = this-object:When().
        oConditionSyntax:Condition(Condition:Name):Is(new SessionTypeCondition(pcSessionCode)).
        
        return this-object.
    end method.
    
    method public IBindingSyntax Named(pcName as character):
        Binding:Name = pcName.
        return this-object.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : BindingRoot
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:56:07 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.IBindingRoot.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.Binding.
using OpenEdge.Core.InjectABL.Binding.IBindingCollection.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Binding.BindingRoot abstract 
        implements IBindingRoot:
    
    /** A collection of bindings, keyed by the service they bind to. */
    define abstract public property Bindings as IMap no-undo get.
    
    /** Declares a binding from the service to itself.        
        @param character The service to bind. */
    method public IBindingSyntax Bind(input pcService as char):
        Assert:ArgumentIsValidType(pcService).
        return this-object:Bind(Class:GetClass(pcService)).
    end method.
    
    /** Declares a binding from the service to itself.        
        @param Class The service to bind. */    
    method public IBindingSyntax Bind(input poService as class Class):
        define variable oBinding as IBinding no-undo.
        
        Assert:ArgumentNotNull(poService, 'Service').
        
        oBinding = new Binding(poService).
        AddBinding(oBinding).
        
        return CreateBindingBuilder(oBinding).
    end method.
    
    /** Unregisters all bindings for the specified service.
        
        @param Class The service to unbind. */    
    method public void Unbind(poService as class Class):
        define variable oBindings as ICollection no-undo.
        define variable oIterator as IIterator no-undo.
        
        assign oBindings = cast(Bindings:Get(poService), ICollection)
               oIterator = oBindings:Iterator().
        do while oIterator:HasNext():
            RemoveBinding(cast(oIterator:Next(), IBinding)).
        end.
    end method.

    /** Unregisters all bindings for the specified service.
        
        @param character The service to unbind. */
    method public void Unbind(pcService as char):
        Assert:ArgumentIsValidType(pcService).
        
        Unbind(Class:GetClass(pcService)).
    end method.
    
    /** Removes any existing bindings for the specified service, and declares a new one.
        
        @param character The service to re-bind. **/
    method public IBindingSyntax Rebind(pcService as character):
        Assert:ArgumentIsValidType(pcService).
        
        return Rebind(Class:GetClass(pcService)).
    end method.

    /** Removes any existing bindings for the specified service, and declares a new one.
        
        @param Class The service to re-bind. **/
    method public IBindingSyntax Rebind(poService as class Class):
        Unbind(poService).
        return Bind(poService).
    end method.
    
    /** Registers the specified binding.
        
        @param IBinding The binding to add. */    
    method abstract public void AddBinding(poBinding as IBinding).

    /** Unregisters the specified binding.
        @param IBinding The binding to remove. */
    method abstract public void RemoveBinding(poBinding as IBinding).
    
    method abstract protected IBindingSyntax CreateBindingBuilder(poBinding as IBinding).
    
end class./** ------------------------------------------------------------------------
    File        : BindingTarget
    Purpose     : Enumeration of InjectABL binding target types 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:37:41 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.InjectABL.Binding.BindingTargetEnum inherits EnumMember: 
    /** Indicates that the binding is from a type to itself. **/
    define static public property Self as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from one type to another. **/
    define static public property Type as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from a type to a provider. **/
    define static public property Provider as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from a type to a callback method. **/
    define static public property Method as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from a type to a constant value. **/
    define static public property Constant  as BindingTargetEnum no-undo get. private set.
        
    constructor static BindingTargetEnum():
        BindingTargetEnum:Self = new BindingTargetEnum().
        BindingTargetEnum:Type = new BindingTargetEnum().
        BindingTargetEnum:Provider = new BindingTargetEnum().
        BindingTargetEnum:Method = new BindingTargetEnum().
        BindingTargetEnum:Constant = new BindingTargetEnum().
    end constructor.
    
    constructor public BindingTargetEnum():
        super(?,?).
    end constructor.
        
end class./** ------------------------------------------------------------------------
    File        : IBinding
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:30:06 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.Binding.IBinding.
/*using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.*/
using OpenEdge.Core.InjectABL.Lifecycle.IProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.Collections.ObjectStack.
using OpenEdge.Lang.Collections.ICollection.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.Binding.IBinding:
    /** Gets the service type that is controlled by the binding. */
    define public property Service as class Class no-undo get.
    
    /** Gets or sets the type of target for the binding. */
    define public property Target as BindingTargetEnum no-undo get. set.
    define public property TargetType as class Class no-undo get. set.
    
    @todo(task="implement", action="").
    /** Gets or sets  the optional name defined for the binding target. 
    define public property TargetName as character no-undo get. set.
    */
    
    /** Gets a value indicating whether the binding has a condition associated with it. */
    define public property IsConditional as logical no-undo get.
    
    /** Gets or sets the condition defined for the binding. */
    define public property Condition as ObjectStack no-undo get. set.
    
    /** Gets or sets the type that returns the provider that should be used by the binding. */
    define public property ProviderType as class Class no-undo get. set.
    
    /** Gets or sets the callback that returns the object that will act as the binding's scope. */
    define public property Scope as StandardScopeEnum no-undo get. set. 
    define public property ScopeCallbackType as class Class no-undo get. set.
    
    /** Gets the parameters defined for the binding. */
    define public property Arguments as ICollection no-undo get.
    
    /** Gets or sets  the optional name defined for the binding. */
    define public property Name as character no-undo get. set.
    
    /** Gets the provider for the binding.
        @param context The context.
        @return The provider to use.    */
    method public IProvider GetProvider().
    
    /** Gets the scope for the binding, if any.
        @param context The context.
        @return The object that will act as the scope, or unknown if the service is transient. */
    method public Object GetScope(poContext as ILifecycleContext).

    /** Determines whether the specified request satisfies the conditions defined on this binding.
        @param request The request.
        @return <c>True</c> if the request satisfies the conditions. otherwise <c>false</c>. */
    method public logical Matches(poBinding as IBinding).
    
end interface./*------------------------------------------------------------------------
    File        : IBindingCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 14:07:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.TypedList.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Binding.IBindingCollection inherits TypedList:
    
    constructor public IBindingCollection():
        super(Class:GetClass('OpenEdge.Core.InjectABL.Binding.IBinding')).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : IBindingResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 09 08:59:51 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.

using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Collections.IMap.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Binding.IBindingResolver:
    
    /** Returns valid binding(s) for the service from a set of bindings
        
        @param IMap The complete set of bindings to resolve
        @param Class The service type
        @param character The binding name
        @return IList  The list of bindings corresponding to the service & name */
    method public IList Resolve(input poBindings as IMap,
                                input poService as class Class,
                                input pcName as character).
    
end interface./** ------------------------------------------------------------------------
    File        : IBindingRoot
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:26:29 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Lang.Collections.IMap.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Binding.IBindingRoot:
    /** A collection of bindings, keyed by the service they bind to. */
    define public property Bindings as IMap no-undo get.
    
    /** Declares a binding from the service to itself.        
        @param Class The service to bind. */
    method public IBindingSyntax Bind(input poService as class Class).
        
    /** Declares a binding from the service to itself.        
        @param character The service to bind. */
    method public IBindingSyntax Bind(input pcService as character).
    
    /** Unregisters all bindings for the specified service.
        
        @param Class The service to unbind. */
    method public void Unbind(input poService as class Class).

    /** Unregisters all bindings for the specified service.
        
        @param character The service to unbind. */
    method public void Unbind(input pcService as character).
    
    /** Removes any existing bindings for the specified service, and declares a new one.
        
        @param Class The service to re-bind. **/
    method public IBindingSyntax Rebind(input poService as class Class).

    /** Removes any existing bindings for the specified service, and declares a new one.
        
        @param character The service to re-bind. **/
    method public IBindingSyntax Rebind(input pcService as character).
    
    /** Registers the specified binding.
        
        @param IBinding The binding to add. */
    method public void AddBinding(input poBinding as IBinding).
    
    /** Unregisters the specified binding.
        @param IBinding The binding to remove. */
    method public void RemoveBinding(input poBinding as IBinding).
    
end interface./*------------------------------------------------------------------------
    File        : IBindingSyntax
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 14:45:09 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.

using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.Binding.IBindingSyntax:
    
    @IBindingToSyntax.
    /** Indicates that the service should be self-bound.  */
    method public IBindingSyntax ToSelf().
    
    /** Indicates that the service should be bound to the specified implementation type.  */
    method public IBindingSyntax To(input poImplementation as class Class).
    method public IBindingSyntax To(input pcImplementation as character).
    
    @IBindingUsingSyntax.
    /** Indicates that the service will be constructed with an instance of the specified provider type.  */
    method public IBindingSyntax Using(input poProvider as class Class).
    method public IBindingSyntax Using(input pcProvider as character).
        
    @IBindingInSyntax.
    /** Indicates that only a single instance of the binding 
        should be created, and then should be re-used for all 
        subsequent requests.  */
    method public IBindingSyntax InSingletonScope().

    /** Indicates that instances activated via the binding should not be re-used, nor have
        their lifecycle managed by InjectABL.  */
    method public IBindingSyntax InTransientScope().
    
    /** Indicates that an instance will be reused across an AppServer connection. 
        Meaningless for statefree AppServers. */
    method public IBindingSyntax InAgentConnectionScope().
    /** Indicates that an instance will be reused across an AppServer request. */
    method public IBindingSyntax InAgentRequestScope().
    
    /* Custom scope */    
    method public IBindingSyntax InScope(input poScopeCallback as class Class, input poScope as StandardScopeEnum).
    
    @IBindingOnSyntax.
    /** Binding is applicable to a client session. This is typically a GUI or thin-client of some sort */
    method public IBindingSyntax OnThinClientSession().
    /** Binding applicable to a server session. This is any headless backend - appserver, webserver etc */
    method public IBindingSyntax OnServerSession().
    /** Binding is applicable to a complete client/server session. Typically a development environment, or fat client */
    method public IBindingSyntax OnFatClientSession().
    /** Indicates that the binding is valid for a session as identified by an application-specific code/name */
    method public IBindingSyntax OnNamedSession(input pcSessionCode as character).
    
    /*
    @IBindingConnectedToSyntax.
    method public IBindingSyntax ConnectedToAppServer(input pcAppServerName as character).
    method public IBindingSyntax ConnectedToDatabase(input pcDbName as character).
    method public IBindingSyntax ConnectedTo(input poConnectionType as ConnectionTypeEnum, input pcConnectionName as character).
    */
    
    /** Certain UI platforms support multiple UI technologies (eg ABL and .NET on GUI Windows).
    @IBindingAsSyntax.
    method public IBindingSyntax AsChui().
    method public IBindingSyntax AsAblGui().
    method public IBindingSyntax AsDotNetGui().
    method public IBindingSyntax AsRiaGui().   
    */
    
    @IBindingWhenSyntax.
    method public IConditionSyntax When().
    
    @IBindingWithSyntax.
    /** Parameters can be passed as type Progress.Lang.Class; in this case, they could be a service to be 
        invoked by InjectABL, or a simple reference which the application uses for its own purposes. For
        simple references, we specify DataTypeEnum:ProgressLangObject in the methods that support it; 
        for a service we specify DataTypeEnum:Class.

        If the overload with PLO is called and a PLC passed in, we assume it's a service.
        
        The default is a Service (ie DataTypeEnum:Class or DataTypeEnum:ClassArray).
        
        If a Service is being used, we can specify an optional InstanceName, but only for scalar values.
        
        All the With*() methods have the follwoing return signature
        @return IBindingSyntax The binding being constructed, for a fluent interface. */    

    /** Generalised case for more complex scenarios; all other WithConstructorArgument() methods pass through this one. */
    method public IBindingSyntax WithConstructorArgument(input poParameter as IParameter extent).    

    /** Indicates that the specified constructor argument should be overridden with the specified value. */
    method public IBindingSyntax WithConstructorArgument(input poService as class Class).
    method public IBindingSyntax WithConstructorArgument(input poService as class Class, input pcInstanceName as character).
    method public IBindingSyntax WithConstructorArgument(input poService as class Class, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithConstructorArgument(input poService as class Class, input poDataType as DataTypeEnum, input pcInstanceName as character).
    
    method public IBindingSyntax WithConstructorArgument(input poService as class Class extent).
    method public IBindingSyntax WithConstructorArgument(input poService as class Class extent, input poDataType as DataTypeEnum).
    
    method public IBindingSyntax WithConstructorArgument(input poValue as Object).
    method public IBindingSyntax WithConstructorArgument(input poValue as Object, input poDeclaringType as class Class).
    method public IBindingSyntax WithConstructorArgument(input poValue as Object extent).
    method public IBindingSyntax WithConstructorArgument(input poValue as Object extent, input poDeclaringType as class Class).
    
    method public IBindingSyntax WithConstructorArgument(input pcValue as character).
    method public IBindingSyntax WithConstructorArgument(input pcValue as character, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithConstructorArgument(input pcValue as character extent).
    method public IBindingSyntax WithConstructorArgument(input pcValue as character extent, input poDataType as DataTypeEnum).
    
    /** Indicates that the specified property should be injected with the specified value.  */
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as class Class).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as class Class, input pcInstanceName as character).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as class Class, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as class Class, input poDataType as DataTypeEnum, input pcInstanceName as character).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as class Class extent).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as class Class extent, input poDataType as DataTypeEnum).
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poValue as Object).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poValue as Object, input poDeclaringType as class Class).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poValue as Object extent).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poValue as Object extent, input poDeclaringType as class Class).
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input pcValue as character).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input pcValue as character, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input pcValue as character extent).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input pcValue as character extent, input poDataType as DataTypeEnum).
    
    /** Generalised case for more complex scenarios; all other WithPropertyValue() methods pass through this one. This method will probably never be called directly, but
        it doesn't hurt to have here. */
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poParameter as IParameter extent).    
    
    /** Indicates that the specified method should be injected with the specified value.  */
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as class Class).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as class Class, input pcInstanceName as character).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as class Class, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as class Class, input poDataType as DataTypeEnum, input pcInstanceName as character).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as class Class extent).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as class Class extent, input poDataType as DataTypeEnum).
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poValue as Object).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poValue as Object, input poDeclaringType as class Class).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poValue as Object extent).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poValue as Object extent, input poDeclaringType as class Class).
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input pcValue as character).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input pcValue as character, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input pcValue as character extent).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input pcValue as character extent, input poDataType as DataTypeEnum).
    
    /** Generalised case for more complex scenarios; all other WithMethodValue() methods pass through this one. */
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poParameter as IParameter extent).
    
    @IBindingNamedSyntax.
    /** Gives the service an instance name. By default this is the service name  */
    method public IBindingSyntax Named(input pcInstanceName as character).
    
end interface./**------------------------------------------------------------------------
    File        : StandardBindingResolver
    Purpose     : Returns all bindings for (typically) a service that meet
                  service, name and condition requirements. More than one
                  binding may be returned. The decision of which binding to
                  use is done by the InjectABL Kernel.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 09 09:02:30 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.Binding.IBindingResolver.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.System.NotFoundError.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Collections.List.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.ObjectStack.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.StandardBindingResolver implements IBindingResolver:
    
    /** Returns valid binding(s) for the service from a set of bindings
        
        @param IMap The complete set of bindings to resolve
        @param Class The service type
        @param character The binding name
        @return IList  The list of bindings corresponding to the service & name */
    method public IList Resolve(input poBindings as IMap,
                                input poService as class Class,
                                input pcName as character):
        define variable oResolvedBindings as IList no-undo.
        define variable oServiceBindings as IList no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oBinding as IBinding no-undo.
        
        oServiceBindings = cast(poBindings:Get(poService), IList).
        if not valid-object(oServiceBindings) then
            undo, throw new NotFoundError(
                    substitute('Service &1', poService:TypeName),
                    'kernel bindings').

        assign oResolvedBindings = new List().
               oIterator = oServiceBindings:Iterator().
        
        do while oIterator:HasNext():
            oBinding = cast(oIterator:Next(), IBinding).
            
            /* Names need to match */
            if oBinding:Name ne pcName then
                next.
            
            /* All conditions need to be satisfied */
            if oBinding:IsConditional and
               not ResolveCondition(oBinding) then
                next.
            
            /* We can use this binding */
            oResolvedBindings:Add(oBinding).
        end.
        
        return oResolvedBindings.
    end method.
    
    /** Resolved the conditions attached to a binding
        
        @param IBinding The biding in question
        @return Logical Whether the binding meets the conditions or not. */
    method protected logical ResolveCondition(input poBinding as IBinding):
        define variable oFIFOConditions as ObjectStack no-undo.
        define variable oCondition as ICondition no-undo.
        define variable lConditionsMet as logical no-undo.
        define variable lSubconditionMet as logical no-undo.
        define variable oLHS as ICondition no-undo.
        define variable oClauseOperator as ICondition no-undo.
        define variable oRHS as ICondition no-undo.
        define variable oOperator as ICondition no-undo.
        
        /* Extract the stack since we basically want to stack to be immutable, since we may
           use the binding again. Pop() will clear the stack. */
        oFIFOConditions = cast(poBinding:Condition:Clone(), ObjectStack).
        /* Invert the stack since we want to work backwards through the stack - FIFO rather than 
           LIFO - since the conditions are added 'forwards' and we want to read 'em that way. */
        oFIFOConditions:Invert().

        lConditionsMet = true.
        
        do while oFIFOConditions:Size gt 0:
            assign oCondition = cast(oFIFOConditions:Pop(), ICondition).
            
            case oCondition:
                /* 'When' starts a new set of evaluations. We treat this as an And (true);
                   this is necessary for cases where there is only one condition. */ 
                when Condition:When then
                    assign oOperator = Condition:And
                           lSubconditionMet = true.
                
                when Condition:And or 
                when Condition:Or then
                    oOperator = oCondition.
                
                otherwise
                    /* Clauses appear on the stack as Condition, Is/Not, Condition */
                    assign oLHS = oCondition
                           oClauseOperator = cast(oFIFOConditions:Pop(), ICondition) 
                           oRHS = cast(oFIFOConditions:Pop(), ICondition)
                           /* Use RHS for resolver, since the RHS is more likely to be more specialised:
                              the LHS might be 'Name' and the RHS refer to a session type or ui type.
                              
                              The resolver can check the LHS if it chooses to, for type compatability */            
                           lSubconditionMet = oRHS:GetResolver():EvaluateClause(oLHS, oClauseOperator, oRHS).
            end case.
            
            /* if need be, do the comparison */
            if valid-object(oOperator) then
            do:
                case oOperator:
                    when Condition:Or then
                    do:
                        lConditionsMet = lConditionsMet or lSubconditionMet.
                        
                        /* If we've satisfied at least one of the OR conditions,
                           we can leave this When block. Don't leave is the conditions
                           are false, since we may come across a true condition later. */
                        if lConditionsMet then
                            leave.
                    end.
                    
                    when Condition:And then
                    do:
                        lConditionsMet = lConditionsMet and lSubconditionMet.
                        
                        /* If we come across a single false condition, leave, since we know there
                           is nothing more to do.  */
                        if not lConditionsMet then
                            leave.
                    end.
                end case.   /* operator */
            end.    /* valid operator */
        end.   /* stuff on stack */
        
        return lConditionsMet.
    end method.
    
end class./*------------------------------------------------------------------------
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

    /* general condition types, to avoid having a SessionName and UIType etc. */
    define static public property Name as ICondition no-undo get. private set.
    define static public property Type as ICondition no-undo get. private set.
    
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

               Condition:Name = new Condition('Name')
               Condition:Type = new Condition('Type')
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
    
end class./** ------------------------------------------------------------------------
    File        : ConditionBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 08 11:50:07 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.IKernel.

using OpenEdge.Lang.Collections.ObjectStack.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.

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

/*
    define public property Is as IConditionSyntax no-undo
        get():
            BindingCondition:Push(Condition:Is).
            return this-object. 
        end get.
        
    define public property Not as IConditionSyntax no-undo
        get():
            BindingCondition:Push(Condition:Not).
            return this-object. 
        end get.
*/
    
    constructor public ConditionBuilder(input poBindingCondition as ObjectStack):
        BindingCondition = poBindingCondition.
        BindingCondition:Push(Condition:And).
    end constructor.
    
    constructor public ConditionBuilder(input poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "Binding").
        
        /* Guesstimate at default depth. */
        BindingCondition = new ObjectStack(10).
        BindingCondition:AutoExpand = true.
        
        poBinding:Condition = BindingCondition.
        
        BindingCondition:Push(Condition:When).
    end constructor.
    
    method public IConditionSyntax Condition(input poCondition as ICondition).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
    method public IConditionSyntax Is(input poCondition as ICondition):
        BindingCondition:Push(Condition:Is).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
    method public IConditionSyntax Not(input poCondition as ICondition):
        BindingCondition:Push(Condition:Not).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : ConnectionCondition
    Purpose     : Session type and session code conditions for bindings.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 11:02:32 EST 2010
    Notes       : * We need a separate Condition class here since we want to 
                    have our own ConditionResolver, since there may be 
                    some special treatment
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.ConnectionCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.StandardConditionResolver.

using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Conditions.ConnectionCondition inherits Condition:
    define static public property CurrentConnection as ICondition no-undo get. set.
    
    define static private property ConditionResolverType as class Class no-undo get. set.
    
    constructor static ConnectionCondition():
          ConnectionCondition:CurrentConnection = new ConnectionCondition('CURRENT_CONNECTIONS'). 
          ConnectionCondition:ConditionResolverType = Class:GetClass('OpenEdge.Core.InjectABL.Binding.Conditions.ConnectionConditionResolver').
    end constructor.
    
    constructor public ConnectionCondition (input pcValue as character):
        super(pcValue).
    end constructor.

    constructor public ConnectionCondition (input poValue as Object):
        super (input poValue).
    end constructor.
    
    method override public IConditionResolver GetResolver():
        return StandardConditionResolver:GetResolver(ConnectionCondition:ConditionResolverType). 
    end method.
    
end class.
/** ------------------------------------------------------------------------
    File        : ConnectionConditionResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 29 10:05:25 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.

class OpenEdge.Core.InjectABL.Binding.Conditions.ConnectionConditionResolver implements IConditionResolver:
    
    constructor public ConnectionConditionResolver():
    end constructor. 

    /** Evaluates the provided conditions. 
        
        @param ICondition The left-hand side argument for the clause
        @param ICondition The clause operator
        @param ICondition The right-hand side argument for the clause
        @return logical Whether the clause resolves to true or false.  */
    method public logical EvaluateClause(input poLHS as ICondition,
                                         input poOperator as ICondition,
                                         input poRHS as ICondition):
        define variable lConditionsMet as logical no-undo.
        
        case poOperator:
            when Condition:Is  then lConditionsMet = poLHS:Equals(poRHS).
            when Condition:Not then lConditionsMet = not poLHS:Equals(poRHS).
        end case.
        
        return lConditionsMet.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : ICondition
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 10:53:22 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Binding.Conditions.ICondition:
    
    /** Returns the resolver used for this condition.
        
        @return IConditionResolver The object used to evaluate a condition of this type. */
    method public IConditionResolver GetResolver().
    
end interface./** ------------------------------------------------------------------------
    File        : IConditionResolver
    Purpose     : InjectABL condition resolution interface.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 10 13:19:00 EST 2010
    Notes       : * Not all conditions resolve as simply as X:Equals(Y);
                    for example, the session type resolves may depend on
                    whether there are AppServers or DBs connected to determine
                    the validity of a clause.
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.

interface OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver:
    
    /** Evaluates the provided conditions. 
        
        @param ICondition The left-hand side argument for the clause
        @param ICondition The clause operator
        @param ICondition The right-hand side argument for the clause
        @return logical Whether the clause resolves to true or false
         */
    method public logical EvaluateClause(input poLHS as ICondition,
                                         input poOperator as ICondition,
                                         input poRHS as ICondition).
    
end interface./* ------------------------------------------------------------------------
    File        : IConditionSyntax
    Purpose     : Defines the syntax for operating with conditions used for
                  resolving InjectABL bindings 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 08 12:02:20 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.

interface OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax:
    define public property And as IConditionSyntax no-undo get.
    define public property Or as IConditionSyntax no-undo get.

    method public IConditionSyntax Condition(input poCondition as ICondition).
    
    method public IConditionSyntax Is(input poCondition as ICondition).
    method public IConditionSyntax Not(input poCondition as ICondition).
    
/*
    method public IConditionSyntax First(input poCondition as ICondition).
    method public IConditionSyntax Last(input poCondition as ICondition).
    method public IConditionSyntax Unique(input poCondition as ICondition).
*/
    
end interface./** ------------------------------------------------------------------------
    File        : SessionTypeCondition
    Purpose     : Session type and session code conditions for bindings.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 11:02:32 EST 2010
    Notes       : * We need a separate Condition class here since we want to 
                    have our own ConditionResolver, since there may be 
                    some special treatment
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.StandardConditionResolver.

using OpenEdge.Lang.String.
using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition inherits Condition:
    
    /* ThinClient, Server, FatClient used for RHS, to compare to the 'Condition:Type' condition */
    define static public property ThinClient as SessionTypeCondition no-undo get. private set. 
    define static public property Server     as SessionTypeCondition no-undo get. private set.
    define static public property FatClient  as SessionTypeCondition no-undo get. private set.
    
    define static private property ConditionResolverType as class Class no-undo get. set.
    
    constructor static SessionTypeCondition():
        assign SessionTypeCondition:ThinClient = new SessionTypeCondition('ThinClient')
               SessionTypeCondition:Server = new SessionTypeCondition('Server')
               SessionTypeCondition:FatClient = new SessionTypeCondition('FatClient')
               
               SessionTypeCondition:ConditionResolverType = Class:GetClass('OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeConditionResolver').
    end constructor.
    
    constructor public SessionTypeCondition (input pcValue as character):
        super (new String(pcValue)).
    end constructor.

    constructor public SessionTypeCondition (input poValue as Object):
        super (input poValue).
    end constructor.
    
    method override public IConditionResolver GetResolver():
        return StandardConditionResolver:GetResolver(SessionTypeCondition:ConditionResolverType). 
    end method.
    
end class.
/** ------------------------------------------------------------------------
    File        : SessionTypeConditionResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 29 10:05:25 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.

using OpenEdge.Lang.SessionClientTypeEnum.
using OpenEdge.Lang.ABLSession.

class OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeConditionResolver implements IConditionResolver:
    
    constructor public SessionTypeConditionResolver():
    end constructor. 
    
    /** Evaluates the provided conditions. 
        
        @param ICondition The left-hand side argument for the clauseRdatas
        @param ICondition The clause operator
        @param ICondition The right-hand side argument for the clause
        @return logical Whether the clause resolves to true or false.  */
    method public logical EvaluateClause(input poLHS as ICondition,
                                         input poOperator as ICondition,
                                         input poRHS as ICondition):
        define variable lConditionsMet as logical no-undo.
        
        case poLHS:
            when Condition:Type then
            do:
                /* Available SessionConditions: ThinClient, FatClient, Server */
                case poRHS:
                    when SessionTypeCondition:ThinClient then
                        lConditionsMet = SessionClientTypeEnum:CurrentSession:Equals(SessionClientTypeEnum:ABLClient)
                                      or SessionClientTypeEnum:CurrentSession:Equals(SessionClientTypeEnum:WebClient).
                    when SessionTypeCondition:FatClient then
                        /* A fat client contains client and server components, and thus is a client that is not a WebClient. */
                        lConditionsMet = SessionClientTypeEnum:CurrentSession:Equals(SessionClientTypeEnum:ABLClient)
                                       and not SessionClientTypeEnum:CurrentSession:Equals(SessionClientTypeEnum:WebClient).
                    when SessionTypeCondition:Server then
                        /* We assume that the other/underfined session client types are used as servers. */
                        lConditionsMet = SessionClientTypeEnum:CurrentSession:Equals(SessionClientTypeEnum:AppServer)
                                      or SessionClientTypeEnum:CurrentSession:Equals(SessionClientTypeEnum:WebSpeed)
                                      or SessionClientTypeEnum:CurrentSession:Equals(SessionClientTypeEnum:Other).
                end case.
            end.
            when Condition:Name then lConditionsMet = ABLSession:Instance:Name eq poRHS:ToString().
        end case.
        
        /* If the operator is Not, the flip the evaluation */
        if poOperator:Equals(Condition:Not) then
            lConditionsMet = not lConditionsMet.
        
        return lConditionsMet.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : StandardConditionResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 29 10:05:25 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.

using OpenEdge.Lang.Assert.

using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Binding.Conditions.StandardConditionResolver implements IConditionResolver: 

    constructor public StandardConditionResolver():
    end constructor. 

    /** Evaluates the provided conditions. 
        
        @param ICondition The left-hand side argument for the clause
        @param ICondition The clause operator
        @param ICondition The right-hand side argument for the clause
        @return logical Whether the clause resolves to true or false
         */
    method public logical EvaluateClause(input poLHS as ICondition,
                                         input poOperator as ICondition,
                                         input poRHS as ICondition):
        define variable lConditionsMet as logical no-undo.
        
        case poOperator:
            when Condition:Is  then lConditionsMet = poLHS:Equals(poRHS).
            when Condition:Not then lConditionsMet = not poLHS:Equals(poRHS).
        end case.
        
        return lConditionsMet.
    end method.
        
    /** Factory method for new IConditionResolver instances.
        
        @param Class The typename of the condition resolver.
        @return IConditionResolver The new resolver to use.      */
    method static public IConditionResolver GetResolver(input poConditionResolverType as class Class):
        define variable oConditionResolver as IConditionResolver no-undo.
        
        Assert:ArgumentNotNull(poConditionResolverType, 'Condition Resolver Type').
        Assert:ArgumentIsType(poConditionResolverType,
                              Class:GetClass('OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver')).
        
        oConditionResolver = dynamic-new(poConditionResolverType:TypeName) ().
        
        return oConditionResolver.
    end method.
    
    
end class./*------------------------------------------------------------------------
    File        : UITypeCondition
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Apr 23 15:11:37 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Binding.Conditions.UITypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.System.UITypeEnum.

class OpenEdge.Core.InjectABL.Binding.Conditions.UITypeCondition: 

    define static public property Chui as ICondition no-undo get. private set. 
    define static public property ABLGui as ICondition no-undo get. private set.
    define static public property RiaGui as ICondition no-undo get. private set.
    define static public property DotNetGui as ICondition no-undo get. private set.
    define static public property Current as ICondition no-undo get. private set.
    
    constructor static UITypeCondition():
        assign UITypeCondition:Chui = new Condition(UITypeEnum:Chui)
               UITypeCondition:ABLGui = new Condition(UITypeEnum:AblGui)
               UITypeCondition:RiaGui = new Condition(UITypeEnum:RiaGui)
               UITypeCondition:DotNetGui = new Condition(UITypeEnum:DotNetGui)
/*               UITypeCondition:Current = new Condition(UITypeEnum:Current)*/
               .
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : IInjectionModule
    Purpose     : Interface for module containing a collection of bindings
                  used for dependency injection.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:09:36 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.IKernel.

interface OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule:
    
    /** Gets the module's name. */
    define public property Name as character no-undo get.
    
    /** Called when the module is loaded into a kernel.
         @param IKernel The kernel that is loading the module. */
     method public void OnLoad(poKernel as IKernel).
     
     /** Called when the module is unloaded from a kernel.
         @param IKernel The kernel that is unloading the module. */
     method public void OnUnload(poKernel as IKernel).
          
end interface./*------------------------------------------------------------------------
    File        : IInjectionModuleCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 14:07:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.

using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection inherits TypedMap: 
    
    constructor public IInjectionModuleCollection():
        super(String:Type,
               Class:GetClass('OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule')).
    end constructor.
    
    constructor public IInjectionModuleCollection(input poMap as IInjectionModuleCollection):
        super (input poMap).
    end constructor.

    method public IInjectionModule Add(input poValue as IInjectionModule):
        return cast(super:Put(input new String(poValue:Name), input poValue), IInjectionModule).
    end method.
    
    method public IInjectionModule Put(input poKey as String, input poValue as IInjectionModule):
        return cast(super:Put(input poKey, input poValue), IInjectionModule).
    end method.
    
    method public IInjectionModule Remove(input poKey as String):
        return cast(super:Remove(input poKey), IInjectionModule).
    end method.
    
    method public IInjectionModule Remove(input pcKey as longchar):
        return cast(super:Remove(input new String(pcKey)), IInjectionModule).
    end method.
    
    method public logical ContainsKey(input poKey as String ):
        return super:ContainsKey(input poKey).
    end method.

    method public logical ContainsKey(input pcKey as longchar):
        return super:ContainsKey(input new String(pcKey)).
    end method.

    method public logical ContainsValue(input poValue as IInjectionModule ):
        return super:ContainsValue(input poValue).
    end method.
    
    method public IInjectionModule Get(input poKey as String ):
        return cast(super:Get(input poKey), IInjectionModule).
    end method.

    method public IInjectionModule Get(input pcKey as longchar):
        return cast(super:Get(input new String(pcKey)), IInjectionModule).
    end method.
    
    method public void PutAll(input poMap as IInjectionModuleCollection):
        super:PutAll(input poMap).
    end method.    
    
    
end class./** ------------------------------------------------------------------------
    File        : InjectionModule
    Purpose     : 
    Syntax      :
    Description : A loadable unit that defines bindings for your application.
    @author pjudge
    Created     : Tue Mar 02 11:08:44 EST 2010 
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.IBindingRoot.
using OpenEdge.Core.InjectABL.Binding.BindingRoot.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.Binding.
using OpenEdge.Core.InjectABL.Binding.BindingBuilder.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.Core.InjectABL.IKernel.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Collections.List.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Assert.

class OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule abstract inherits BindingRoot 
        implements IInjectionModule: 

     /** Gets the kernel that the module is loaded into.  */
    define public property Kernel as IKernel no-undo get. protected set.
    
    /** Gets the module's name. Only a single module with a given name can be loaded at one time.  */
    define public property Name as character no-undo
        get():
            return this-object:GetClass():TypeName.
        end get.
        private set.
    
    define override public property Bindings as IMap no-undo get. private set.
         
    constructor public InjectionModule():
        super().
        Bindings = new Map().
    end constructor.
    
    /** Called when the module is loaded into a kernel.
        @param kernel The kernel that is loading the module.
      */
    method public void OnLoad(poKernel as IKernel):
        Assert:ArgumentNotNull(poKernel, "kernel").
        
        Kernel = poKernel.
        Load().
    end.

     /** Called when the module is unloaded from a kernel. 
         
         @param kernel The kernel that is unloading the module.  */
    method public void OnUnload(input poKernel as IKernel):
        define variable oIterator as IIterator.
        define variable oBinding as IBinding.
        
        Assert:ArgumentNotNull(poKernel, "InjectABL kernel").
        
        Unload().
        
        oIterator = Bindings:Values:Iterator().
        do while oIterator:HasNext():
            oBinding = cast(oIterator:Next(), IBinding).
            cast(Kernel, IBindingRoot):RemoveBinding(oBinding).
            Bindings:Remove(oBinding).
        end.
        
        Bindings:Clear().
        Kernel = ?.
    end.
    
     /** Loads the module into the kernel.  */
    method public abstract void Load().

     /** Unloads the module from the kernel.  */
    @method(virtual="true").     
    method public void Unload():
    end method.

     /** Registers the specified binding.
         
         @param binding The binding to add. */
    method override public void AddBinding(input poBinding as IBinding):
        define variable oBindings as IList no-undo.
        
        Assert:ArgumentNotNull(input poBinding, "binding").
        
        cast(Kernel, IBindingRoot):AddBinding(poBinding).
        
        oBindings = cast(Bindings:Get(input poBinding:Service), IList).
        if not valid-object(oBindings) then
        do:
            oBindings = new List().
            Bindings:Put(poBinding:Service, oBindings).
        end.
        
        oBindings:Add(input poBinding).
    end.
    
     /** Unregisters the specified binding.
        @param binding The binding to remove.
       */
    method override public void RemoveBinding(poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "binding").

        cast(Kernel, IBindingRoot):RemoveBinding(pobinding).
        Bindings:Remove(poBinding).
    end.
    
    method override protected IBindingSyntax CreateBindingBuilder(poBinding as IBinding):
        return new BindingBuilder(poBinding, Kernel).
    end method.
    
end class./*------------------------------------------------------------------------
    File        : ModuleLoader
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 10:23:08 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.Assert.

class OpenEdge.Core.InjectABL.Binding.Modules.ModuleLoader: 
        /** Gets or sets the kernel into which modules will be loaded. **/
        define public property Kernel as IKernel no-undo get. private set.

        /** Initializes a new instance of the <see cref="ModuleLoader"/> class. 
            <param name="kernel">The kernel into which modules will be loaded.</param>
        **/
        constructor public ModuleLoader(poKernel as IKernel):
            Assert:ArgumentNotNull(poKernel, "kernel").
            Kernel = poKernel.
        end constructor.

        /** Loads any modules found in the files that match the specified patterns.
            <param name="patterns">The patterns to search.</param>
        **/
        method public void LoadModules(pcPatterns as char extent):
            def var oModule as IInjectionModule.
            
            Kernel:Load(oModule).
        end.
end class./** ------------------------------------------------------------------------
    File        : IParameter
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 09:26:12 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.Binding.Parameters.IParameter:
    /** (optional) Gets the name of the parameter. Only informational.*/
    define public property Name as character no-undo get. set.
    
    /** Gets the optional instance name of the parameter. This is only used when the parameter
        is a type/class which InjectABL will resolves from a pre-existing binding. The parameter 
        might be a general interface (IDataAccess) but the binding will specify a name ("EmployeeDA");
        this property allows us to specify that object. */
    define public property ServiceInstanceName as character no-undo get. set.
    
    /** (mandatory) The datatype of the parameter. */
    define public property DataType as DataTypeEnum no-undo get.
    
    /** (mandatory) Specify a declared type for cases where the parameter an object or array thereof. ABL doesn't currently (10.2B)
        allow us to discover either the declared type of the array, or the signature of the callee (method, property, ctor),
        and so we need to specify the type for the InjectABL kernel. */
    define public property DeclaredType as class Class no-undo get.
    
    /** Gets the value for the parameter within the specified context.
        @param context The context.
        @return The value for the parameter. */
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object).
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object extent).
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character).
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character extent).
    
end interface./** ------------------------------------------------------------------------
    File        : Parameter
    Purpose     : Constructor, method or property parameter/argument class for
                  dependency injection.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 16:03:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.InvalidCallError.
using OpenEdge.Core.System.ArgumentError.

using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Parameters.Parameter implements IParameter:
    /** (optional) Gets the name of the parameter. Only informational.*/
    define public property Name as character no-undo get. set.
    
    /** (optional) Gets the instance name of the parameter value. This is only used when the parameter
        is a type/class which InjectABL will resolves from a pre-existing binding. The parameter 
        might be a general interface (IDataAccess) but the binding will specify a name ("EmployeeDA");
        this property allows us to specify that object.
        
        Note that this is only valid for scalar arguments, not vectors/arrays.  */
    define public property ServiceInstanceName as character no-undo get. set.
    
    /** (mandatory) The datatype of the parameter. */
    define public property DataType as DataTypeEnum no-undo get. private set.
    
    /** (mandatory) Specify a declared type for cases where the parameter an object or array
        thereof. ABL doesn't currently (10.2B) allow us to discover either the declared type
        of the array, or the signature of the callee (method, property, ctor), and so we need
        to specify the type for the InjectABL kernel. */
    define public property DeclaredType as class Class no-undo get. private set.
    
    define private variable moValue as Object extent no-undo.
    define private variable mcValue as character extent no-undo.
    
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object):
        if DataTypeEnum:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not an object data type ').
        if DataTypeEnum:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is an not a scalar value').
        
        if DataType:Equals(DataTypeEnum:Class) then
            poValue = poContext:Kernel:Get(cast(moValue[1], Class), ServiceInstanceName).
        else
            poValue = moValue[1].
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        if DataTypeEnum:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not an object data type').
        
        if not DataTypeEnum:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is an not array').
        
        iMax = extent(moValue).
        extent(poValue) = iMax.
        
        do iLoop = 1 to iMax:
            if DataType:Equals(DataTypeEnum:ClassArray) then
                poValue[iLoop] = poContext:Kernel:Get(cast(moValue[iLoop], Class)).
            else
                poValue = moValue.
        end.
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character):
        if not DataTypeEnum:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not a primitive data type').
        
        if DataTypeEnum:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not a scalar value').
        
        pcValue = mcValue[1].
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character extent):
        if not DataTypeEnum:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not a primitive data tye').
                           
        if not DataTypeEnum:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is an not array').
        
        pcValue = mcValue.
    end method.
    
/* Primitive value constructors */
    constructor public Parameter(input pcValue as character):
        this-object(pcValue, DataTypeEnum:Character).
    end constructor.
    
    constructor public Parameter(input pcValue as character extent):
        this-object(pcValue, DataTypeEnum:Character).
    end constructor.
    
    constructor public Parameter(input pcValue as character, input poDataType as DataTypeEnum):
        assign DataType = poDataType
               extent(mcValue) = 1
               mcValue[1] = pcValue.
    end constructor.
    
    constructor public Parameter(input pcValue as character extent, input poDataType as DataTypeEnum):
        assign DataType = poDataType
               mcValue = pcValue.
    end constructor.
    
/* Object value constructors */
    constructor public Parameter(input poValue as Object):
        this-object(poValue,
                    if valid-object(poValue) then poValue:GetClass() else Class:GetClass('Progress.Lang.Object') ).
    end constructor.
    
    constructor public Parameter(input poValue as Object, input poDeclaredType as class Class):
        Assert:ArgumentNotNull(poDeclaredType, 'Declared type').
        
        /* Use another ctor for this */
        if valid-object(poValue) and type-of(poValue, Progress.Lang.Class) then
            undo, throw new ArgumentError('Argument cannot be of type Progress.Lang.Class', 'poValue').
        
        assign extent(moValue) = 1
               moValue[1] = poValue
               DeclaredType = poDeclaredType
               DataType = DataTypeEnum:ProgressLangObject.
    end constructor.
            
    constructor public Parameter(input poValue as Object extent):
        this-object(poValue,
                    if valid-object(poValue[1]) then poValue[1]:GetClass() else Class:GetClass('Progress.Lang.Object')).
    end constructor.
    
    constructor public Parameter(input poValue as Object extent, input poDeclaredType as class Class):
        Assert:ArgumentNotNull(poDeclaredType, 'Declared type').
        
        if valid-object(poValue[1]) and type-of(poValue[1], Progress.Lang.Class) then
            undo, throw new ArgumentError('Argument cannot be of type Progress.Lang.Class', 'poValue').
        
        assign moValue = poValue
               DeclaredType = poDeclaredType
               DataType = DataTypeEnum:ProgressLangObject.        
    end constructor.        

/* Class (service or value) constructors */
    constructor public Parameter(input poType as class Class):
        /* Defaults to a service */ 
        this-object(poType, DataTypeEnum:Class, '').
    end constructor.
    
    constructor public Parameter(input poType as class Class, input pcInstanceName as character):
        /* Defaults to a service */ 
        this-object(poType, DataTypeEnum:Class, pcInstanceName).
    end constructor.
    
    constructor public Parameter(input poType as class Class, input poDataType as DataTypeEnum):
        this-object(poType, poDataType, '').
    end constructor.        
    
    constructor public Parameter(input poType as class Class,
                                 input poDataType as DataTypeEnum,
                                 input pcServiceInstanceName as character):
        Assert:ArgumentNotNull(poType, 'Object value').
        Assert:ArgumentNotNull(poDataType, 'Data type').
        
        assign extent(moValue) = 1
               moValue[1] = poType               
               DataType = poDataType
               ServiceInstanceName = pcServiceInstanceName.
        
        /* If this is a reference, the declared type is a Progress.Lang.Class object;
           if not, then we take the given type as the declared type.  */
        if poDataType:Equals(DataTypeEnum:ProgressLangObject) then
            DeclaredType = Class:GetClass('Progress.Lang.Class').
        else
            DeclaredType = poType.
    end constructor.        
    
    constructor public Parameter(input poType as class Class extent):
        this-object(poType, Class:GetClass('Progress.Lang.Class')).
        
        /* Assume this is a service */
        DataType = DataTypeEnum:Class.
    end constructor.
            
    constructor public Parameter(input poType as class Class extent, input poDataType as DataTypeEnum):
        /* These are always PLC */
        this-object(poType, Class:GetClass('Progress.Lang.Class')).
        DataType = poDataType.
    end constructor.
    
            
    
end class./*------------------------------------------------------------------------
    File        : Routine
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Nov 18 14:31:22 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.

using OpenEdge.Lang.RoutineTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Parameters.Routine:
    /** The InjectABL service that's a parent for this routine  */
    define public property Service as class Class no-undo get. private set.
    /** The name of the routine */     
    define public property RoutineName as character no-undo get. private set.
    
    /** Is the routine a Constructor, Method or Property (setter) */
    define public property RoutineType as RoutineTypeEnum no-undo get. private set.
    
    /** The parameter to be passed to the routine */
    define public property Parameters as IParameter extent no-undo get. set.
    
    constructor public Routine(input poService as class Class,
                               input pcRoutineName as character,
                               input poRoutineType as RoutineTypeEnum ):
        Service = poService.
        RoutineName = pcRoutineName.
        RoutineType = poRoutineType.
    end method.
    
    method override public Object Clone():
        define variable oClone as Routine no-undo.
        
        oClone = new Routine(this-object:Service,
                             this-object:RoutineName,
                             this-object:RoutineType).
        
        oClone:Parameters = this-object:Parameters.
        return oClone.        
    end method.

end class./** ------------------------------------------------------------------------
    File        : ILifecycleContext
    Purpose     : 
    Syntax      : 
    Description : Contains information about the activation of a single instance.
    @author pjudge
    Created     : Tue Mar 02 11:45:31 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.InjectABL.Lifecycle.IProvider.
using OpenEdge.Core.InjectABL.IKernel.

using OpenEdge.Lang.Collections.ICollection.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext:  
    /** Gets the request. 
    define public property Request as IActivationRequest no-undo get.
    */
    
    /** Gets the kernel that is driving the activation. */
    define public property Kernel as IKernel no-undo get.
    
    /** Gets the binding. */
    define public property Binding as IBinding no-undo get.
    
    /** Gets the arguments for the constructor/methods/etc that were passed to manipulate the activation process. */
    define public property Arguments as ICollection no-undo get.
    
    /** Gets or sets the pipeline component. */
    define public property Pipeline as IPipeline no-undo get.
    
    /** Gets the provider that should be used to create the instance for this context.
        
        @return IProvider The provider that should be used. */
    method public IProvider GetProvider().
    
    /** Gets the scope for the context that "owns" the instance activated therein.
        @return Object The object that acts as the scope. */
    method public Object GetScope().
    
    /** Resolves this instance for this context.
        The resolved instance. */
    method public Object Resolve().
    
end interface./*------------------------------------------------------------------------
    File        : ILifecycleStrategy
    Purpose     : Is called during the activation and deactivation of an instance.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 07:55:45 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Lifecycle.*.
using Progress.Lang.*.

interface OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy:  
    /** Contributes to the activation of the instance in the specified context.
        @param poContext The lifecycle context
        @param poInstance The instance being activated
     */
    method public void Activate(poContext as ILifecycleContext, poInstance as Object).
    
    /** Contributes to the deactivation of the instance in the specified context.
        @param poContext The lifecycle context
        @param poInstance The instance being deactivated
      */
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object).
    
end interface./*------------------------------------------------------------------------
    File        : ILifecycleStrategyCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 14:07:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategyCollection.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy.
using OpenEdge.Lang.Collections.TypedCollection.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategyCollection inherits TypedCollection: 
        
    constructor public ILifecycleStrategyCollection():
        super(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy')).
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : IPipeline
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 08:09:14 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Lifecycle.*.
using Progress.Lang.*.

interface OpenEdge.Core.InjectABL.Lifecycle.IPipeline:  
    /** Gets the strategies that contribute to the activation and deactivation processes. **/
    define public property Strategies as ILifecycleStrategyCollection no-undo get.

    /** Activates the instance in the specified context. 
     <param name="context">The context.</param>
     <param name="reference">The instance reference.</param>
    **/
    method public void Activate(poContext as ILifecycleContext, poInstance as Object).

    /** Deactivates the instance in the specified context.
     <param name="context">The context.</param>
     <param name="reference">The instance reference.</param>
     **/
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object).
  
end interface./*------------------------------------------------------------------------
    File        : IProvider
    Purpose     : 
    Syntax      : 
    Description : Creates instances of services.
    @author pjudge
    Created     : Tue Mar 02 13:27:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using Progress.Lang.Object.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Lifecycle.IProvider:  
    /** Gets the type (or prototype) of instances the provider creates. */
    define public property Type as class Class no-undo get.

    /** Creates an instance within the specified context.
    
        @param ILifecycleContext The context used to create the object.
        @return Object The created instance. */
    method public Object Create(poContext as ILifecycleContext).
    
    /** Dependency injection into a method.
    
        @param Object The instance into which we inject values
        @param ILifecycleContext The context containing the values to be injected */
    method public void InjectMethods(poInstance as Object, poContext as ILifecycleContext).    
    
    /** Dependency injection into a property.
        
        @param Object The instance into which we inject values
        @param ILifecycleContext The context containing the values to be injected */
    method public void InjectProperties(poInstance as Object, poContext as ILifecycleContext).
    
end interface. /** ------------------------------------------------------------------------
    File        : LifecycleContext
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 10:03:26 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.LifecycleContext.
using OpenEdge.Core.InjectABL.ICache.
using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.InjectABL.Lifecycle.IProvider.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.IKernel.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.LifecycleContext
        implements ILifecycleContext:
    
    /** Gets the kernel that is driving the activation. */
    define public property Kernel as IKernel no-undo get. private set.
    
    /** Gets the Binding */
    define public property Binding as IBinding no-undo get. private set.

    /** Gets the parameters that were passed to manipulate the activation process. */
    define public property Arguments as ICollection no-undo get. private set.

    /** Gets or sets the cache component. */
    define public property Cache as ICache no-undo get. private set.

    /** Gets or sets the pipeline component. */
    define public property Pipeline as IPipeline no-undo get. private set.

    /** Initializes a new instance of the <see cref="Context"/> class.
        @param kernel The kernel managing the resolution.
        @param request The context's Request:
        @param binding The context's Binding:
        @param cache The cache component.
        @param planner The planner component.
        @param pipeline The pipeline component. */
    constructor public LifecycleContext(poKernel as IKernel,
                                        poBinding as IBinding,
                                        poPipeline as IPipeline,
                                        poCache as ICache):
        
        Assert:ArgumentNotNull(poKernel, "kernel").
        Assert:ArgumentNotNull(poBinding, "binding").
        Assert:ArgumentNotNull(poPipeline, "pipeline").
        Assert:ArgumentNotNull(poCache, "cache").
        
        assign Kernel = poKernel
               Binding = poBinding
               /* (Deep) Clone the arguments, since we may mess with them on our travels here. */
               Arguments = cast(poBinding:Arguments:Clone(), ICollection)
               Pipeline = poPipeline
               Cache = poCache.
    end constructor.
    
    /** Gets the scope for the context that "owns" the instance activated therein.
        We don't store a reference for it since we want to be able to allow garbage 
        collection to clean it up. 
        
        @return The object that acts as the scope.
     */
    method public Object GetScope():
        return Binding:GetScope(this-object).
    end method.

    /** Gets the provider that should be used to create the instance for this context.
        @return The provider that should be used.
     */
    method public IProvider GetProvider():
        return Binding:GetProvider().
    end method.
    
    /** Resolves the instance associated with this context.
        
        @return The resolved instance.  */
    method public Object Resolve():
        define variable oInstance as Object no-undo.
        
        if Binding:TargetType:IsInterface() then
            oInstance = Kernel:Get(Binding:TargetType).
        else
        do:
            oInstance = Cache:TryGet(this-object).
            if valid-object(oInstance) then
                return oInstance.
            
            /* This will perform any constructor injection, via the provider. */
            oInstance = GetProvider():Create(this-object).
            
            /* Transient object aren't cached */
            if valid-object(GetScope()) then
                Cache:Remember(this-object, oInstance).
            
            /* Activation may have method and/or property injection */
            Pipeline:Activate(this-object, oInstance).
        end.
        
        return oInstance.
    end method.
    
    method override public Object Clone():
        define variable oClone as ILifecycleContext no-undo.
        
        oClone = new LifecycleContext(this-object:Kernel,
                                      this-object:Binding,
                                      this-object:Pipeline,
                                      this-object:Cache).
        return oClone.
    end method.
    
end class.
/*------------------------------------------------------------------------
    File        : LifecycleStrategy
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 07:58:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.LifecycleStrategy abstract implements ILifecycleStrategy: 
    
    constructor public LifecycleStrategy ():
    end constructor.
    
    @method(virtual="True").
    method public void Activate(poContext as ILifecycleContext, poInstance as Object):
    end method.
    
    @method(virtual="True").
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object):
    end method.
    
end class./*------------------------------------------------------------------------
    File        : MethodInjectionLifecycleStrategy
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 11 09:02:02 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.LifecycleStrategy.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.MethodInjectionLifecycleStrategy inherits LifecycleStrategy: 
    constructor public MethodInjectionLifecycleStrategy (  ):
        super ().
    end constructor.
    
    method override public void Activate(poContext as ILifecycleContext, poInstance as Object):
        poContext:GetProvider():InjectMethods(poInstance, poContext).
    end method.
    
end class./*------------------------------------------------------------------------
    File        : PropertyInjectionLifecycleStrategy
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 11 09:02:02 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.LifecycleStrategy.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.PropertyInjectionLifecycleStrategy inherits LifecycleStrategy: 
    constructor public PropertyInjectionLifecycleStrategy (  ):
        super ().
    end constructor.
    
    method override public void Activate(poContext as ILifecycleContext, poInstance as Object):
        poContext:GetProvider():InjectProperties(poInstance, poContext).
    end method.
    
end class./*------------------------------------------------------------------------
    File        : Pipeline
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 08:14:13 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategyCollection.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.Collections.IIterator.

using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.StandardPipeline implements IPipeline:
    
    define public property Strategies as ILifecycleStrategyCollection no-undo get. private set. 

    constructor public StandardPipeline(poStrategies as ILifecycleStrategyCollection):
        Assert:ArgumentNotNull(poStrategies, 'Lifecycle strategies').
        
        Strategies = poStrategies.
    end constructor.
    
    method public void Activate(poContext as ILifecycleContext, poInstance as Object):
        define variable oIterator as IIterator no-undo.
        
        Assert:ArgumentNotNull(poInstance, 'Instance').
        Assert:ArgumentNotNull(poContext, 'Lifecycle context').
        
        oIterator = Strategies:Iterator().
        do while oIterator:HasNext():
            cast(oIterator:Next(), ILifecycleStrategy):Activate(poContext, poInstance).
        end.
    end method.
    
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object):
        define variable oIterator as IIterator no-undo.

        Assert:ArgumentNotNull(poInstance, 'Instance').
        Assert:ArgumentNotNull(poContext, 'Lifecycle context').
        
        oIterator = Strategies:Iterator().
        do while oIterator:HasNext():
            cast(oIterator:Next(), ILifecycleStrategy):Deactivate(poContext, poInstance).
        end.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : StandardProvider
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 16:41:44 EST 2010
    Notes       : * We need to catch certain P.L.SysErrors since we don't
                    know in advance what the callees' signatures are, and so
                    we shoot and hope. And catch SysErrors based on number.
                    This catch allows us to handle these conditions gracefully,
                    which is what we would do if we could determine the callee
                    signatures in advance. 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.IProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.

using OpenEdge.Core.System.InvocationError.
using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.ParameterList.
using Progress.Lang.AppError.
using Progress.Lang.SysError.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.StandardProvider implements IProvider:
    define private static property ProviderType as class Class no-undo get. private set.  
    
    define public property Type as class Class no-undo get. private set.
    
    constructor public StandardProvider(poClass as class Class):
        this-object:Type = poClass.
    end constructor.
    
    /** Method injection **/
    method protected void InjectViaMethod(poInstance as Object,
                                          poMethod as Routine,
                                          poContext as ILifecycleContext):
        define variable oPL as ParameterList no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
                
        Assert:ArgumentNotNull(poMethod, 'injection method').
        
        iMax = extent(poMethod:Parameters).
        if iMax eq ? then
            iMax = 0.
        oPL = new ParameterList(iMax).
        
        do iLoop = 1 to iMax:
            SetParameterValue(poContext,
                              oPL,
                              iLoop,
                              poMethod:Parameters[iLoop]).
        end.
        
        poInstance:GetClass():Invoke(poInstance, poMethod:RoutineName, oPL).
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            /* Could not dynamically find method ''<name> in class ''<name> with <number> matching parameter(s). (15312) */
            case eSysErr:GetMessageNum(1):
                when 15312 then
                    undo, throw new InvocationError(eSysErr, RoutineTypeEnum:Method:ToString(), poContext:Binding:TargetType:TypeName).
                otherwise
                    undo, throw eSysErr.
            end case.
        end catch.
    end method.
    
    @todo(task="implement", action="futures").
    /** Constructor injection 
    
        At some point in the future, we may add a generic/dynamic constructor injection 
        strategy, which will determine which constructor to use. At the moment, this decision
        is based on the first constructor in the bindings with the most arguments, and attempts
        to invoke an object with those arguments. 
        
        @param ILifecycleContext The context for creating an object.
        @return Object The newly-created object         */
    method public Object Create(input poContext as ILifecycleContext):
        define variable oNew as Object no-undo.
        define variable oPL as ParameterList no-undo.
        define variable oCtorArg as Parameter extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iNumParam as integer no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oCtor as Routine no-undo.
        define variable oRoutine as Routine no-undo.
        
        Assert:ArgumentNotNull(poContext:Binding:TargetType, 'Binding target').
        
        iNumParam = 0.
        if not poContext:Arguments:IsEmpty() then
        do:
            oIterator = poContext:Arguments:Iterator().
            
            /* find the ctor with the largest number of parameters */
            do while oIterator:HasNext():
                oRoutine = cast(oIterator:Next(), Routine).
                if oRoutine:RoutineType:Equals(RoutineTypeEnum:Constructor) then
                do:
                    if not valid-object(oCtor) then
                        oCtor = oRoutine.
                    else
                    if extent(oRoutine:Parameters) gt extent(oCtor:Parameters) then
                        oCtor = oRoutine.
                end.
            end.
            
            if valid-object(oCtor) and extent(oCtor:Parameters) ne ? then
                assign iNumParam = extent(oCtor:Parameters)
                       extent(oCtorArg) = iNumParam
                       oCtorArg = cast(oCtor:Parameters, Parameter).
        end.
        
        oPL = new ParameterList(iNumParam).
        do iLoop = 1 to iNumParam:
            SetParameterValue(poContext,
                              oPL,
                              iLoop,
                              oCtorArg[iLoop]).
        end.
        
        oNew = poContext:Binding:TargetType:New(oPL).
        
        /* Make sure we're using the right type */
        Assert:ArgumentIsType(oNew, this-object:Type).
        
        return oNew.
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            /* Dynamic NEW cannot NEW class <type> because an unambiguous appropriate constructor could not be found. (15310) */ 
            case eSysErr:GetMessageNum(1):
                when 15310 then
                    undo, throw new InvocationError(eSysErr, RoutineTypeEnum:Constructor:ToString(), poContext:Binding:TargetType:TypeName).
                otherwise
                    undo, throw eSysErr.                                                    
            end case.
        end catch.
    end method.
    
    method public void InjectMethods(poInstance as Object,
                                     poContext as ILifecycleContext):
        define variable oIterator as IIterator no-undo.
        define variable oRoutine as Routine no-undo.
        
        if not poContext:Arguments:IsEmpty() then
        do:
            oIterator = poContext:Arguments:Iterator().
            
            /* find the ctor with the largest number of parameters */
            do while oIterator:HasNext():
                oRoutine = cast(oIterator:Next(), Routine).
                if oRoutine:RoutineType:Equals(RoutineTypeEnum:Method) then
                    InjectViaMethod(poInstance,
                                    oRoutine,
                                    poContext).
            end.
        end.
    end method.
    
    method public void InjectProperties(poInstance as Object,
                                        poContext as ILifecycleContext):
        define variable oPropValue as IParameter no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oRoutine as Routine no-undo.
        define variable oPL as ParameterList no-undo.
        
        if not poContext:Arguments:IsEmpty() then
        do:
            oIterator = poContext:Arguments:Iterator().
            oPL = new ParameterList(1).
            
            do while oIterator:HasNext():
                oRoutine = cast(oIterator:Next(), Routine).
                if oRoutine:RoutineType:Equals(RoutineTypeEnum:PropertySetter) then
                do:
                    oPL:Clear().
                    oPL:NumParameters = 1.
                    SetParameterValue(poContext,
                                      oPL,
                                      1, 
                                      cast(oRoutine:Parameters[1], Parameter)).
                    /* FUTURE? poInstance:GetClass():Invoke(poInstance, poPropertyValue:Name, oPL).*/
                    
                    /* Assume there's a Set<PropertyName> method in the interim, while we wait for
                       dynamic property setting. */
                    poInstance:GetClass():Invoke(poInstance, 'Set' + oRoutine:RoutineName, oPL).
                end.                                      
            end.
        end.
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            /* Could not dynamically find method ''<name> in class ''<name> with <number> matching parameter(s). (15312) */
            case eSysErr:GetMessageNum(1):
                when 15312 then
                    undo, throw new InvocationError(eSysErr, RoutineTypeEnum:PropertySetter:ToString(), poContext:Binding:TargetType:TypeName).
                otherwise
                    undo, throw eSysErr.
            end case.
        end catch.
    end method.
    
    method protected void SetParameterValue(poContext as ILifecycleContext,
                                            poParams as Progress.Lang.ParameterList /* fully-qualified for clarity */,
                                            piOrder as integer,
                                            poArgument as IParameter /*InjectABL parameter*/ ):
        define variable oValue as Object no-undo.
        define variable oValueArray as Object extent no-undo.
        define variable cValue as character no-undo.
        define variable cValueArray as character extent no-undo.
        define variable lIsArray as logical no-undo.
        
        lIsArray = DataTypeEnum:IsArray(poArgument:DataType).
        
        if DataTypeEnum:IsPrimitive(poArgument:DataType) then
        do:
            if lIsArray then
            do:
                poArgument:GetValue(poContext, output cValueArray).
                poParams:SetParameter(piOrder,
                                      poArgument:DataType:ToString(),
                                      IOModeEnum:Input:ToString(),
                                      cValueArray).
            end.
            else
            do:
                poArgument:GetValue(poContext, output cValue).
                poParams:SetParameter(piOrder,
                                      poArgument:DataType:ToString(),
                                      IOModeEnum:Input:ToString(),
                                      cValue).
            end.
        end.    /* primitives */
        else
        do:
            if lIsArray then
            do:
                poArgument:GetValue(poContext, output oValueArray).
                poParams:SetParameter(piOrder,
                                      substitute(DataTypeEnum:ClassArray:ToString(), poArgument:DeclaredType:TypeName),
                                      IOModeEnum:Input:ToString(),
                                      oValueArray).
            end.
            else
            do:
                poArgument:GetValue(poContext, output oValue).
                poParams:SetParameter(piOrder,
                                      substitute(DataTypeEnum:Class:ToString(), poArgument:DeclaredType:TypeName),
                                      IOModeEnum:Input:ToString(),
                                      oValue).
            end.
        end.    /* objects*/
        
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            case eSysErr:GetMessageNum(1):
                /* Unable to convert SET-PARAMETER value to datatype passed. (10059) */
                when 10059 then
                    undo, throw new ArgumentError(eSysErr, 'Progress.Lang.ParameterList:SetParameter', poArgument:Name).
                otherwise
                    undo, throw eSysErr.
            end case.
        end catch.
    end method.
    
    constructor static StandardProvider():
        StandardProvider:ProviderType = Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IProvider').
    end constructor.
    
    /** factory method for new IProvider instances **/
    method static public IProvider GetProvider(poProviderType as class Class,
                                               poImplementation as class Class):
        define variable oProvider as IProvider no-undo.
        
        Assert:ArgumentNotNull(poProviderType, "provider type").
        Assert:ArgumentNotNull(poImplementation, "implementation type").
        
        if not poProviderType:IsA(StandardProvider:ProviderType) then
            undo, throw new AppError('type mismatch:' + poProviderType:TypeName + ' must implement ' + StandardProvider:ProviderType:TypeName).
        
        oProvider = dynamic-new(poProviderType:TypeName) (poImplementation).
        
        return oProvider.
    end method.
    
end class.
/*------------------------------------------------------------------------
    File        : StandardScope
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 14:37:17 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.StandardScope.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.AgentConnection.
using OpenEdge.Lang.AgentRequest.

using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.StandardScope:
    /** Gets the callback for scope. */
    method static public Object GetScope(poContext as ILifecycleContext,
                                         poScope as StandardScopeEnum  /* StandardScope */ ):
        case poScope:
            when StandardScopeEnum:Transient then return StandardScope:Transient(poContext).
            when StandardScopeEnum:Singleton then return StandardScope:Singleton(poContext).
            when StandardScopeEnum:ABLSession then return StandardScope:ABLSession(poContext).
            when StandardScopeEnum:AgentConnection then return StandardScope:AgentConnection(poContext).
            when StandardScopeEnum:AgentRequest then return StandardScope:AgentRequest(poContext).
        end case.
    end method.
    
    method static public Object Transient(poContext as ILifecycleContext):
        return ?.
    end method.
    
    /** Gets the callback for singleton scope. This scope is for the lifetime of the Kernel. This
        is usually the same as the session, but doesn't have to be. */
    method static public Object Singleton(poContext as ILifecycleContext):
         return poContext:Kernel.
    end method.

    /** Gets the callback for ABL Session scope. This scope is for the lifetime of the Session.
     */
    method static public Object ABLSession(poContext as ILifecycleContext):
        return ABLSession:Instance.
    end method.
    
    /** Gets the callback for Agent connection scope. This scope is for the lifetime of a connection
        to an AppServer. Not valid for statefree AppServers.   */
    method static public Object AgentConnection(poContext as ILifecycleContext):
        return AgentConnection:Instance.
    end method.
    
    /** Gets the callback for agent request scope. This scope is for the lifetime of a client's request
        to the AppServer. */
    method static public Object AgentRequest(poContext as ILifecycleContext):
        return AgentRequest:Instance.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : StandardScopeEnum
    Purpose     : Enumeration of InjectABL scopes. This is the standard/default set. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 04 13:50:10 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum inherits EnumMember: 
    define static public property Default as StandardScopeEnum no-undo get. private set.
    
    /** One instance, running free, like a wolf. */
    define static public property Transient as StandardScopeEnum no-undo get. private set.
    
    /** Only one instance at a time: effectively scoped to the life of the InjectABL kernel. */
    define static public property Singleton as StandardScopeEnum no-undo get. private set.

    /** One instance per AVM Session. */
    define static public property ABLSession as StandardScopeEnum no-undo get. private set.
    
    /** One instance per connection; meaningless for statefree Appservers */
    define static public property AgentConnection as StandardScopeEnum no-undo get. private set.
    
    /** One instance per AppServer request */
    define static public property AgentRequest as StandardScopeEnum no-undo get. private set.
    
    /** Custom scope */    
    define static public property Custom as StandardScopeEnum no-undo get. private set.
    
    constructor static StandardScopeEnum():
        /* these all use this type as IBinding:ScopeCallbackType */
        StandardScopeEnum:Transient = new StandardScopeEnum('Transient').
        StandardScopeEnum:Singleton = new StandardScopeEnum('Singleton').
        
        StandardScopeEnum:ABLSession = new StandardScopeEnum('ABLSession').
        StandardScopeEnum:AgentRequest = new StandardScopeEnum('AgentRequest').
        StandardScopeEnum:AgentConnection = new StandardScopeEnum('AgentConnection').
        
        /* IBinding:ScopeCallbackType set to input value */
        StandardScopeEnum:Custom = new StandardScopeEnum('Custom').
        
        StandardScopeEnum:Default = StandardScopeEnum:Transient.
    end constructor.
    
    constructor public StandardScopeEnum (pcName as character):
        super(pcName).
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : ILogger
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 06 12:17:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface OpenEdge.Core.Logger.ILogger:  
  
end interface./*------------------------------------------------------------------------
    File        : AccessViolationError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 07 17:00:40 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.AccessViolationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.AccessViolationError inherits ApplicationError: 
    define static public property READ_ONLY as character no-undo init 'read-only' get.
    
    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
            
    constructor public AccessViolationError(poErr as Error,pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public AccessViolationError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.     
        this-object(oUnknown,pcArgs1,pcArgs2).     
    end constructor.
    
    constructor public AccessViolationError(poErr as Error):
        super(poErr).
        this-object:ErrorTitle = 'Access Denied'.
        this-object:ErrorText = 'The &1 is marked as &2'.        
    end constructor.
    
    constructor public AccessViolationError():
        define variable oUnknown as Error no-undo.     
        this-object(oUnknown).        
    end constructor.
end class./*------------------------------------------------------------------------
    File        : OpenEdge.Core.System.ApplicationError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 09 10:37:02 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ErrorSeverityEnum.

using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.FlagsEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.ParameterList.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using Progress.Lang.Class.
using Progress.Lang.Error.

class OpenEdge.Core.System.ApplicationError abstract inherits AppError
        implements IExternalizable:
    
    define static public property ShowDebugMessages as logical no-undo init false get. set.
    
    define public property InnerError as Error no-undo get. protected set.
    
    define abstract protected property ErrorTitle as character no-undo get.         
    define abstract protected property ErrorText as longchar no-undo get.
    
    define protected property LogFileName as character no-undo get. set.
    
    define private stream sLog.
    
    constructor public ApplicationError():               
        super().
        
        /* can/will be overwritten by individual Error */
        this-object:Severity = ErrorSeverityEnum:Default:Value.
        
        LogFileName = session:temp-directory + '/' + 'error.log'.
    end constructor.
    
    constructor public ApplicationError(poInnerError as Error):               
        this-object().
        
        this-object:InnerError = poInnerError.
    end constructor.
    
    method public void LogError():
        output stream sLog to value(LogFileName) append.
            put stream sLog unformatted ResolvedMessageText().
        output stream sLog close.
    end method.
    
    method public void ShowError():
        /** This method should probably use a 'proper' message dialog; this
            might be a complete MVP application. For now, we simply use
            the MESSAGE statement. **/

        if FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Fatal) or
           FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Critical) or
           FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Error)then
            message ResolvedMessageText() view-as alert-box error title ResolvedTitle().
        else
        if FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Info) or
           FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Debug) then
            message ResolvedMessageText() view-as alert-box information title ResolvedTitle().
        else
        if FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Message) then
            message ResolvedMessageText() view-as alert-box message title ResolvedTitle().
        else
            message ResolvedMessageText() view-as alert-box warning title ResolvedTitle().
    end method.
    
    method public character ResolvedTitle():
        return substitute('&1', this-object:ErrorTitle).
    end method.
    
    @todo(task="implement", action="needs refactoring sans formatting").            
    method public character ResolvedMessageText():
        define variable cMsg      as character no-undo.        
        
        cMsg = substitute(this-object:ErrorText,
                               GetMessage(1),
                               GetMessage(2),
                               GetMessage(3),
                               GetMessage(4),
                               GetMessage(5),
                               GetMessage(6),
                               GetMessage(7),
                               GetMessage(8),
                               GetMessage(9)).
        if CallStack gt "" then 
            cMsg = cMsg 
                 + "~n~n"
                 + "Call Stack:"
                 + "~n------------~n"
                 + CallStack.            
        
        cMsg = ResolveInnerErrorText(cMsg).
        
        return cMsg.                 
    end method.
    
    method protected character ResolveInnerErrorText(input pcMessageText as character):
        define variable cInnerMsg as character no-undo.
        
        if valid-object(InnerError) then 
        do:
            if type-of(InnerError, ApplicationError) then
                cInnerMsg = cast(InnerError, ApplicationError):ResolvedMessageText().
            else if type-of(InnerError,AppError) then
                cInnerMsg = CoreErrorMessageText(cast(InnerError, AppError)).
            else 
                cInnerMsg = CoreErrorMessageText(InnerError).
            if cInnerMsg gt "" then
            do:
               pcMessageText = pcMessageText 
                    + (if pcMessageText eq "" then "" 
                       else "~n~n" 
                            + "Caused by:" 
                            + "~n") 
                    + cInnerMsg.
               if InnerError:CallStack gt "" then 
                  pcMessageText = pcMessageText 
                       + "~n~n"
                       + "Call Stack:"
                       + "~n------------~n"
                       + InnerError:CallStack.
            end.       
        end.         
        
        return pcMessageText.
    end method.
    
    /* returns text for an AppError 
       If there is a ReturnValue then NumMessages will not be checked or used  */  
    method protected character CoreErrorMessageText (poErr as AppError):
        if type-of(poErr, AppError) then 
            return poErr:ReturnValue.
        else  
            return CoreErrorMessageText(cast(poErr,Error)).   
    end method.
    
    method protected character CoreErrorMessageText (poErr as Error):
        define variable cMsg as character no-undo.
        define variable i as integer no-undo. 
       
        do i = 1 to poErr:NumMessages:
            cMsg = cMsg 
                 + (if cMsg = "" then "" else "~n~n") 
                 + poErr:GetMessage(i).
        end.    
       
        return cMsg.
    end method.
         
    method public override Object Clone():
        define variable oParams as ParameterList no-undo.
        define variable oClone as ApplicationError no-undo.
        define variable oClass as class Class no-undo. 
        define variable iLoop  as integer no-undo.
        
        oClass = this-object:GetClass().
        oParams = new ParameterList(1).
        oParams:SetParameter(1,
                             substitute(DataTypeEnum:Class:ToString(), 'Progress.Lang.Error'),
                             IOModeEnum:Input:ToString(),
                             this-object:InnerError).
        oClone = cast(oClass:New(oParams), ApplicationError).
        do iLoop = 1 to NumMessages:
            oClone:AddMessage(GetMessage(iLoop), iLoop).
        end.
        oClone:Severity = this-object:Severity.
        
        return oClone.
    end method.

    method public void WriteObject(input poStream as IObjectOutput):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = NumMessages.
        poStream:WriteInt(iMax).
        do iLoop = 1 to iMax:
            poStream:WriteLongchar(GetMessage(iLoop)).
        end.
                        
        poStream:WriteInt(this-object:Severity).
        poStream:WriteObject(InnerError).
    end method.

    method public void ReadObject(input poStream as IObjectInput):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = poStream:ReadInt().
        do iLoop = 1 to iMax:
            this-object:AddMessage(string(poStream:ReadLongchar()), iLoop).
        end.
        
        this-object:Severity = poStream:ReadInt().
        InnerError = cast(poStream:ReadObject(), Error).
    end method.
    
end class./*------------------------------------------------------------------------
    File        : ArgumentError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 13 12:43:45 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.ArgumentError inherits ApplicationError: 

    define override protected property ErrorTitle as character no-undo get. private set. 
    define override protected property ErrorText as longchar no-undo get. private set.

    constructor public ArgumentError(poInnerError as Error):
        super(poInnerError).
        
        ErrorTitle = 'Argument Error'.
        ErrorText = '&1 (name &2)'.
    end constructor.
    
    constructor public ArgumentError(pcArgs1 as char, pcArgs2 as char):
        this-object(?, pcArgs1, pcArgs2).
    end constructor.
    
    constructor public ArgumentError(poInnerError as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poInnerError).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

end class./*------------------------------------------------------------------------
    File        : BufferFieldMismatchError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:39:12 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.BufferFieldMismatchError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.BufferFieldMismatchError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
    
    constructor public BufferFieldMismatchError(pcArgs1 as char, pcArgs2 as char):
        this-object().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public BufferFieldMismatchError():
        super().
        
        this-object:ErrorTitle = 'Buffer Field Mismatch Error'.
        this-object:ErrorText = 'The buffers being compared have different fields. Buffer 1: &1; buffer 2: &2.'.
    end constructor.


end class./*------------------------------------------------------------------------
    File        : BufferNotAvailableError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:27:18 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.BufferNotAvailableError.
using Progress.Lang.Error.

class OpenEdge.Core.System.BufferNotAvailableError inherits ApplicationError: 
    
    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
    
    constructor public BufferNotAvailableError(poErr as Error):
        super(poErr).
        ErrorText = 'Buffer Not Available Error'.
        ErrorTitle = 'Buffer &1 not available'.        
    end constructor.
    
    constructor public BufferNotAvailableError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
    constructor public BufferNotAvailableError(poErr as Error,pcArgs1 as character):
        this-object(poErr).   
        AddMessage(pcArgs1, 1).
    end constructor.
    
    constructor public BufferNotAvailableError(pcArgs1 as character):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1).
    end constructor.
    
    
end class./*------------------------------------------------------------------------
    File        : DoesNotExistError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 07 16:56:09 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.DoesNotExistError.
using Progress.Lang.Error.

class OpenEdge.Core.System.DoesNotExistError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
        
    constructor public DoesNotExistError(poErr as Error, pcArgs1 as char):
        this-object(poErr).    
        AddMessage(pcArgs1, 1).
    end constructor.
    
    constructor public DoesNotExistError(pcArgs1 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1).
    end constructor.
    
        
    constructor public DoesNotExistError(poErr as Error):
        super (poErr).
        
        this-object:ErrorTitle = 'Does Not Exist Error'.
        this-object:ErrorText = 'The &1 specified does not exist'.
    end constructor.
    
    constructor public DoesNotExistError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).     
    end constructor.

end class./** ------------------------------------------------------------------------
    File        : ErrorSeverityEnum
    Purpose     : Enumeration of error severities 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 26 14:23:12 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ErrorSeverityEnum.
using OpenEdge.Lang.FlagsEnum.

class OpenEdge.Core.System.ErrorSeverityEnum  inherits FlagsEnum :
    
    define static public property Default  as ErrorSeverityEnum no-undo get. private set.
    define static public property None     as ErrorSeverityEnum no-undo get. private set.
    define static public property Fatal    as ErrorSeverityEnum no-undo get. private set.
    define static public property Critical as ErrorSeverityEnum no-undo get. private set.
    define static public property Error    as ErrorSeverityEnum no-undo get. private set.
    define static public property Warning  as ErrorSeverityEnum no-undo get. private set.
    define static public property Message  as ErrorSeverityEnum no-undo get. private set.
    define static public property Info     as ErrorSeverityEnum no-undo get. private set.
    define static public property Debug    as ErrorSeverityEnum no-undo get. private set.
    
    constructor static ErrorSeverityEnum():
        ErrorSeverityEnum:None = new ErrorSeverityEnum(1, 'None').
        ErrorSeverityEnum:Fatal = new ErrorSeverityEnum(2, 'Fatal').
        ErrorSeverityEnum:Critical = new ErrorSeverityEnum(4, 'Critical').
        ErrorSeverityEnum:Error = new ErrorSeverityEnum(8, 'Error').
        ErrorSeverityEnum:Warning = new ErrorSeverityEnum(16, 'Warning').
        ErrorSeverityEnum:Message = new ErrorSeverityEnum(32, 'Message').
        ErrorSeverityEnum:Info = new ErrorSeverityEnum(64, 'Info').
        ErrorSeverityEnum:Debug  = new ErrorSeverityEnum(128, 'Debug').
        
        ErrorSeverityEnum:Default = ErrorSeverityEnum:Error.
    end constructor.

    constructor public ErrorSeverityEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.

end class./** ------------------------------------------------------------------------
    File        : EventArgs
    Purpose     : Generic event arguments class, including static 'Empty'
                  option. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Jul 27 11:45:09 EDT 2009
    Notes       : * Using EventArgs allows us to extend arguments without
                    changing event signatures.
                  * this class is likely to be specialised, but there's no 
                    requirement for that to happen. although outside of 
                    'empty' this is a somewhat useless class :)
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.EventArgs.

class OpenEdge.Core.System.EventArgs:

    /** A single instance of this class so that we don't have
        to pass nulls around (ie we can depend on there always being
        a value if we so desire).   */
    define static public property Empty as EventArgs 
        get():
            if not valid-object(EventArgs:Empty) then
                EventArgs:Empty = new EventArgs().
             
             return EventArgs:Empty.
        end.
        private set.
    
    constructor public EventArgs():
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : ILoginData
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 04 11:32:53 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Core.System.ILoginData:
    
    define public property UserName as character no-undo get. set.
    define public property Password as character no-undo get. set.     
    
end interface./*------------------------------------------------------------------------
    File        : InvalidActionError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 19 13:15:14 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.


class OpenEdge.Core.System.InvalidActionError inherits ApplicationError: 
    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
            
    constructor public InvalidActionError(pcArgs1 as char):
        this-object(?, pcArgs1).
    end constructor.
    
    constructor public InvalidActionError (poErr as Error, pcArgs1 as char):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
    end constructor.
    
    constructor public InvalidActionError (poErr as Error):
        super(poErr).

        ErrorText = 'Invalid action: &1'.
        ErrorTitle = 'Invalid Action Error'.
    end constructor.
    
    constructor public InvalidActionError ():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : InvalidCallError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 13 12:38:37 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.

class OpenEdge.Core.System.InvalidCallError inherits ApplicationError:
        
    define override protected property ErrorTitle as character no-undo get. set.
    define override protected property ErrorText as longchar no-undo get. set.
    
    constructor public InvalidCallError():
        super().
        
        ErrorTitle = 'Invalid Call Error'.
        ErrorText = 'Invalid &1 call: &2'.
    end constructor.
    
    constructor public InvalidCallError(pcArgs1 as char, pcArgs2 as char):
        this-object().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : InvalidTypeError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:10:06 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.InvalidTypeError.
using Progress.Lang.Error.

class OpenEdge.Core.System.InvalidTypeError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
        
    constructor public InvalidTypeError(pcArgs1 as char, pcArgs2 as char, pcArgs3 as char):
        define variable oUnknown as Error no-undo.
        this-object(?,pcArgs1,pcArgs2,pcArgs3).
    end constructor.
    
    constructor public InvalidTypeError(poErr as Error, pcArgs1 as char, pcArgs2 as char, pcArgs3 as char):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
        AddMessage(pcArgs3, 3).
    end constructor.
    
    constructor public InvalidTypeError(poErr as Error):
        super(poErr).

        ErrorText = 'The &1 &2 does not implement &3'.
        ErrorTitle = 'Invalid Type Error'.
    end constructor.
    
    constructor public InvalidTypeError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : InvalidValueSpecifiedError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:06:54 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using Progress.Lang.Error.

class OpenEdge.Core.System.InvalidValueSpecifiedError inherits ApplicationError: 

    define override protected property ErrorTitle as character no-undo get. set.
    define override protected property ErrorText as longchar no-undo get. set.
    
    constructor public InvalidValueSpecifiedError (e as Error):
        super(e).
        
        ErrorTitle = 'Invalid Value Specified Error'.
        ErrorText = 'Invalid &1 specified &2'.
    end constructor.
    
    constructor protected InvalidValueSpecifiedError ():
        define variable oNullError as Error no-undo.
        this-object(oNullError).
    end constructor.
    
    constructor public InvalidValueSpecifiedError (pcArgs1 as char, pcArgs2 as char):
        this-object().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public InvalidValueSpecifiedError (e as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(e).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public InvalidValueSpecifiedError (pcArgs1 as char):
        this-object().
        AddMessage(pcArgs1, 1).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : InvocationError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 12 15:06:24 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.InvocationError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set. 
    define override protected property ErrorTitle as character no-undo get. set. 

    constructor public InvocationError(poInnerError as Error):
        super (poInnerError).        
                
        this-object:ErrorTitle = 'Invocation Error'.
        this-object:ErrorText = 'Cannot invoke &1 on class &2'.
    end constructor.
    
    constructor public InvocationError(poErr as Error,
                                       pcArgs1 as char,
                                       pcArgs2 as char):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

    constructor public InvocationError(pcArgs1 as char,
                                       pcArgs2 as char):
        this-object().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public InvocationError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : IQuery
    Purpose     : interface for standard query wrapper/object
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jul 31 16:33:06 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.System.IQuery.
using OpenEdge.Core.System.RowPositionEnum.   
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.ITableOwner.
using OpenEdge.Lang.FindTypeEnum.

using OpenEdge.Core.System.EventArgs.

interface OpenEdge.Core.System.IQuery:
    
    /* Events */
    /** Fired when the query is opened or reopened. This event only fires on query represented by the public QueryHandle.
        
        @param IQuery The query being operated on
        @param EventArgs Arguments pertaining to the operation. */
    define public event QueryOpened signature void (input poQuery as IQuery, input poArgs as EventArgs).
    
    /** Fired when the query is closed. This event only fires on query represented by the public QueryHandle.
        
        @param IQuery The query being operated on
        @param EventArgs Arguments pertaining to the operation. */
    define public event QueryClosed signature void (input poQuery as IQuery, input poArgs as EventArgs).

    /** Fired when the query is repositioned. This even only fires on query represented by the 
        public QueryHandle property, not any (internal) clones.
        
        @param IQuery The query being operated on
        @param EventArgs Arguments pertaining to the operation. */
    define public event QueryRepositioned signature void (input poQuery as IQuery, input poArgs as EventArgs).
    
    /** The ABL handle to the underlying query. Read-only. */
    define public property QueryHandle as handle no-undo get.
    
    /** (derived) Is the query open? */
    define public property IsOpen as logical no-undo get.

    define public property Definition as IQueryDefinition no-undo get.
    define public property NumRows as integer no-undo get.
    define public property CurrentRow as integer no-undo get.
    define public property RowPosition as RowPositionEnum no-undo get.
    define public property TableOwner as ITableOwner no-undo get.
    
    method public void Prepare().
    
    /** Resets the query definition to it's original state */
    method public void Reset().
    
    /** Sets the base query definition to the current query definition. */
    method public void Rebase().
    
    /* Constructs an ABL query based on the existing QueryDefinition */
    method public void Open().
    method public logical Close().
        
    method public logical Reopen().
    method public logical Reopen(input pcRowKey as character extent).
    method public logical Reopen(input piRow as integer).
    
    /* position to rowid specified by keys */
    method public logical Reposition(input pcRowKey as character extent).
    /* reposition to row number */
    method public logical Reposition(input piRow as integer).    
    /* navigate through query */
    method public logical GetFirst().
    method public logical GetNext().
    method public logical GetLast().
    method public logical GetPrev().
    
    /* Use method since we can't add a get override for the entire array as property. */
    method public character extent GetRowKey(input piPosition as integer).
    method public character extent GetRowKeyWhere(input poQueryDefinition as IQueryDefinition,    
                                                  input poFindType as FindTypeEnum).
    
    method public character extent GetCurrentRowKey().
    method public character extent GetFirstRowKey().
    method public character extent GetNextRowKey().
    method public character extent GetLastRowKey().
    method public character extent GetPrevRowKey().
    
    method public character GetCurrentBufferKey(input pcBufferName as character).
    method public character GetBufferTableName(input pcBufferName as character).
    
    
    
end interface./** ------------------------------------------------------------------------
    File        : IQueryDefinition
    Purpose     : Interface for query definition: the decomposed parts of a query. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 27 16:06:04 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinitionEventArgs.
using OpenEdge.Core.System.QueryBuffer.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.QueryJoin.
using OpenEdge.Core.System.QuerySort.

using OpenEdge.Lang.QueryBlockTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.SortDirectionEnum.
using OpenEdge.Lang.String.

using Progress.Lang.Object.

interface OpenEdge.Core.System.IQueryDefinition:
    
    /* Allows us to optimize building of queries (ie we don't need to create a new buffer).
       The setting of the *Changed properties to FALSE is an exogenous event: whoever's
       using this object needs to do that. It will probably happen on open. */
    define public event QueryDefinitionChanged signature void (input poQueryDefinition as IQueryDefinition,
                                                               input poEventArgs as QueryDefinitionEventArgs).
                           
    define public property QueryBlockType as QueryBlockTypeEnum no-undo get. set.
    define public property NumBuffers as integer no-undo get.
    
    @todo(task="refactor", action="make oo-ish").
    /*
    /* buffers are ordered, keyed on nameIList or IMap?  */
    define public property Buffers as IList no-undo get. private set.
    define public property Joins as ICollection no-undo get. private set.
    define public property Filters as ICollection no-undo get. private set.
    /* sorting is ordered */
    define public property Sorts as IList no-undo get. private set.
    */
    
    /** Indicates whether the query can join to tables outside of this query definition. This may
        happen in some cases; for instance when dealing with DataSourceQuery objects which are used
        for DATA-SOURCE queries for ProDataSets.
        
        An external join is assumed to apply only to the 2nd (JoinBuffer) buffer in the QueryJoin. */        
    define public property AllowExternalJoins as logical no-undo get. set.
    
    /* Old-school */
    method public void ClearAll().
    method public void ClearBuffers().
    method public void ClearFilters().
    method public void ClearSort().
    method public void ClearJoins().
    
    method public void SetBuffers(input pcBuffer as character extent, input pcTable as character extent).
    method public void SetBuffers(input pcBuffer as character extent).
    
    method public void AddBuffer(input pcBuffer as character).
    method public void AddBuffer(input pcBuffer as character, input pcTable as character).    
    method public void AddBuffer(input pcBuffer as character,
                                 input pcTable as character,
                                 input poQueryType as QueryTypeEnum,
                                 input poLockMode as LockModeEnum).
    
    method public void AddBuffer(input poQueryBuffer as QueryBuffer).
    
    method public void RemoveBuffer(input pcBuffer as character).
    method public void RemoveBuffer(input poQueryBuffer as QueryBuffer).
    
    /* IQuery will use these methods when constructing an ABL query */
    method public character extent GetBufferList().
    method public character extent GetBufferList(output pcTables as char extent,
                                                 output poQueryTypes as QueryTypeEnum extent,
                                                 output poLockModes as LockModeEnum extent).
    
    /** Returns the buffers in the definition. 
        
        @return QueryBuffer[] An ordered array of buffers in this definition. */
    method public QueryBuffer extent GetQueryBuffers().

    method public void SetBufferTable(input pcBuffer as character, input pcTable as character).
    method public void SetBufferLockMode(input pcBuffer as character, input poLockMode as LockModeEnum).   /* OpenEdge.System.Core.LockModeEnum  */
    method public void SetBufferQueryType(input pcBuffer as character, input poQueryType as QueryTypeEnum). /* OpenEdge.System.Core.QueryTypeEnum */
    
    method public character GetBufferTable(input pcBuffer as character).
    method public LockModeEnum GetBufferLockMode(input pcBuffer as character).    /* OpenEdge.System.Core.LockModeEnum */
    method public QueryTypeEnum GetBufferQueryType(input pcBuffer as character).
    
    @todo(task="Refactor AddFilter to have type-specific signatures; remove need to pass DataTypeEnum. ").
    /** Filter the query per the arguments.
        
        @param character The buffer name being filtered 
        @param character The buffer field being filtered
        @param OperatorEnum The operator (=,>, etc)
        @param String The string value for the filter.
        @param DataTypeEnum The datatype being stored in the string parameter.
        @param JoinEnum The join type (and/or etc) for the filter. */
    method public void AddFilter (input pcBufferName as character,
                                  input pcFieldName as character,
                                  input poOperator as OperatorEnum,
                                  input poFieldValue as String,
                                  input poFieldType as DataTypeEnum,
                                  input poJoinType as JoinEnum).
    
    /** Filter the query per the arguments.
                    
        @param QueryFilter The query filter used to filter the query. */                                  
    method public void AddFilter (input poQueryFilter as QueryFilter).
    
    /** Removes a filter clause from then definition.
        
        @param QueryFilter The query filter used to filter the query. */
    method public void RemoveFilter (input poQueryFilter as QueryFilter).
    
    /** Create a join between 2 buffers in this definition.
        
        @param character The first buffer name in the join
        @param character The first buffer field in the join
        @param OperatorEnum The operator (=,>, etc)
        @param character The second buffer name in the join
        @param character The second buffer field in the join
        @param JoinEnum The join type (and/or etc) for the filter. */
    method public void AddJoin (input pcBufferName as character,
                                input pcFieldName as character,
                                input poOperator as OperatorEnum,
                                input pcJoinBufferName as character,
                                input pcJoinFieldName as character,
                                input poJoinType as JoinEnum).

    /** Create a join between 2 buffers in this definition.
    
        @param QueryJoin Parameters for the join. */    
    method public void AddJoin(input poQueryJoin as QueryJoin).

    /** Removes a join between 2 buffers in this definition.
    
        @param QueryJoin Parameters for the join. */    
    method public void RemoveJoin(input poQueryJoin as QueryJoin).

    /** Add a sort condition to the definition.
    
        @param character The buffer being sorted
        @param character The field being sorted
        @param SortDirection The direction of the sort. */
    method public void AddSort (input pcBufferName as character,
                                input pcFieldName as character,
                                input poSortDirection as SortDirectionEnum).

    /** Add a sort condition to the definition.
        
        @param character The buffer being sorted
        @param character The field being sorted
        @param SortDirection The direction of the sort.
        @param integer The ordinal position of the sort phrase for the buffer. */
    method public void AddSort (input pcBufferName as character,
                                input pcFieldName as character,
                                input poSortDirection as SortDirectionEnum,
                                input piPosition as integer).
    
    /** Add a sort condition to the definition.
        
        @param QuerySort Parameters for the sort. */ 
    method public void AddSort(input poQuerySort as QuerySort).
    
    /** Removes a sort condition to the definition.
        
        @param QuerySort Parameters for the sort. */ 
    method public void RemoveSort(input poQuerySort as QuerySort).
    
    /** Returns the complete query string (ready for QUERY-PREPARE).
        
        @param longchar The complete query prepare string. */
    method public longchar GetQueryString().
    
    
    /** Returns the complete query string (ready for QUERY-PREPARE).
        
        @param character[] An array of buffer names for which 
               return a where clause that filters and joins between all
               buffers.
        @return longchar The query clause string. */
    method public longchar GetQueryString(input pcBufferName as character extent).
    
    /** Returns all of the query elements for the query.
        
        @return Object[] An array of the elements that make up this query. */
    method public Object extent GetQueryElements().
    
    /** Returns sort information for all buffers in the definition.
        
        @return longchar A complete sort string for all buffers in the definition. */
    method public longchar GetSort().
    
    /** Returns sort information.
        
        @param character The buffer name for which to retrieve sort information
        @return longchar A complete sort string for the specified buffer. */
    method public longchar GetSort(input pcBufferName as character).
    
    /** Returns the Sort information for the given buffer.
        
        @param character The buffer name for which to retrieve sort information
        @return QuerySort[] An ordered array of sort parameters */
    method public QuerySort extent GetQuerySort(input pcBufferName as character).
    
    /** Returns the Sort information for all buffers. 
        
        @return QuerySort[] An ordered array of sort parameters */    
    method public QuerySort extent GetQuerySort().
    
    /** Returns the filter criteria for a buffer, in string form. This
        could be used as-is for a WHERE clause.
        
        @param character The buffer name 
        @return longchar The where-clause-compatible string. */
    method public longchar GetFilter(input pcBufferName as character).
    
    /** Returns the filters applicable to a buffer.
       
        @param character The buffer name
        @return QueryFilter[] An array of query filter objects that
                apply to this buffer. */
    method public QueryFilter extent GetQueryFilter(input pcBufferName as character).

    /** Returns the filters applicable to all the buffers in the query.
       
        @return QueryFilter[] An array of query filter objects that apply 
                to all the buffers. The filters are ordered by buffer order. */
    method public QueryFilter extent GetQueryFilters().

    /** Returns the joins applicable to a buffer.
        
        @param character The buffer name
        @return QueryJoin[] An array of query filter objects that
                apply to this buffer. */
    method public QueryJoin extent GetQueryJoin(input pcBufferName as character).
    
    /** Returns the filters applicable to all the buffers in the query.
       
        @return QueryJoin [] An array of query filter objects that apply 
                to all the buffers. The filters are ordered by buffer order. */
    method public QueryJoin extent GetQueryJoins().

end interface.
/* *------------------------------------------------------------------------
    File        : ITableOwner
    Purpose     :        
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 04 11:28:51 EDT 2009
    Notes       : * An implementation of this interface is required by an IQuery object
                    in order to create a buffer (or buffers) for the query to use. 
  ---------------------------------------------------------------------- */

interface OpenEdge.Core.System.ITableOwner:
    
    /** @param character A table or buffer name. The implementer will
        know how to interpret the name. The name passed in is the name
        that the query will use together with its IQueryDefinition.
        
        @return A buffer handle corresponding to the requested name. */
    method public handle GetTableHandle (input pcTableName as character).
    
end interface.
@deprecated(version="0.0"). 
/*------------------------------------------------------------------------
    File        : LoginData
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 12 13:44:10 EDT 2009
    Notes       : * This is a sample LoginData: ILoginData could have 
                    anything in it, really. 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*.

class OpenEdge.Core.System.LoginData  implements ILoginData :
         
    define public property UserName as character no-undo get. set.
    define public property Password as character no-undo get. set. 
    
    constructor public LoginData (  ):
        super ().
        
    end constructor.

    constructor public LoginData (pcUserName as char, pcPassword as char):
        super ().
        
        UserName = pcUserName.
        Password = pcPassword.
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : NotFoundError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Feb 22 12:56:33 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.NotFoundError.
using Progress.Lang.Error.

class OpenEdge.Core.System.NotFoundError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
        
    constructor public NotFoundError(poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public NotFoundError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        
        this-object(oUnknown,pcArgs1, pcArgs2).
    end constructor.
        
    constructor public NotFoundError(poErr as Error):
        super (poErr).
        
        this-object:ErrorTitle = 'Not Found Error'.
        this-object:ErrorText = '&1 not found in &2'.
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : Query
    Purpose     : General query object/wrapper
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jul 31 16:34:19 EDT 2009
    Notes       : The buffers this query uses could also theoretically
                  be encapsulated. This is left as an exercise for the
                  reader :) 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.QueryDefinitionEventArgs.
using OpenEdge.Core.System.IQuery.
using OpenEdge.Core.System.ITableOwner.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.RowPositionEnum.
using OpenEdge.Core.System.QueryElementEnum.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.UnsupportedOperationError.

using OpenEdge.Core.System.EventArgs.
using OpenEdge.Core.System.QueryElementEnum.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.Collections.ObjectStack.

using OpenEdge.Lang.FlagsEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.FindTypeEnum.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.Assert.
using OpenEdge.Lang.String.
using Progress.Lang.Error.

class OpenEdge.Core.System.Query use-widget-pool 
        implements IQuery:

    /** Fired when the query is opened or reopened. This event only fires on query represented by the public QueryHandle.
        
        @param IQuery The query being operated on
        @param EventArgs Arguments pertaining to the operation. */
    define public event QueryOpened signature void (input poQuery as IQuery, input poArgs as EventArgs).

    /** Allows raising of the QueryOpened event by derived classes. 
        
        @param EventArgs Arguments for the event.  */
    method protected void OnQueryOpened(input poArgs as EventArgs):
        this-object:QueryOpened:Publish(this-object, poArgs).
    end method.
    
    /** Fired when the query is closed. This event only fires on query represented by the public QueryHandle.
        
        @param IQuery The query being operated on
        @param EventArgs Arguments pertaining to the operation. */
    define public event QueryClosed signature void (input poQuery as IQuery, input poArgs as EventArgs).

    /** Allows raising of the QueryClosed event by derived classes. 
        
        @param EventArgs Arguments for the event.  */
    method protected void OnQueryClosed(input poArgs as EventArgs):
        this-object:QueryClosed:Publish(this-object, poArgs).
    end method.

    /** Fired when the query is repositioned. This even only fires on query represented by the public QueryHandle.
            
        @param IQuery The query being operated on
        @param EventArgs Arguments pertaining to the operation. */
    define public event QueryRepositioned signature void (input poQuery as IQuery, input poArgs as EventArgs).
    
    /** Allows raising of the QueryRepositioned event by derived classes. 
        
        @param EventArgs Arguments for the event.  */
    method protected void OnQueryRepositioned(input poArgs as EventArgs):
        this-object:QueryRepositioned:Publish(this-object, poArgs).
    end method.

    /* The model or other component that holds this query. We need it in case of callbacks. */ 
    define public property TableOwner as ITableOwner no-undo  get. protected set.
    
    define public property QueryHandle as handle no-undo get. protected set.
    
    /** (derived) Is the query open? */
    define public property IsOpen as logical no-undo
        get():
            return (valid-handle(QueryHandle) and QueryHandle:is-open).
        end get.
    
    /* Query only has one this-object:Definition associated with it. Once it's created, we can
       manipulate to our hearts' content, but the object instance stays the same. */
    define public property Definition as IQueryDefinition no-undo get. protected set.

    /* This is the base or initial definition used to create this query. It's 
       a copy of the QueryDef passed in to the ctor, and should not be changed. */
/*    define protected property BaseDefinition as IQueryDefinition no-undo get. set.*/
    define protected property BaseDefinition as ObjectStack no-undo
        get():
            if not valid-object(BaseDefinition) then
                BaseDefinition = new ObjectStack().
            
            return BaseDefinition.
        end get.
        set.
    
    define public property NumRows as int no-undo
        get():
            define variable iNumRows as int no-undo.
            
            if valid-handle(QueryHandle) and QueryHandle:is-open then
                iNumRows = QueryHandle:num-results.
            else
                iNumRows = -1.
            
            return iNumRows.
        end get.
    
    define public property CurrentRow as integer no-undo 
        get():
            define variable iCurrentRow as int no-undo.
            
            if valid-handle(QueryHandle) and QueryHandle:is-open then
                iCurrentRow = QueryHandle:current-result-row.
            else
                iCurrentRow = -1.
            
            return iCurrentRow.
        end get.
        
    define public property RowPosition as RowPositionEnum no-undo
        get():
            define variable oRowPosition as RowPositionEnum no-undo.
                
            if not valid-handle(QueryHandle) or 
               not QueryHandle:is-open or
               QueryHandle:current-result-row eq 0 then
                oRowPosition = RowPositionEnum:None.
            else
                if QueryHandle:current-result-row eq 1 then
                    oRowPosition = RowPositionEnum:IsFirst. 
                else
                    if QueryHandle:current-result-row eq QueryHandle:num-results then
                        if oRowPosition eq RowPositionEnum:IsFirst then
                            oRowPosition = RowPositionEnum:IsFirstAndLast.
                        else
                            oRowPosition = RowPositionEnum:IsLast. 
                    else
                        oRowPosition = RowPositionEnum:NotFirstOrLast.
            
            return oRowPosition.
        end get.
    
    /** Contains the query elements changed since the last time the query was built. */
    define protected property QueryElementsChanged as integer no-undo get. set.
    
    define protected property BuildQuery as logical no-undo
        get.
        set(input plBuildQuery as logical):
            if plBuildQuery eq false then
                QueryElementsChanged = 0.
            
            BuildQuery = plBuildQuery.
        end set.

    constructor protected Query():
        create query QueryHandle.
        
        /* Obviously, we'll need to build the query at some point. */
        BuildQuery = true.
        QueryElementsChanged = QueryElementsChanged + QueryElementEnum:Buffer:Value.
    end constructor.
    
    constructor public Query(input poTableOwner as ITableOwner,
                             input poDefinition as IQueryDefinition):
        this-object().
        
        Assert:ArgumentNotNull(poDefinition, 'Query Definition').

        assign this-object:Definition = poDefinition
               TableOwner = poTableOwner.
        Rebase().
        
        /* If someone changes the query, we want to know about it so that when we
           (re)open a query, we know whether to rebuild the query string again (or 
           not). */
        this-object:Definition:QueryDefinitionChanged:Subscribe(QueryDefinitionChangedHandler).
    end constructor.
    
    method public void Open():
        this-object:Open(QueryHandle).
    end method.
    
    method protected void Open(input phQuery as handle):
        /* Build called since the defs may have changed.
           Build checks whether it needs to do anything. */
        Prepare(phQuery).
        
        if valid-handle(phQuery) then
        do:
            if phQuery:is-open then
                phQuery:query-close().
            phQuery:query-open().
            
            if phQuery eq QueryHandle then
                OnQueryOpened(EventArgs:Empty).
        end.
    end method.
    
    method public logical Close():
        return this-object:Close(QueryHandle).
    end method.
    
    method protected logical Close(input phQuery as handle):
        define variable lOk as logical no-undo.
        
        if valid-handle(phQuery) and phQuery:is-open then
            lOk = phQuery:query-close().
        else 
            lOK = false.
        
        if phQuery eq QueryHandle then
            OnQueryClosed(EventArgs:Empty).
        
        return lOK.
    end method.
    
    method public logical Reposition(input piRow as integer):
        return this-object:Reposition(QueryHandle, piRow).
    end method.
    
    method protected logical Reposition(input phQuery as handle, input piRow as integer):
        define variable lOk as logical no-undo.
        
        if piRow gt 0 then
        do:
            phQuery:reposition-to-row(piRow).
            
            /* deal with non-scrolling queries */
            if not phQuery:get-buffer-handle(phQuery:num-buffers):available then
                phQuery:get-next().
            lOK = phQuery:get-buffer-handle(1):available.           
        end.
        else
            lOK = false.
        
        if phQuery eq QueryHandle then
            OnQueryRepositioned(EventArgs:Empty).
        
        return lOK.
    end method.
    
    /** Repositions a query.  
        
        @param handle The query handle to reposition
        @param rowid[] An array of rowids used to reposition the query.
        @return logical Returns true if the query successfully repositioned to the
                row specified by the rowid array.   */
    method static public logical Reposition (input phQuery as handle,
                                                 input prRecord as rowid extent):
        define variable lOk as logical no-undo.
                                                     
        if prRecord[1] ne ? then
        do:
            /* Workaround for bug */
            if extent(prRecord) eq 1 then
                phQuery:reposition-to-rowid(prRecord[1]).
            else
                phQuery:reposition-to-rowid(prRecord).
            
            /* deal with non-scrolling queries */
            if not phQuery:get-buffer-handle(phQuery:num-buffers):available then
                phQuery:get-next().
                    
            lOK = phQuery:get-buffer-handle(1):available.
        end.
        else
            lOK = false.
           
/*        if phQuery eq QueryHandle then           */
/*            OnQueryRepositioned(EventArgs:Empty).*/
/*                                                 */
        return lOK.
    end method.
    
    method public logical Reposition (input pcRowKey as char extent):
        define variable lOk as logical no-undo.
        
        lOK = Query:Reposition(QueryHandle, pcRowKey).
        OnQueryRepositioned(EventArgs:Empty).
        
        return lOk. 
    end method.
    
    /** Repositions a query.  
        
        @param handle The query handle to reposition
        @param character[] An array of character row keys (either where clauses or rowids)
        @return logical Returns true if the query successfully repositioned to the
                row specified by the rowid array.   */            
    method static public logical Reposition(input phQuery as handle,
                                            input pcRowKey as char extent):
        define variable rCurrentRow as rowid extent no-undo.
        define variable iExtent as integer no-undo.
        define variable hBuffer as handle no-undo.
                extent(rCurrentRow) = extent(pcRowKey).
        rCurrentRow = ?.
        
        do iExtent = 1 to extent(pcRowKey):
            if pcRowKey[iExtent] eq '' or 
               pcRowKey[iExtent] eq ? then
                next.
            
            if pcRowKey[iExtent] begins 'where' then
            do:
                hBuffer = phQuery:get-buffer-handle(iExtent).
                hBuffer:find-unique(pcRowKey[iExtent]) no-error.
                if hBuffer:available then
                    rCurrentRow[iExtent] = hBuffer:rowid.
            end.
            else
                rCurrentRow[iExtent] = to-rowid(pcRowKey[iExtent]).
        end.    /* loop through where */
        
        return Query:Reposition(phQuery, rCurrentRow).
    end method.
            
    method public logical Reopen():
        return this-object:Reopen(QueryHandle).
    end method.
    
    method protected logical Reopen(input phQuery as handle):
        return this-object:Reopen(Query:GetCurrentRowKey(phQuery)).
    end method.
    
    method public logical Reopen(input pcRowKey as char extent):
        return this-object:Reopen(QueryHandle, pcRowKey).
    end method.
    
    method protected logical Reopen(input phQuery as handle, input pcRowKey as char extent):
        this-object:Open(phQuery).
        return Query:Reposition(phQuery, pcRowKey).
    end method.
    
    method public logical Reopen(input piRow as integer):
        return this-object:Reopen(QueryHandle, piRow).
    end method.
    
    method protected logical Reopen(input phQuery as handle, input piRow as integer):
        this-object:Open(phQuery).
        return this-object:Reposition(phQuery, piRow).
    end method.
    
    method public character extent GetCurrentRowKey():
        return Query:GetCurrentRowKey(QueryHandle).
    end method.

    method static public character GetBufferRowKey(input phBuffer as handle):
        define variable cKeyWhere as character no-undo.
        define variable iLoop as integer no-undo.
        define variable cKeys as character no-undo.
        define variable iMax as integer no-undo.
        /** single space for building query strings. Note the init value must be at least one space */
        define variable cSpacer as character no-undo init ' '.
        
        if not phBuffer:available then
            return ?.

        cKeys = phBuffer:keys. 
        if cKeys eq 'Rowid' then
            return string(phBuffer:rowid).
        
        iMax = num-entries(cKeys).
        do iLoop = 1 to iMax:
            cKeyWhere = cKeyWhere + cSpacer
                      + (if iLoop eq 1 then 'where ' else ' and ') + cSpacer
                      + phBuffer:name + '.' + entry(iLoop, cKeys) + cSpacer
                      + OperatorEnum:IsEqual:ToString() + cSpacer 
                      + quoter(phBuffer:buffer-field(entry(iLoop, cKeys)):buffer-value).
        end.    /* key fields */
        
        return cKeyWhere.
    end method.
                
    method static public character extent GetCurrentRowKey(input phQuery as handle):
        define variable cKeyWhere as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iFields as integer no-undo.
        define variable cKeys as character no-undo.
        define variable hBuffer as handle no-undo.
        
        if valid-handle(phQuery) and phQuery:is-open then
        do:
            extent(cKeyWhere) = phQuery:num-buffers.
            
            do iLoop = 1 to phQuery:num-buffers:
                cKeyWhere[iLoop] = Query:GetBufferRowKey(phQuery:get-buffer-handle(iLoop)).
            end.
        end.
        else
            assign extent(cKeyWhere) = 1
                   cKeyWhere = ?.
        
        return cKeyWhere.
    end method.
    
    method static public QueryFilter extent GetCurrentRowKeyElements(input phQuery as handle):
        define variable oFilters as ICollection no-undo.
        define variable iLoop as integer no-undo.
        define variable iFields as integer no-undo.
        define variable cKeys as character no-undo.
        define variable hBuffer as handle no-undo.
        
        if valid-handle(phQuery) and phQuery:is-open then
        do:
            oFilters = new Collection().
            
            do iLoop = 1 to phQuery:num-buffers:
                hBuffer = phQuery:get-buffer-handle(iLoop).
                if not hBuffer:available then
                do:
                    oFilters:Add(?).
                    leave.
                end.
                
                cKeys = hBuffer:keys.
                if cKeys eq 'Rowid' then
                    oFilters:Add(new QueryFilter(
                                            hBuffer:name,
                                            cKeys,
                                            OperatorEnum:IsEqual,
                                            new String(string(hBuffer:rowid)),
                                            DataTypeEnum:Rowid,
                                            JoinEnum:And)).
                else
                do iFields = 1 to num-entries(cKeys):
                    oFilters:Add(new QueryFilter(
                                            hBuffer:name,
                                            entry(iFields, cKeys),
                                            OperatorEnum:IsEqual,
                                            new String(hBuffer:buffer-field(entry(iFields, cKeys)):buffer-value),
                                            DataTypeEnum:Rowid,
                                            JoinEnum:And)).
                end.    /* key fields */
            end.
        end.
        
        return cast(oFilters:ToArray(), QueryFilter).
    end method.    
    
    method public character extent GetFirstRowKey().
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        GetFirst(hQuery).
        
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            this-object:Close(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetNextRowKey().
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        GetNext(hQuery).
                
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            this-object:Close(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetLastRowKey().
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        GetLast(hQuery).
                
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            this-object:Close(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetPrevRowKey().
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        GetPrev(hQuery).
                
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            this-object:Close(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetRowKey(input piPosition as int):
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        this-object:Reposition(hQuery, piPosition).
                
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            this-object:Close(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetRowKeyWhere(input poDefinition as IQueryDefinition,
                                                  input poFindType as FindTypeEnum):
        define variable hQuery as handle no-undo.
        define variable cFirstRowKey as character extent no-undo.
        define variable cRowKey as character extent no-undo.
        define variable cAltRowKey as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        hQuery:query-prepare(string(poDefinition:GetQueryString())).
        hQuery:query-open().
        
        case poFindType:
            when FindTypeEnum:Next or when FindTypeEnum:Prev then
                /*
                return error new UnsupportedOperationError(
                    FindTypeEnum:Next:ToString() + ' or ' + FindTypeEnum:Prev:ToString(),
                    'Query:GetRowKeyWhere()').
                */ .                    
            when FindTypeEnum:First then
            do:
                hQuery:get-first().
                cRowKey = GetCurrentRowKey(hQuery).
            end.
            when FindTypeEnum:Last then
            do:
                hQuery:get-last().
                cRowKey = GetCurrentRowKey(hQuery).
            end.
            when FindTypeEnum:Unique then
            do:
                hQuery:get-first().
                cRowKey = GetCurrentRowKey(hQuery).
                iMax = extent(cRowKey). 

                hQuery:get-last().
                cAltRowKey = GetCurrentRowKey(hQuery).
                
                @todo(task="implement", action="errors").
                if extent(cAltRowKey) eq iMax then
                do iLoop = 1 to iMax:
                    if cRowKey[iLoop] ne cAltRowKey[iLoop] then
                        return error.
                end.
                else
                    return error.
            end.
        end case.
        
        return cRowKey.
        
        finally:
            this-object:Close(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    /* We may clone this query in order to get row keys from a result without
       causing the 'real' query to reposition. This may be used when performing
       multi-select operations in the UI, where we don't want to move off the
       current record. Note that these actions may be expensive, because of the
       cost of creating, opening, etc the query. */
    method protected handle CloneQuery(input phSource as handle):
        define variable hQueryClone as handle no-undo.        
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        create query hQueryClone.
        iMax = phSource:num-buffers.
        
        do iLoop  = 1 to iMax:
            hQueryClone:add-buffer(phSource:get-buffer-handle(iLoop)).
        end.
        hQueryClone:query-prepare(phSource:prepare-string).
        
        return hQueryClone.
    end method. 
        
    destructor public Query():
        this-object:Definition:QueryDefinitionChanged:Unsubscribe(QueryDefinitionChangedHandler).
        
        DeleteQuery().
    end destructor.
    
    method public void QueryDefinitionChangedHandler(input poSender as IQueryDefinition, input poArgs as QueryDefinitionEventArgs):
        /* Ignore prebult PDS queries wrt buffer changes. We only want
           to react to filter, sort, join changes.
           
           Don't touch the buffers if we aren't able to create them via a TableOwner.
           
           This is a shortcut, since BuildQuery checks for this
           sort of thing. */
        if poArgs:Element:Equals(QueryElementEnum:Buffer) and
           not valid-object(TableOwner) then
            BuildQuery = false.
        else
        do:
            BuildQuery = true.
            QueryElementsChanged = QueryElementsChanged + poArgs:Element:Value.
        end.
    end.
    
    method protected void DeleteQuery():
        define variable iLoop as integer no-undo.
                
        /* don't delete PDS auto queries */
        if valid-object(TableOwner) and
           valid-handle(QueryHandle) then
        do:
            do iLoop = 1 to QueryHandle:num-buffers:
                delete object QueryHandle:get-buffer-handle(iLoop).
            end.
            
            delete object QueryHandle.
        end.        
    end method.
    
    /** Resets the query definition to it's original state */
    method public void Reset():
        this-object:Close().
        
        Definition = cast(BaseDefinition:Pop(), IQueryDefinition). 
/*        Prepare().*/
    end method.
    
    /** Sets the base query definition to the current query definition. */
    method public void Rebase():
        BaseDefinition:Push(cast(Definition:Clone(), IQueryDefinition)).
    end method.
    
    method public void Prepare():
        Prepare(QueryHandle).
    end method.
    
    method protected void Prepare(input phQuery as handle):
        /* keep separate variable for debugging */
        define variable cPrepareString as character no-undo.
        
        /* Always prepare this query. */
        BuildQuery = true.
        BuildQuery(phQuery).
        
        cPrepareString = this-object:Definition:GetQueryString().
        
        phQuery:query-prepare(cPrepareString).                                      
    end method.
    
    method protected void RemoveQueryBuffers(input phQuery as handle):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = phQuery:num-buffers. 
        
        /* Clean up after ourselves. Note that this only removes the
           named buffer used for the query, and not the underlying buffer
           itself. */
        do iLoop = 1 to iMax:
            delete object phQuery:get-buffer-handle(iLoop).
        end.
    end method.
    
    /** Construct and prepare a query based on the current query definition.
            
        @param handle The query handle being built. This may be an invalid handle, hence the
                      return value of a handle. */
    method protected void BuildQuery(input phQuery as handle):
        define variable cBuffers as character extent no-undo.
        define variable cTables as character extent no-undo.
        define variable oQueryTypes as QueryTypeEnum extent no-undo.
        define variable oLockModes as LockModeEnum extent no-undo.
        define variable hBuffer as handle no-undo.
        define variable iExtent as integer no-undo.
        define variable hTable as handle no-undo.
        
        /* nothing to do here. */
        if not BuildQuery then
            return.
        
        /* (re)build the query's buffers.
           don't delete the query since the consumer of this query may use the 
           handle as a name (and probably does, in fact) so we don't want to mess 
           with that.
           
           Don't touch the buffers if we aren't able to create them via a TableOwner.
           
           If any of the buffers in the definition have changed, remove all the buffers 
           and re-create. */
        if valid-object(TableOwner) and 
           FlagsEnum:IsA(QueryElementsChanged, QueryElementEnum:Buffer) then
        do:
            RemoveQueryBuffers(phQuery).
            
            /* And now add the new buffer(s) */
            cBuffers = this-object:Definition:GetBufferList(output cTables,
                                                            output oQueryTypes,
                                                            output oLockModes).
            do iExtent = 1 to extent(cBuffers):
                hBuffer = GetQueryBuffer(cTables[iExtent], cBuffers[iExtent]).
                
                Assert:ArgumentNotNull(hBuffer, 'Buffer Handle for ' + cBuffers[iExtent]).
                
                if iExtent eq 1 then
                    phQuery:set-buffers(hBuffer).
                else
                    phQuery:add-buffer(hBuffer).
            end.
        end.
        
        /* for this query, we're at rest and ready to go */
        BuildQuery = false.
    end method.
    
    /** Returns a buffer handle for use in the query.
        
        Note: this is method makes Query a candidate for abstraction, since we
              use(d) the ITableOwner construct for determining the buffer. However,
              since there are now different deriviatives of the Query class which
              supply the buffer handle in different ways (eg. DataSourceQuery and/or
              ModelQuery), it can be argues that this functionality doesn't really belong 
              in this base Query class.
              
              However, the ITableOwner code will remain in place for now, barring
              refactoring.
        
        @param character The table name        
        @param character The buffer name for the buffer
        @return handle The buffer handle for use in the query.  */
    method protected handle GetQueryBuffer(input pcTableName as character,
                                           input pcBufferName as character):
        define variable hBuffer as handle no-undo.
        
        create buffer hBuffer
                    for table TableOwner:GetTableHandle(pcTableName)  
                    buffer-name pcBufferName.
                    
        return hBuffer.                    
    end method. 
    
    method public logical GetFirst():
        return GetFirst(QueryHandle).
    end method.
    
    method protected logical GetFirst(input phQuery as handle):
        this-object:Reposition(phQuery, 1).
                                        
        return phQuery:get-buffer-handle(1):available.
    end method.
                
    method public logical GetNext():
        return GetNext(QueryHandle).
    end method.
    
    method protected logical GetNext(input phQuery as handle):
        this-object:Reposition(phQuery, phQuery:current-result-row + 1).
        
        return phQuery:get-buffer-handle(1):available.
    end method.
    
    method public logical GetLast():
        return GetLast(QueryHandle).
    end method.
    
    method protected logical GetLast(input phQuery as handle):
        this-object:Reposition(phQuery:num-results).
        
        return phQuery:get-buffer-handle(1):available.            
    end method.
        
    method public logical GetPrev():
        return GetPrev(QueryHandle).
    end method.
    
    method protected logical GetPrev(input phQuery as handle):
        this-object:Reposition(max(phQuery:current-result-row - 1, 1)).
        
        return phQuery:get-buffer-handle(1):available.
    end method.
    
    method public character extent GetRowKeyWhere(input poDefinition as IQueryDefinition):
        return GetRowKeyWhere(poDefinition, FindTypeEnum:First).
    end method.
    
    method public character GetCurrentBufferKey(input pcBufferName as char):
        define variable cRowKey as char extent no-undo.
        define variable cKey as char no-undo.
        define variable cBuffers as char extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        assign cRowKey = GetCurrentRowKey()
               iMax = QueryHandle:num-buffers
               cKey = ?.
        
        /* Unable to determine row key (query might not be open) */
        if extent(cRowKey) eq 1 and cRowKey[1] eq ? then
            cKey = ?.
        else
        do iLoop = 1 to iMax while cKey eq ?:
            if QueryHandle:get-buffer-handle(iLoop):name eq pcBufferName then
                cKey = cRowKey[iLoop].
        end.
        
        return cKey.        
    end method.
    
    method public character GetBufferTableName(pcBufferName as char):
        define variable cTable as character no-undo. 
        cTable = QueryHandle:get-buffer-handle(pcBufferName):table.

        @todo(task="improve message in unsupported Error  or create new Error").
        catch e as Error:
              if valid-handle(QueryHandle) then 
                  undo, throw new InvalidValueSpecifiedError(e,"buffer name","~"" + pcBufferName + "~"").    
                else
                  undo, throw new UnsupportedOperationError(e,"buffer name","~"" + pcBufferName + "~"").   
        end catch.
        finally:
           return cTable.
        end.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : QueryBuffer
    Purpose     : Parameter object for query buffers, used in IQueryDefinition 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Dec 10 10:16:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.QueryBuffer.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.

using OpenEdge.Lang.BufferJoinModeEnum.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.System.QueryBuffer
        implements IExternalizable:
    
    define public property Name as character no-undo get. set.
    define public property TableName as character no-undo get. set.
    define public property QueryType as QueryTypeEnum no-undo get. set.
    define public property LockMode as LockModeEnum no-undo get. set.
/*    define public property JoinMode as BufferJoinModeEnum no-undo get. set.*/
    
    @todo(task="implement", action="implement collection of sorts, filters, and joins ").
    
    constructor public QueryBuffer(input pcName as character):
        this-object(pcName, pcName, QueryTypeEnum:Default, LockModeEnum:Default). 
    end constructor. 

    constructor public QueryBuffer(input pcName as character,
                                   input pcTableName as character,
                                   input poQueryType as QueryTypeEnum,
                                   input poLockMode as LockModeEnum):
        Assert:ArgumentNotNullOrEmpty(pcName, 'Buffer name').
        Assert:ArgumentNotNullOrEmpty(pcTableName, 'Buffer table name').
        Assert:ArgumentNotNull(poQueryType, 'query type').
        Assert:ArgumentNotNull(poLockMode, 'lock mode').
        
        assign Name = pcName
               TableName = pcTableName
               QueryType = poQueryType
               LockMode = poLockMode.
    end constructor.
    
    constructor public QueryBuffer(input pcName as character,
                                   input pcTableName as character):
        this-object(pcName,
                    pcTableName,
                    QueryTypeEnum:Default,
                    LockModeEnum:Default).                                      
    end constructor.
    
    method override public logical Equals(input p0 as Object):
        define variable lEquals as logical no-undo.
        define variable oQB as QueryBuffer no-undo.
                
        lEquals = super:Equals(input p0).
        
        if not lEquals and type-of(p0, QueryBuffer) then
            assign oQB = cast(p0, QueryBuffer)
                   lEquals = oQB:Name eq this-object:Name
                         and oQB:TableName eq this-object:TableName
                         and oQB:QueryType:Equals(this-object:QueryType)
                         and oQB:LockMode:Equals(this-object:LockMode).
        
        return lEquals.
    end method.
    
    method public void WriteObject( input poStream as IObjectOutput):
        poStream:WriteChar(this-object:Name).
        poStream:WriteChar(TableName).
        poStream:WriteEnum(QueryType).
        poStream:WriteEnum(LockMode).
    end method.

    method public void ReadObject( input poStream as IObjectInput):
        assign this-object:Name = poStream:ReadChar()
               TableName = poStream:ReadChar()
               QueryType = cast(poStream:ReadEnum(), QueryTypeEnum)
               LockMode =  cast(poStream:ReadEnum(), LockModeEnum)
               .
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : QueryDefinition
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 27 16:02:48 EDT 2009
    Notes       : * Is IExternalizable because its derived TableRequest is
                    potentially passed across the wire. 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.QueryBuffer.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.QueryJoin.
using OpenEdge.Core.System.QuerySort.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Core.System.QueryDefinitionEventArgs.
using OpenEdge.Core.System.QueryDefinitionOperationEnum.
using OpenEdge.Core.System.QueryElementEnum.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.IObjectInput.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.Collection.

using OpenEdge.Lang.QueryBlockTypeEnum.
using OpenEdge.Lang.ByteOrderEnum.
using OpenEdge.Lang.CompareStrengthEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.SortDirectionEnum.
using OpenEdge.Lang.EnumMember.
using OpenEdge.Lang.String.
using Progress.Lang.Object.

class OpenEdge.Core.System.QueryDefinition
        implements IQueryDefinition, IExternalizable :
    
    define public event QueryDefinitionChanged signature void (poQueryDefinition as IQueryDefinition,
                                                               poEventArgs as QueryDefinitionEventArgs).
    
    define public property QueryBlockType as QueryBlockTypeEnum no-undo
        get ():
            if not valid-object(QueryBlockType) then
                QueryBlockType = QueryBlockTypeEnum:Default.
                            
            return QueryBlockType.
        end get.
        set.

    /** Indicates whether the query can join to tables outside of this query definition. This may
        happen in some cases; for instance when dealing with DataSourceQuery objects which are used
        for DATA-SOURCE queries for ProDataSets.
        
        An external join is assumed to apply only to the 2nd (JoinBuffer) buffer in the QueryJoin. */        
    define public property AllowExternalJoins as logical no-undo initial false get. set.
    
    /* Only ever set by AddBuffer(). */
    define public property NumBuffers as integer no-undo get. protected set.
    
    define private temp-table ttBuffer no-undo
        field BufferName as character 
        field Order as integer
        field TableName as character 
        field QueryType as Object   /* OpenEdge.Lang.QueryTypeEnum */
        field LockMode as Object    /* OpenEdge.Lang.LockModeEnum */
        /* field JoinMode as Object    OpenEdge.Lang.BufferJoinModeEnum */
        index idx1 as unique BufferName
        index idx2 as primary unique Order.
    
    define private temp-table ttFilter no-undo
        field BufferName as character
        field FieldName as character 
        field Operator as Object        /* OpenEdge.Lang.OperatorEnum */
        field FieldValue as Object      /*OE.Lang.String */
        field FieldType as Object       /* OpenEdge.Lang.DataTypeEnum */
        field JoinType as Object        /* OpenEdge.Lang.JoinEnum */
        index idx1 as primary unique BufferName FieldName Operator FieldValue.
    
    define private temp-table ttJoin no-undo
        field BufferName as character
        field FieldName as character 
        field Operator as Object   /* OpenEdge.Lang.OperatorEnum */
        field JoinBufferName as character 
        field JoinFieldName as character 
        field JoinType as Object       /* OpenEdge.Lang.JoinEnum */
        index idx1 as primary unique BufferName FieldName Operator JoinBufferName JoinFieldName
        index idx2 JoinBufferName
        index idx3 BufferName.
    
    define private temp-table ttSort no-undo
        field BufferName as char
        field FieldName as char
        field Direction as Object /* OpenEdge.Lang.SortDirectionEnum */
        field Order as int
        index idx1 as primary unique BufferName FieldName.

    /** single space for building query strings. Note the init value must be at least one space */
    define private variable mcSpacer as character no-undo init ' '.
    
    method public void AddFilter (pcBufferName as character,
                                  pcFieldName as character,
                                  poOperator as OperatorEnum,
                                  poFieldValue as String,
                                  poFieldType as DataTypeEnum,
                                  poJoinType as JoinEnum):
        define buffer lbFilter for ttFilter.
        
        create lbFilter.
        assign lbFilter.BufferName = pcBufferName
               lbFilter.FieldName = pcFieldName
               lbFilter.Operator = poOperator
               lbFilter.FieldValue = poFieldValue
               lbFilter.FieldType = poFieldType
               lbFilter.JoinType = poJoinType.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Filter, QueryDefinitionOperationEnum:Create)).
    end method.
    
    method public void AddFilter(input poQueryFilter as QueryFilter):
        AddFilter(poQueryFilter:BufferName,
                  poQueryFilter:FieldName,
                  poQueryFilter:Operator,
                  poQueryFilter:FieldValue,
                  poQueryFilter:FieldType,
                  poQueryFilter:JoinType).
    end method.
    
    /** Removes a filter clause from then definition.
        
        @param QueryFilter The query filter used to filter the query. */
    method public void RemoveFilter (input poQueryFilter as QueryFilter):
        define buffer lbFilter for ttFilter.
        
        for each lbFilter where
                 lbFilter.BufferName = poQueryFilter:BufferName and
                 lbFilter.FieldName = poQueryFilter:FieldName and
                 lbFilter.Operator = poQueryFilter:Operator
                 no-lock:                     
            
            /* We may be using a different QuerySort object to the original, so use
               Equals() instead of reference */
            if cast(lbFilter.FieldValue, String):Equals(poQueryFilter:FieldValue) then
            do:
                delete lbFilter.
                
                OnQueryDefinitionChanged(
                    new QueryDefinitionEventArgs(
                            QueryElementEnum:Filter,
                            QueryDefinitionOperationEnum:Delete)).
                leave.
            end.
        end.
    end method.
            
    method public void ClearFilters():
        empty temp-table ttFilter.
        
        OnQueryDefinitionChanged(
            new QueryDefinitionEventArgs(
                    QueryElementEnum:Filter,
                    QueryDefinitionOperationEnum:Empty)).
    end method.
        
    method public void ClearSort():
        empty temp-table ttSort.
        
        OnQueryDefinitionChanged(
            new QueryDefinitionEventArgs(
                    QueryElementEnum:Filter,
                    QueryDefinitionOperationEnum:Empty)).
    end method.

    method public void ClearJoins():
        empty temp-table ttJoin.
        
        OnQueryDefinitionChanged(
            new QueryDefinitionEventArgs(
                    QueryElementEnum:Join,
                    QueryDefinitionOperationEnum:Empty)).
    end method.
    
    method public void ClearBuffers():
        empty temp-table ttBuffer.
        NumBuffers = 0.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Buffer, QueryDefinitionOperationEnum:Empty)).
    end method.
    
    method public void ClearAll():
        this-object:QueryBlockType = ?.
        
        this-object:ClearBuffers().
        this-object:ClearFilters().
        this-object:ClearJoins().
        this-object:ClearSort().
    end method.
    
    method public character extent GetBufferList():
        define variable cTables as character extent no-undo.
        define variable oDummy as EnumMember extent no-undo.
        
        return GetBufferList(output cTables, output oDummy, output oDummy).
    end method.
    
    method public character extent GetBufferList(output pcTables as character extent,
                                                 output poQueryTypes as QueryTypeEnum extent,
                                                 output poLockModes as LockModeEnum extent):
        
        define variable cBuffer as character extent no-undo.
        define variable iExtentSize as integer no-undo.
        define variable iExtent as integer no-undo.
        
        define buffer lbBuffer for ttBuffer.
        define query qryBuffer for lbBuffer.
        
        open query qryBuffer preselect each lbBuffer.
        
        iExtentSize = max(1, query qryBuffer:num-results).
        
        extent(cBuffer) = iExtentSize.
        extent(pcTables) = iExtentSize.
        extent(poQueryTypes) = iExtentSize.
        extent(poLockModes) = iExtentSize.
         
        query qryBuffer:get-first().
        iExtent = 1.
        do while not query qryBuffer:query-off-end:
            assign cBuffer[iExtent] = lbBuffer.BufferName
                   pcTables[iExtent] = lbBuffer.TableName
                   poQueryTypes[iExtent] = cast(lbBuffer.QueryType, QueryTypeEnum)
                   poLockModes[iExtent] = cast(lbBuffer.LockMode, LockModeEnum)
                   iExtent = iExtent + 1.
            
            query qryBuffer:get-next().
        end.
        
        close query qryBuffer.
        
        return cBuffer.        
    end method.
    
    method public QueryBuffer extent GetQueryBuffers():
        define variable oQB as QueryBuffer extent no-undo.
        
        define buffer lbBuffer for ttBuffer.
        define query qryBuffer for lbBuffer.
        
        open query qryBuffer preselect each lbBuffer by lbBuffer.Order.
        
        if query qryBuffer:num-results gt 0 then
        do:
            extent(oQB) = query qryBuffer:num-results.
            query qryBuffer:get-first().
            do while not query qryBuffer:query-off-end:
                oQB[query qryBuffer:current-result-row] =
                        new QueryBuffer(lbBuffer.BufferName,
                                        lbBuffer.TableName,
                                        cast(lbBuffer.QueryType, QueryTypeEnum),
                                        cast(lbBuffer.LockMode, LockModeEnum)).
                query qryBuffer:get-next().
            end.
            close query qryBuffer.
        end.
                
        return oQB.
    end method.
    
    method public void AddBuffer(pcBuffer as character):
        AddBuffer(pcBuffer, pcBuffer).
    end method.
            
    method public void AddBuffer(pcBuffer as character, pcTable as char):        
        AddBuffer(pcBuffer,
                  pcTable,
                  QueryTypeEnum:Default,
                  LockModeEnum:Default).
    end method.
    
    method public void AddBuffer(input poQueryBuffer as QueryBuffer):
        AddBuffer(poQueryBuffer:Name,
                  poQueryBuffer:TableName,
                  poQueryBuffer:QueryType,
                  poQueryBuffer:LockMode).
    end method.
    
    /** Removes a buffer and related records. Note that only one
        QueryDefinitionChanged event first, for the buffer. The 
        child records are simply removed.
        
        @param QueryBuffer The buffer being removed */
    method public void RemoveBuffer(input poQueryBuffer as QueryBuffer):
        RemoveBuffer(poQueryBuffer:Name).
    end method.
    
    /** Removes a buffer and related records. Note that only one
        QueryDefinitionChanged event first, for the buffer. The 
        child records are simply removed.
        
        @param character The buffer being removed */        
    method public void RemoveBuffer(input pcBufferName as character):
        define buffer lbBuffer for ttBuffer.
        define buffer lbJoin for ttJoin.
        define buffer lbFilter for ttFilter.
        define buffer lbSort for ttSort.
        
        find lbBuffer where lbBuffer.BufferName = pcBufferName no-error.
        if available lbBuffer then
        do:
            for each lbFilter where lbFilter.BufferName = lbBuffer.BufferName:
                delete lbFilter.
            end.
            
            for each lbJoin where
                     lbJoin.BufferName = lbBuffer.BufferName or
                     lbJoin.JoinBufferName = lbBuffer.BufferName:
                delete lbJoin.                         
            end.
            
            for each lbSort where lbSort.BufferName = lbBuffer.BufferName:
                delete lbSort.
            end.
            ReorderSort().
            
            delete lbBuffer.
            ReorderBuffers().
            
            /* Only one event fires */
            OnQueryDefinitionChanged(
                new QueryDefinitionEventArgs(
                        QueryElementEnum:Buffer,
                        QueryDefinitionOperationEnum:Delete)).
        end.
    end method.    
    
    method protected void ReorderBuffers():
        define buffer lbBuffer for ttBuffer.
        define query qryBuffer for lbBuffer.
        define variable iOrder as integer no-undo.
        
        open query qryBuffer
            preselect each lbBuffer by lbBuffer.Order.
        get first qryBuffer.

        do while not query-off-end('qryBuffer'):
            assign iOrder = iOrder + 1 
                   lbBuffer.Order = iOrder.
        end.
        close query qryBuffer.
    end method.
    
    method public void AddBuffer(pcBuffer as character,
                                 pcTable as character,
                                 poQueryType as QueryTypeEnum,
                                 poLockMode as LockModeEnum):
        define buffer lbBuffer for ttBuffer.
        
        if not can-find(lbBuffer where lbBuffer.BufferName = pcBuffer) then
        do:
            create lbBuffer.
            assign lbBuffer.BufferName = pcBuffer
                   lbBuffer.TableName = (if pcTable eq '' then pcBuffer else pcTable)
                   NumBuffers = NumBuffers + 1 
                   lbBuffer.Order = NumBuffers
                   lbBuffer.LockMode = poLockMode
                   lbBuffer.QueryType = poQueryType.
                   
            OnQueryDefinitionChanged(
                new QueryDefinitionEventArgs(
                        QueryElementEnum:Buffer,
                        QueryDefinitionOperationEnum:Create)).
        end.
    end method.
    
    method public void SetBuffers(pcBuffer as character extent, pcTable as character extent):
        define variable iLoop as integer no-undo.
                       
        do iLoop = 1 to extent(pcBuffer):
            /* Let AddBuffer figure order out */
            AddBuffer(pcBuffer[iLoop], pcTable[iLoop]).
        end.
    end method.
            
    method public void SetBuffers(pcBuffer as character extent):
        SetBuffers(pcBuffer, pcBuffer).
    end method.
        
    method public void SetBufferTable(pcBuffer as character, pcTable as char):
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.
        if not available lbBuffer then
            AddBuffer(pcBuffer, pcTable).
        else
            lbBuffer.TableName = pcTable.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Buffer, QueryDefinitionOperationEnum:Update)).
    end method.
    
    method public void SetBufferLockMode(pcBuffer as character, poLockMode as LockModeEnum):
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.
        if not available lbBuffer then
            AddBuffer(pcBuffer).
        else
            lbBuffer.LockMode = poLockMode.
            
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Buffer, QueryDefinitionOperationEnum:Update)).
    end method.
    
    method public void SetBufferQueryType(pcBuffer as character, poQueryType as QueryTypeEnum):
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.
        if not available lbBuffer then
            AddBuffer(pcBuffer).
        else
            lbBuffer.QueryType = poQueryType.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Buffer, QueryDefinitionOperationEnum:Update)).
    end method.
            
    method public QueryTypeEnum GetBufferQueryType(pcBuffer as char):
        define variable oType as QueryTypeEnum no-undo.
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.        
        if available lbBuffer then 
            oType = cast(lbBuffer.QueryType, QueryTypeEnum).
        
        return oType.
    end method.
    
    method public LockModeEnum GetBufferLockMode(pcBuffer as char):
        define variable oMode as LockModeEnum no-undo.
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.        
        if available lbBuffer then 
            oMode = cast(lbBuffer.LockMode, LockModeEnum).
        
        return oMode.
    end method.
    
    method public character GetBufferTable(pcBuffer as char):
        define variable cTable as char no-undo.
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.        
        if available lbBuffer then 
            cTable = lbBuffer.TableName.
        
        return cTable.        
    end method.
    
    constructor public QueryDefinition():
        super ().
    end constructor.
    
    /** Create a join between 2 buffers in this definition.
    
        @param QueryJoin Parameters for the join. */    
    method public void AddJoin(input poQueryJoin as QueryJoin):
        AddJoin(poQueryJoin:BufferName,
                poQueryJoin:FieldName,
                poQueryJoin:Operator,
                poQueryJoin:JoinBufferName,
                poQueryJoin:JoinFieldName,
                poQueryJoin:JoinType).
    end method.
    
    /** Removes a join between 2 buffers in this definition.
    
        @param QueryJoin Parameters for the join. */    
    method public void RemoveJoin(input poQueryJoin as QueryJoin):
        define buffer lbJoin for ttJoin.
        
        find lbJoin where
             lbJoin.BufferName = poQueryJoin:BufferName and
             lbJoin.FieldName  = poQueryJoin:FieldName and
             lbJoin.Operator = poQueryJoin:Operator and 
             lbJoin.JoinBufferName = poQueryJoin:JoinBufferName and 
             lbJoin.JoinFieldName = poQueryJoin:JoinFieldName
             no-error.
        if available lbJoin then
        do:
            delete lbJoin.             

            OnQueryDefinitionChanged(
                new QueryDefinitionEventArgs(
                        QueryElementEnum:Join,
                        QueryDefinitionOperationEnum:Delete)).                    
        end.
    end method.
    
    /** Create a join between 2 buffers in this definition.
        
        @param character The first buffer name in the join
        @param character The first buffer field in the join
        @param OperatorEnum The operator (=,>, etc)
        @param character The second buffer name in the join
        @param character The second buffer field in the join
        @param JoinEnum The join type (and/or etc) for the filter. */        
    method public void AddJoin (pcBufferName as character,
                                pcFieldName as character,
                                poOperator as OperatorEnum,
                                pcJoinBufferName as character,
                                pcJoinFieldName as character,
                                poJoinType as JoinEnum):
        define buffer lbJoin for ttJoin.
        
        create lbJoin.
        assign lbJoin.BufferName = pcBufferName
               lbJoin.FieldName = pcFieldName
               lbJoin.Operator = poOperator
               lbJoin.JoinBufferName = pcJoinBufferName
               lbJoin.JoinFieldName = pcJoinFieldName
               lbJoin.JoinType = poJoinType.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Join, QueryDefinitionOperationEnum:Create)).
    end method.
    
    method public logical Equals(poQuery as QueryDefinition):
        define variable lEquals as logical no-undo.
        define variable cThis as longchar no-undo.
        define variable cThat as longchar no-undo.
        
        if not valid-object(poQuery) then
            lEquals = false.            
        else
        /* if this is exactly the same object reference, then it's
           exactly the same object (ahem). */
        if int(poQuery) eq int(this-object) then
            lEquals = true.
        else
            lEquals = super:Equals(poQuery).
        
        /* the super call might do way more simple checks, but if we're not equal at that point, 
           we certainly won't pass this test. */
        if lEquals then
            lEquals = compare(this-object:GetMD5(),
                              OperatorEnum:IsEqual:ToString(),
                              poQuery:GetMD5(),
                              CompareStrengthEnum:Raw:ToString()).
        
        return lEquals.
    end method.
    
    method public char GetMD5():
        define variable oOOS as IObjectOutput no-undo.
        define variable mStream as memptr no-undo.
        
        oOOS = new ObjectOutputStream().
        oOOS:WriteObject(this-object).
        oOOS:Write(output mStream).
        
        return string(md5-digest(mStream)).
        
        finally:
            set-size(mStream) = 0.
        end finally.
    end method.
    
    method protected void OnQueryDefinitionChanged (poEventArgs as QueryDefinitionEventArgs):
        this-object:QueryDefinitionChanged:Publish(
                this-object,
                new QueryDefinitionEventArgs(QueryElementEnum:Join, QueryDefinitionOperationEnum:Create)).
    end method.
    
    method public void WriteObject(input po as IObjectOutput):
        po:WriteEnum(QueryBlockType).
        po:WriteLogical(AllowExternalJoins).
        
        po:WriteTable(buffer ttBuffer:handle).
        po:WriteTable(buffer ttFilter:handle).
        po:WriteTable(buffer ttJoin:handle).
        po:WriteTable(buffer ttSort:handle).
    end method.
    
    method public void ReadObject(input po as IObjectInput):
        QueryBlockType = cast(po:ReadEnum(), QueryBlockTypeEnum).
        AllowExternalJoins = po:ReadLogical().
        
        po:ReadTable(table ttBuffer by-reference).
        po:ReadTable(table ttFilter by-reference).
        po:ReadTable(table ttJoin by-reference).
        po:ReadTable(table ttSort by-reference).
    end method.
    
    method public override Object Clone():
        define variable oClone as IQueryDefinition no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oBuffer as QueryBuffer extent no-undo.
        define variable oFilter as QueryFilter extent no-undo.
        define variable oJoin as QueryJoin extent no-undo.
        define variable oSort as QuerySort extent no-undo.
        
        oClone = cast(this-object:GetClass():New(), IQueryDefinition).
        oClone:QueryBlockType = this-object:QueryBlockType.
        oClone:AllowExternalJoins = this-object:AllowExternalJoins.
        
        oBuffer = this-object:GetQueryBuffers().
        iMax = extent(oBuffer).
        do iLoop = 1 to iMax:
            oClone:AddBuffer(oBuffer[iLoop]).
        end.
        
        oFilter = this-object:GetQueryFilters().
        iMax = extent(oFilter).
        do iLoop = 1 to iMax:
            oClone:AddFilter(oFilter[iLoop]).
        end.
        
        oJoin = this-object:GetQueryJoins().
        iMax = extent(oJoin).
        do iLoop = 1 to iMax:
            oClone:AddJoin(oJoin[iLoop]).
        end.
        
        oSort = this-object:GetQuerySort().
        iMax = extent(oSort).
        do iLoop = 1 to iMax:
            oClone:AddSort(oSort[iLoop]).
        end.
        
        return oClone.
    end method.
    
    /** Returns all of the query elements for the query.
        
        @return Object[] An array of the elements that make up this query. */
    method public Object extent GetQueryElements().
        define variable oElements as ICollection no-undo.
        
        oElements = new Collection().
        oElements:Add(QueryBlockType).
        oElements:AddArray(GetQueryBuffers()).
        oElements:AddArray(GetQueryFilters()).
        oElements:AddArray(GetQueryJoins()).
        oElements:AddArray(GetQuerySort()).
        
        return oElements:ToArray().    
    end method.
    
    method public longchar GetQueryString():
        return GetQueryString(GetBufferList()). 
    end.
        
    /** Returns the complete query string (ready for QUERY-PREPARE).
        
        @param character[] An array of buffer names for which 
               return a where clause that filters and joins between all
               buffers.
        @return longchar The query clause string. */
    method public longchar GetQueryString(pcBuffers as character extent):
        define variable cTables as character extent no-undo.
        define variable iExtent as integer no-undo.
        define variable cJoin as character no-undo.
        define variable cFilter as character no-undo.
        define variable cWhere as character no-undo.
        define variable cSortBy as character no-undo.
        define variable cBufferName as character no-undo.
        define variable cQueryBufferList as character no-undo.
        
        define buffer lbBuffer for ttBuffer.  
        
        cWhere = this-object:QueryBlockType:ToString().
        do iExtent = 1 to extent(pcBuffers):
            cBufferName = pcBuffers[iExtent].
            find lbBuffer where lbBuffer.BufferName = cBufferName no-error.
            
            assign cQueryBufferList = cQueryBufferList + ',' + lbBuffer.BufferName 
                   cJoin = GetJoin(cQueryBufferList, cBufferName)
                   cFilter = GetFilter(cBufferName)
                   
                   cSortBy = cSortBy + mcSpacer + GetSort(cBufferName)
                   
                   /* Note: where string broken up for readability. */
                   cWhere = cWhere + mcSpacer 
                          + cast(lbBuffer.QueryType, EnumMember):ToString() + mcSpacer 
                          + lbBuffer.BufferName.
           
            
            if cJoin ne '' then
            do:
                cWhere = cWhere             + mcSpacer 
                        + 'where'           + mcSpacer 
                        + '(' + cJoin + ') '.
                if cFilter ne '' then
                    cWhere = cWhere                     + mcSpacer 
                           + JoinEnum:And:ToString()    + mcSpacer 
                           + '(' + cFilter + ') '.
            end.
            else
            if cFilter ne '' then
                cWhere = cWhere + mcSpacer + 'where' + mcSpacer + cFilter.
            
            /* lock status and terminate */
            cWhere = cWhere + mcSpacer 
                   + cast(lbBuffer.LockMode,EnumMember):ToString() + mcSpacer
                   + (if iExtent ne extent(pcBuffers) then ', ' else '').
        end.
        
        return cWhere + mcSpacer + cSortBy.
    end method.

/** SORT CRITERIA **/
    /** Add a sort condition to the definition.
    
        @param character The buffer being sorted
        @param character The field being sorted
        @param SortDirection The direction of the sort. */
    method public void AddSort (pcBufferName as character,
                                pcFieldName as character,
                                poSortDirection as SortDirectionEnum):
        define variable iOrder as integer no-undo.

        define buffer lbSort for ttSort.
        define query qrySort for lbSort.
        
        open query qrySort 
            preselect each lbSort by lbSort.Order.
        
        iOrder = query qrySort:num-results + 1.
        
        AddSort(pcBufferName, pcFieldName, poSortDirection, iOrder).                                
    end method.
    
    /** Add a sort condition to the definition.
        
        @param character The buffer being sorted
        @param character The field being sorted
        @param SortDirection The direction of the sort.
        @param integer The ordinal position of the sort phrase for the buffer. */    
    method public void AddSort (pcBufferName as character,
                                pcFieldName as character,
                                poSortDirection as SortDirectionEnum,
                                piOrder as integer ):
        define buffer lbSort for ttSort.
        
        find lbSort where
             lbSort.BufferName = pcBufferName and
             lbSort.FieldName = pcFieldName
             no-error.
        if not available lbSort then
        do:
            create lbSort.
            assign lbSort.BufferName = pcBufferName
                   lbSort.FieldName = pcFieldName.
        end.
        
        assign lbSort.Direction = poSortDirection
               lbSort.Order     = piOrder.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Sort, QueryDefinitionOperationEnum:Create)).
    end method.
    
    /** Add a sort condition to the definition.
        
        @param QuerySort Parameters for the sort. */     
    method public void AddSort(input poQuerySort as QuerySort):
        define variable iOrder as integer no-undo.

        define buffer lbSort for ttSort.
        define query qrySort for lbSort.
        
        open query qrySort 
            preselect each lbSort by lbSort.Order.
        
        iOrder = query qrySort:num-results + 1.
        
        AddSort(poQuerySort:BufferName,
                poQuerySort:FieldName,
                poQuerySort:Direction,
                iOrder).
    end method.
    

    /** Removes a sort condition from the definition.
        
        @param QuerySort Parameters for the sort. */ 
    method public void RemoveSort(input poQuerySort as QuerySort).
        define buffer lbSort for ttSort.
        
        find lbSort where
             lbSort.BufferName = poQuerySort:BufferName and
             lbSort.FieldName = poQuerySort:FieldName
             no-error.
        if available lbSort then
        do:
            delete lbSort.
        
            ReorderSort().
            
            OnQueryDefinitionChanged(
                new QueryDefinitionEventArgs(
                        QueryElementEnum:Sort,
                        QueryDefinitionOperationEnum:Delete)).                    
        end.
    end method.
    
    method protected void ReorderSort():
        define buffer lbSort for ttSort.
        define query qrySort for lbSort.
        define variable iOrder as integer no-undo.
        
        open query qrySort 
            preselect each lbSort by lbSort.Order.
        get first qrySort.
        
        do while not query-off-end('qrySort'):
            assign iOrder = iOrder + 1 
                   lbSort.Order = iOrder.
        end.
        close query qrySort.
    end method.
    
    /** Returns sort information for all buffers in the definition.
        
        @return longchar A complete sort string for all buffers in the definition. */
    method public longchar GetSort():
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cBuffers as character extent no-undo.
        define variable cSortBy as longchar no-undo.
        
        cBuffers = GetBufferList().
        iMax = extent(cBuffers).
        
        do iLoop = 1 to iMax:
            cSortBy = cSortBy + mcSpacer + GetSort(cBuffers[iLoop]).
        end.
        
        return cSortBy.
    end method.
    
    /** Returns sort information.
        
        @param character The buffer name for which to retrieve sort information
        @return longchar A complete sort string for the specified buffer. */
    method public longchar GetSort(input pcBufferName as character):
        define variable cSortBy as longchar no-undo.
        define variable oSortDirection as EnumMember no-undo.
        
        define buffer lbSort for ttSort.
        
        for each lbSort where
                 lbSort.BufferName = pcBufferName
                 by lbSort.Order:
            assign oSortDirection = cast(lbSort.Direction, EnumMember)
                   cSortBy = cSortBy + ' by '
                         + lbSort.BufferName + '.' + lbSort.FieldName + mcSpacer 
                         + (if oSortDirection:Equals(SortDirectionEnum:Ascending) then '' 
                            else oSortDirection:ToString() ).
        end.
        
        return cSortBy.
    end method.
    
    /** Returns the Sort information for the given buffer.
           
        @param character The buffer name for which to retrieve sort information
        @return QuerySort[] An ordered array of sort parameters */    
    method public QuerySort extent GetQuerySort(input pcBufferName as character):
        define buffer lbSort for ttSort.
        define query qrySort for lbSort.
        
        open query qrySort 
            preselect each lbSort where
                           lbSort.BufferName = pcBufferName
                           by lbSort.Order.
        return FillQuerySort(query qrySort:handle).
    end method.

    /** Returns the Sort information for all buffers. 
        
        @return QuerySort[] An ordered array of sort parameters */    
    method public QuerySort extent GetQuerySort():
        define buffer lbBuffer for ttBuffer.
        define buffer lbSort for ttSort.
        
        define query qrySort for lbBuffer, lbSort.
        
        open query qrySort
            preselect each lbBuffer,
                      each lbSort where
                           lbSort.BufferName = lbBuffer.BufferName
                      by lbBuffer.Order
                      by lbSort.Order.
        
        return FillQuerySort(query qrySort:handle).            
    end method.
    
    /** Creates QuerySort objects based on a query.
        
        @param handle The open query used to filter sort records.
        @return QuerySort[] An ordered array of sort parameter objects. */
    method protected QuerySort extent FillQuerySort(input phQuery as handle):
        define variable oQS as QuerySort extent no-undo.
        define variable hBuffer as handle no-undo.
        
        if valid-handle(phQuery) and 
           phQuery:is-open and 
           phQuery:num-results gt 0 then
        do:
            extent(oQS) = phQuery:num-results.
            hBuffer = phQuery:get-buffer-handle('lbSort') no-error.
            if not valid-handle(hBuffer) then
                hBuffer = phQuery:get-buffer-handle('ttSort').
            
            phQuery:get-first().
            do while not phQuery:query-off-end:
                oQS[phQuery:current-result-row] =
                        new QuerySort(hBuffer::BufferName,
                                      hBuffer::FieldName,
                                      cast(hBuffer::Direction, SortDirectionEnum)).
                phQuery:get-next().
            end.
            phQuery:query-close().
        end.
        
        return oQS.        
    end method.
    
    /** Returns the filter criteria for a buffer, in string form. This
        could be used as-is for a WHERE clause.
        
        @param character The buffer name 
        @return longchar The where-clause-compatible string. */    
    method public longchar GetFilter(input pcBufferName as character):
        define variable cWhereClause as longchar no-undo.
        define variable cValue as character no-undo.
        
        define buffer lbFilter for ttFilter.
        
        for each lbFilter where lbFilter.BufferName = pcBufferName:
            if cWhereClause <> '' then
                cWhereClause = cWhereClause                                     + mcSpacer
                              + cast(lbFilter.JoinType, EnumMember):ToString()  + mcSpacer.
            
            cValue = string(cast(lbFilter.FieldValue, String):Value).
            if cast(lbFilter.FieldType, DataTypeEnum):Equals(DataTypeEnum:Rowid) then
                cWhereClause = cWhereClause                                     + mcSpacer
                             + 'rowid(' + quoter(lbFilter.BufferName) + ')'     + mcSpacer 
                             + cast(lbFilter.Operator, EnumMember):ToString()   + mcSpacer
                             + 'to-rowid(' + quoter(cValue) + ')'.
            else
                cWhereClause = cWhereClause                                     + mcSpacer
                             + lbFilter.BufferName + '.' + lbFilter.FieldName   + mcSpacer 
                             + cast(lbFilter.Operator, EnumMember):ToString()   + mcSpacer
                             + quoter(cValue).
        end.
        
        return cWhereClause. 
    end method.
    
    /** Returns the filters applicable to a buffer.
       
        @param character The buffer name
        @return QueryFilter[] An array of query filter objects that
                apply to this buffer. */    
    method public QueryFilter extent GetQueryFilter(input pcBufferName as character):
        define buffer lbFilter for ttFilter.
        define query qryFilter for lbFilter.
        
        open query qryFilter 
            preselect each lbFilter where
                           lbFilter.BufferName = pcBufferName.
        
        return FillQueryFilter(query qryFilter:handle).
    end method.
    
    /** Returns the filters applicable to all the buffers in the query.
       
        @return QueryFilter[] An array of query filter objects that apply 
                to all the buffers. The filters are ordered by buffer order. */
    method public QueryFilter extent GetQueryFilters():
        define buffer lbBuffer for ttBuffer.
        define buffer lbFilter for ttFilter.
        
        define query qryFilter for lbBuffer, lbFilter.
        
        open query qryFilter
            preselect each lbBuffer, 
                      each lbFilter where
                           lbFilter.BufferName = lbBuffer.BufferName
                           by lbBuffer.Order.
        
        return FillQueryFilter(query qryFilter:handle).
    end method.    

    /** Returns the joins applicable to a buffer.
        
        @param character The buffer name
        @return QueryJoin[] An array of query filter objects that
                apply to this buffer. */
    method public QueryJoin extent GetQueryJoin(input pcBufferName as character):
        define buffer lbBuffer for ttBuffer.
        define buffer lbJoin for ttJoin.
        
        define query qryJoin for lbBuffer, lbJoin.
        
        open query qryJoin
            preselect each lbBuffer where
                           lbBuffer.BufferName = pcBufferName, 
                      each lbJoin where
                           lbJoin.BufferName = lbBuffer.BufferName.
        
        return FillQueryJoin(query qryJoin:handle, pcBufferName).        
    end method.
    
    /** Returns the joins applicable to all the buffers in the query.
       
        @return QueryJoin[] An array of query join objects that apply 
                to all the buffers. The joins are ordered by buffer order. */
    method public QueryJoin extent GetQueryJoins():
        define buffer lbBuffer for ttBuffer.
        define buffer lbJoin for ttJoin.
        
        define query qryJoin for lbBuffer, lbJoin.
        
        open query qryJoin
            preselect each lbBuffer, 
                      each lbJoin where
                           lbJoin.BufferName = lbBuffer.BufferName
                           by lbBuffer.Order.
        
        return FillQueryJoin(query qryJoin:handle, '*').
    end method.
    
    /** Creates QueryJoin objects based on a query.
        
        @param handle The open query used to filter sort records.
        @param character The name of the buffers that will be used in the 
               query. This allows us to join from and to a buffer.
        @return QueryJoin[] An ordered array of sort parameter objects. */
    method protected QueryJoin extent FillQueryJoin(input phQuery as handle,
                                                    input pcBuffersInQuery as character):
        define variable oQJ as QueryJoin extent no-undo.
        define variable hBuffer as handle no-undo.
        
        if valid-handle(phQuery) and 
           phQuery:is-open and 
           phQuery:num-results gt 0 then
        do:
            extent(oQJ) = phQuery:num-results.
            hBuffer = phQuery:get-buffer-handle('lbJoin') no-error.
            if not valid-handle(hBuffer) then
                hBuffer = phQuery:get-buffer-handle('ttJoin').
            
            phQuery:get-first().
            do while not phQuery:query-off-end:
                if can-do(pcBuffersInQuery, hBuffer::BufferName) and 
                   can-do(pcBuffersInQuery, hBuffer::JoinBufferName) then
                do:
                    oQJ[phQuery:current-result-row] =
                        new QueryJoin(hBuffer::BufferName,
                                      hBuffer::FieldName,
                                      cast(hBuffer::Operator, OperatorEnum),
                                      hBuffer::JoinBufferName,
                                      hBuffer::JoinFieldName,
                                      cast(hBuffer::JoinType, JoinEnum)).
                end.
                phQuery:get-next().
            end.
            phQuery:query-close().
        end.
        
        return oQJ.        
    end method.    
    /** Creates QuerySort objects based on a query.
        
        @param handle The open query used to filter sort records.
        @return QuerySort[] An ordered array of sort parameter objects. */
    method protected QueryFilter extent FillQueryFilter(input phQuery as handle):
        define variable oQF as QueryFilter extent no-undo.
        define variable hBuffer as handle no-undo.
        
        if valid-handle(phQuery) and 
           phQuery:is-open and 
           phQuery:num-results gt 0 then
        do:
            extent(oQF) = phQuery:num-results.
            hBuffer = phQuery:get-buffer-handle('lbFilter') no-error.
            if not valid-handle(hBuffer) then
                hBuffer = phQuery:get-buffer-handle('ttFilter').
            
            phQuery:get-first().
            do while not phQuery:query-off-end:
                oQF[phQuery:current-result-row] =
                        new QueryFilter(hBuffer::BufferName,
                                        hBuffer::FieldName,
                                        cast(hBuffer::Operator, OperatorEnum),
                                        cast(hBuffer::FieldValue, String),
                                        cast(hBuffer::FieldType, DataTypeEnum),
                                        cast(hBuffer::JoinType, JoinEnum)).
                phQuery:get-next().
            end.
            phQuery:query-close().
        end.
        
        return oQF.        
    end method.
        
    method protected longchar GetJoin(pcBuffersInQuery as character, pcBufferName as character):
        define variable cWhereClause as longchar no-undo.
        define variable iExtent as integer no-undo.
        define buffer lbJoin for ttJoin.
        
        for each lbJoin where 
                 lbJoin.BufferName = pcBufferName or
                 lbJoin.JoinBufferName = pcBufferName:
            if lookup(lbJoin.BufferName, pcBuffersInQuery) gt 0 and 
               (AllowExternalJoins or lookup(lbJoin.JoinBufferName, pcBuffersInQuery) gt 0) then
            do:
                if cWhereClause <> '' then
                    cWhereClause = cWhereClause + mcSpacer
                                  + cast(lbJoin.JoinType, EnumMember):ToString() + mcSpacer.
                cWhereClause = cWhereClause
                             + lbJoin.BufferName + '.' + lbJoin.FieldName + mcSpacer 
                             + cast(lbJoin.Operator, EnumMember):ToString() + mcSpacer
                             + lbJoin.JoinBufferName + '.' + lbJoin.JoinFieldName.
            end.
        end.
        
        return cWhereClause. 
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : QueryDefinitionEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Sep 02 14:50:19 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.EventArgs.
using OpenEdge.Core.System.QueryElementEnum.
using OpenEdge.Core.System.QueryDefinitionOperationEnum.

class OpenEdge.Core.System.QueryDefinitionEventArgs inherits EventArgs: 

    define public property Element   as QueryElementEnum no-undo get. set.
    define public property Operation as QueryDefinitionOperationEnum no-undo get. set.
    define public property Value     as character no-undo get. set.
    
    @todo(task="implement", action="add querybuffer/filter that changed?").
    
    constructor public QueryDefinitionEventArgs():
        super().
    end constructor.
    
    constructor public QueryDefinitionEventArgs(poElement as QueryElementEnum, poOperation as QueryDefinitionOperationEnum):
        this-object(poElement, poOperation, ?).
    end constructor.
        
    constructor public QueryDefinitionEventArgs(poElement as QueryElementEnum, poOperation as QueryDefinitionOperationEnum, pcValue as char):
        this-object().
        
        this-object:Element = poElement.
        this-object:Operation = poOperation.        
        this-object:Value = pcValue.
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : QueryDefinitionOperationEnum
    Purpose     : Enumeration of operations on a query definition
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Sep 02 14:57:50 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.QueryDefinitionOperationEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.System.QueryDefinitionOperationEnum final inherits EnumMember: 
    
    define public static property Empty     as QueryDefinitionOperationEnum no-undo get. private set.
    define public static property Create    as QueryDefinitionOperationEnum no-undo get. private set.
    define public static property Delete    as QueryDefinitionOperationEnum no-undo get. private set.
    define public static property Update    as QueryDefinitionOperationEnum no-undo get. private set.
    
    constructor static QueryDefinitionOperationEnum():
        QueryDefinitionOperationEnum:Empty  = new QueryDefinitionOperationEnum('Empty').
        QueryDefinitionOperationEnum:Create = new QueryDefinitionOperationEnum('Create').
        QueryDefinitionOperationEnum:Delete = new QueryDefinitionOperationEnum('Delete').
        QueryDefinitionOperationEnum:Update = new QueryDefinitionOperationEnum('Update').
    end constructor.

    constructor public QueryDefinitionOperationEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : QueryElement
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Dec 10 10:54:16 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

class OpenEdge.Core.System.QueryElement abstract: 

end class./** ------------------------------------------------------------------------
    File        : QueryElementEnum
    Purpose     : Enumeration of elements/component parts of a query 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Sep 02 15:01:39 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.QueryElementEnum.
using OpenEdge.Lang.FlagsEnum.

class OpenEdge.Core.System.QueryElementEnum final inherits FlagsEnum:
    
    define public static property Buffer    as QueryElementEnum no-undo get. private set.
    define public static property Join      as QueryElementEnum no-undo get. private set.
    define public static property Filter    as QueryElementEnum no-undo get. private set.
    define public static property Sort      as QueryElementEnum no-undo get. private set.
    
    constructor static QueryElementEnum():
        QueryElementEnum:Buffer = new QueryElementEnum(1).
        QueryElementEnum:Join = new QueryElementEnum(2).
        QueryElementEnum:Filter = new QueryElementEnum(4).
        QueryElementEnum:Sort = new QueryElementEnum(8).
    end constructor.

    constructor public QueryElementEnum ( input piValue as integer ):
        super (input piValue).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : QueryFilter
    Purpose     : Parameter object for query filter clauses, used in IQueryDefinition 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Dec 10 10:16:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.System.QueryFilter
        implements IExternalizable:

    define public property BufferName as character no-undo get. set.
    define public property FieldName as character no-undo get. set.
    define public property Operator as OperatorEnum no-undo get. set.
    /* FieldValue can be refactored into individual abl primitives, and so remove the
       need for FieldType */
    define public property FieldValue as String no-undo get. set.
    define public property FieldType as DataTypeEnum no-undo get. set.
    define public property JoinType as JoinEnum no-undo get. set.
    
    constructor public QueryFilter(input pcBufferName as character,
                                   input pcFieldName as character,
                                   input poOperator as OperatorEnum,
                                   input poFieldValue as String,
                                   input poFieldType as DataTypeEnum,
                                   input poJoinType as JoinEnum):
        
        Assert:ArgumentNotNullOrEmpty(pcBufferName, 'Buffer Name').
        Assert:ArgumentNotNullOrEmpty(pcFieldName, 'Field Name').
        Assert:ArgumentNotNull(poOperator, 'Operator').
        /* field value can be null, but the string object not so  */
        Assert:ArgumentNotNull(poFieldValue, 'Field value object').
        Assert:ArgumentNotNull(poJoinType, 'Join type').
        Assert:ArgumentNotNull(poFieldType, 'Field datatype').
        
        assign BufferName = pcBufferName
               FieldName = pcFieldName
               Operator = poOperator
               FieldValue = poFieldValue
               FieldType = poFieldType
               JoinType = poJoinType.
    end constructor.
    
    method override public logical Equals(input p0 as Object):
        define variable lEquals as logical no-undo.
        define variable oQB as QueryFilter no-undo.
                
        lEquals = super:Equals(input p0).
        
        if not lEquals and type-of(p0, QueryFilter) then
            assign oQB = cast(p0, QueryFilter)
                   lEquals = oQB:BufferName eq this-object:BufferName
                         and oQB:FieldName eq this-object:FieldName                    
                         and oQB:Operator:Equals(this-object:Operator)
                         and oQB:FieldType:Equals(this-object:FieldType)
                         and oQB:JoinType:Equals(this-object:JoinType)
                         and oQB:FieldValue:Equals(this-object:FieldValue).
        
        return lEquals.
    end method.
    
    method public void WriteObject( input poStream as IObjectOutput):
        poStream:WriteChar(BufferName).
        poStream:WriteChar(FieldName).
        poStream:WriteEnum(Operator).
        poStream:WriteEnum(FieldType).
        poStream:WriteEnum(JoinType).
        poStream:WriteObject(FieldValue).
    end method.

    method public void ReadObject( input poStream as IObjectInput ):
        assign BufferName = poStream:ReadChar()
               FieldName = poStream:ReadChar()
               Operator = cast(poStream:ReadEnum(), OperatorEnum)
               FieldType =  cast(poStream:ReadEnum(), DataTypeEnum)
               JoinType =  cast(poStream:ReadEnum(), JoinEnum)
               FieldValue = cast(poStream:ReadObject(), String).
    end method.
    
    method override public character ToString():
        define variable cWhereClause as character no-undo.
        define variable cValue as character no-undo.
        
        assign cWhereClause = ' ' + JoinType:ToString() + ' '
               cValue = string(FieldValue:Value).
        
        if FieldType:Equals(DataTypeEnum:Rowid) then
            cWhereClause = cWhereClause 
                         + 'rowid(' + quoter(BufferName) + ')' 
                         + Operator:ToString() + ' '
                         + 'to-rowid(' + quoter(cValue) + ')'.
        else
        if FieldType:Equals(DataTypeEnum:Handle) then
            cWhereClause = cWhereClause 
                         + BufferName + '.' + FieldName + ' ' 
                         + Operator:ToString() + ' '
                         + 'widget-handle(' + quoter(cValue) + ')'.
        else
            cWhereClause = cWhereClause
                         + BufferName + '.' + FieldName + ' ' 
                         + Operator:ToString() + ' '
                         + quoter(cValue).
        
        return cWhereClause.
    end method.
        
end class./** ------------------------------------------------------------------------
    File        : QueryHeader
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Dec 10 13:05:12 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

class OpenEdge.Core.System.QueryHeader: 

end class./** ------------------------------------------------------------------------
    File        : QueryJoin
    Purpose     : Parameter object for query join clauses, used in IQueryDefinition 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Dec 10 10:16:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.QueryJoin.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.System.QueryJoin
        implements IExternalizable:
    
    define public property BufferName as character no-undo get. set.
    define public property FieldName as character no-undo get. set.
    define public property Operator as OperatorEnum no-undo get. set.
    define public property JoinBufferName as character no-undo get. set.
    define public property JoinFieldName as character no-undo get. set.
    define public property JoinType as JoinEnum no-undo get. set.
    
    /** Indicates that the JoinBuffer is an external (to this definition anyway)
        join. This may be the case in queries used on ProDataSets' Data-sources,
        where the where string is generated between a DB table and a temp-table in the
        PDS. The query in that case doesn't know about the temp-table 
    @todo(task="refactor", action="create DatasourceQueryDef?").     
    define public property JoinBufferIsExternal as logical no-undo get. set.
        */
    
    constructor public QueryJoin(input pcBufferName as character,
                                 input pcFieldName as character,
                                 input poOperator as OperatorEnum,
                                 input pcJoinBufferName as character,
                                 input pcJoinFieldName as character,
                                 input poJoinType as JoinEnum):
        
        Assert:ArgumentNotNullOrEmpty(pcBufferName, 'Buffer Name').
        Assert:ArgumentNotNullOrEmpty(pcFieldName, 'Field Name').
        Assert:ArgumentNotNull(poOperator, 'Operator').
        Assert:ArgumentNotNull(poJoinType, 'Join type').
        Assert:ArgumentNotNullOrEmpty(pcJoinBufferName, 'Join Buffer Name').
        Assert:ArgumentNotNullOrEmpty(pcJoinFieldName, 'Join Field Name').
        
        assign BufferName = pcBufferName
               FieldName = pcFieldName
               Operator = poOperator
               JoinBufferName = pcJoinBufferName
               JoinFieldName = pcJoinFieldName
               JoinType = poJoinType.
    end constructor.
    
    method override public logical Equals(input p0 as Object):
        define variable lEquals as logical no-undo.
        define variable oQB as QueryJoin no-undo.
                
        lEquals = super:Equals(input p0).

        if not lEquals and type-of(p0, QueryJoin) then
            assign oQB = cast(p0, QueryJoin)
                   lEquals = oQB:BufferName eq this-object:BufferName
                         and oQB:FieldName eq this-object:FieldName                    
                         and oQB:Operator:Equals(this-object:Operator)
                         and oQB:JoinBufferName eq this-object:JoinBufferName
                         and oQB:JoinFieldName eq this-object:JoinFieldName.
        
        return lEquals.
    end method.
    
    method public void WriteObject( input poStream as IObjectOutput):
        poStream:WriteChar(BufferName).
        poStream:WriteChar(FieldName).
        poStream:WriteEnum(Operator).
        poStream:WriteChar(JoinBufferName).
        poStream:WriteChar(JoinFieldName).
        poStream:WriteEnum(JoinType).
    end method.

    method public void ReadObject( input poStream as IObjectInput ):
        assign BufferName = poStream:ReadChar()
               FieldName = poStream:ReadChar()
               Operator = cast(poStream:ReadEnum(), OperatorEnum)
               JoinType =  cast(poStream:ReadEnum(), JoinEnum)
               JoinBufferName = poStream:ReadChar()
               JoinFieldName = poStream:ReadChar().
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : QuerySort
    Purpose     : Parameter object for query buffers, used in IQueryDefinition 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Dec 10 10:16:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.QuerySort.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Lang.SortDirectionEnum .
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.System.QuerySort
        implements IExternalizable:
    
    define public property BufferName as character no-undo get. set.
    define public property FieldName as character no-undo get. set.
    define public property Direction as SortDirectionEnum no-undo get. set.
    
    constructor public QuerySort(input pcBufferName as character,
                                 input pcFieldName as character,
                                 input poDirection as SortDirectionEnum):
        Assert:ArgumentNotNullOrEmpty(pcBufferName, 'Buffer Name').
        Assert:ArgumentNotNullOrEmpty(pcFieldName, 'Field Name').
        Assert:ArgumentNotNull(poDirection, 'Direction').
        
        assign BufferName = pcBufferName
               FieldName = pcFieldName
               Direction = poDirection. 
    end constructor.

    constructor public QuerySort(input pcBufferName as character,
                                 input pcFieldName as character):
        this-object(pcBufferName, pcFieldName, SortDirectionEnum:Default).                                     
    end constructor.
    
    method override public logical Equals(input p0 as Object):
        define variable lEquals as logical no-undo.
        define variable oQB as QuerySort no-undo.
                
        lEquals = super:Equals(input p0).
        
        if not lEquals and type-of(p0, QuerySort) then
            assign oQB = cast(p0, QuerySort)
                   lEquals = oQB:BufferName eq this-object:BufferName
                         and oQB:FieldName eq this-object:FieldName
                         and oQB:Direction:Equals(this-object:Direction).
        
        return lEquals.
    end method.
    
    method public void WriteObject( input poStream as IObjectOutput):
        poStream:WriteChar(BufferName).
        poStream:WriteChar(FieldName).
        poStream:WriteEnum(Direction).
    end method.

    method public void ReadObject( input poStream as IObjectInput ):
        assign BufferName= poStream:ReadChar()
               FieldName = poStream:ReadChar()
               Direction =  cast(poStream:ReadEnum(), SortDirectionEnum).
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : RowPositionEnum
    Purpose     : Enumerates the relative position of a row within a query. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 16:53:01 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.RowPositionEnum. 
using OpenEdge.Lang.EnumMember. 

class OpenEdge.Core.System.RowPositionEnum final inherits EnumMember: 
    
    /** None means no records in the query. */
    define public static property None           as RowPositionEnum no-undo get. private set.
    define public static property IsFirst        as RowPositionEnum no-undo get. private set.
    define public static property IsLast         as RowPositionEnum no-undo get. private set.
    define public static property IsFirstAndLast as RowPositionEnum no-undo get. private set.
    define public static property NotFirstOrLast as RowPositionEnum no-undo get. private set.
    
    constructor static RowPositionEnum():
        RowPositionEnum:None = new RowPositionEnum('None').
        RowPositionEnum:IsFirst = new RowPositionEnum('IsFirst').
        RowPositionEnum:IsLast = new RowPositionEnum('IsLast').
        RowPositionEnum:IsFirstAndLast = new RowPositionEnum('IsFirstAndLast').
        RowPositionEnum:NotFirstOrLast = new RowPositionEnum('NotFirstOrLast').        
    end constructor.

    constructor public RowPositionEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class.@deprecated(version="0.0").
/** ------------------------------------------------------------------------
    File        : UITypeEnum
    Purpose     : Lists the supported UI types  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Apr 23 15:08:30 EDT 2010
    Notes       : * This class is not final since implementers could have their
                    own names for UI types.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.UITypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.System.UITypeEnum inherits EnumMember:
    /** Character-mode UI */
    define static public property Chui as UITypeEnum no-undo get. private set.
    /** 'Classic' ABL GUI */
    define static public property AblGui as UITypeEnum no-undo get. private set.
    /* OpenEdge GUI for .NET */
    define static public property DotNetGui as UITypeEnum no-undo get. private set.
    /** RIA/Web UI */
    define static public property RiaGui as UITypeEnum no-undo get. private set.
    
    constructor static UITypeEnum():
        assign UITypeEnum:Chui = new UITypeEnum('Chui')
               UITypeEnum:AblGui = new UITypeEnum('AblGui')
               UITypeEnum:DotNetGui = new UITypeEnum('DotNetGui')
               UITypeEnum:RiaGui = new UITypeEnum('RiaGui').
    end constructor.
    
    constructor public UITypeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : UnhandledError
    Purpose     : An OE ApplicationError to wrap any unhandled PLE that may come along.
                  This allows us to use the standard ShowMessage() etc constructs that
                  are part of the ApplicationError 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue May 03 14:14:57 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Lang.Assert.
using Progress.Lang.Error.
using Progress.Lang.Class.

class OpenEdge.Core.System.UnhandledError inherits ApplicationError: 
	define override protected property ErrorText as longchar no-undo get. set. 
	define override protected property ErrorTitle as character no-undo get. set. 
		
	constructor public UnhandledError (input poInnerError as Error):
		super(input poInnerError).
		
		/* this class is only meant for non-ApplicationError errors (ie the unhandled ones :) ) */
		Assert:ArgumentNotType(poInnerError, Class:GetClass('OpenEdge.Core.System.ApplicationError')).
		
        ErrorText = 'Unhandled error &1'.
        ErrorTitle = 'Unhandled Progress.Lang.Error'.
	end constructor.

    /** For these unhandled errors, there is no containing error, so we only show the inner error's
        resovled text. */
    method override public character ResolvedMessageText():
        return ResolveInnerErrorText('').
	end method.
	
end class./** ------------------------------------------------------------------------
    File        : UnsupportedOperationError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Sep 02 13:46:49 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ErrorSeverityEnum.
using OpenEdge.Core.System.UnsupportedOperationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.UnsupportedOperationError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
    
    constructor public UnsupportedOperationError (pcArgs1 as char, pcArgs2 as char):
        this-object(?,pcArgs1,pcArgs2).       
    end constructor.

    constructor public UnsupportedOperationError (poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public UnsupportedOperationError(poErr as Error):
        super(poErr).
        
        this-object:Severity = (ErrorSeverityEnum:Debug:Value + ErrorSeverityEnum:Warning:Value).
        this-object:ErrorTitle = 'Unsupported Operation Error'.
        this-object:ErrorText = '&1 is not supported for &2'.
    end constructor.
  
end class./*------------------------------------------------------------------------
    File        : ValueNotSpecifiedError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 07 16:46:43 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ValueNotSpecifiedError.
using Progress.Lang.Error.

class OpenEdge.Core.System.ValueNotSpecifiedError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
    
    constructor public ValueNotSpecifiedError (poErr as Error):
        super(poErr).
        ErrorText = 'No &1 specified for &2'.
        ErrorTitle = 'Value Not Specified Error'.        
    end constructor.
    
    constructor public ValueNotSpecifiedError (pcArgs1 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1).
    end constructor.
    
    constructor public ValueNotSpecifiedError (poErr as Error,pcArgs1 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
    end constructor.
    
    constructor public ValueNotSpecifiedError (pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs2,pcArgs2).
    end constructor.    
    
    constructor public ValueNotSpecifiedError (poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
end class./* ------------------------------------------------------------------------
    File        : BinaryOperationsHelper
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jan 15 14:56:25 EST 2010
    Notes       : * This class based on Garry Hall's binop.i utility    
                  * Utilities to perform bitwise logical operations,
                    which the ABL does not provide. All operations are performed
                    by and on INTEGERs.
                  * These are slower than using ABL arithmetic operators,
                    so try to use an arithmetic operation if possible
                    e.g.    (myval & 255) is the same as (myval mod 256)
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

class OpenEdge.Core.Util.BinaryOperationsHelper:
     
    /* BinAnd - returns the bitwise AND of two INTEGERs as an INT
       INPUT ipiOp1 AS INT - first operand to AND operation
       INPUT ipiOp2 AS INT - second operand to AND operation */
    method static public int BinAnd(piOp1 as int, piOp2 as int):
        define variable ires  as integer init 0 no-undo.
        define variable iloop as integer no-undo.
        
        do iloop = 1 to 32:
            if get-bits(piOp1, iloop, 1) + get-bits(piOp2, iloop, 1) ge 2 then
                put-bits(ires,iloop,1) = 1.
        end.
        
        return ires.
    end method.
    
    /* BinOr  - returns the bitwise OR of two INTEGERs as an INT
       INPUT ipiOp1 AS INT - first operand to OR operation
       INPUT ipiOp2 AS INT - second operand to OR operation */
    method static public int BinOr(piOp1 as int, piOp2 as int):
        define variable ires  as integer init 0 no-undo.    
        define variable iloop as integer no-undo.
        
        do iloop = 1 to 32:
            if get-bits(piOp1, iloop, 1) + get-bits(piOp2, iloop, 1) ge 1 then
                put-bits(ires,iloop,1) = 1.
        end.
        
        return ires.
    end method.

    /* Xor - returns the bitwise Xor of two INTEGERs as an INT
       INPUT ipiOp1 AS INT - first operand to Xor operation
       INPUT ipiOp2 AS INT - second operand to Xor operation
       Derivations:
           BinXor - same operation, provided for consistent naming */
    method static public int Xor (piOp1 as int, piOp2 as int):
        define variable ires  as integer init 0 no-undo.    
        define variable iloop as integer no-undo.
        
        do iloop = 1 to 32:
            if get-bits(piOp1, iloop, 1) + get-bits(piOp2, iloop, 1) eq 1 then
                put-bits(ires,iloop,1) = 1.
        end.
        return ires.
    end method.
    
    method static public int BinXor(piOp1 as int, piOp2 as int):
        return Xor(piOp1,piOp2).
    end method.
    
    /* BinNot - returns the bitwise NOT of an INTEGER as an INT
       INPUT ipiOp1 AS INT - the operand to the NOT operation
       Note that this is performed on ALL 32 bits of the int.
       This is also the same as the following arithmetic:
        -1  (ipiOp1 + 1)   */
    method static public int BinNot(piOp1 as int):
        define variable ires  as integer init 0 no-undo.    
        define variable iloop as integer no-undo.
        
        do iloop = 1 to 32:
            if get-bits(piOp1, iloop, 1) eq 0 then
                put-bits(ires,iloop,1) = 1.
        end.
        
        return ires.
    end method.
    
end class./*------------------------------------------------------------------------
    File        : BufferHelper
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 19 15:16:47 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.BufferNotAvailableError.
using OpenEdge.Core.System.BufferFieldMismatchError.

using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.CompareStrengthEnum.
using OpenEdge.Lang.DataTypeEnum.

class OpenEdge.Core.Util.BufferHelper: 
    
    method public static character extent BufferCompare (phSource as handle,
                                                         phTarget as handle):
        define variable iLoop          as integer   no-undo.
        define variable iField         as integer   no-undo.
        define variable hSourceField   as handle    no-undo.
        define variable hTargetField   as handle    no-undo.
        define variable iExtent        as integer   no-undo.
        define variable lExtent        as logical   no-undo.
        define variable iNumItems      as integer   no-undo.
        define variable iNumDiff       as integer   no-undo.
        define variable cChangedFields as character extent no-undo.
        define variable cTempFields    as character extent no-undo.
        
        if not valid-handle(phSource) then
            undo, throw new InvalidValueSpecifiedError('source buffer').
                        
        if not phSource:available then
            undo, throw new BufferNotAvailableError(phSource:name).

        if not valid-handle(phTarget) then
            undo, throw new InvalidValueSpecifiedError('target buffer').
                
        if not phTarget:available then
            undo, throw new BufferNotAvailableError(phTarget:name).
        
        /* max size is num fields in buffer */
        extent(cTempFields) = phSource:num-fields.
        
        do iField = 1 to phSource:num-fields:
            hSourceField = phSource:buffer-field(iField).
            hTargetField = phTarget:buffer-field(hSourceField:name) no-error.
    
            if not valid-handle(hTargetField) then
                undo, throw new BufferFieldMismatchError(phSource:Name, phTarget:Name).
    
            assign lExtent   = hSourceField:extent gt 0
                   iNumItems = if not lExtent then 1 else hSourceField:extent.
            
            do iExtent = 1 to iNumItems:
                if not CompareFieldValues(hSourceField,
                                          if lExtent then iExtent else 0,
                                          OperatorEnum:IsEqual,
                                          hTargetField,
                                          if lExtent then iExtent else 0,
                                          CompareStrengthEnum:Raw ) then 
                    assign iNumDiff = iNumDiff + 1
                           cTempFields[iNumDiff] = hSourceField:name
                                                 + if lExtent then "[" + string(iExtent) + "]" else "".
            end.  /* extent loop */
        end. /* field loop */

        extent(cChangedFields) = iNumDiff.
        do iField = 1 to iNumDiff:
            cChangedFields[iField] = cTempFields[iField].
        end.
                        
        return cChangedFields.
    end method.
        
    method protected static logical CompareFieldValues ( phColumn1  as handle,        
                                                         piExtent1  as integer,
                                                         poOperator as OperatorEnum,
                                                         phColumn2  as handle,
                                                         piExtent2  as integer,
                                                         poStrength as CompareStrengthEnum):
        define variable lSame   as logical no-undo.
        define variable iExtent as integer no-undo.
             
        if DataTypeEnum:Clob:Equals(phColumn1:data-type) then
            lSame = CompareClobValues(phColumn1,
                                      poOperator,
                                      phColumn2,
                                      poStrength).   
        else
        if DataTypeEnum:Character:Equals(phColumn1:data-type) then
            lSame = compare(phColumn1:buffer-value(piExtent1),
                            poOperator:ToString(),
                            phColumn2:buffer-value(piExtent2),
                            poStrength:ToString()).
        else
        do:
            case poOperator:
                when OperatorEnum:IsEqual then
                    lSame = phColumn1:buffer-value(piExtent1) eq phColumn2:buffer-value(piExtent2).
                when OperatorEnum:LessThan then
                    lSame = phColumn1:buffer-value(piExtent1) lt phColumn2:buffer-value(piExtent2).
                when OperatorEnum:LessEqual then
                    lSame = phColumn1:buffer-value(piExtent1) le phColumn2:buffer-value(piExtent2).
                when OperatorEnum:GreaterEqual then
                    lSame = phColumn1:buffer-value(piExtent1) ge phColumn2:buffer-value(piExtent2).
                when OperatorEnum:GreaterThan then
                    lSame = phColumn1:buffer-value(piExtent1) gt phColumn2:buffer-value(piExtent2).
                when OperatorEnum:NotEqual then
                    lSame = phColumn1:buffer-value(piExtent1) ne phColumn2:buffer-value(piExtent2).
            end case.
        end.
                        
        return lSame.
    end method.
              
    method protected static logical CompareClobValues ( phColumn1  as handle,                
                                                        poOperator as OperatorEnum,
                                                        phcolumn2  as handle,
                                                        poStrength as CompareStrengthEnum) :
        define variable cLong1    as longchar no-undo.
        define variable cLong2    as longchar no-undo.
        define variable lUnknown1 as logical  no-undo.
        define variable lUnknown2 as logical  no-undo.
        define variable lEqual    as logical  no-undo.
        define variable lCompare  as logical  no-undo.
    
        assign lEqual    = poOperator eq OperatorEnum:IsEqual
               lUnknown1 = (phColumn1:buffer-value eq ?)
               lUnknown2 = (phColumn2:buffer-value eq ?).
    
        if lUnknown1 and lUnknown2 then
            lCompare = lEqual.
        else
        if lUnknown1 or lUnknown2 then
            lCompare = not lEqual.
        else
        if length(phColumn1:buffer-value) ne length(phColumn2:buffer-value) then
            lCompare = not lEqual.
        else
        do:
            copy-lob from phColumn1:buffer-value to cLong1.
            copy-lob from phColumn2:buffer-value to cLong2.
            lCompare = compare(cLong1,
                               poOperator:ToString(),
                               cLong2,
                               poStrength:ToString()).
        end.
            
        return lCompare.
    end method.
end class.
/** ------------------------------------------------------------------------
    File        : IExternalizable
    Purpose     : Interface for Externalisable objects.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 25 12:42:41 EST 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IExternalizable.

interface OpenEdge.Core.Util.IExternalizable:   /* inherits ISerializable */

    /** Serialization method for an object.
        
        @param IObjectOutput The object that's performing the serialization */   
    method public void WriteObject(input poStream as IObjectOutput).
    
    /** Deserialization method for an object.
        
        @param IObjectInput The object that's performing the deserialization */
    method public void ReadObject(input poStream as IObjectInput).
    
end interface./** ------------------------------------------------------------------------
    File        : IObjectInput
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 25 10:11:57 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Object.

interface OpenEdge.Core.Util.IObjectInput:  

    /** Resets/reinitialises the input */
    method public void Reset().
    
    method public void Read(input pcStream as longchar).
    method public void Read(input pcFile as character).
    method public void Read(input pmStream as memptr).
    
    method public Object ReadObject().
    method public Object extent ReadObjectArray().
    
    method public EnumMember ReadEnum().
    
    method public character ReadChar().
    method public character extent ReadCharArray().

    method public longchar ReadLongChar().
    method public longchar extent ReadLongCharArray().
    
    method public integer ReadInt().
    method public integer extent ReadIntArray().
    
    method public int64 ReadInt64().
    method public int64 extent ReadInt64Array().
    
    method public decimal ReadDecimal().
    method public decimal extent ReadDecimalArray().
    
    method public date ReadDate().
    method public date extent ReadDateArray().

    method public datetime ReadDateTime().
    method public datetime extent ReadDateTimeArray().
    
    method public datetime-tz ReadDateTimeTz().
    method public datetime-tz extent ReadDateTimeTzArray().

    method public logical ReadLogical().
    method public logical extent ReadLogicalArray().
    
    method public rowid ReadRowid().
    method public rowid extent ReadRowidArray().
    
    method public recid ReadRecid().
    method public recid extent ReadRecidArray().
    
    /** @param dataset-handle Can be called by-reference */
    method public void ReadDataset(input-output dataset-handle phValue).

    /** @param table-handle Can be called by-reference */    
    method public void ReadTable(input-output table-handle phValue).
    
    method public handle ReadHandle().
    method public handle extent ReadHandleArray().
        
end interface./** ------------------------------------------------------------------------
    File        : IObjectOutput
    Purpose     : Object serialization/externalisation interface
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 25 10:10:35 EST 2011
    Notes       : * The Write*() and Write*Array() methods write the argument to the stream etc. 
                    They could have been simply named Write() and been overloaded by input
                    parameter; however, since the IObjectInput interface's analog Read*() and Read*Array()
                    methods return the data value (and don't use an OUTPUT parameter) since this
                    makes the Read a little easier to work with, the Write() methods follow
                    the same naming convention for consistency.
  ---------------------------------------------------------------------- */
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Object.

interface OpenEdge.Core.Util.IObjectOutput:
    
    /** Resets/reinitialises the output */
    method public void Reset().
    
    /**  Writes the serialized output to the specified file 
         
         @param character The name of a file to write the output into. */
    method public void Write(input pcFileName as character).

    /**  Writes the serialized output to a memptr
         
         @param memptr The memprt into which to write the output. */    
    method public void Write(output pmStream as memptr).

    /**  Writes the serialized output to a CLOB
         
         @param longchar The CLOB into which to write the output. */        
    method public void Write(output pcStream as longchar).
    
    /** Write*() and Write*Array() methods to write individual members into the output.
        (see note above). */
    method public void WriteObject(input poValue as Object).
    method public void WriteObjectArray(input poValue as Object extent).
    
    method public void WriteEnum(input poMember as EnumMember).

    method public void WriteChar(input pcValue as character).
    method public void WriteCharArray(input pcValue as character extent).
    
    method public void WriteLongchar(input pcValue as longchar).
    method public void WriteLongcharArray(input pcValue as longchar extent).
    
    method public void WriteInt(input piValue as integer).
    method public void WriteIntArray(input piValue as integer extent).
    
    method public void WriteInt64(input piValue as int64).
    method public void WriteInt64Array(input piValue as int64 extent).
    
    method public void WriteDecimal(input pdValue as decimal).
    method public void WriteDecimalArray(input pdValue as decimal extent).
    
    method public void WriteDate(input ptValue as date).
    method public void WriteDateArray(input ptValue as date extent).

    method public void WriteDateTime(input ptValue as datetime).
    method public void WriteDateTimeArray(input ptValue as datetime extent).

    method public void WriteDateTimeTz(input ptValue as datetime-tz).
    method public void WriteDateTimeTzArray(input ptValue as datetime-tz extent).
    
    method public void WriteLogical(input plValue as logical).
    method public void WriteLogicalArray(input plValue as logical extent).
    
    method public void WriteRowid(input prValue as rowid).
    method public void WriteRowidArray(input prValue as rowid extent).
    
    method public void WriteRecid(input prValue as recid).
    method public void WriteRecidArray(input prValue as recid extent).
    
    method public void WriteDataset(input phValue as handle).
    method public void WriteTable(input phValue as handle).
    
    method public void WriteHandle(input phValue as handle).
    method public void WriteHandleArray(input phValue as handle extent).

end interface./*------------------------------------------------------------------------
    File        : ISerializable
    Purpose     : Serializes to and from LONGCHAR. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 29 14:22:12 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Core.Util.ISerializable :
    
end interface./*------------------------------------------------------------------------
    File        : ObjectInputError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 21 14:03:44 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.Util.ObjectInputError.
using Progress.Lang.Error.

class OpenEdge.Core.Util.ObjectInputError inherits ApplicationError:    
    define static public property TYPE as character no-undo init 'type' get.
    define static public property BYTE as character no-undo init 'byte' get.
    define static public property STREAM_VERSION as character no-undo init 'stream version' get.
    define static public property BYTE_ORDER as character no-undo init 'byte order' get.
    define static public property MD5_VALUE as character no-undo init 'r-code MD5 value' get.
    define static public property VALUE as character no-undo init 'value' get.
    define static public property CLASS_REFERENCE as character no-undo init 'class reference' get.
    define static public property ABL_VERSION as character no-undo init 'ABL version' get.
    define static public property API_CALL as character no-undo init 'API call' get.
    
    define override protected property ErrorTitle as character init 'Object Input Error' no-undo get. set. 
    define override protected property ErrorText as longchar init 'Invalid &1 encountered. Expecting &2 at position &3' no-undo get. set.
    
    constructor public ObjectInputError (pcArg1 as char, pcArg2 as char, pcArg3 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArg1,pcArg2,pcArg3).
    end constructor.
   
    constructor public ObjectInputError (poErr as Error, pcArg1 as char, pcArg2 as char, pcArg3 as char):
        this-object(poErr).
        AddMessage(pcArg1, 1).
        AddMessage(pcArg2, 2).
        AddMessage(pcArg3, 3).
    end constructor.
    
    constructor public ObjectInputError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
    constructor public ObjectInputError(poErr as Error):
       super(poErr).
       ErrorTitle = 'Object Input Error'.
       ErrorText = 'Invalid &1 encountered. Expecting &2 at position &3'.
    end constructor.
        
end class./** ------------------------------------------------------------------------
    File        : ObjectInputStream
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Nov 13 14:29:30 EST 2009
    Notes       : * The Read<type>() methods have output parameters because they 
                    cater for both vectors and scalars. The alternative is to
                    have  Read<type>Array() methods that return the valid type.
                  * For the protocol definition, see 
                    https://wiki.progress.com/display/OEBP/Object+Serialization+Protocol
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Core.Util.ObjectStreamConstants.
using OpenEdge.Core.Util.ObjectInputError.
using OpenEdge.Lang.SortDirectionEnum.
using OpenEdge.Lang.ByteOrderEnum.
using OpenEdge.Lang.Collections.ObjectStack.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.EnumMember.

using Progress.Lang.ParameterList.
using Progress.Lang.Error.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.Util.ObjectInputStream
        implements IObjectInput:
    
    define private variable mmStreamMptr as memptr no-undo.
    define private variable miCursor as integer no-undo.
    define private variable miDepth as integer  no-undo.
    define private variable moTopLevel as Object no-undo.
    define private variable moCurrentType as class Class no-undo.
    define private variable moTypeStack     as ObjectStack no-undo.
    define private variable miSessionDecimalPoint as integer no-undo.
    define private variable miSessionNumericSeparator as integer no-undo.
    define private variable moReadObjParam as ParameterList no-undo.
    define private variable moObjectInputError as ObjectInputError no-undo.
    
    define private temp-table StreamReference no-undo
        field ReferenceType as integer  /* ObjectStreamConstants:REFTYPE_ */
        field Reference as Object       /* object id for PLO or PLC */
        field Position as integer       /* position in stream */
        index idx1 as primary unique ReferenceType Position
        .
    
    constructor public ObjectInputStream():
        Reset().
    end constructor.
        
    destructor public ObjectInputStream():
        this-object:Clear().
    end destructor.
    
    method protected void Clear():
        define buffer lbRef for StreamReference.
        
        empty temp-table lbRef.        
        moReadObjParam = ?.
        moCurrentType = ?.
        moTopLevel = ?.
        moObjectInputError = ?.
        /* this is the only time we should hard-code a 1; otherwise use ObjectStreamConstants:SIZE_BYTE */
        miCursor = 1.
        set-size(mmStreamMptr) = 0.
    end method.
    
    method public void Initialize():
        /* Create on parameter list object that 
           we'll reuse. */
        moReadObjParam = new ParameterList(1).
        moReadObjParam:SetParameter(1,
                                    substitute(DataTypeEnum:Class:ToString(), this-object:GetClass():TypeName),
                                    IOModeEnum:Input:ToString(),
                                    this-object).
    end method.
    
    /** Resets/reinitialises the input */      
    method public void Reset():
        this-object:Clear().
        Initialize().
    end method.
    
    @todo(task="refactor", action="merg input CHAR and input LONGCHAR to one; disambiguate with params? names?").
    method public void Read(pcStream as longchar):
        define variable mStream as memptr no-undo.
        
        set-byte-order(mStream) = ByteOrderEnum:BigEndian:Value.
                        
        copy-lob from pcStream to mStream.
        this-object:Read(mStream).
                
        /* mStream is a temp-var so clean up. the byte stream
           has been copied to this class' mmStreamMptr for internal use. */
        finally:
            set-size(mStream) = 0.
        end finally.
    end method.
    
    method public void Read(input pcFile as character):
        define variable mStream as memptr no-undo.
        
        set-byte-order(mStream) = ByteOrderEnum:BigEndian:Value.
                
        copy-lob from file pcFile to mStream.
        this-object:Read(mStream).
        
        /* mStream is a temp-var so clean up. the byte stream
           has been copied to this class' mmStreamMptr for internal use. */
        finally:
            set-size(mStream) = 0.
        end finally.
    end method.
    
    method public void Read(pmStream as memptr):
        if get-byte-order(pmStream) ne ByteOrderEnum:BigEndian:Value then
            ThrowError(ObjectInputError:BYTE_ORDER,
                           ByteOrderEnum:BigEndian:ToString(),
                           miCursor - ObjectStreamConstants:SIZE_BYTE).
        
        mmStreamMptr = pmStream.
        
        ReadStreamHeader().
        
        /* If anything (not just ObjectInputError) happens, clean up! */ 
        catch oError as Error:
            this-object:Clear().
            /* pass on the Error */
            undo, throw oError.
        end catch.
    end method.
    
    method protected void ReadStreamHeader():
        if ReadString() ne ObjectStreamConstants:STREAM_MAGIC then
            ThrowError(ObjectInputError:VALUE,
                           ObjectStreamConstants:STREAM_MAGIC,
                           -1).
        
        if ReadByte() ne ObjectStreamConstants:STREAM_VERSION then
            ThrowError(ObjectInputError:STREAM_VERSION,
                           string(ObjectStreamConstants:STREAM_VERSION),
                           miCursor - ObjectStreamConstants:SIZE_BYTE).
        
        miSessionDecimalPoint = ReadByte().
        miSessionNumericSeparator = ReadByte().
        
        /* Is this the right Proversion? */
        if ReadString() ne proversion then
            ThrowError(ObjectInputError:ABL_VERSION,
                           proversion,
                           miCursor - ObjectStreamConstants:SIZE_BYTE).
    end method.
    
    method public void DefaultReadObject():
        define variable iStackLoop as integer no-undo.
        define variable iMemberLoop as integer no-undo.
        define variable iStackSize as integer no-undo.
        define variable iMembers as integer no-undo.
        define variable oType as class Class no-undo.
        
        /* Members are written out from the least-derived ("highest") class
           to the most-derived ("lowest", aka poIn) class. This way values
           that are set at a less-derived class will be overridden and 
           correct. */
        iStackSize = moTypeStack:Size.
        
        do iStackLoop = 1 to iStackSize:
            oType = cast(moTypeStack:Pop(), Class).
            
            /* get this value from somewhere */
            iMembers = 0.
            
            /* does nothing (yet) because of a lack of reflection on members */
            do iMemberLoop = 1 to iMembers:
                /* get props from type */
                /* retrieve value from input object 
                o:<Member> = Read<type>().
                */
            end.
        end.
    end method.
    
    method public Object ReadObject():
        define variable oObj as Object no-undo.            
        define variable oClass as class Class no-undo.
        define variable iRepositionTo as integer no-undo.
        define variable lInvoke as logical no-undo.
        
        /* The first Byte must be one of TC_OBJECT, TC_ENUM or TC_NULL. */        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                assign oObj = ?.            
            when ObjectStreamConstants:TC_ENUM then
            do:
                miCursor = miCursor - ObjectStreamConstants:SIZE_BYTE.
                AddWarning(ObjectInputError:API_CALL,
                           ObjectStreamConstants:EXTERNALIZABLE_METHOD_READENUM,
                           miCursor).
                oObj = ReadEnum().
            end.    /* enum */
            when ObjectStreamConstants:TC_OBJECT then
            /* The TC_OBJECT byte is always followed by one of
               - TC_METADATA: contains class desc and values (if the object is serializable/externalizable)
               - TC_REFERENCE: a pointer (typically backwards) to a previously-defined TC_OBJECT location. */
            case ReadByte():
                when ObjectStreamConstants:TC_REFERENCE then
                do:
                    iRepositionTo = ReadInt().
                    if iRepositionTo eq ? then
                        ThrowError(ObjectInputError:VALUE,
                                       DataTypeEnum:Integer:ToString(),
                                       miCursor - ObjectStreamConstants:SIZE_LONG).
                    
                    oObj = GetReference(ObjectStreamConstants:REFTYPE_OBJECT,
                                        iRepositionTo + ObjectStreamConstants:SIZE_BYTE).
                    if not valid-object(oObj) then
                        ThrowError(ObjectInputError:CLASS_REFERENCE,
                                       'reference',
                                       miCursor - ObjectStreamConstants:SIZE_LONG).
                end.
                when ObjectStreamConstants:TC_METADATA then
                    /* Now we have a pointer to a TC_METADATA byte . We think.
                       Go to the reference position, and then back one, since we want 
                       to make double-sure that we have the TC_METADATA.
                       
                       We're going to re-read this byte (yeah, wasteful, but
                       makes coding more consistent). */
                    assign miCursor = miCursor - ObjectStreamConstants:SIZE_BYTE
                           oObj = ReadObjectInternal().
                otherwise
                    ThrowError(ObjectInputError:BYTE,
                                   ObjectStreamConstants:ToString(ObjectStreamConstants:TC_METADATA)
                                   + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_REFERENCE),
                                   miCursor - ObjectStreamConstants:SIZE_BYTE).
            end case.   /* byte following the TC_OBJECT byte */
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ', ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ENUM)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_OBJECT),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.   /* first byte TC_ENUM or TC_OBJECT */
        
        return oObj.
    end method.
    
    method protected void RegisterReference (piType as int,
                                        piPos as int,
                                        poReference as Object):
        def buffer bRef for StreamReference.
                                
        find bRef where
             bRef.ReferenceType = piType and
             bRef.Position = piPos
             no-error.
        if not available bRef then
        do:
            create bRef.
            assign bRef.ReferenceType = piType
                   bRef.Reference = poReference
                   bRef.Position = piPos.
        end.
    end method.
    
    method protected Object GetReference(piType as int,                                          
                                         piPos as int):
        define variable oObj as Object no-undo.                                             
        def buffer bRef for StreamReference.
        
        find bRef where
             bRef.ReferenceType = piType and
             bRef.Position = piPos
             no-error.
        if available bRef then
            oObj = bRef.Reference.
        
        return oObj.
    end method.    
    
    method protected Object ReadObjectInternal():
        define variable oClass as class Class no-undo.
        define variable oObj as Object no-undo.
        define variable iPosition as integer no-undo.
        
        /* the cursor is currently pointing - should be anyway - at the TC_METADATA
           byte marker referring to an object. Keep this for storate in the StreamReference 
           table. */
        assign iPosition = miCursor
               miDepth = 0
               moTypeStack = new ObjectStack()
               /* Find the type */
               oClass = ReadClassDesc()
               /* Create the instance */
               oObj = oClass:New().
        
        /* At this point we have a valid object for adding to the references */
        RegisterReference(ObjectStreamConstants:REFTYPE_OBJECT, iPosition, oObj).
        
        if not valid-object(moTopLevel) then
            moTopLevel = oObj.
        
        /* TC_NULL separates the meta from the data, as it were. */
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_NULL).
        
        /* InvokeReadObject() will determine what calls to make - ReadObject()
           or DefaultReadObject etc. */
        InvokeReadObject(oObj).
        moTypeStack = ?.
        
        /* there's never one written at the end of the top-level object (for space) */
        if oObj ne moTopLevel then
            ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
        
        return oObj.
    end method.
        
    method protected class Class ReadClassDesc():
        define variable cTypeName as char no-undo.
        define variable oClass as class Class no-undo.
        define variable iByteMarker as integer no-undo.
        define variable iNumFields as int no-undo.
        define variable iTypeFlags as int no-undo.
        define variable cMD5 as character no-undo.
        define variable iCursor as integer no-undo.
        
        /* We're either at the top of the hierarcy (TC_ENDBLOCKDATA), or not (TC_METADATA).
           If neither, then something's wrong. */
        case ReadByte():
            when ObjectStreamConstants:TC_ENDBLOCKDATA then
                /* Unwind the class depth stack, so we know that we
                   need to make another ReadClassDesc() call. Typically,
                   we're in the process of unwinding, so this call will 
                   result in another TC_ENDBLOCKDATA being found, until
                   we're at the bottom of the pile. */
                miDepth = miDepth - 1.
            when ObjectStreamConstants:TC_METADATA then
            do:
                miDepth = miDepth + 1.
                cTypeName = ReadString().
                oClass = Class:GetClass(cTypeName).
                moTypeStack:Push(oClass).
                
                rcode-info:file-name = replace(cTypeName, '.', '/').
                /* Keep cursor just in case MD% doesn't match. */                
                iCursor = miCursor.
                cMD5 = ReadString().
                if cMD5 eq ? then
                    AddWarning(ObjectInputError:MD5_VALUE,
                               'a valid value',
                               iCursor).
                else
                if cMD5 ne rcode-info:md5-value then
                    ThrowError(ObjectInputError:MD5_VALUE,
                                   rcode-info:md5-value,
                                   iCursor).
                
                iTypeFlags = ReadByte().
                
                /* Serializable */
                if IsFlag(iTypeFlags, ObjectStreamConstants:SC_SERIALIZABLE) then
                do:
                    /* read property names, types. */
                end.
            end.    /* TC_METADATA */
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ENDBLOCKDATA)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_METADATA),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
        
        /* Up/down we go ... */
        if miDepth ne 0 then
        /* oParentClass = */ ReadClassDesc().
        
        return oClass.
    end method.
    
    method public Object extent ReadObjectArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var oObj as Object extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(oObj) = iExtent.
                do iLoop = 1 to iExtent:
                    oObj[iLoop] = ReadObject().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
                
        return oObj.
    end method.
    
    method protected void InvokeReadObject(poIn as Object):
        moCurrentType = poIn:GetClass().
        
        if moCurrentType:IsA(ObjectStreamConstants:SERIALIZABLE_IFACE_TYPE) then
            DefaultReadObject().
        /* A type could be Externalizable and Serializable, so no ELSE */
        if moCurrentType:IsA(ObjectStreamConstants:EXTERNALIZABLE_IFACE_TYPE) then
            moCurrentType:Invoke(poIn,
                          ObjectStreamConstants:EXTERNALIZABLE_METHOD_READOBJECT,
                          moReadObjParam).

        /* If we get here, then the class being serialized doesn't
           re-throw any of the ObjectInputErrors it receives.
           
           We don't want to continue, since there was an error, so 
           we abort. */
        if valid-object(moObjectInputError) then
            undo, throw moObjectInputError.
        
        moCurrentType = ?.                          
    end method.
    
    method public EnumMember ReadEnum():
        define variable oEnum as EnumMember no-undo.
        define variable iValue as integer no-undo.
        define variable cName as character no-undo.
        define variable cType as character no-undo.
        define variable iPos as integer no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                oEnum = ?.
            when ObjectStreamConstants:TC_ENUM then
            do:
                /* keep in case of error */
                iPos = miCursor - ObjectStreamConstants:SIZE_BYTE.
                
                cType = ReadChar().
                iValue = ReadInt().
                cName = ReadChar().
                
                /* value trumps name */
                if iValue ne ? then
                    oEnum = cast(dynamic-invoke(cType, 'EnumFromValue', iValue), EnumMember) no-error.
                else
                if cName ne '' and cName ne ? then
                    oEnum = cast(dynamic-invoke(cType, 'EnumFromString', cName), EnumMember) no-error.
                
                if not valid-object(oEnum) then
                    ThrowError(ObjectInputError:VALUE,
                               substitute('valid EnumMember from Type &1, Name &2, Value &3 and EnumFromString() or EnumFromValue() method',
                                           cType, cName, iValue),
                               iPos).
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_METADATA)
                               + ', ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ENUM),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
        
        return oEnum. 
    end method.
    
    /**  READ ABL PRIMITIVE DATA TYPES **/
    method public char ReadChar():
        return ReadString().
    end method.
        
    method public char extent ReadCharArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var cVal as char extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(cVal) = iExtent.
                do iLoop = 1 to iExtent:
                    cVal[iLoop] = ReadChar().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
                
        return cVal.
    end method.
        
    method public longchar ReadLongChar():
        return ReadLongString().
    end method.
    
    method public longchar extent ReadLongCharArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var cVal as longchar extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(cVal) = iExtent.
                do iLoop = 1 to iExtent:
                    cVal[iLoop] = ReadChar().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
                
        return cVal.
    end method.
    
    method public int ReadInt():
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                return ?.
            when ObjectStreamConstants:TC_VALUE then
                return ReadLong().
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_METADATA)
                               + ', ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_VALUE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
    end method.
    
    method public int extent ReadIntArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var iVal as int extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(iVal) = iExtent.
                do iLoop = 1 to iExtent:
                    iVal[iLoop] = ReadInt().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.

        return iVal.
    end method.

    method public int64 ReadInt64():
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                return ?.
            when ObjectStreamConstants:TC_VALUE then
                return int64(ReadDouble()).
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_METADATA)
                               + ', ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_VALUE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
    end method.
    
    method public int64 extent ReadInt64Array():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var iVal as int64 extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(iVal) = iExtent.
                do iLoop = 1 to iExtent:
                    iVal[iLoop] = ReadInt64().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.

        return iVal.
    end method.
    
    method public decimal ReadDecimal():
        /* Decimals are written as strings, since there are no good
           PUT-* analogs for them. They're always written in American
           numeric format, without any numeric separators.
           
           In case anyone cares, we keep the num-dec-point in the stream header.           
          */
        return decimal(replace(ReadString(), '.', session:numeric-decimal-point)).
    end method.
    
    method public dec extent ReadDecimalArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var dVal as decimal extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(dVal) = iExtent.
                do iLoop = 1 to iExtent:
                    dVal[iLoop] = ReadDecimal().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.

        return dVal.
    end method.
    
    method public date ReadDate():
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                return ?.
            when ObjectStreamConstants:TC_VALUE then
                return date(ReadLong()).
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_METADATA)
                               + ', ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_VALUE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
    end method.
    
    method public date extent ReadDateArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var tVal as date extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(tVal) = iExtent.
                do iLoop = 1 to iExtent:
                    tVal[iLoop] = ReadDate().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.

        return tVal.
    end method.

    method public datetime ReadDateTime():
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                return ?.
            when ObjectStreamConstants:TC_VALUE then
                return datetime(date(ReadLong()), ReadLong()).
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_METADATA)
                               + ', ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_VALUE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
    end method.
    
    method public datetime extent ReadDateTimeArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var tVal as datetime extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(tVal) = iExtent.
                do iLoop = 1 to iExtent:
                    tVal[iLoop] = ReadDateTime().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
                
        return tVal.
    end method.
    
    method public datetime-tz ReadDateTimeTz():
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                return ?.
            when ObjectStreamConstants:TC_VALUE then
                return datetime-tz(date(ReadLong()), ReadLong(), ReadLong()).
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_METADATA)
                               + ', ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_VALUE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
    end method.
    
    method public datetime-tz extent ReadDateTimeTzArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var tVal as datetime-tz extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(tVal) = iExtent.
                do iLoop = 1 to iExtent:
                    tVal[iLoop] = ReadDateTimeTz().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
                
        return tVal.
    end method.
    
    method public log ReadLogical():
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                return ?.
            when ObjectStreamConstants:TC_VALUE then
                return logical(ReadByte()).
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_METADATA)
                               + ', ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_VALUE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
    end method.
    
    method public log extent ReadLogicalArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var lVal as logical extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(lVal) = iExtent.
                do iLoop = 1 to iExtent:
                    lVal[iLoop] = ReadLogical().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
        
        return lVal.
    end method.

    method public rowid ReadRowid():
        return to-rowid(ReadString()).
    end method.

    method public rowid extent ReadRowidArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var rVal as rowid extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(rVal) = iExtent.
                do iLoop = 1 to iExtent:
                    rVal[iLoop] = ReadRowid().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
                    
        return rVal.
    end method.

    method public recid ReadRecid():
        def var rVal as recid no-undo.
        rVal = ReadInt().
        
        return rVal.
    end method.
    
    method public recid extent ReadRecidArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var rVal as recid extent no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                . /* do nothing */
            when ObjectStreamConstants:TC_ARRAY then
            do:
                iExtent = ReadByte().
                extent(rVal) = iExtent.
                do iLoop = 1 to iExtent:
                    rVal[iLoop] = ReadRecid().
                end.
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).                    
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' +  ObjectStreamConstants:ToString(ObjectStreamConstants:TC_ARRAY),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
        
        return rVal.
    end method.
    
    method public void ReadDataset(input-output dataset-handle phOut):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        define variable iByte as integer no-undo.
        
        iByte = ReadByte().
        case iByte:
            when ObjectStreamConstants:TC_NULL then
                phOut = ?.
            when ObjectStreamConstants:TC_OBJECT then
            do:
                phOut = ReadDatasetDesc(phOut).
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_NULL).
                
                /* buffer data */
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_BLOCKDATA).        
                    
                iMax = ReadByte().
                do iLoop = 1 to iMax:
                    ReadBufferData(phOut:get-buffer-handle(iLoop)).
                end.
                /* buffer */
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
                
                /* dataset */
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_OBJECT),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
                
        end case.
    end method.
    
    method protected handle ReadDatasetDesc(phIn as handle):
        define variable hDataset as handle no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cName as character no-undo.
        define variable lBuildDataset as logical no-undo.
        
        /* this is always written */
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_METADATA).                
        cName = ReadString().
        lBuildDataset = ReadLogical().
        
        if valid-handle(phIn) then
        do:
            if not DataTypeEnum:Dataset:Equals(phIn:type) then  
                ThrowError(ObjectInputError:TYPE,
                               DataTypeEnum:Dataset:ToString(),
                               miCursor).
            
            /* extra check for name. */
            if phIn:name ne cName then
                ThrowError(ObjectInputError:VALUE, cName, miCursor).
            
            /* if passed-in dataset isn't dynamic, throw an error. the values should
               match (although crc-value may differ if the source and target differ and
               so we'd never get here). */
            if phIn:dynamic ne lBuildDataset then
                ThrowError(ObjectInputError:VALUE,
                        'dynamic=' + string(lBuildDataset),
                        miCursor).
            
            hDataset = phIn.                                        
        end.    /* valid-handle */

        if lBuildDataset then
        do:
            create dataset hDataset.
            hDataset:name = cName.
            
            ValidateByte(ReadByte(), ObjectStreamConstants:TC_BLOCKDATA).
                    
            /* buffers */
            iMax = ReadByte().
            do iLoop = 1 to iMax:
                hDataset:add-buffer(ReadTableDesc(?)).
            end.
            ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
                        
            /* relations */
            ValidateByte(ReadByte(), ObjectStreamConstants:TC_BLOCKDATA).
            
            iMax = ReadByte().
            do iLoop = 1 to iMax:
                ReadDatasetRelation(hDataset).
            end.
            ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
        
        return hDataset:handle.
    end method.
    
    method protected handle ReadTableDesc(phIn as handle):
        define variable iLoop as integer no-undo.
        define variable iLoop2 as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iIndexEntries as integer no-undo.
        define variable iCursor as integer no-undo.
        define variable hTable as handle no-undo.
        define variable cTableName as char no-undo.
        define variable cIndexName as char no-undo.
        define variable cIndex as character no-undo.
        define variable lBuildTable as logical no-undo.
        
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_METADATA).        
        cTableName = ReadString().
        lBuildTable = ReadLogical().
        
        if valid-handle(phIn) then
        do:
            if not DataTypeEnum:TempTable:Equals(phIn:type) then  
                ThrowError(ObjectInputError:TYPE,
                               DataTypeEnum:TempTable:ToString(),
                               miCursor).
            
            /* extra check for name. */
            if phIn:name ne cTableName then
                ThrowError(ObjectInputError:VALUE, cTableName, miCursor).
            
            /* if passed-in dataset isn't dynamic, throw an error. the values should
               match (although crc-value may differ if the source and target differ and
               so we'd never get here). */
            if phIn:dynamic ne lBuildTable then
                ThrowError(ObjectInputError:VALUE,
                        'dynamic=' + string(lBuildTable),
                        miCursor).
            hTable = phIn.                                        
        end.    /* valid-handle */

        if lBuildTable then
        do:
            create temp-table hTable.
            iMax = ReadByte().
                    
            /* fields */
            ValidateByte(ReadByte(), ObjectStreamConstants:TC_BLOCKDATA).
            
            /* Dump enough info for ADD-NEW-FIELD() */
            do iLoop = 1 to iMax:
                hTable:add-new-field(
                    ReadString(),
                    DataTypeEnum:EnumFromValue(ReadByte()):ToString(), /*cDataType,*/
                    ReadByte(),     /*iExtent,*/
                    ReadString(),   /*cFormat,*/
                    ReadString(),   /*cInitial,*/
                    ReadString(),   /*cLabel,*/
                    ReadString()).  /*cColLabel)*/
            end.
            ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
                    
            /* Indexes */
            ValidateByte(ReadByte(), ObjectStreamConstants:TC_BLOCKDATA).
            
            iMax = ReadByte().
            do iLoop = 1 to iMax:
                iCursor = miCursor.                
                cIndex = ReadString().
                iIndexEntries = num-entries(cIndex).
                cIndexName = entry(1, cIndex).
                
                /* Don't do this for the default index, and also make sure we've
                   got sufficient things. */
                if iIndexEntries gt 5 then
                do:
                    hTable:add-new-index(cIndexName,
                        logical(integer(entry(2, cIndex))),   /* unique index? */
                        logical(integer(entry(3, cIndex))),   /* primary index? */
                        logical(integer(entry(4, cIndex)))).   /* word index? */
                    
                    do iLoop2 = 5 to iIndexEntries by 2:
                        hTable:add-index-field(cIndexName,
                            entry(iLoop2, cIndex),
                            SortDirectionEnum:EnumFromValue(integer(entry(iLoop2 + 1, cIndex))):ToString()).
                    end.
                end.    /* >5 index entries */
                else
                if cIndexName ne 'default' then
                        ThrowError(ObjectInputError:VALUE,
                                       'even number of index entries',
                                       /* show position where the index string starts and not the
                                          length and markers */
                                       iCursor + ObjectStreamConstants:SIZE_BYTE + ObjectStreamConstants:SIZE_LONG).
            end.
            ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
            
            hTable:temp-table-prepare(cTableName).
            
            phIn = htable.
        end.
        
        return hTable.            
    end method.
    
    method protected void ReadDatasetRelation(phDataset as handle):
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_BLOCKDATA).
        
        phDataset:add-relation(
                phDataset:get-buffer-handle(ReadString()),  /* parent-buffer */
                phDataset:get-buffer-handle(ReadString()),  /* child-buffer */
                ReadString(),   /* relation fields */
                ReadLogical(),  /* reposition? */                
                ReadLogical(),  /* nested? */
                ReadLogical(),  /* active? */                
                ReadLogical(),  /* recursive? */
                ReadLogical()). /*foriegn key hidden? */
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
    end method.
    
    method protected void ReadBufferData (phBuffer as handle):
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_BLOCKDATA).

        iMax = ReadInt().
        do iLoop = 1 to iMax:
            phBuffer:buffer-create().
            ReadBufferRow(phBuffer).
            phBuffer:buffer-release().
        end.
        
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
    end method.    
    
    method protected void ReadBufferRow(phBuffer as handle):
        define variable iLoop  as integer   no-undo.
        define variable iMax   as integer   no-undo.
        define variable cIndex as character no-undo.
        define variable hField as handle    no-undo.

        ValidateByte(ReadByte(), ObjectStreamConstants:TC_BLOCKDATA).        
        
        do iLoop = 1 to phBuffer:num-fields:
            hField = phBuffer:buffer-field(iLoop).
            
            case DataTypeEnum:EnumFromString(hField:data-type):
                when DataTypeEnum:Character then
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadChar().
                    else
                        hField:buffer-value = ReadCharArray().
                when DataTypeEnum:Date then 
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadDate().
                    else
                        hField:buffer-value = ReadDateArray().
                when DataTypeEnum:DateTime then
                    if hField:extent eq 0 then 
                        hField:buffer-value = ReadDateTime().
                    else
                        hField:buffer-value = ReadDateTimeArray().
                when DataTypeEnum:DatetimeTZ then
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadDateTimeTz().
                    else
                        hField:buffer-value = ReadDateTimeTzArray().
                when DataTypeEnum:Decimal then
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadDecimal().
                    else
                        hField:buffer-value = ReadDecimalArray().
                when DataTypeEnum:Integer then
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadInt().
                    else
                        hField:buffer-value = ReadIntArray().
                when DataTypeEnum:Int64 then 
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadInt64().
                    else
                        hField:buffer-value = ReadInt64Array().
                when DataTypeEnum:Logical then
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadLogical().
                    else
                        hField:buffer-value = ReadLogicalArray().
                when DataTypeEnum:LongChar then
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadLongChar().
                    else
                        hField:buffer-value = ReadLongCharArray().
                when DataTypeEnum:Class or when DataTypeEnum:ProgressLangObject then
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadObject().
                    else
                        hField:buffer-value = ReadObjectArray().
                when DataTypeEnum:Recid then
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadRecid().
                    else
                        hField:buffer-value = ReadRecidArray().
                when DataTypeEnum:Rowid then 
                    if hField:extent eq 0 then
                        hField:buffer-value = ReadRowid().
                    else
                        hField:buffer-value = ReadRowidArray().
            end case.
        end.
        
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
    end method.
    
    method public void ReadTable(input-output table-handle phTable):
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                phTable = ?.
            when ObjectStreamConstants:TC_TABLE then
            do:
                phTable = ReadTableDesc(phTable).
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_NULL).
                
                ReadBufferData(phTable:default-buffer-handle).
                
                ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
            end.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_TABLE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
    end method.
    
    method public handle ReadHandle():
        return widget-handle(string(ReadInt())).
    end method.
    
    method public handle extent ReadHandleArray():
        def var iExtent as int no-undo.
        def var iLoop as int no-undo.
        def var hVal as handle extent no-undo.
        
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_ARRAY).        

        iExtent = ReadByte().
        extent(hVal ) = iExtent.
        do iLoop = 1 to iExtent:
            hVal [iLoop] = ReadHandle().
        end.
                    
        ValidateByte(ReadByte(), ObjectStreamConstants:TC_ENDBLOCKDATA).
                
        return hVal.
    end method.
    
    /* read from memptr */
    method protected int ReadByte():
        def var iByte as int no-undo.
        
        iByte = get-byte(mmStreamMptr, miCursor).
        miCursor = miCursor + ObjectStreamConstants:SIZE_BYTE.
        
        return iByte.
    end method.
            
    method protected int ReadShort():
        def var iShort as int no-undo.
        
        iShort = get-short(mmStreamMptr, miCursor).
        miCursor = miCursor + ObjectStreamConstants:SIZE_SHORT.
        
        return iShort.
    end method.
    
    method protected int ReadLong():
        def var iLong as int no-undo.
        
        iLong = get-long(mmStreamMptr, miCursor).
        miCursor = miCursor + ObjectStreamConstants:SIZE_LONG.
        
        return iLong.
    end method.
    
    method protected dec ReadDouble():
        def var iDouble as int no-undo.
        
        iDouble = get-double(mmStreamMptr, miCursor).
        miCursor = miCursor + ObjectStreamConstants:SIZE_DOUBLE.
        
        return iDouble.
    end method.
    
    method protected char ReadString():
        /* code same as ReadLongString but we 
           for performance reasons we want to
           use native CHAR not LONGCHAR converted. */
        def var iLength as int no-undo.
        def var cVal as char no-undo.

        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                cVal = ?.
            when ObjectStreamConstants:TC_VALUE then            
                assign iLength  = ReadLong()
                       cVal     = get-string(mmStreamMptr, miCursor, iLength)
                       miCursor = miCursor + iLength.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_VALUE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
        
        return cVal.        
    end method.
        
    method protected longchar ReadLongString():
        def var iLength as int no-undo.
        def var cVal as longchar no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                cVal = ?.
            when ObjectStreamConstants:TC_VALUE then            
                assign iLength  = ReadLong()
                       cVal     = get-string(mmStreamMptr, miCursor, iLength)
                       miCursor = miCursor + iLength.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_VALUE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
        
        return cVal.
    end method.

    method protected raw ReadRaw():
        def var iLength as int no-undo.
        def var rVal as raw no-undo.
        
        case ReadByte():
            when ObjectStreamConstants:TC_NULL then
                /* default for RAW is ? */ .
            when ObjectStreamConstants:TC_VALUE then
                assign iLength  = ReadLong()
                       rVal     = get-bytes(mmStreamMptr, miCursor, iLength)
                       miCursor = miCursor + iLength.
            otherwise
                ThrowError(ObjectInputError:BYTE,
                               ObjectStreamConstants:ToString(ObjectStreamConstants:TC_NULL)
                               + ' or ' + ObjectStreamConstants:ToString(ObjectStreamConstants:TC_VALUE),
                               miCursor - ObjectStreamConstants:SIZE_BYTE).
        end case.
                
        return rVal.
    end method.
    
    method protected void ValidateByte(piActualByte as integer, piCheckByte as integer):
        /* Reference the /previous/ position, since ReadByte() always increments the cursor,
           and since this check happens after the incrememnt, we need to point back to the
           actual byte that doesn't match expectations. */
        if piActualByte ne piCheckByte then
            ThrowError(ObjectInputError:BYTE,
                           ObjectStreamConstants:ToString(piCheckByte),
                           miCursor - ObjectStreamConstants:SIZE_BYTE).
    end method.
    
    method protected void AddWarning(pcType as char, pcParam1 as char, piPosition as int ):
        @todo(task="implement").
        /*
        message
            pcType skip
            pcParam1 skip
            piPosition
        view-as alert-box warning.
        */
    end method.
    
    method protected void ThrowError(pcType as char, pcParam1 as char, piPosition as int ):
        /* Keep a clone around in case the class being serialized doesn't
           re-throw any of the ObjectOutputErrors it receives. We use a 
           clone because the thrown class is GC'd before we need it to be,
           even if we assign it to a member.
           
           We can deal with the Error in InvokeWriteObject if need be. */
        moObjectInputError = new ObjectInputError(pcType, pcParam1, string(piPosition)).
        
        undo, throw cast(moObjectInputError:Clone(), ObjectInputError).
    end method.
    
    method protected logical IsFlag (piValueSum as int, piCheckVal as int):
        define variable iPos as integer no-undo.
        define variable iVal as integer no-undo.
        
        do iPos = 1 to 32 while iVal eq 0:
            iVal = get-bits(piCheckVal, iPos, 1).
        end.
        
        return (get-bits(piValueSum, iPos - 1, 1) eq iVal).
    end method.
    
end class./*-----------------------------------------------------------------------
    File        : ObjectOutputError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 21 14:03:44 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.Util.ObjectOutputError.
using Progress.Lang.Error.

class OpenEdge.Core.Util.ObjectOutputError inherits ApplicationError:
    define static public property STREAM as character no-undo init 'stream' get.
    define static public property TYPE as character no-undo init 'type' get.
    define static public property API_CALL as character no-undo init 'API call' get.
    define static public property ARRAY_SIZE as character no-undo init 'array size' get.
    define static public property DB_REFS as character no-undo init 'references to database fields' get.
    
    define override protected property ErrorTitle as character no-undo get. set. 
    define override protected property ErrorText as longchar no-undo get. set.
    
    constructor public ObjectOutputError ( ):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
    constructor public ObjectOutputError (poErr as Error):
       super(poErr).      
       ErrorTitle = 'Object Output Error'.
       ErrorText = 'Invalid &1 encountered. Expecting &2'.       
    end constructor.
   
    constructor public ObjectOutputError (poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public ObjectOutputError (pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1,pcArgs2).
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : ObjectOutputStream
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Nov 13 14:22:25 EST 2009
    Notes       : * IExternalizable types don't write out metadata
                 * For the protocol definition, see
                 https://wiki.progress.com/display/OEBP/Object+Serialization+Protocol     
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectStreamConstants.
using OpenEdge.Core.Util.ObjectOutputError.
using OpenEdge.Lang.SortDirectionEnum.
using OpenEdge.Lang.ByteOrderEnum.
using OpenEdge.Lang.Collections.ObjectStack.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.CompareStrengthEnum.
using OpenEdge.Lang.EnumMember.

using Progress.Lang.ParameterList.
using Progress.Lang.Error.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.Util.ObjectOutputStream
            implements IObjectOutput:
    
    define private variable miCursor              as integer           no-undo.
    define private variable mrStreamBuffer        as raw               no-undo.
    define private variable moTopLevel            as Object            no-undo.
    define private variable moTypeStack           as ObjectStack       no-undo.
    
    define private variable moWriteObjParam       as ParameterList     no-undo.
    define private variable moObjectOutputError   as ObjectOutputError no-undo.
    define private variable mlStreamHeaderWritten as logical           no-undo.
    
    define private temp-table StreamReference no-undo
        field ReferenceType as integer  /* ObjectStreamConstants:REFTYPE_ */
        field Reference     as integer      /* object id for PLO or PLC */
        field Position      as integer       /* */
        index idx1 as primary unique ReferenceType Reference
        .
    constructor public ObjectOutputStream():
        Initialize().
    end constructor.
    
    destructor public ObjectOutputStream():
        this-object:Clear().
    end destructor.
    
    method protected void Clear():
        define buffer lbRef for StreamReference.
            
        empty temp-table lbRef.
        moTopLevel = ?.
        
        length(mrStreamBuffer) = 0. 
        mrStreamBuffer = ?.
        miCursor = 0.
        moWriteObjParam = ?.
        moObjectOutputError = ?.
        mlStreamHeaderWritten = false.
    end method.
    
    /** Resets/reinitialises the output */
    method public void Reset():
        this-object:Clear().
        Initialize().
    end method.
    
    method protected void Initialize():
        /* Create on parameter list object that
           we'll reuse. */
        moWriteObjParam = new ParameterList(1).
        moWriteObjParam:SetParameter(1,
            substitute(DataTypeEnum:Class:ToString(), this-object:GetClass():TypeName),
            IOModeEnum:Input:ToString(),
            this-object).
        
        miCursor = 1.
    end method.
    
    method protected void WriteStreamHeader():
        WriteString(ObjectStreamConstants:STREAM_MAGIC).
        WriteByte(ObjectStreamConstants:STREAM_VERSION).
        
        /* This is invariant for this object, so write it in the
           header instead of for each decimal. Note that we write 
           dates in broken-down pieces, so don't need to keep formats
           for them. */
        WriteByte(asc(session:numeric-decimal-point)).
        WriteByte(asc(session:numeric-separator)).
        
        /* What version are we running? */
        WriteString(proversion).
        
        mlStreamHeaderWritten = true.
    end method.
    
    /**  Writes the serialized output to the specified file 
         
         @param character The name of a file to write the output into. */    
    method public void Write(pcFileName as char):
        define variable mStream as memptr no-undo.

        this-object:Write(output mStream).
        copy-lob mStream to file pcFileName.
        
        finally:
            set-size(mStream) = 0.
        /* this-object:Clear called from Write(memptr) */
        end finally.
    end method.
    
    /**  Writes the serialized output to a memptr
         
         @param memptr The memprt into which to write the output. */    
    method public void Write(output pmStream as memptr):
        set-byte-order(pmStream) = ByteOrderEnum:BigEndian:Value.
        set-size(pmStream) = miCursor.
        put-bytes(pmStream, 1) = mrStreamBuffer.
        
        /* make sure we clear the memptr*/
        finally:
            this-object:Clear().
        end finally.
    end method.
    
    /**  Writes the serialized output to a CLOB
         
         @param longchar The CLOB into which to write the output. */            
    method public void Write(output pcStream as longchar):
        define variable mStream as memptr no-undo.
        
        this-object:Write(output mStream).
        copy-lob mStream to pcStream.
        
        finally:
            set-size(mStream) = 0.
        /* this-object:Clear called from Write(memptr) */
        end finally.        
    end method.
    
    method protected void DefaultWriteObject(poIn as Object):
        define variable iStackLoop  as integer no-undo.
        define variable iMemberLoop as integer no-undo.
        define variable iStackSize  as integer no-undo.
        define variable iMembers    as integer no-undo.
        define variable oType       as class   Class no-undo.
        
        /* Write out the members from the least-derived ("highest") class
           to the most-derived ("lowest", aka poIn) class. This way values
           that are set at a less-derived class will be overridden and 
           correct. */
        iStackSize = moTypeStack:Size.
        
        do iStackLoop = 1 to iStackSize:
            oType = cast(moTypeStack:Pop(), Class).
            
            /* get this value from somewhere */
            iMembers = 0.
            
            /* does nothing (yet) because of a lack of reflection on members */
            do iMemberLoop = 1 to iMembers:
            /* get props from type */
            /* retrieve value from input object 
            Write<type>(o:<Member>).
            */
            end.
        end.
    end method.
    
    /** write the ABL data types **/
    method public void WriteObject(poIn as Object):
        define variable iRefPosition     as integer no-undo.
        define variable iMetadataBytePos as integer no-undo.
        define variable lWriteDetails    as logical no-undo.
        
        /* Top-level class */
        if not valid-object(moTopLevel) then
        do:
            WriteStreamHeader().
            moTopLevel = poIn.
        end.
        
        /* The first byte folling TC_OBJECT will always be another byte marker.
           It should be either TC_NULL, TC_REFERENCE or TC_METADATA, depending
           on circumstance. */
        if valid-object(poIn) then
        do:
            /* Enumerations (EnumMember) must be written using WriteEnum() rather than
               WriteObject. */
            if type-of(poIn, EnumMember) then
            do:
                WriteEnum(cast(poIn, EnumMember)).
                return.
            end.
            
            WriteByte(ObjectStreamConstants:TC_OBJECT).
            if poIn eq moTopLevel then
                lWriteDetails = true.
            else
                assign /* iMetadataBytePos is where the TC_OBJECT byte for the 
                          class will be (ie the previous position at the TC_OBJECT byte) */
                    iMetadataBytePos = miCursor - ObjectStreamConstants:SIZE_BYTE
                    iRefPosition     = AddReference(ObjectStreamConstants:REFTYPE_OBJECT,
                                            int(poIn),  /* object reference ('handle'), as key value */
                                            iMetadataBytePos)
                    lWriteDetails    = iRefPosition eq iMetadataBytePos.
            
            if lWriteDetails then
            do:
                moTypeStack = new ObjectStack().
                
                /* next byte is going to be TC_METADATA, unless we're PLO, 
                   which we shouldn't (can't?) be */
                WriteClassDesc(poIn:GetClass()).
                
                /* Only write the TC_NULL when the whole class def for this class is done */
                WriteByte(ObjectStreamConstants:TC_NULL).
                InvokeWriteObject(poIn).
                /* no longer needed */
                moTypeStack = ?.
                /* Completely done with object. Don't need this for
                   the top-level since we're now at the end of the stream.
                   Or should be. */
                if poIn ne moTopLevel then
                    WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
            end.    /* write details */
            else
            do:
                /* point to existing object def (earlier) in stream */
                WriteByte(ObjectStreamConstants:TC_REFERENCE).
                WriteInt(iRefPosition).
            end.
        end.    /* valid-object */
        else
            WriteByte(ObjectStreamConstants:TC_NULL).
    end method.    
    
    method protected void InvokeWriteObject(poIn as Object):
        define variable oType as class Class no-undo.
        
        oType = poIn:GetClass().

        if oType:IsA(ObjectStreamConstants:SERIALIZABLE_IFACE_TYPE) then
            DefaultWriteObject(poIn).
        
        /* A type could be Externalizable and Serializable, so no ELSE */
        if oType:IsA(ObjectStreamConstants:EXTERNALIZABLE_IFACE_TYPE) then
            oType:Invoke(poIn,
                ObjectStreamConstants:EXTERNALIZABLE_METHOD_WRITEOBJECT,
                moWriteObjParam).
        /* If we get here, then the class being serialized doesn't
           re-throw any of the ObjectOutputErrors it receives.
           
           We don't want to continue, since there was an error, so 
           we abort. */
        if valid-object(moObjectOutputError) then
            undo, throw moObjectOutputError .
    end method.
    
    method protected integer AddReference (piType as int,
        piRef as int,
        piPos as int):
        def buffer bRef for StreamReference.
        
        find bRef where
            bRef.ReferenceType = piType and
            bRef.Reference = piRef
            no-error.
        if not available bRef then
        do:
            create bRef.
            assign 
                bRef.ReferenceType = piType
                bRef.Reference     = piRef
                bRef.Position      = piPos.
        end.
        
        return bRef.Position.
    end method.
    
    method protected void WriteClassDesc(poType as class Class):
        define variable iFlags           as integer   no-undo.
        define variable lWriteMemberInfo as logical   no-undo.
        define variable cMD5             as character no-undo.
        define variable cTypeName        as character no-undo.
        
        /* Don't write top-level class, ie Progress.Lang.Object. The
           PROVERSION written into the stream header will ensure we 
           have the right top-level object.
           
           Note, don't write the name in the highly unlikely case that
           PLO changes in the future. */
        if valid-object(poType:SuperClass) then
        do:
            WriteByte(ObjectStreamConstants:TC_METADATA).
            moTypeStack:Push(poType).
            
            cTypeName = poType:TypeName.
            WriteString(cTypeName).
            
            rcode-info:file-name = replace(cTypeName, '.', '/').
            cMD5  = rcode-info:md5-value no-error.
            WriteString(cMD5).
            
            assign 
                lWriteMemberInfo = no
                iFlags           = 0.
            
            if poType:IsA(ObjectStreamConstants:EXTERNALIZABLE_IFACE_TYPE) then
                assign iFlags           = iFlags + ObjectStreamConstants:SC_EXTERNALIZABLE + ObjectStreamConstants:SC_WRITE_METHOD
                    lWriteMemberInfo = no.
            
            if poType:IsA(ObjectStreamConstants:SERIALIZABLE_IFACE_TYPE) then                
                assign iFlags           = iFlags + ObjectStreamConstants:SC_SERIALIZABLE
                    lWriteMemberInfo = yes.
            
            /* Each class in the hierarchy needs to be either Serializable or Externalizable. */
            if iFlags eq 0 then
                ThrowError(ObjectOutputError:TYPE,
                    'type that implements ' + ObjectStreamConstants:SERIALIZABLE_IFACE_TYPE 
                    + ' or ' + ObjectStreamConstants:EXTERNALIZABLE_IFACE_TYPE).
            WriteByte(iFlags).
            
            if lWriteMemberInfo then
            do:
            /* num properties, variables, fields */
            /* actually write out property names, types */
            end.

            WriteClassDesc(poType:SuperClass).
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteObjectArray(pIn as Object extent):        
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().

        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteObject(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteEnum(input poMember as EnumMember):
        ValidateStream().
        
        if valid-object(poMember) then
        do:
            WriteByte(ObjectStreamConstants:TC_ENUM).
            WriteChar(poMember:GetClass():TypeName).
            WriteInt(poMember:Value).
            WriteChar(poMember:Name).
        end.
        else
            WriteByte(ObjectStreamConstants:TC_NULL).
    end method.
    
    method public void WriteChar(pc as char):
        ValidateStream().
        WriteString(pc).
    end method.
        
    method public void WriteCharArray(pIn as character extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteChar(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteLongchar(pc as longchar):
        ValidateStream().
        WriteString(pc).
    end method.
    
    method public void WriteLongcharArray(pIn as longchar extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteLongchar(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteInt(pi as int):
        ValidateStream().
        
        if pi eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_VALUE).
            WriteLong(pi).
        end.
    end method.
    
    method public void WriteIntArray(pIn as integer extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteInt(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteInt64(pi as int64):
        ValidateStream().
        if pi eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_VALUE).                   
            WriteDouble(pi).
        end.
    end method.
            
    method public void WriteInt64Array(pIn as int64 extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteInt64(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteDecimal(pd as dec):
        def var cVal as char no-undo.
        
        ValidateStream().
                
        /* Put into stream as string since there's no decent analog in PUT-* terms.
           Convert to American format for writing. Don't change the SESSION since we
           have no idea what the caller is doing before or after the WriteDecimal() calls:
           they might be using a string representation of a decimal for some strange thing. 
           So we will 'hand-craft' it. */
        assign 
            cVal = replace(string(pd), session:numeric-separator, '')
            cVal = replace(cVal, session:numeric-decimal-point, '.').
        
        WriteString(cVal).
    end method.
    
    method public void WriteDecimalArray(pIn as dec extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.

        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteDecimal(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteDate(pt as date):
        ValidateStream().
        if pt eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_VALUE).                           
            WriteLong(int(date(pt))).
        end.
    end method.
        
    method public void WriteDateArray(pIn as date extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteDate(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.

    method public void WriteDateTime(pt as datetime):
        ValidateStream().
        
        if pt eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_VALUE).
            WriteLong(int(date(pt))).
            WriteLong(mtime(pt)).
        end.
    end method.
    
    method public void WriteDateTimeArray(pIn as datetime extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteDateTime(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteDateTimeTz(pt as datetime-tz):
        ValidateStream().
        
        if pt eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_VALUE).
            WriteLong(int(date(pt))).
            WriteLong(mtime(pt)).
            WriteLong(timezone(pt)).
        end.
    end method.
    
    method public void WriteDateTimeTzArray(pIn as datetime-tz extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
    
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteDateTimeTz(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteLogical(pl as log):
        ValidateStream().
        if pl eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_VALUE).        
            WriteByte(int(pl)).
        end.
    end method.
    
    method public void WriteLogicalArray(pIn as log extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteLogical(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.

    method public void WriteRowid(pr as rowid):
        ValidateStream().
        WriteString(string(pr)).    
    end method.
    
    method public void WriteRowidArray(pIn as rowid extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteRowid(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.

    method public void WriteRecid(pr as recid):
        ValidateStream().
        WriteInt(int(pr)).    
    end method.
    
    method public void WriteRecidArray(pIn as recid extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iMax eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).        
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteRecid(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
        
    method protected void WriteDatasetDesc(phIn as handle):
        define variable iLoop     as integer no-undo.
        define variable iMax      as integer no-undo.
        define variable hRelation as handle  no-undo.
        
        WriteByte(ObjectStreamConstants:TC_METADATA).   /* dataset */
        WriteString(phIn:name).
        WriteLogical(phIn:dynamic). /* ie do we need to construct the dataset? */
        
        if phIn:dynamic then
        do:
            /* buffers */
            WriteByte(ObjectStreamConstants:TC_BLOCKDATA).  /* buffers */
            iMax = phIn:num-buffers.
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteTableDesc(phIn:get-buffer-handle(iLoop)).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).   /* buffers */
            
            /* relations */
            WriteByte(ObjectStreamConstants:TC_BLOCKDATA).  /* relations */
            iMax = phIn:num-relations.
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteDatasetRelation(phIn:get-relation(iLoop)).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA). /* relations */
        end.
    end method.
    
    method public void WriteDataset (phIn as handle):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        if not valid-handle(phIn) then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            if not DataTypeEnum:Dataset:Equals(phIn:type) then
                ThrowError(ObjectOutputError:TYPE,
                    DataTypeEnum:Dataset:ToString()).
            
            WriteByte(ObjectStreamConstants:TC_OBJECT).     /* dataset */
            WriteDatasetDesc(phIn).
            WriteByte(ObjectStreamConstants:TC_NULL).
            
            WriteByte(ObjectStreamConstants:TC_BLOCKDATA).  /* buffer data */
            iMax = phIn:num-buffers.
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteBufferData(phIn:get-buffer-handle(iLoop)).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).   /* buffer data */
            
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).  /* dataset */
        end.
    end method.
    
    method protected void WriteDatasetRelation(phIn as handle):
        WriteByte(ObjectStreamConstants:TC_BLOCKDATA).
    
        /* Write information for a relation in the order
           that ADD-RELATION() expects it in. */                
        WriteString(phIn:parent-buffer:name).
        WriteString(phIn:child-buffer:name).
        WriteString(phIn:relation-fields).
        WriteLogical(phIn:reposition).
        WriteLogical(phIn:nested).
        WriteLogical(phIn:active).
        WriteLogical(phIn:recursive).
        WriteLogical(phIn:foreign-key-hidden).
        
        WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).            
    end method.
    
    method protected void WriteTableDesc(phIn as handle):
        define variable hField as handle  no-undo.
        define variable iLoop  as integer no-undo.
        define variable iMax   as integer no-undo.
        
        WriteByte(ObjectStreamConstants:TC_METADATA).   /* buffer */
        WriteString(phIn:name).
        WriteLogical(phIn:dynamic). /* ie do we need to construct the table/buffer? */
        
        if phIn:dynamic then
        do:
            iMax = phIn:num-fields.
            WriteByte(iMax).
                        
            WriteByte(ObjectStreamConstants:TC_BLOCKDATA).   /* fields */
            /* Dump enough info for ADD-NEW-FIELD(). And write it in the order that A-N-F() expects,
               so we don't have to use intermediaries on read. */
            do iLoop = 1 to iMax:
                hField = phIn:buffer-field(iLoop).
                WriteString(hField:name).
                WriteByte(DataTypeEnum:EnumFromString(hField:data-type):Value).
                WriteByte(hField:extent).   /* Extent will be 0 for scalars */
                WriteString(hField:format).
                WriteString(hField:default-string).
                WriteString(hField:label).
                WriteString(hField:column-label).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).   /* fields */
            
            WriteIndexInfo(phIn).
        end.
    end method.
    
    method protected void WriteIndexInfo(phIn as handle):
        define variable iLoop  as integer   no-undo.
        define variable iMax   as integer   no-undo.
        define variable cIndex as character extent no-undo.        

        WriteByte(ObjectStreamConstants:TC_BLOCKDATA).  /* Indexes */
        
        assign 
            iMax           = 1
            extent(cIndex) = ObjectStreamConstants:SIZE_INDEX_ARRAY
            cIndex[iMax]   = phIn:index-information(iMax)
            .
        do while cIndex[iMax] ne ?:
            assign 
                iMax         = iMax + 1
                cIndex[iMax] = phIn:index-information(iMax).
        end.
        /* we'll be outta this loop with a too-high iMax value */
        iMax = iMax - 1.
        if iMax gt extent(cIndex) then
            ThrowError(ObjectOutputError:ARRAY_SIZE, string(ObjectStreamConstants:SIZE_INDEX_ARRAY)).

        WriteByte(iMax).
                
        do iLoop = 1 to iMax:
            WriteString(cIndex[iLoop]).
        end.
        WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).   /* indexes */
    end method.
    
    method protected void WriteBufferRow(phIn as handle):
        define variable iLoop  as integer   no-undo.
        define variable iMax   as integer   no-undo.
        define variable cIndex as character no-undo.
        define variable hField as handle    no-undo.
        
        WriteByte(ObjectStreamConstants:TC_BLOCKDATA).   /* row */
        do iLoop = 1 to phIn:num-fields:
            hField = phIn:buffer-field(iLoop).
            
            case DataTypeEnum:EnumFromString(hField:data-type):
                when DataTypeEnum:Character then
                    if hField:extent eq 0 then
                        WriteChar(hField:buffer-value).
                    else
                        WriteCharArray(hField:buffer-value).
                when DataTypeEnum:Date then 
                    if hField:extent eq 0 then
                        WriteDate(hField:buffer-value).
                    else
                        WriteDateArray(hField:buffer-value).
                when DataTypeEnum:DateTime then
                    if hField:extent eq 0 then
                        WriteDateTime(hField:buffer-value).
                    else
                        WriteDateTimeArray(hField:buffer-value).
                when DataTypeEnum:DatetimeTZ then
                    if hField:extent eq 0 then
                        WriteDateTimeTz(hField:buffer-value).
                    else
                        WriteDateTimeTzArray(hField:buffer-value).
                when DataTypeEnum:Decimal then
                    if hField:extent eq 0 then
                        WriteDecimal(hField:buffer-value).
                    else
                        WriteDecimalArray(hField:buffer-value).
                when DataTypeEnum:Integer then
                    if hField:extent eq 0 then
                        WriteInt(hField:buffer-value).
                    else
                        WriteIntArray(hField:buffer-value).
                when DataTypeEnum:Int64 then
                    if hField:extent eq 0 then
                        WriteInt64(hField:buffer-value).
                    else
                        WriteInt64Array(hField:buffer-value).
                when DataTypeEnum:Logical then
                    if hField:extent eq 0 then
                        WriteLogical(hField:buffer-value).
                    else
                        WriteLogicalArray(hField:buffer-value).
                when DataTypeEnum:LongChar then
                    if hField:extent eq 0 then
                        WriteLongChar(hField:buffer-value).
                    else
                        WriteLongCharArray(hField:buffer-value).
                when DataTypeEnum:Class or 
                when DataTypeEnum:ProgressLangObject then
                    if hField:extent eq 0 then
                    do:
                        if type-of(hField:buffer-value, EnumMember) then
                            WriteEnum(hField:buffer-value).
                        else
                            WriteObject(hField:buffer-value).
                    end.
                    else
                        WriteObjectArray(hField:buffer-value).
                when DataTypeEnum:Recid then
                    if hField:extent eq 0 then
                        WriteRecid(hField:buffer-value).
                    else
                        WriteRecidArray(hField:buffer-value).
                when DataTypeEnum:Rowid then 
                    if hField:extent eq 0 then
                        WriteRowid(hField:buffer-value).
                    else
                        WriteRowidArray(hField:buffer-value).
                otherwise
                ThrowError(ObjectOutputError:TYPE,
                    'something other than ' + hField:data-type).
            end case.
        end.
        
        WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).   /* row */
    end method.
    
    method protected void WriteBufferData (phIn as handle):
        define variable hQry    as handle no-undo.
        define variable hBuffer as handle no-undo.
        
        WriteByte(ObjectStreamConstants:TC_BLOCKDATA).  /* data */
        create buffer hBuffer for table phIn:table-handle buffer-name 'Serialize'.
        create query hQry.
        hQry:set-buffers(hBuffer).
        hQry:query-prepare('preselect each ' + hBuffer:name).
        hQry:query-open().
        WriteInt(hQry:num-results).
        
        hQry:get-first().        
        do while not hQry:query-off-end:
            WriteBufferRow(hBuffer).
            hQry:get-next().
        end.
        hQry:query-close().
        WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).   /* data */
        
        delete object hQry.
        delete object hBuffer.
    end method.
    
    method public void WriteTable(phIn as handle):
        define variable hBuffer as handle no-undo.
        
        ValidateStream().
        
        if not valid-handle(phIn) then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            if not DataTypeEnum:Buffer:Equals(phIn:type) then
            do:
                if not DataTypeEnum:TempTable:Equals(phIn:type) then
                    ThrowError(ObjectOutputError:TYPE,
                        DataTypeEnum:Buffer:ToString()
                        + ' or ' + DataTypeEnum:TempTable:ToString()).
                phIn = phIn:default-buffer-handle.
            end.
            
            WriteByte(ObjectStreamConstants:TC_TABLE).
            WriteTableDesc(phIn).
            WriteByte(ObjectStreamConstants:TC_NULL).
            
            WriteBufferData(phIn).
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    method public void WriteHandle(ph as handle):
        ValidateStream().
        case DataTypeEnum:EnumFromString(ph:type):
            when DataTypeEnum:Buffer or 
            when DataTypeEnum:TempTable then
                ThrowError(ObjectOutputError:API_CALL,
                    ObjectStreamConstants:EXTERNALIZABLE_METHOD_WRITETABLE).
            when DataTypeEnum:Dataset then
                ThrowError(ObjectOutputError:API_CALL,
                    ObjectStreamConstants:EXTERNALIZABLE_METHOD_WRITEDATASET).
            otherwise
            WriteInt(int(ph)).
        end case.
    end method.
    
    method protected void ThrowError(pcType as char, pcParam as char):
        /* Keep a clone around in case the class being serialized doesn't
           re-throw any of the ObjectOutputErrors it receives. We use a 
           clone because the thrown class is GC'd before we need it to be,
           even if we assign it to a member.
           
           We can deal with the Error in InvokeWriteObject if need be. */
        moObjectOutputError = new ObjectOutputError(pcType, pcParam).        
        
        undo, throw cast(moObjectOutputError:Clone(), ObjectOutputError).
    end method.
    
    method public void WriteHandleArray(pIn as handle extent):
        define variable iLoop as integer no-undo.
        define variable iMax  as integer no-undo.
        
        ValidateStream().
        
        iMax = extent(pIn).
        if iLoop eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            WriteByte(ObjectStreamConstants:TC_ARRAY).
            WriteByte(iMax).
            do iLoop = 1 to iMax:
                WriteHandle(pIn[iLoop]).
            end.
            WriteByte(ObjectStreamConstants:TC_ENDBLOCKDATA).
        end.
    end method.
    
    /* Protected Write*() methods below do the actual writes to the stream. */
    method protected void WriteByte(piIn as int):
        put-byte(mrStreamBuffer, miCursor) = piIn.
        miCursor = miCursor + ObjectStreamConstants:SIZE_BYTE.
    end method.
    
    method protected void WriteShort(piIn as int):
        put-short(mrStreamBuffer, miCursor) = piIn.
        miCursor = miCursor + ObjectStreamConstants:SIZE_SHORT.
    end method.
    
    method protected void WriteLong(piIn as int):
        put-long(mrStreamBuffer, miCursor) = piIn.
        miCursor = miCursor + ObjectStreamConstants:SIZE_LONG.
    end method.
    
    method protected void WriteDouble(pdIn as dec):
        put-double(mrStreamBuffer, miCursor) = pdIn.
        miCursor = miCursor + ObjectStreamConstants:SIZE_DOUBLE.
    end method.
    
    method protected void WriteString(pcVal as char):
        define variable lcVal as longchar no-undo.
        lcVal = pcVal.
        
        WriteString(lcVal).
    end method.
    
    method protected void WriteString(pcVal as longchar):
        define variable iLength as integer no-undo.
        define variable iMarker as integer no-undo.
        
        if pcVal eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            iLength = length(pcVal, CompareStrengthEnum:Raw:ToString()).
            
            WriteByte(ObjectStreamConstants:TC_VALUE).
            WriteLong(iLength).
            put-string(mrStreamBuffer, miCursor) = pcVal.
            miCursor = miCursor + iLength.
        end.
    end method.

    method protected void WriteRaw(prVal as raw):
        define variable iLength as integer no-undo.
        define variable iMarker as integer no-undo.
        
        if prVal eq ? then
            WriteByte(ObjectStreamConstants:TC_NULL).
        else
        do:
            iLength = length(prVal, CompareStrengthEnum:Raw:ToString()).
            
            WriteByte(ObjectStreamConstants:TC_VALUE).
            WriteLong(iLength).
            put-bytes(mrStreamBuffer, miCursor) = prVal.
            miCursor = miCursor + iLength.
        end.
    end method.
    
    method protected void ValidateStream():
        if not mlStreamHeaderWritten then
            ThrowError(ObjectOutputError:STREAM, 'stream header to be written').
    end method.
    
end class./*------------------------------------------------------------------------
    File        : ObjectStreamConstants
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 17 14:18:12 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.Util.ObjectStreamConstants.

class OpenEdge.Core.Util.ObjectStreamConstants final: 
    
    define public static property /* BYTE */ PROTOCOL_VERSION_1    as integer init 1       no-undo get.
    
    /* SC_ = stream code */
    define public static property /* BYTE */ SC_BLOCK_DATA         as integer init 8       no-undo get.
    define public static property /* BYTE */ SC_EXTERNALIZABLE     as integer init 4       no-undo get.
    define public static property /* BYTE */ SC_SERIALIZABLE       as integer init 2       no-undo get.
    define public static property /* BYTE */ SC_WRITE_METHOD       as integer init 1       no-undo get.

    
    define public static property /* STRING */ STREAM_MAGIC          as character init 'PABLO' no-undo get.
    define public static property /* BYTE */ STREAM_VERSION        as integer  init 1       no-undo get.
    
    /* TC_ = TypeCode_ */
/*    define public static property /* BYTE */ TC_BASE               as integer init 112     no-undo get.*/
/*    define public static property /* BYTE */ TC_BLOCKDATALONG      as integer init 122     no-undo get.*/
/*    define public static property /* BYTE */ TC_CLASS              as integer init 118     no-undo get.*/
/*    define public static property /* BYTE */ TC_EXCEPTION          as integer init 123     no-undo get.*/
/*    define public static property /* BYTE */ TC_MAX                as integer init 125     no-undo get.*/
/*    define public static property /* BYTE */ TC_PROXYCLASSDESC     as integer init 125     no-undo get.*/
/*    define public static property /* BYTE */ TC_RESET              as integer init 121     no-undo get.*/
    
    define public static property /* BYTE */ TC_ARRAY              as integer init 117     no-undo get.
    define public static property /* BYTE */ TC_BLOCKDATA          as integer init 119     no-undo get.
    define public static property /* BYTE */ TC_METADATA           as integer init 114     no-undo get.
    define public static property /* BYTE */ TC_DATASET            as integer init 121     no-undo get.
    define public static property /* BYTE */ TC_DECIMAL            as integer init 118     no-undo get.
    define public static property /* BYTE */ TC_ENDBLOCKDATA       as integer init 120     no-undo get.
/*    define public static property /* BYTE */ TC_INVALIDOBJECT      as integer init 112     no-undo get.*/
/*    define public static property /* BYTE */ TC_LONGSTRING         as integer init 124     no-undo get.*/
    define public static property /* BYTE */ TC_NULL               as integer init 112     no-undo get.
    define public static property /* BYTE */ TC_OBJECT             as integer init 115     no-undo get.
    define public static property /* BYTE */ TC_ENUM               as integer init 116     no-undo get.
    define public static property /* BYTE */ TC_REFERENCE          as integer init 113     no-undo get.
/*    define public static property /* BYTE */ TC_STRING             as integer init 116     no-undo get.*/
    define public static property /* BYTE */ TC_TABLE              as integer init 122     no-undo get.
    define public static property /* BYTE */ TC_VALUE              as integer init 123     no-undo get.
    
    /* Sizes always in BYTES */
    define public static property SIZE_BYTE     as integer init 1 no-undo get.
    define public static property SIZE_SHORT    as integer init 2 no-undo get.
    define public static property SIZE_USHORT   as integer init 2 no-undo get.
    define public static property SIZE_LONG     as integer init 4 no-undo get.
    define public static property SIZE_ULONG    as integer init 4 no-undo get.
    define public static property SIZE_INT64    as integer init 8 no-undo get.
    define public static property SIZE_FLOAT    as integer init 4 no-undo get.
    define public static property SIZE_DOUBLE   as integer init 8 no-undo get.
    
    define public static property REFTYPE_OBJECT as integer init 1 no-undo get.
    define public static property REFTYPE_TYPE   as integer init 2 no-undo get.
    
    define public static property SERIALIZABLE_IFACE_TYPE   as character init 'OpenEdge.Core.Util.ISerializable' no-undo get.    
    define public static property EXTERNALIZABLE_IFACE_TYPE as character init 'OpenEdge.Core.Util.IExternalizable' no-undo get.
        
    define public static property EXTERNALIZABLE_METHOD_READOBJECT as character init 'ReadObject' no-undo get.
    define public static property EXTERNALIZABLE_METHOD_WRITEOBJECT as character init 'WriteObject' no-undo get.
    define public static property EXTERNALIZABLE_METHOD_WRITETABLE as character init 'WriteTable' no-undo get.
    define public static property EXTERNALIZABLE_METHOD_WRITEDATASET as character init 'WriteDataset' no-undo get.
    define public static property EXTERNALIZABLE_METHOD_WRITEENUM as character init 'WriteEnum' no-undo get.
    define public static property EXTERNALIZABLE_METHOD_READENUM as character init 'ReadEnum' no-undo get.
    
    define public static property SIZE_INDEX_ARRAY as integer init 20 no-undo get.
    
    method static public character ToString (piObjectStreamConstant as integer):
        define variable cString as character no-undo.
        
        case piObjectStreamConstant:
            /* SC_ constants */
            when ObjectStreamConstants:SC_BLOCK_DATA then cString ='SC_BLOCK_DATA'.
            when ObjectStreamConstants:SC_EXTERNALIZABLE then cString ='SC_EXTERNALIZABLE'.
            when ObjectStreamConstants:SC_SERIALIZABLE then cString ='SC_SERIALIZABLE'.
            when ObjectStreamConstants:SC_WRITE_METHOD then cString ='SC_WRITE_METHOD'.
            /* TC_ constants */
            when ObjectStreamConstants:TC_DECIMAL then cString ='TC_DECIMAL'.
            when ObjectStreamConstants:TC_VALUE then cString ='TC_VALUE'.
            when ObjectStreamConstants:TC_ARRAY then cString ='TC_ARRAY'.
            when ObjectStreamConstants:TC_BLOCKDATA then cString ='TC_BLOCKDATA'.
            when ObjectStreamConstants:TC_METADATA then cString ='TC_METADATA'.
            when ObjectStreamConstants:TC_DATASET then cString ='TC_DATASET'.
            when ObjectStreamConstants:TC_ENDBLOCKDATA then cString ='TC_ENDBLOCKDATA'.
/*            when ObjectStreamConstants:TC_LONGSTRING then cString ='TC_LONGSTRING'.*/
            when ObjectStreamConstants:TC_NULL then cString ='TC_NULL'.
            when ObjectStreamConstants:TC_OBJECT then cString ='TC_OBJECT'.
            when ObjectStreamConstants:TC_ENUM then cString ='TC_ENUM'.
            when ObjectStreamConstants:TC_REFERENCE then cString ='TC_REFERENCE'.
/*            when ObjectStreamConstants:TC_STRING then cString ='TC_STRING'.*/
            when ObjectStreamConstants:TC_TABLE then cString ='TC_TABLE'.
            /* REFTYPE_  constants */
            when ObjectStreamConstants:REFTYPE_OBJECT then cString ='REFTYPE_OBJECT'.
            when ObjectStreamConstants:REFTYPE_TYPE then cString ='REFTYPE_TYPE'.
        end case.
        
        return cString.
    end method.    
end class.
/** ------------------------------------------------------------------------
    File        : SaxReader
    Purpose     : Wrapper OpenEdge/Core/XML/SaxReaderfacade.p which handles SAX
                  parser events.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 13 09:50:23 EDT 2010
    Notes       : * The strongly-typed events in this class correspond to the
                    SAX-READER events, as documented in the ABL documentation
                    set. This class basically acts as a wrapper around a .P 
                    since classes can't be specified as listeners for the SAX-
                    READER object. This class then re-publishes the events as
                    strongly typed events.
                  * The strongly-typed events in this class follow the ABL convention,
                    and not the sender,eventargs convention otherwise used in
                    this reference code.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

class OpenEdge.Core.XML.SaxReader:
    
    /* SAX Events from SAX-READER callbacks */
    define public event SaxReaderStartDocument signature void(input phReader as handle).
     
    define public event SaxReaderProcessingInstruction signature void (input phReader as handle, 
                                                                       input pcTarget as character,
                                                                       input pcData as character).    
    define public event SaxReaderResolveEntity signature void (input phReader as handle,
                                                               input pcPublicID as character,
                                                               input pcSystemID as character,
                                                               output pcFilePath as character,
                                                               output pcMemPointer as longchar).
    define public event SaxReaderStartPrefixMapping signature void (input phReader as handle,
                                                                    input pcPrefix as character,
                                                                    input pcURI as character).    
    define public event SaxReaderEndPrefixMapping signature void (input phReader as handle,
                                                                  input pcPrefix as character).    
    define public event SaxReaderStartElement signature void (input phReader as handle,
                                                              input pcNamespaceURI as character,
                                                              input pcLocalName as character,
                                                              input pcQName as character,
                                                              input phAttributes as handle ).
    define public event SaxReaderCharacters signature void (input phReader as handle,
                                                            input pcCharData as longchar,
                                                            input piNumChars as integer).
    define public event SaxReaderIgnorableWhitespace signature void (input phReader as handle,
                                                                     input pcCharData as character,
                                                                     input piNumChars as integer).
    define public event SaxReaderEndElement signature void (input phReader as handle,
                                                            input pcName  as character,
                                                            input pcPublicID as character,
                                                            input pcSystemID as character).
    define public event SaxReaderEndDocument signature void (input phReader as handle).
    define public event SaxReaderNotationDecl signature void (input phReader as handle,
                                                              input pcName  as character,
                                                              input pcPublicID as character,
                                                              input pcSystemID as character).
    define public event SaxReaderUnparsedEntityDecl signature void (input phReader as handle,
                                                                    input pcName as character,
                                                                    input publicID     as character,
                                                                    input systemID     as character,
                                                                    input pcNotationName as character).
    define public event SaxReaderWarning signature void (input phReader as handle,
                                                         input pcErrMessage as character).
    define public event SaxReaderError signature void (input phReader as handle,
                                                       input pcErrMessage as character).
    define public event SaxReaderFatalError signature void (input phReader as handle,
                                                            input pcErrMessage as character).
    
    define private variable mhParserProc as handle no-undo.
    
    constructor public SaxReader():
        run OpenEdge/Core/XML/saxreaderfacade.p persistent set mhParserProc (this-object).        
    end constructor.
    
    destructor public SaxReader():
        delete procedure mhParserProc no-error.
    end destructor.
    
    method public void ParseDocument(pcXML as longchar):
        run ParseDocument in mhParserProc (pcXML).
    end method.
    
    /* Tell the parser where to find an external entity. */
    method public void ResolveEntity (input pcPublicID as character,
                                      input pcSystemID as character,
                                      output pcFilePath as character,
                                      output pcMemPointer as longchar):
        SaxReaderResolveEntity:Publish(self:handle, pcPublicID, pcSystemID, output pcFilePath, output pcMemPointer).                                          
    end method.
    
    /** Process various XML tokens. */
    method public void StartDocument():
        SaxReaderStartDocument:Publish(self:handle).
    end method.
    
    method public void ProcessingInstruction(input pcTarget as character,
                                             input pcData as character):
        SaxReaderProcessingInstruction:Publish(self:handle, pcTarget, pcData).
    end method.
    
    method public void StartPrefixMapping(input pcPrefix as character,
                                          input pcURI as character):
        SaxReaderStartPrefixMapping:Publish(self:handle, pcPrefix, pcURI).                                              
    end method.

    method public void EndPrefixMapping(input pcPrefix as character):
        SaxReaderEndPrefixMapping:Publish(self:handle, pcPrefix).
    end method.

    method public void StartElement(input pcNamespaceURI as character,
                                    input pcLocalName as character,
                                    input pcQName as character,
                                    input phAttributes as handle ):
        SaxReaderStartElement:Publish(self:handle, pcNamespaceURI, pcLocalName, pcQName, phAttributes).                                        
    end method.

    method public void Characters(input pcCharData as longchar,
                                  input piNumChars as integer):
        SaxReaderCharacters:Publish(self:handle, pcCharData, piNumChars).
    end method.

    method public void IgnorableWhitespace(input pcCharData as character,
                                           input piNumChars as integer):
        SaxReaderIgnorableWhitespace:Publish(self:handle, pcCharData, piNumChars).
    end method.

    method public void EndElement(input pcNamespaceURI as character,
                                  input pcLocalName as character,
                                  input pcQName as character):
        SaxReaderEndElement:Publish(self:handle, pcNamespaceURI, pcLocalName, pcQName).                                      
    end method.

    method public void EndDocument():
        SaxReaderEndDocument:Publish(self:handle).
    end method.

    /** Process notations and unparsed entities.*/
    method public void NotationDecl(input pcName  as character,
                                    input pcPublicID as character,
                                    input pcSystemID as character):
        SaxReaderNotationDecl:Publish(self:handle, pcName, pcPublicID, pcSystemID).                                        
    end method.

    method public void UnparsedEntityDecl(input pcName as character,
                                          input pcPublicID as character,
                                          input pcSystemID as character,
                                          input pcNotationName as character):
        SaxReaderUnparsedEntityDecl:Publish(self:handle, pcName, pcPublicID, pcSystemID, pcNotationName).                                              
    end method.

    /*Handle errors.*/
    method public void Warning(input pcErrMessage as character):
        SaxReaderWarning:Publish(self:handle, pcErrMessage).
    end method.

    method public void Error(input pcErrMessage as character):
        SaxReaderError:Publish(self:handle, pcErrMessage).
    end method.
    
    method public void FatalError(input pcErrMessage as character):
        SaxReaderFatalError:Publish(self:handle, pcErrMessage).
    end method. 
    
end class./** ------------------------------------------------------------------------
    File        : SaxReaderfacade.p
    Purpose     : XML SAX parser facade procedure.
    Syntax      :
    Description : 
    @author pjudge
    Created     : Tue Jul 13 09:40:09 EDT 2010
    Notes       : * This procedure acts as a facade object for the SaxReader
                    class, since classes can't be subscribed as event listeners
                    for the ABL SAX-READER.
                  * The individual procedures here are as documented in the
                    ABL documentation set. 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.XML.SaxReader.
using OpenEdge.Lang.SerializationModeEnum.

/* ***************************  Definitions  ************************** */
/** The facade object that handles the callbacks from the SAX parser, and which
    publishes them as typed events. */
define input parameter poSaxReader as SaxReader no-undo.

create widget-pool.

/* ***************************  Main Block  *************************** */

procedure ParseDocument:
    define input parameter pcXML as longchar no-undo.
    
    define variable hSaxReader as handle no-undo.
    define variable hSaxAttributes as handle no-undo.
    
    create sax-reader hSaxReader.
    hSaxReader:handler = this-procedure.
    
    create sax-attributes hSaxAttributes.
    
    hSaxReader:set-input-source(SerializationModeEnum:LongChar:ToString(), pcXML).
    hSaxReader:sax-parse().
    
    finally:
        delete object hSaxAttributes no-error.
        delete object hSaxReader no-error.
    end finally.
end procedure.

/* ***************************  Callbacks  *************************** */

/* Tell the parser where to find an external entity. */
procedure ResolveEntity:
    define input  parameter publicID   as character no-undo.
    define input  parameter systemID   as character no-undo.
    define output parameter filePath   as character no-undo.
    define output parameter memPointer as longchar no-undo.
    
    poSaxReader:ResolveEntity(publicID, systemID, output filePath, output memPointer).
end procedure.

/** Process various XML tokens. */
procedure StartDocument:
    poSaxReader:StartDocument().
end procedure.

procedure ProcessingInstruction:
    define input parameter target as character no-undo.
    define input parameter data   as character no-undo.
    
    poSaxReader:ProcessingInstruction(target, data).
end procedure.

procedure StartPrefixMapping:
    define input parameter prefix as character no-undo.
    define input parameter uri    as character no-undo.
    
    poSaxReader:StartPrefixMapping(prefix, uri).
end procedure.

procedure EndPrefixMapping:    
    define input parameter prefix as character no-undo.
    
    poSaxReader:EndPrefixMapping(prefix).
end procedure.

procedure StartElement:
    define input parameter namespaceURI as character no-undo.
    define input parameter localName    as character no-undo.
    define input parameter qName        as character no-undo.
    define input parameter attributes   as handle no-undo.
    
    poSaxReader:StartElement(namespaceURI, localName, qName, attributes).
end procedure.

procedure Characters:
    define input parameter charData as longchar no-undo.
    define input parameter numChars as integer no-undo.
    
    poSaxReader:Characters(charData, numChars).
end procedure.

procedure IgnorableWhitespace:
    define input parameter charData as character no-undo.
    define input parameter numChars as integer.
    
    poSaxReader:IgnorableWhitespace(charData, numChars).
end procedure.

procedure EndElement:
     define input parameter namespaceURI as character no-undo.
     define input parameter localName    as character no-undo.
     define input parameter qName        as character no-undo.
     
     poSaxReader:EndElement(namespaceURI, localName, qName).
end procedure.

procedure EndDocument:
    poSaxReader:EndDocument().
end procedure.

/** Process notations and unparsed entities.*/
procedure NotationDecl:
    define input parameter name     as character no-undo.
    define input parameter publicID as character no-undo.
    define input parameter systemID as character no-undo.
    
    poSaxReader:NotationDecl(name, publicID, systemID).
end procedure.

procedure UnparsedEntityDecl:
    define input parameter name         as character no-undo.
    define input parameter publicID     as character no-undo.
    define input parameter systemID     as character no-undo.
    define input parameter notationName as character no-undo.
    
    poSaxReader:UnparsedEntityDecl(name, publicID, systemID, notationName).
end procedure.

/*Handle errors.*/
procedure Warning:
    define input parameter errMessage as character no-undo.
    
    poSaxReader:Warning(errMessage).
end procedure.

procedure Error:
    define input parameter errMessage as character no-undo.
     
    poSaxReader:Error(errMessage).
end procedure.

procedure FatalError:
    define input parameter errMessage as character no-undo.
    
    poSaxReader:FatalError(errMessage).
end procedure.

/** EOF **//** ------------------------------------------------------------------------
    File        : SaxWriter
    Purpose     : An OOABL wrapper around the ABL SAX-WRITER handle. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 22 15:40:24 EST 2010
    Notes       : * The majority of method names correspond to the ABL attributes/methods,
                    which are comprehensively documented in the ABL documentation set.
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.XML.SaxWriterError.
using OpenEdge.Core.XML.SaxWriterDataTypeEnum.

using OpenEdge.Lang.SaxWriteStatusEnum.
using OpenEdge.Lang.SerializationModeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.

class OpenEdge.Core.XML.SaxWriter use-widget-pool:
    
    /* The actual SAX-WRITER handle */
    define private variable mhSaxWriter as handle no-undo.
    
    /** (derived) Maps to SAX-WRITER WRITE-STATUS attribute. See the ABL documentation for more details. */
    define public property WriteStatus as SaxWriteStatusEnum no-undo
        get():
            if valid-handle(mhSaxWriter) then
                return SaxWriteStatusEnum:EnumFromValue(mhSaxWriter:write-status).
        end get.
    
    /** Maps to SAX-WRITER ENCODING attribute. See the ABL documentation for more details. */
    define public property Encoding  as character no-undo
        get.
        set(input pcEncoding as character):
            ValidateCanUpdateProperty('Encoding').
            mhSaxWriter:encoding = pcEncoding.
            Encoding = pcEncoding.
        end set.
    
    /** Maps to SAX-WRITER FORMATTED attribute. See the ABL documentation for more details. */
    define public property IsFormatted as logical no-undo 
        get.
        set (input plFormatted as logical):
            ValidateCanUpdateProperty('IsFormatted').
            IsFormatted = plFormatted.
            mhSaxWriter:formatted = plFormatted.
        end set.
    
    /** Maps to SAX-WRITER FRAGMENT attribute. See the ABL documentation for more details. */
    define public property IsFragment as logical no-undo
        get.
        set (input plFragment as logical):
            ValidateCanUpdateProperty('IsFragment').
            IsFragment = plFragment.
            mhSaxWriter:fragment = plFragment.
        end set.
    
    /** Maps to SAX-WRITER STANDALONE attribute. See the ABL documentation for more details. */ 
    define public property IsStandalone as logical no-undo
        get.
        set(input plStandalone as logical):
            ValidateCanUpdateProperty('IsStandalone').
            IsStandalone = plStandalone.
            mhSaxWriter:standalone = plStandalone.
        end set.
    
    /** Maps to SAX-WRITER STRICT attribute. See the ABL documentation for more details. */
    define public property IsStrict as logical no-undo
        get.
        set(input plStrict as logical):
            ValidateCanUpdateProperty('IsStrict').
            IsStrict = plStrict.
            mhSaxWriter:strict= plStrict.
        end set.
    
    /** Maps to SAX-WRITER VERSION attribute. See the ABL documentation for more details. */
    define public property Version  as character no-undo
        get.
        set(input pcVersion as character):
            ValidateCanUpdateProperty('Version').
            
            if IsStrict and Version ne '1.0' then
                undo, throw new SaxWriterError('setting ' + quoter('Version') + ' property with SaxWriter:IsString and version is ' + pcVersion, '').
            
            mhSaxWriter:version = pcVersion.
            Version = pcVersion.
        end set.
    
    constructor public SaxWriter():
        Initialize().
    end constructor.
    
    constructor public SaxWriter(input pcFilename as character):
        Initialize().
        WriteTo(pcFilename).
    end constructor.

    constructor public SaxWriter(input pcDocument as longchar):
        Initialize().
        WriteTo(pcDocument).
    end constructor.

    constructor public SaxWriter(input phStream as handle):
        Initialize().
        WriteTo(phStream).
    end constructor.

    constructor public SaxWriter(input pmDocument as memptr):
        Initialize().
        WriteTo(pmDocument).            
    end constructor.
    
    method protected void ValidateCanUpdateProperty(input pcPropertyName as character):
        if valid-handle(mhSaxWriter) then
        case WriteStatus:
            when SaxWriteStatusEnum:Idle or when SaxWriteStatusEnum:Complete then
                /* allowed to update property */ .
            otherwise
                undo, throw new SaxWriterError('setting ' + quoter(pcPropertyName) + ' property with SaxWriter status of ', WriteStatus:ToString()).
        end case.
    end method.
    
    method public void Initialize():
        if not valid-handle(mhSaxWriter) then
            create sax-writer mhSaxWriter.
        else
            Reset().                
    end method.
    
    method public logical  Reset():
        if valid-handle(mhSaxWriter) then
            return mhSaxWriter:reset().
        else
            return false.            
    end method.
    
    method public logical WriteTo(input pcFilename as character):
        return mhSaxWriter:set-output-destination(SerializationModeEnum:File:ToString(), pcFilename).    
    end method.

    method public logical WriteTo(input pcDocument as longchar):
        return mhSaxWriter:set-output-destination(SerializationModeEnum:LongChar:ToString(), pcDocument).    
    end method.

    method public logical WriteTo(input phStream as handle):
        Assert:ArgumentIsType(phStream, DataTypeEnum:Stream, 'stream').
        
        return mhSaxWriter:set-output-destination(SerializationModeEnum:StreamHandle:ToString(), phStream).
    end method.

    method public logical WriteTo(input pmDocument as memptr):    
        return mhSaxWriter:set-output-destination(SerializationModeEnum:Memptr:ToString(), pmDocument).
    end method.
    
    method public logical StartDocument():
        return mhSaxWriter:start-document().
    end method. 

    method public logical EndDocument():
        return mhSaxWriter:end-document().
    end method.

    method public logical DeclareNamespace(input pcNamespaceURI as longchar):
        return DeclareNamespace(pcNamespaceURI, ?).                                               
    end method.                                               
    
    method public logical DeclareNamespace(input pcNamespaceURI as longchar,
                                           input pcNamespacePrefix as longchar):
        return mhSaxWriter:declare-namespace(pcNamespaceURI, pcNamespacePrefix).                                               
    end method.                                               
    
    method public logical StartElement(input pcName as longchar):
        return StartElement(pcName, ?, ?).
    end method.
    
    method public logical StartElement(input pcName as longchar,
                                       input pcNamespaceURI as longchar):
        return StartElement(pcName, pcNamespaceURI, ?).
    end method.
    
    method public logical StartElement(input pcName as longchar,
                                       input pcNamespaceURI as longchar,                                       
                                       input phSaxAttributes as handle):
        return mhSaxWriter:start-element(pcName, pcNamespaceURI, phSaxAttributes).
    end method.

    
    method public logical EndElement(input pcName as longchar):
        return EndElement(pcName, ?).
    end method.
    
    method public logical EndElement(input pcName as longchar,
                                     input pcNamespaceURI as longchar):
        return mhSaxWriter:end-element(pcName, pcNamespaceURI).                                           
    end method.

    method public logical InsertAttribute (input pcName as longchar,
                                           input pcValue as longchar):
        return InsertAttribute(pcName, pcValue, ?). 
    end method.            

    method public logical InsertAttribute (input pcName as longchar,
                                           input pcValue as longchar,
                                           input pcNamespaceURI as longchar):
        return mhSaxWriter:insert-attribute(pcName, pcValue, pcNamespaceURI). 
    end method.
    
    /** Writes a value to the output destination. This method defaults to
        writing characters. 
        
        @param longchar The value being written.
        @return logical Whether the operation succeeded or not. */
    method public logical WriteValue(input pcValue as longchar):
        return WriteValue(SaxWriterDataTypeEnum:Characters, pcValue).
    end method.
    
    /** Writes a value to the output destination. This method simply writes
        the value for the given type, using the correct WRITE-* call. 
        
        There's a WriteFragment() method which deals with a noderef handle.
        
        @param SaxWriterDataTypeEnum The element type
        @param longchar The value being written.
        @return logical Whether the operation succeeded or not. */
    method public logical WriteValue(input poType as SaxWriterDataTypeEnum,
                                     input pcValue as longchar):
        case poType:
            when SaxWriterDataTypeEnum:CData then return mhSaxWriter:write-cdata(pcValue).
            when SaxWriterDataTypeEnum:Characters then return mhSaxWriter:write-characters(pcValue).
            when SaxWriterDataTypeEnum:Comment then return mhSaxWriter:write-comment(pcValue).
            when SaxWriterDataTypeEnum:EntityReference then return mhSaxWriter:write-entity-ref(pcValue).
            when SaxWriterDataTypeEnum:Fragment then return mhSaxWriter:write-fragment(pcValue).
        end case.
    end method.
    
    /** Writes a fragment's values from a specified XML node ref 
        
        @param handle The valid XML node-ref handle containing the fragment
        @return logical Whether the operation succeeded or not. */
    method public logical WriteFragment(input phNodeRef as handle):
        Assert:ArgumentIsType(phNodeRef, DataTypeEnum:XmlNodeRef, 'XML Node Ref').
        
        return mhSaxWriter:write-fragment(phNodeRef).
    end method.

    method public logical WriteDataElement(input pcName as longchar,
                                           input pcValue as longchar):
        return WriteDataElement(pcName, pcValue, ?, ?).                                               
    end method.

    method public logical WriteDataElement(input pcName as longchar,
                                           input pcValue as longchar,
                                           input pcNamespaceURI as longchar):
        return WriteDataElement(pcName, pcValue, pcNamespaceURI, ?).                                               
    end method.
    
    method public logical WriteDataElement(input pcName as longchar,
                                           input pcValue as longchar,
                                           input pcNamespaceURI as longchar,
                                           input phSaxAttributes as handle ):
        return mhSaxWriter:write-data-element(pcName, pcValue, pcNamespaceURI, phSaxAttributes).                                               
    end method.

    method public logical WriteEmptyElement(input pcName as longchar):
        return WriteEmptyElement(pcName, ?, ?).
    end method.

    method public logical WriteEmptyElement(input pcName as longchar,
                                            input pcNamespaceURI as longchar):
        return WriteEmptyElement(pcName, pcNamespaceURI, ?).
    end method.
    
    method public logical WriteEmptyElement(input pcName as longchar,
                                            input pcNamespaceURI as longchar,
                                            input phSaxAttributes as handle ):
        return mhSaxWriter:write-empty-element(pcName, pcNamespaceURI, phSaxAttributes).
    end method.

    method public logical WriteExternalDTD(input pcName as longchar,
                                           input pcSystemId as longchar):
        return WriteExternalDTD(pcName, pcSystemId, ?).
    end method.
    
    method public logical WriteExternalDTD(input pcName as longchar,
                                           input pcSystemId as longchar,
                                           input pcPublicId as longchar):
        return mhSaxWriter:write-external-dtd(pcName, pcSystemId, pcPublicId).
    end method.
    
    method public logical WriteProcessingInstruction(input pcTarget as longchar,
                                                     input pcData as longchar):
        return mhSaxWriter:write-processing-instruction(pcTarget, pcData).                                                         
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : SaxWriterDataTypeEnum
    Purpose     : Enumeration of the types that the SAX-WRITER can write as values
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 23 09:02:49 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.XML.SaxWriterDataTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.XML.SaxWriterDataTypeEnum inherits EnumMember:
    
    define static public property CData as SaxWriterDataTypeEnum  no-undo get. private set.
    define static public property Characters as SaxWriterDataTypeEnum  no-undo get. private set.
    define static public property Comment as SaxWriterDataTypeEnum  no-undo get. private set.
    define static public property EntityReference as SaxWriterDataTypeEnum  no-undo get. private set.
    define static public property Fragment as SaxWriterDataTypeEnum  no-undo get. private set.
        
    constructor static SaxWriterDataTypeEnum():
        SaxWriterDataTypeEnum:CData = new SaxWriterDataTypeEnum(1).
        SaxWriterDataTypeEnum:Characters = new SaxWriterDataTypeEnum(2).
        SaxWriterDataTypeEnum:Comment = new SaxWriterDataTypeEnum(3).
        SaxWriterDataTypeEnum:EntityReference = new SaxWriterDataTypeEnum(4).
        SaxWriterDataTypeEnum:Fragment = new SaxWriterDataTypeEnum(5).
    end constructor.
    
    constructor public SaxWriterDataTypeEnum(input piValue as integer):
        super (input piValue).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : SaxWriterError
    Purpose     : Application error raised when errors are raised by the SaxWriter / SAX-WRITER
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 22 16:04:57 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.XML.SaxWriterError inherits ApplicationError: 
    define override protected property ErrorText as longchar no-undo get. set. 
    define override protected property ErrorTitle as character no-undo get. set. 

    constructor public SaxWriterError(input poInnerError as Error):
        super(poInnerError).
        
        this-object:ErrorTitle = 'Sax Writer Error'.
        this-object:ErrorText = 'Error &1 &2'.
    end constructor.

    constructor public SaxWriterError(input poErr as Error,
                                      input pcArgs1 as character,
                                      input pcArgs2 as character):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

    constructor public SaxWriterError(input pcArgs1 as character,
                                      input pcArgs2 as character):
        this-object(?).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

end class./** ------------------------------------------------------------------------
    File        : WebServiceInvocationError
    Purpose     : Application error raised when errors are raised in a WebService call.  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 22 12:06:12 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.XML.WebServiceInvocationError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set. 
    define override protected property ErrorTitle as character no-undo get. set. 
    
    constructor public WebServiceInvocationError(input poInnerError as Error):
        super(poInnerError).
        
        this-object:ErrorTitle = 'WebService Invocation Error'.
        this-object:ErrorText = 'Error invoking &1 on WebService &2 &3'.
    end constructor.
    
    constructor public WebServiceInvocationError(input poErr as Error,
                                                 input pcArgs1 as character,
                                                 input pcArgs2 as character,
                                                 input pcArgs3 as character):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
        AddMessage(pcArgs3, 3).
    end constructor.

    constructor public WebServiceInvocationError(input pcArgs1 as character,
                                                 input pcArgs2 as character,
                                                 input pcArgs3 as character):
        this-object(?).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
        AddMessage(pcArgs3, 3).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : WebServiceProtocol
    Purpose     : Simple OOABL wrapper around ABL WebServices Out 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jul 02 12:01:04 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.XML.WebServiceProtocol.
using OpenEdge.Core.XML.WebServiceInvocationError.

using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.

using Progress.Lang.SoapFaultError.
using Progress.Lang.Error.

class OpenEdge.Core.XML.WebServiceProtocol abstract:
    /** (mandatory) The name of the service to which we are connecting */
    define public property Service as character no-undo get. private set.
    
    /** (mandatory) The WSDL document descibing the service */
    define protected property WSDL as character no-undo get. private set.
    
    /** (optional) Any additional connection parameters */
    define protected property ConnectionParams as character no-undo get. set.
    
    /** The handle to the running webservice */
    define protected property WebServiceHandle as handle no-undo get. private set.
    
    /** The handle to the port on the running webservice */
    define protected property PortHandle as handle no-undo get. private set.
    
    /** (derived) Returns whether the service is currently connected. */
    define public property Connected as logical no-undo 
        get():
            return (valid-handle(WebServiceHandle) and WebServiceHandle:connected()).
        end get.
    
    constructor public WebServiceProtocol(pcService as character,
                                          pcWSDL as character,
                                          pcConnectionParams as character):
        Assert:ArgumentNotNullOrEmpty(pcService, 'Service').
        Assert:ArgumentNotNullOrEmpty(pcWSDL, 'WSDL').
                                                      
        assign Service = pcService
               WSDL = pcWSDL
               ConnectionParams = pcConnectionParams.
    end constructor.
    
    destructor public WebServiceProtocol():
        DisconnectService().
    end destructor.
    
    /** Executes an operation in a port on the WebService. This is a generalised method;
        concrete implementors can execute their operations using this method or using 
        a more specialised call.
        
        @param character The port type
        @param character The operation name
        @param longchar The request SOAP message
        @return longchar The return SOAP message.       */
    method public longchar ExecuteOperation(input pcPortTypeName as character,
                                            input pcOperationName as character,
                                            input pcInputParam as longchar):
        
        define variable cOutputParam as longchar no-undo.
        
        ConnectService().
        
        run value(pcOperationName) in ConnectPortType(pcPortTypeName) (input pcInputParam, output cOutputParam).
        
        return cOutputParam.
        
        catch eError as Error:
            undo, throw new WebServiceInvocationError(eError, pcOperationName, this-object:Service, '').
        end catch.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.
    end method.
    
    /** Connects to the service. */
    method public void ConnectService():
        define variable cConnectString as character no-undo.
        
        if not this-object:Connected then
        do:
            cConnectString = substitute('-S &1 -WSDL &2 &3',
                                this-object:Service,
                                this-object:WSDL,
                                this-object:ConnectionParams).
            create server WebServiceHandle.
            WebServiceHandle:connect(cConnectString).
        end.
        catch eError as Error:
            delete object WebServiceHandle no-error.
            undo, throw new WebServiceInvocationError(eError, 'ConnectService', this-object:Service, '').
        end catch.        
    end method.
    
    /** Disconnects from the service, if connected. */
    method public void DisconnectService():
        if this-object:Connected then
            WebServiceHandle:disconnect().
        delete object WebServiceHandle no-error.
    end method.
    
    /** Connects to the specified port type.
        
        @param character The port type 
        @return handle The port on which to run the operation.  */
    method protected handle ConnectPortType(input pcPortType as character):
        if not this-object:Connected then
            undo, throw new WebServiceInvocationError(
                    pcPortType,
                    this-object:Service,
                    '  - service not connected').
        
        run value(pcPortType) set PortHandle on server WebServiceHandle.
        
        return PortHandle.
    end method.
    
    /**  Disconnects the currently-connected port type */
    method protected handle DisconnectPortType():
        delete object PortHandle no-error.
    end method.
    
    method static public character XmlTypeFromABL(input pcABLType as longchar):
        define variable cXmlType as character no-undo.
        
        case string(pcABLType):
            when 'datetime' then cXmlType = 'dateTime'.
            when 'logical' then  cXmlType = 'boolean'.
            when 'character' then  cXmlType = 'string'.
            otherwise cXmlType = lc(pcABLType).
        end case.
        
        return cXmlType.
    end method.
    
end class./*------------------------------------------------------------------------
    File        : ABLPrimitive
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Oct 05 15:38:21 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

class OpenEdge.Lang.ABLPrimitive abstract: 
    
end class./** ------------------------------------------------------------------------
    File        : ABLSession
    Purpose     : An extension of the SESSION system handle. 
    Syntax      : 
    Description : ABLSession object : this object lives for the lifespan of 
                  an AVM Session. 
    @author pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : * Store customer properties for a session in the SessionProperties 
                    IMap property
                  * Discover handle- and object- references for given names
                  * Resolves weak references
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.String.
using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.Lang.ABLSession:
    
    /** Information regarding session lifespan. */    
    define public property ActiveSince as datetime-tz no-undo get. private set.
    
    /** A unique identifier for this session. The SESSION:HANDLE tends to be the
        same every time; this gives us the opportunity to identify this session across all time and space */
    define public property Id as character no-undo get. private set.
    
    /** A collection of user-defined properties. These
        can be any key/value set of objects. */
    define public property SessionProperties as IMap no-undo get. private set.

    /** An optional session type identifier. Defaults to SESSION:CLIENT-TYPE, but we have
        need for more complex session identifiers ('Development' or 'ClientRuntime'), which
        are not limited to simple client types. */
    define public property Name as character no-undo
        get():
            /* Simple default to client type */
            if this-object:Name eq '' or this-object:Name  eq ? then
                this-object:Name = session:client-type.
            
            return this-object:Name.
        end get.
        set.
    
    define static public property Instance as ABLSession no-undo  
        get():
            if not valid-object(Instance) then
                Instance = new ABLSession().
            
            return Instance.
        end get.
        private set.
    
    constructor private ABLSession():
        assign this-object:Id = guid(generate-uuid)
               ActiveSince = now
               SessionProperties = new Map().
        
        CacheStartupProperties().               
    end constructor.
    
    method private void CacheStartupProperties():
        /* cache the value of -param on startup */
        SessionProperties:Put(new String('SESSION:PARAM'), new String(session:parameter)). 
        SessionProperties:Put(new String('SESSION:ICFPARAM'), new String(session:parameter)).
    end method.
    
    /** Returns the first running persistent procedure instance found
        for a given name.
        
        @param character The (relative) path name for a procedure.
        @return handle The handle to that procedure, if any. Unknown value if
                       there's no running instance of that name. */
    method public handle GetFirstRunningProc (input pcName as character):
        define variable hProc as handle no-undo.
        
        hProc = session:first-procedure.
        do while valid-handle(hProc) and hProc:file-name ne pcName:
            hProc = hProc:next-sibling. 
        end.
        
        return hProc.
    end method.

    /** Returns all the running persistent procedure instances found
        for a given name.
        
        @param character The (relative) path name for a procedure.
        @return handle An array of handles to that procedure, if any.
                       If there's no running instance of that name, then
                       the array has an extent of 1 (one) which contains the 
                       unknown value.       */ 
    method public handle extent GetAllRunningProcs (input pcName as character):
        define variable hProc as handle extent no-undo.
        define variable hTemp as handle no-undo.
        define variable cProcs as character no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        hTemp = session:first-procedure.
        do while valid-handle(hTemp):         
            if hTemp:file-name eq pcName then
                cProcs = cProcs + ',' + string(hTemp).
            
            hTemp = hTemp:next-sibling. 
        end.
        
        iMax = max((num-entries(cProcs) - 1), 0).
        if iMax eq 0 then
            assign extent(hProc) = 1
                   hProc[1] = ?.
        else        
        do iLoop = 1 to iMax:
            hProc[iLoop] = widget-handle(entry(iLoop, cProcs)).
        end.
        
        return hProc.        
    end method.
    
    /** Resolves a weak reference into an object instance. A weak reference is an integer
        representation of an object reference. This method is analogous to the WIDGET-HANDLE()
        function.
        
        Notes: * Based on http://msdn.microsoft.com/en-us/library/ms404247(v=VS.90).aspx
               * Performance of ResolveWeakReference() will probably suck.
               * An ABL statement "OBJECT-REFERENCE(int)" would entirely replace this method.    
        @param integer A weak reference to an object.
        @return Object The object instance corresponding to that reference. The unknown value/null
                is returned if the referecen cannot be resolved.  */
    method public Object ResolveWeakReference(input piReference as integer):
        define variable oInstance as Object no-undo.
        define variable oReference as Object no-undo.
        
        oInstance = session:first-object.
        do while valid-object(oInstance) and not valid-object(oReference):
            if piReference eq int(oInstance) then
                oReference = oInstance.
            oInstance = oInstance:Next-Sibling.
        end.
        
        return oReference.        
    end method.
    
    /** Returns the first object instance found that is of the type given.
        
        @param character The type name. This can be a class or an interface. 
        @return Object The reference to that type, if any. Unknown value if
                       there's no running instance of that name. */
    method public Object GetFirstClassInstance(input pcName as character):
        define variable oInstance as Object no-undo.
        
        oInstance = session:first-object.
        do while valid-object(oInstance) and oInstance:GetClass():IsA(pcName):
            oInstance = oInstance:next-sibling. 
        end.
        
        return oInstance.
    end method.
    
    /** Returns all the object instances found that are of the type given.
        
        @param character The type name. This can be a class or an interface.
        @return Object The reference to that type, if any. Unknown value if
                       there's no running instance of that name. */
    method public Object extent GetAllInstances(input pcName as character):
        define variable oInstance as Object extent no-undo.
        define variable oTemp as Object no-undo.
        define variable oCollection as ICollection no-undo.
        
        oCollection = new Collection().
        
        oTemp = session:first-object.
        do while valid-object(oTemp):
            if oTemp:GetClass():IsA(pcName) then
                oCollection:Add(oTemp).
            
            oTemp = oTemp:next-sibling. 
        end.
        
        if oCollection:Size gt 0 then        
            oInstance = oCollection:ToArray().
        else
        do:
            extent(oInstance) = 1.
            oInstance[1] = ?.
        end.
        
        return oInstance.
        finally:
            oCollection:Clear().
        end finally.
    end method.
    
end class./*------------------------------------------------------------------------
    File        : AgentConnection
    Purpose     : 
    Syntax      : 
    Description : AgentConnection object : this object lives for the lifespan of 
                  an AppServer connection (stateless AppServer).
    @author pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : * The instance's lifespan is managed by as AppServer connect/disconnect
                    procedures.
                  * Note that this is meaninless for StateFree AppServers.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.AgentConnection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.

class OpenEdge.Lang.AgentConnection:
    /** Information regarding connection lifespan. */    
    define public property ActiveSince as datetime-tz no-undo get. private set.
    
    /** A unique identifier for this connection. */
    define public property Id as character no-undo get. private set.
    
    /* A collection of user-defined properties */
    define public property ConnectionProperties as IMap no-undo get. private set.
    
    define static public property Instance as AgentConnection no-undo
        get():
            if not valid-object(Instance) then
                Instance = new AgentConnection().
            return Instance.
        end get.
        private set.
    
    
    constructor private AgentConnection():
        assign this-object:Id = guid(generate-uuid)
               ConnectionProperties = new Map()
               ActiveSince = now.
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : AgentRequest
    Purpose     : 
    Syntax      : 
    Description : AgentRequest object : this object lives for the lifespan of 
                  an AppServer
    @author pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : * The instance's lifespan is managed by as AppServer activate/deactivate
                    procedures.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.AgentRequest.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.IMap.

class OpenEdge.Lang.AgentRequest:
    define public property ActiveSince as datetime-tz no-undo get. private set.
    
    /* A collection of user-defined properties */
    define public property RequestProperties as IMap no-undo get. private set.
    
    define static public property Instance as AgentRequest no-undo  
        get():
            if not valid-object(Instance) then
                Instance = new AgentRequest().
            return Instance.
        end get.
        private set.
    
    define public property Id as char no-undo get. private set.
    
    constructor private AgentRequest():
        assign this-object:Id = guid(generate-uuid)
               RequestProperties = new Map()
               ActiveSince = now.
    end constructor.

end class./** ------------------------------------------------------------------------
    File        : Assert
    Purpose     : General assertions of truth. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 10:08:57 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.Assert.
using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.
using Progress.Lang.AppError.

class OpenEdge.Lang.Assert:

    method public static void ArgumentNotNull(input poArgument as Object , pcName as char):
        if not valid-object(poArgument) then
            undo, throw new AppError(substitute('&1 cannot be null', pcName)).
    end method.
    
    method public static void ArgumentNotNull(input poArgument as Object extent, pcName as char):
        if extent(poArgument) eq ? then
            undo, throw new AppError(substitute('&1 cannot be null', pcName)).
    end method.

    method public static void ArgumentNotNull(pcArgument as character, pcName as character):
        if pcArgument eq ? then 
            undo, throw new AppError(substitute('&1 cannot be unknown', pcName)).
    end method.
    
    method public static void ArgumentNotNullOrEmpty(pcArgument as character, pcName as character):
        define variable cLongCharArg as longchar no-undo.
        cLongCharArg = pcArgument.
        Assert:ArgumentNotNullOrEmpty(cLongCharArg, pcName).
    end method.
    
    method public static void ArgumentNotNullOrEmpty(pcArgument as longchar, pcName as character):
        if pcArgument eq ? or pcArgument eq '' then 
            undo, throw new AppError(substitute('&1 cannot be unknown or empty', pcName)).
    end method.

    method public static void ArgumentNonZero(piArgument as integer, pcName as character):
        if piArgument eq 0 then
            undo, throw new AppError(substitute('&1 cannot be zero', pcName)).
    end method.

    method public static void ArgumentNonZero(piArgument as int64, pcName as character):
        if piArgument eq 0 then
            undo, throw new AppError(substitute('&1 cannot be zero', pcName)).
    end method.
    
    method public static void ArgumentNonZero(piArgument as integer extent, pcName as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        Assert:ArgumentHasDeterminateExtent(piArgument, pcName).
        iMax = extent(piArgument).
        do iLoop = 1 to iMax:
            Assert:ArgumentNonZero(piArgument[iLoop], substitute('Extent &2 of &1', pcName, iLoop)).
        end.
    end method.

    method public static void ArgumentNonZero(piArgument as int64 extent, pcName as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        Assert:ArgumentHasDeterminateExtent(piArgument, pcName).
        iMax = extent(piArgument).
        do iLoop = 1 to iMax:
            Assert:ArgumentNonZero(piArgument[iLoop], substitute('Extent &2 of &1', pcName, iLoop)).
        end.
    end method.

    method public static void ArgumentNonZero(piArgument as decimal, pcName as character):
        if piArgument eq 0 then
            undo, throw new AppError(substitute('&1 cannot be zero', pcName)).
    end method.
        
    method public static void ArgumentIsInterface(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if not poArgument:IsInterface() then
            undo, throw new AppError(substitute('&1 is an interface', poArgument:TypeName)).
    end method.

    method public static void ArgumentNotInterface(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if poArgument:IsInterface() then
            undo, throw new AppError(substitute('&1 is not an interface', poArgument:TypeName)).
    end method.

    method public static void ArgumentIsAbstract(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if not poArgument:IsAbstract() then
            undo, throw new AppError(substitute('&1 is not an abstract type', poArgument:TypeName)).        
    end method.

    method public static void ArgumentNotAbstract(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if poArgument:IsAbstract() then
            undo, throw new AppError(substitute('&1 is an abstract type', poArgument:TypeName)).        
    end method.
        
    method public static void ArgumentIsFinal(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if not poArgument:IsFinal() then
            undo, throw new AppError(substitute('&1 is not a final type', poArgument:TypeName)).
    end method.
    
    method public static void ArgumentNotFinal(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if poArgument:IsFinal() then
            undo, throw new AppError(substitute('&1 is a final type', poArgument:TypeName)).                        
    end method.
    
    method static public void ArgumentIsValidType(input pcTypeName as character):
        define variable oType as class Class no-undo.
        
        Assert:ArgumentNotNullOrEmpty(pcTypeName, 'TypeName').
        oType = Class:GetClass(pcTypeName) no-error.
        if not valid-object(oType) then
            undo, throw new AppError(substitute('&1 is not a valid type', pcTypeName)).
    end method.

    method public static void ArgumentIsType(input poArgument as Object extent, poType as class Class):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        if extent(poArgument) eq ? then
            undo, throw new AppError('argument cannot be an indeterminiate array').
        
        iMax = extent(poArgument).
        do iLoop = 1 to iMax:
            Assert:ArgumentIsType(poArgument[iLoop], poType).
        end.
    end method.
    
    method public static void ArgumentIsType(input poArgument as Object, poType as class Class):
        define variable oDerivedClass as class Class no-undo.
        
        Assert:ArgumentNotNull(poArgument, 'argument').
        Assert:ArgumentNotNull(poType, 'type').
        
        if type-of(poArgument, Progress.Lang.Class) then 
            oDerivedClass = cast(poArgument, Progress.Lang.Class).
        else
            oDerivedClass = poArgument:GetClass().
        
        if not oDerivedClass:IsA(poType) then
            undo, throw new AppError(
                    substitute('Object &1 (of type &2) is not of type &3',
                        poArgument:ToString(),
                        oDerivedClass:TypeName,
                        poType:TypeName)).
    end method.
    
    method public static void ArgumentNotType(input poArgument as Object, poType as class Class):
        define variable oDerivedClass as class Class no-undo.
        
        Assert:ArgumentNotNull(poArgument, 'argument').
        Assert:ArgumentNotNull(poType, 'type').
        
        if type-of(poArgument, Progress.Lang.Class) then 
            oDerivedClass = cast(poArgument, Progress.Lang.Class).
        else
            oDerivedClass = poArgument:GetClass().
        
        if oDerivedClass:IsA(poType) then
            undo, throw new AppError(
                    substitute('Object &1 (of type &2) is of type &3',
                        poArgument:ToString(),
                        oDerivedClass:TypeName,
                        poType:TypeName)).
    end method.
    
    /** Asserts that a handle is valid.
        
        @param handle The handle being checked.
        @param character The name of the handle/variable being checked. */
    method public static void ArgumentNotNull(input phArgument as handle, input pcName as character):
        if not valid-handle(phArgument) then
            undo, throw new AppError(substitute('&1 cannot be null', pcName)).
    end method.

    /** Asserts that a handle is valid and of a particular datatype
        
        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @param character The name of the variable/handle.   */
    method public static void ArgumentIsType(input phArgument as handle,
                                             input poCheckType as DataTypeEnum,
                                             input pcName as character):
        define variable cCheckType as character no-undo.
        
        Assert:ArgumentNotNull(phArgument, pcName).
        Assert:ArgumentNotNull(poCheckType, 'Check DataType').
        
        cCheckType = poCheckType:ToString().
        if phArgument:type ne cCheckType then
            undo, throw new AppError(substitute('&1 is not of type &2', pcName, cCheckType)).        
    end method.

    /** Asserts that a handle is valid and not of a particular datatype
        
        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @param character The name of the variable/handle.   */
    method public static void ArgumentNotType(input phArgument as handle,
                                             input poCheckType as DataTypeEnum,
                                             input pcName as character):
        define variable cCheckType as character no-undo.
        
        Assert:ArgumentNotNull(phArgument, pcName).
        Assert:ArgumentNotNull(poCheckType, 'Check DataType').
        
        cCheckType = poCheckType:ToString().
        if phArgument:type eq cCheckType then
            undo, throw new AppError(substitute('&1 cannot be of type &2', pcName, cCheckType)).        
    end method.
        
    method public static void ArgumentHasDeterminateExtent(input pcArgument as character extent,
                                                           input pcName as character):
        if extent(pcArgument) eq ? then
            undo, throw new AppError(substitute('&1 array cannot be indeterminate', pcName)).                                                               
    end method.
    
    method public static void ArgumentIsIndeterminateArray(input pcArgument as character extent,
                                                           input pcName as character):
        if extent(pcArgument) ne ? then
            undo, throw new AppError(substitute('&1 array must be indeterminate', pcName)).                                                               
    end method.
    
    method public static void ArgumentHasDeterminateExtent(input piArgument as integer extent,
                                                           input pcName as character):
        if extent(piArgument) eq ? then
            undo, throw new AppError(substitute('&1 array cannot be indeterminate', pcName)).
    end method.

    method public static void ArgumentIsIndeterminateArray(input piArgument as integer extent,
                                                           input pcName as character):
        if extent(piArgument) ne ? then
            undo, throw new AppError(substitute('&1 array must be indeterminate', pcName)).
    end method.

    method public static void ArgumentHasDeterminateExtent(input piArgument as int64 extent,
                                                           input pcName as character):
        if extent(piArgument) eq ? then
            undo, throw new AppError(substitute('&1 array cannot be indeterminate', pcName)).
    end method.

    method public static void ArgumentIsIndeterminateArray(input piArgument as int64 extent,
                                                           input pcName as character):
        if extent(piArgument) ne ? then
            undo, throw new AppError(substitute('&1 array must be indeterminate', pcName)).
    end method.

    method public static void ArgumentIsAvailable(input phArgument as handle,
                                                  input pcName as character):
        Assert:ArgumentNotNull(phArgument, pcName).
        
        if not phArgument:available then
            undo, throw new AppError(substitute('record in buffer &1 is not available', pcName)).                                                               
    end method.

    method public static void ArgumentIsInt(input pcArgument as character,
                                            input pcName as character):
        define variable iCheckVal as integer no-undo.
        
        iCheckVal = int(pcArgument) no-error.
        if error-status:error then
            undo, throw new AppError(substitute('&1 is an integer value', pcName)).                                                               
    end method.
    
    
end class./** ------------------------------------------------------------------------
    File        : BufferJoinModeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Feb 25 09:47:34 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BufferJoinModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.BufferJoinModeEnum final inherits EnumMember:
     
    define public static property Default as BufferJoinModeEnum no-undo get. private set.
    define public static property Inner as BufferJoinModeEnum no-undo get. private set.
    define public static property Outer as BufferJoinModeEnum no-undo get. private set.
    define public static property LeftOuter as BufferJoinModeEnum no-undo get. private set.
    
    constructor static BufferJoinModeEnum():
        BufferJoinModeEnum:Inner = new BufferJoinModeEnum('').
        BufferJoinModeEnum:Outer  = new BufferJoinModeEnum('outer-join').
        BufferJoinModeEnum:LeftOuter = new BufferJoinModeEnum('left outer-join').
        
        BufferJoinModeEnum:Default  = BufferJoinModeEnum:Inner.
    end constructor.

    constructor public BufferJoinModeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.

    method static public BufferJoinModeEnum EnumFromString (input pcName as character):
        define variable oEnum as BufferJoinModeEnum no-undo.
        
        case pcName:
            when BufferJoinModeEnum:Inner:ToString() then oEnum = BufferJoinModeEnum:Inner.
            when BufferJoinModeEnum:Outer:ToString() then oEnum = BufferJoinModeEnum:Outer.
            when BufferJoinModeEnum:LeftOuter:ToString() then oEnum = BufferJoinModeEnum:LeftOuter.
        end case.
        
        return oEnum.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : ByteOrderEnum
    Purpose     : Enumeration of byte-order 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 21 09:40:59 EST 2009
    Notes       : * Taken from ABL documentation
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.ByteOrderEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.ByteOrderEnum final inherits EnumMember:

    define public static property Default       as ByteOrderEnum no-undo get. private set.
    define public static property HostByteOrder as ByteOrderEnum no-undo get. private set.
    define public static property BigEndian     as ByteOrderEnum no-undo get. private set.
    define public static property LittleEndian  as ByteOrderEnum no-undo get. private set.
    
    constructor static ByteOrderEnum():
        ByteOrderEnum:HostByteOrder = new ByteOrderEnum(host-byte-order, 'host-byte-order').
        ByteOrderEnum:BigEndian = new ByteOrderEnum(big-endian, 'big-endian').
        ByteOrderEnum:LittleEndian = new ByteOrderEnum(little-endian, 'little-endian').
        
        ByteOrderEnum:Default = ByteOrderEnum:HostByteOrder.
    end constructor.
        
    constructor public ByteOrderEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    method static public ByteOrderEnum EnumFromString(pcByteOrder as char):
        define variable oMember as ByteOrderEnum no-undo.
        
        case pcByteOrder:
            when ByteOrderEnum:HostByteOrder:ToString() then oMember = ByteOrderEnum:HostByteOrder.
            when ByteOrderEnum:BigEndian:ToString() then oMember = ByteOrderEnum:BigEndian.
            when ByteOrderEnum:LittleEndian:ToString() then oMember = ByteOrderEnum:LittleEndian.
        end case.
        
        return oMember.        
    end method.
    
    method static public ByteOrderEnum EnumFromValue(piByteOrder as integer):
        define variable oMember as ByteOrderEnum no-undo.
        
        case piByteOrder:
            when ByteOrderEnum:HostByteOrder:Value then oMember = ByteOrderEnum:HostByteOrder.
            when ByteOrderEnum:BigEndian:Value then oMember = ByteOrderEnum:BigEndian.
            when ByteOrderEnum:LittleEndian:Value then oMember = ByteOrderEnum:LittleEndian.
        end case.
        
        return oMember.
    end method.

end class./** ------------------------------------------------------------------------
    File        : CallbackNameEnum
    Purpose     : Enumeration of ABL callback types, including ProDataSets,
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 07 13:48:05 EDT 2009
    Notes       : * Taken from ABL documentation
  ----------------------------------------------------------------------*/
routine-level on error undo , throw.

using OpenEdge.Lang.CallbackNameEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.CallbackNameEnum final inherits EnumMember:
    
    /* Web Services */
    define public static property RequestHeader  as CallbackNameEnum no-undo get. private set.
    define public static property ResponseHeader as CallbackNameEnum no-undo get. private set.
    
    /* ProDataSet, Buffer */
    define public static property BeforeFill     as CallbackNameEnum no-undo get. private set.
    define public static property AfterFill      as CallbackNameEnum no-undo get. private set.
    
    /* Buffer */
    define public static property BeforeRowFill  as CallbackNameEnum no-undo get. private set.
    define public static property AfterRowFill   as CallbackNameEnum no-undo get. private set.
    define public static property RowCreate      as CallbackNameEnum no-undo get. private set.
    define public static property RowDelete      as CallbackNameEnum no-undo get. private set.
    define public static property RowUpdate      as CallbackNameEnum no-undo get. private set.
    define public static property FindFailed     as CallbackNameEnum no-undo get. private set.
    define public static property Syncronize     as CallbackNameEnum no-undo get. private set.

    /* Query */
    define public static property OffEnd         as CallbackNameEnum no-undo get. private set.
    
    constructor static CallbackNameEnum():
        CallbackNameEnum:RequestHeader = new CallbackNameEnum('request-header').
        CallbackNameEnum:ResponseHeader = new CallbackNameEnum('response-header').
        CallbackNameEnum:BeforeFill = new CallbackNameEnum('before-fill').
        CallbackNameEnum:AfterFill = new CallbackNameEnum('after-fill').
        CallbackNameEnum:BeforeRowFill = new CallbackNameEnum('before-row-fill').
        CallbackNameEnum:AfterRowFill = new CallbackNameEnum('after-row-fill').
        CallbackNameEnum:RowCreate = new CallbackNameEnum('row-create').
        CallbackNameEnum:RowDelete = new CallbackNameEnum('row-delete').
        CallbackNameEnum:RowUpdate = new CallbackNameEnum('row-update').
        CallbackNameEnum:FindFailed = new CallbackNameEnum('find-failed').
        CallbackNameEnum:Syncronize = new CallbackNameEnum('syncronize').
        CallbackNameEnum:OffEnd = new CallbackNameEnum('OFF-END').            
    end constructor.

    constructor public CallbackNameEnum( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : CompareStrengthEnum
    Purpose     : Enumeration of strengths for the COMPARE statement 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 13:57:05 EDT 2009
    Notes       : * Taken from ABL documentation
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.CompareStrengthEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.CompareStrengthEnum final inherits EnumMember: 

    define public static property Raw               as CompareStrengthEnum no-undo get. private set.
    define public static property CaseSensitive     as CompareStrengthEnum no-undo get. private set.
    define public static property CaseInsensitive   as CompareStrengthEnum no-undo get. private set.
    define public static property Caps              as CompareStrengthEnum no-undo get. private set.
    define public static property Primary           as CompareStrengthEnum no-undo get. private set.
    define public static property Secondary         as CompareStrengthEnum no-undo get. private set.
    define public static property Tertiary          as CompareStrengthEnum no-undo get. private set.
    define public static property Quaternary        as CompareStrengthEnum no-undo get. private set.
    
    constructor static CompareStrengthEnum():
        CompareStrengthEnum:Raw = new CompareStrengthEnum(1, 'RAW').
        CompareStrengthEnum:CaseSensitive = new CompareStrengthEnum(2, 'CASE-SENSITIVE').
        CompareStrengthEnum:CaseInsensitive = new CompareStrengthEnum(3, 'CASE-INSENSITIVE').
        CompareStrengthEnum:Caps = new CompareStrengthEnum(4, 'CAPS').
        CompareStrengthEnum:Primary = new CompareStrengthEnum(5, 'PRIMARY').
        CompareStrengthEnum:Secondary = new CompareStrengthEnum(6, 'SECONDARY').
        CompareStrengthEnum:Tertiary = new CompareStrengthEnum(7, 'TERTIARY').
        CompareStrengthEnum:Quaternary = new CompareStrengthEnum(8, 'QUATERNARY').
    end constructor.

    constructor public CompareStrengthEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
end class.
/** ------------------------------------------------------------------------
    File        : DataTypeEnum
    Purpose     : Enumeration of ABL datatypes
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 16 13:44:09 EDT 2009
    Notes       : * EnumMember numeric values taken from ADE
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.
  
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.DataTypeEnum final inherits EnumMember:
    
    define public static property Default            as DataTypeEnum no-undo get. private set.
    define public static property None               as DataTypeEnum no-undo get. private set.
    
    /* ABL Primitives */
    define public static property Character          as DataTypeEnum no-undo get. private set.
    define public static property CharacterArray     as DataTypeEnum no-undo get. private set.
    define public static property LongChar           as DataTypeEnum no-undo get. private set.
    define public static property LongCharArray      as DataTypeEnum no-undo get. private set.
    define public static property Integer            as DataTypeEnum no-undo get. private set.
    define public static property IntegerArray       as DataTypeEnum no-undo get. private set.
    define public static property Int64              as DataTypeEnum no-undo get. private set.
    define public static property Int64Array         as DataTypeEnum no-undo get. private set.
    define public static property Decimal            as DataTypeEnum no-undo get. private set.
    define public static property DecimalArray       as DataTypeEnum no-undo get. private set.
    define public static property Logical            as DataTypeEnum no-undo get. private set.
    define public static property LogicalArray       as DataTypeEnum no-undo get. private set.
    define public static property Rowid              as DataTypeEnum no-undo get. private set.
    define public static property RowidArray         as DataTypeEnum no-undo get. private set.
    define public static property Recid              as DataTypeEnum no-undo get. private set.
    define public static property RecidArray         as DataTypeEnum no-undo get. private set.
    define public static property Date               as DataTypeEnum no-undo get. private set.
    define public static property DateArray          as DataTypeEnum no-undo get. private set.
    define public static property Datetime           as DataTypeEnum no-undo get. private set.
    define public static property DatetimeArray      as DataTypeEnum no-undo get. private set.
    define public static property DatetimeTZ         as DataTypeEnum no-undo get. private set.
    define public static property DatetimeTZArray    as DataTypeEnum no-undo get. private set.
    define public static property Raw                as DataTypeEnum no-undo get. private set.
    define public static property RawArray           as DataTypeEnum no-undo get. private set.
    define public static property Memptr             as DataTypeEnum no-undo get. private set.
    define public static property MemptrArray        as DataTypeEnum no-undo get. private set.
    define public static property Handle             as DataTypeEnum no-undo get. private set.
    define public static property HandleArray        as DataTypeEnum no-undo get. private set.
    define public static property BLOB               as DataTypeEnum no-undo get. private set.
    define public static property CLOB               as DataTypeEnum no-undo get. private set.
    define public static property ComHandle          as DataTypeEnum no-undo get. private set.
    define public static property ComHandleArray     as DataTypeEnum no-undo get. private set.
    
    /* Data structures */
    define public static property Dataset            as DataTypeEnum no-undo get. private set.
    define public static property Buffer             as DataTypeEnum no-undo get. private set.
    define public static property TempTable          as DataTypeEnum no-undo get. private set.
    
    /* User-defined types */
    define public static property ProgressLangObject as DataTypeEnum no-undo get. private set.
    define public static property Enumeration        as DataTypeEnum no-undo get. private set.
    define public static property Class              as DataTypeEnum no-undo get. private set.
    define public static property ClassArray         as DataTypeEnum no-undo get. private set.

    /* Streams */
    define public static property Stream as DataTypeEnum no-undo get. private set.
    
    /* XML */
    define public static property XmlDocument as DataTypeEnum no-undo get. private set.
    define public static property XmlNodeRef as DataTypeEnum no-undo get. private set.
    
    constructor static DataTypeEnum():
        DataTypeEnum:None = new DataTypeEnum(01, '').
        DataTypeEnum:Character = new DataTypeEnum(02, 'Character').
        DataTypeEnum:CharacterArray = new DataTypeEnum(03, 'Character Extent').
        DataTypeEnum:LongChar = new DataTypeEnum(04, 'Longchar').
        DataTypeEnum:LongCharArray = new DataTypeEnum(05, 'Longchar Extent').
        DataTypeEnum:Integer = new DataTypeEnum(06, 'Integer').
        DataTypeEnum:IntegerArray = new DataTypeEnum(07, 'Integer Extent').
        DataTypeEnum:Int64 = new DataTypeEnum(08, 'Int64').
        DataTypeEnum:Int64Array = new DataTypeEnum(09, 'Int64 Extent').
        DataTypeEnum:Decimal = new DataTypeEnum(10, 'Decimal').
        DataTypeEnum:DecimalArray = new DataTypeEnum(11, 'Decimal Extent').
        DataTypeEnum:Logical = new DataTypeEnum(12, 'Logical').
        DataTypeEnum:LogicalArray = new DataTypeEnum(13, 'Logical Extent').
        DataTypeEnum:Rowid = new DataTypeEnum(14, 'Rowid').
        DataTypeEnum:RowidArray = new DataTypeEnum(15, 'Rowid Extent').
        DataTypeEnum:Recid = new DataTypeEnum(16, 'Recid').
        DataTypeEnum:RecidArray = new DataTypeEnum(17, 'Recid Extent').
        DataTypeEnum:Date = new DataTypeEnum(18, 'Date').
        DataTypeEnum:DateArray = new DataTypeEnum(19, 'Date Extent').
        DataTypeEnum:Datetime = new DataTypeEnum(20, 'Datetime').
        DataTypeEnum:DatetimeArray = new DataTypeEnum(21, 'Datetime Extent').
        DataTypeEnum:DatetimeTZ = new DataTypeEnum(22, 'Datetime-TZ').
        DataTypeEnum:DatetimeTZArray = new DataTypeEnum(23, 'Datetime-TZ Extent').
        DataTypeEnum:Raw = new DataTypeEnum(24, 'Raw').
        DataTypeEnum:RawArray = new DataTypeEnum(25, 'Raw Extent').
        DataTypeEnum:Memptr = new DataTypeEnum(26, 'Memptr').
        DataTypeEnum:MemptrArray = new DataTypeEnum(27, 'Memptr Extent').
        DataTypeEnum:Handle = new DataTypeEnum(28, 'Handle').
        DataTypeEnum:HandleArray = new DataTypeEnum(29, 'Handle Extent').
        DataTypeEnum:Class = new DataTypeEnum(30, 'Class &1').
        DataTypeEnum:ClassArray = new DataTypeEnum(31, 'Class &1 Extent').
        DataTypeEnum:ProgressLangObject = new DataTypeEnum(32, 'Progress.Lang.Object').
        DataTypeEnum:BLOB = new DataTypeEnum(33, 'BLOB').
        DataTypeEnum:CLOB = new DataTypeEnum(34, 'CLOB').
        DataTypeEnum:ComHandle = new DataTypeEnum(35, 'Com-Handle').
        DataTypeEnum:ComHandleArray = new DataTypeEnum(36, 'Com-Handle Extent').
        DataTypeEnum:Dataset = new DataTypeEnum(37, 'Dataset').
        DataTypeEnum:Buffer = new DataTypeEnum(38, 'Buffer').
        DataTypeEnum:TempTable = new DataTypeEnum(39, 'Temp-Table').
        
        DataTypeEnum:Enumeration = new DataTypeEnum(40, 'Enumeration').
        DataTypeEnum:Stream = new DataTypeEnum(41, 'Stream').
        
        DataTypeEnum:XmlNodeRef = new DataTypeEnum(42, 'x-noderef').
        DataTypeEnum:XmlDocument = new DataTypeEnum(43, 'x-document').
        
        DataTypeEnum:Default = DataTypeEnum:Character.
    end constructor.

    constructor public DataTypeEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    method static public DataTypeEnum EnumFromValue(piDataType as integer):
        define variable oMember as DataTypeEnum no-undo.
        
        case piDataType:
            when DataTypeEnum:None:Value               then oMember = DataTypeEnum:None.
            when DataTypeEnum:Character:Value          then oMember = DataTypeEnum:Character.
            when DataTypeEnum:CharacterArray:Value     then oMember = DataTypeEnum:CharacterArray.
            when DataTypeEnum:Longchar:Value           then oMember = DataTypeEnum:LongChar.
            when DataTypeEnum:LongcharArray:Value      then oMember = DataTypeEnum:LongCharArray.
            when DataTypeEnum:Integer:Value            then oMember = DataTypeEnum:Integer.
            when DataTypeEnum:IntegerArray:Value       then oMember = DataTypeEnum:IntegerArray.
            when DataTypeEnum:Int64:Value              then oMember = DataTypeEnum:Int64.
            when DataTypeEnum:Int64Array:Value         then oMember = DataTypeEnum:Int64Array.
            when DataTypeEnum:Decimal:Value            then oMember = DataTypeEnum:Decimal.
            when DataTypeEnum:DecimalArray:Value       then oMember = DataTypeEnum:DecimalArray.
            when DataTypeEnum:Logical:Value            then oMember = DataTypeEnum:Logical.
            when DataTypeEnum:LogicalArray:Value       then oMember = DataTypeEnum:LogicalArray.
            when DataTypeEnum:Rowid:Value              then oMember = DataTypeEnum:Rowid.
            when DataTypeEnum:RowidArray:Value         then oMember = DataTypeEnum:RowidArray.
            when DataTypeEnum:Recid:Value              then oMember = DataTypeEnum:Recid.
            when DataTypeEnum:RecidArray:Value         then oMember = DataTypeEnum:RecidArray.
            when DataTypeEnum:Date:Value               then oMember = DataTypeEnum:Date.
            when DataTypeEnum:DateArray:Value          then oMember = DataTypeEnum:DateArray.
            when DataTypeEnum:Datetime:Value           then oMember = DataTypeEnum:Datetime.
            when DataTypeEnum:DatetimeArray:Value      then oMember = DataTypeEnum:DatetimeArray.
            when DataTypeEnum:DatetimeTZ:Value         then oMember = DataTypeEnum:DatetimeTZ.
            when DataTypeEnum:DatetimeTZArray:Value    then oMember = DataTypeEnum:DatetimeTZArray.
            when DataTypeEnum:Raw:Value                then oMember = DataTypeEnum:Raw.
            when DataTypeEnum:RawArray:Value           then oMember = DataTypeEnum:RawArray.
            when DataTypeEnum:Memptr:Value             then oMember = DataTypeEnum:Memptr.
            when DataTypeEnum:MemptrArray:Value        then oMember = DataTypeEnum:MemptrArray.
            when DataTypeEnum:Handle:Value             then oMember = DataTypeEnum:Handle.
            when DataTypeEnum:HandleArray:Value        then oMember = DataTypeEnum:HandleArray.
            when DataTypeEnum:Class:Value              then oMember = DataTypeEnum:Class.
            when DataTypeEnum:ClassArray:Value         then oMember = DataTypeEnum:ClassArray.
            when DataTypeEnum:ProgressLangObject:Value then oMember = DataTypeEnum:ProgressLangObject.
            when DataTypeEnum:BLOB:Value               then oMember = DataTypeEnum:BLOB.
            when DataTypeEnum:CLOB:Value               then oMember = DataTypeEnum:CLOB.
            when DataTypeEnum:ComHandle:Value          then oMember = DataTypeEnum:ComHandle.
            when DataTypeEnum:ComHandleArray:Value     then oMember = DataTypeEnum:ComHandleArray.
            when DataTypeEnum:Dataset:Value            then oMember = DataTypeEnum:Dataset.
            when DataTypeEnum:Buffer:Value             then oMember = DataTypeEnum:Buffer.
            when DataTypeEnum:TempTable:Value          then oMember = DataTypeEnum:TempTable.
            when DataTypeEnum:Enumeration:Value        then oMember = DataTypeEnum:Enumeration.
            when DataTypeEnum:Stream:Value             then oMember = DataTypeEnum:Stream.
            when DataTypeEnum:XmlDocument:Value        then oMember = DataTypeEnum:XmlDocument.
            when DataTypeEnum:XmlNodeRef:Value         then oMember = DataTypeEnum:XmlNodeRef.
        end case.
        
        return oMember.        
    end method.
    
    method static public DataTypeEnum EnumFromString(pcDataType as character):
        define variable oMember as DataTypeEnum no-undo.
        
        case pcDataType:
            when DataTypeEnum:None:ToString()               then oMember = DataTypeEnum:None.
            when DataTypeEnum:Character:ToString()          then oMember = DataTypeEnum:Character.
            when DataTypeEnum:CharacterArray:ToString()     then oMember = DataTypeEnum:CharacterArray.
            when DataTypeEnum:Longchar:ToString()           then oMember = DataTypeEnum:LongChar.
            when DataTypeEnum:LongcharArray:ToString()      then oMember = DataTypeEnum:LongCharArray.
            when DataTypeEnum:Integer:ToString()            then oMember = DataTypeEnum:Integer.
            when DataTypeEnum:IntegerArray:ToString()       then oMember = DataTypeEnum:IntegerArray.
            when DataTypeEnum:Int64:ToString()              then oMember = DataTypeEnum:Int64.
            when DataTypeEnum:Int64Array:ToString()         then oMember = DataTypeEnum:Int64Array.
            when DataTypeEnum:Decimal:ToString()            then oMember = DataTypeEnum:Decimal.
            when DataTypeEnum:DecimalArray:ToString()       then oMember = DataTypeEnum:DecimalArray.
            when DataTypeEnum:Logical:ToString()            then oMember = DataTypeEnum:Logical.
            when DataTypeEnum:LogicalArray:ToString()       then oMember = DataTypeEnum:LogicalArray.
            when DataTypeEnum:Rowid:ToString()              then oMember = DataTypeEnum:Rowid.
            when DataTypeEnum:RowidArray:ToString()         then oMember = DataTypeEnum:RowidArray.
            when DataTypeEnum:Recid:ToString()              then oMember = DataTypeEnum:Recid.
            when DataTypeEnum:RecidArray:ToString()         then oMember = DataTypeEnum:RecidArray.
            when DataTypeEnum:Date:ToString()               then oMember = DataTypeEnum:Date.
            when DataTypeEnum:DateArray:ToString()          then oMember = DataTypeEnum:DateArray.
            when DataTypeEnum:Datetime:ToString()           then oMember = DataTypeEnum:Datetime.
            when DataTypeEnum:DatetimeArray:ToString()      then oMember = DataTypeEnum:DatetimeArray.
            when DataTypeEnum:DatetimeTZ:ToString()         then oMember = DataTypeEnum:DatetimeTZ.
            when DataTypeEnum:DatetimeTZArray:ToString()    then oMember = DataTypeEnum:DatetimeTZArray.
            when DataTypeEnum:Raw:ToString()                then oMember = DataTypeEnum:Raw.
            when DataTypeEnum:RawArray:ToString()           then oMember = DataTypeEnum:RawArray.
            when DataTypeEnum:Memptr:ToString()             then oMember = DataTypeEnum:Memptr.
            when DataTypeEnum:MemptrArray:ToString()        then oMember = DataTypeEnum:MemptrArray.
            when DataTypeEnum:Handle:ToString()             then oMember = DataTypeEnum:Handle.
            when DataTypeEnum:HandleArray:ToString()        then oMember = DataTypeEnum:HandleArray.
            when DataTypeEnum:Class:ToString()              then oMember = DataTypeEnum:Class.
            when DataTypeEnum:ClassArray:ToString()         then oMember = DataTypeEnum:ClassArray.
            when DataTypeEnum:ProgressLangObject:ToString() then oMember = DataTypeEnum:ProgressLangObject.
            when DataTypeEnum:BLOB:ToString()               then oMember = DataTypeEnum:BLOB.
            when DataTypeEnum:CLOB:ToString()               then oMember = DataTypeEnum:CLOB.
            when DataTypeEnum:ComHandle:ToString()          then oMember = DataTypeEnum:ComHandle.
            when DataTypeEnum:ComHandleArray:ToString()     then oMember = DataTypeEnum:ComHandleArray.
            when DataTypeEnum:Dataset:ToString()            then oMember = DataTypeEnum:Dataset.
            when DataTypeEnum:Buffer:ToString()             then oMember = DataTypeEnum:Buffer.
            when DataTypeEnum:TempTable:ToString()          then oMember = DataTypeEnum:TempTable.
            when DataTypeEnum:Enumeration:ToString()        then oMember = DataTypeEnum:Enumeration.
            when DataTypeEnum:Stream:ToString()             then oMember = DataTypeEnum:Stream.
            when DataTypeEnum:XmlDocument:ToString()        then oMember = DataTypeEnum:XmlDocument.
            when DataTypeEnum:XmlNodeRef:ToString()         then oMember = DataTypeEnum:XmlNodeRef.
        end case.
                
        return oMember.   
    end method.

    method static public logical IsPrimitive(poDataType as DataTypeEnum):
        define variable lPrimitive as logical no-undo.
        
        case poDataType:
            when DataTypeEnum:Class or
            when DataTypeEnum:ClassArray or
            when DataTypeEnum:ProgressLangObject or
            when DataTypeEnum:Enumeration or
            when DataTypeEnum:None then 
                lPrimitive = false.
            otherwise
                lPrimitive = true.
        end case.
        
        return lPrimitive.
    end method.
    
    method static public logical IsArray(input poDataType as DataTypeEnum):
        return (entry(num-entries(poDataType:Name, ' '), poDataType:Name, ' ') eq 'extent').
    end method.
    
    /** Mapping from ABL data type to XML Schema supported data types. Taken from 
        the Working With XML book from the documentation set.
        
        Note that the converse is not supported, since there are multiple ABL types
        that map to a single XML schema type.
        
        @param DataTypeEnum The ABL data type
        @return character The XML data type. */
    method static public character ToXmlSchemaType(input poDataType as DataTypeEnum):
        define variable cXmlSchemaType as character no-undo.
        
        case poDataType:
            when DataTypeEnum:BLOB then cXmlSchemaType = 'base64Binary'.
            when DataTypeEnum:Character then cXmlSchemaType = 'string'.
            when DataTypeEnum:CLOB then cXmlSchemaType = 'string'.
            when DataTypeEnum:ComHandle then cXmlSchemaType = 'long'.
            when DataTypeEnum:Date then cXmlSchemaType = 'date'.
            when DataTypeEnum:DateTime then cXmlSchemaType = 'dateTime'.
            when DataTypeEnum:DatetimeTZ then cXmlSchemaType = 'dateTime'.
            when DataTypeEnum:Decimal then cXmlSchemaType = 'decimal'.
            when DataTypeEnum:Int64 then cXmlSchemaType = 'long'.
            when DataTypeEnum:Integer then cXmlSchemaType = 'int'.
            when DataTypeEnum:Logical then cXmlSchemaType = 'boolean'.
            when DataTypeEnum:Raw then cXmlSchemaType = 'base64Binary'.
            when DataTypeEnum:Recid then cXmlSchemaType = 'long'.
            when DataTypeEnum:Rowid then cXmlSchemaType = 'base64Binary'.
            when DataTypeEnum:Handle then cXmlSchemaType = 'long'.
            /*@todo(task="question", action="decent default?").*/
            otherwise cXmlSchemaType = poDataType:ToString().
        end case.
        
        return cXmlSchemaType.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : DateTimeAddIntervalEnum
    Purpose     : Enumeration of intervals for DATETIME and -TZ operations
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 11 11:35:55 EST 2010
    Notes       : * Taken fromA BL documentation
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.DateTimeAddIntervalEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.DateTimeAddIntervalEnum final inherits EnumMember: 

    define static public property Default as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Years as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Months as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Weeks as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Days as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Hours as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Minutes as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Seconds as DateTimeAddIntervalEnum no-undo get. private set.
    define static public property Milliseconds as DateTimeAddIntervalEnum no-undo get. private set.
    
    constructor static DateTimeAddIntervalEnum():        
        assign DateTimeAddIntervalEnum:Years = new DateTimeAddIntervalEnum('Years')
               DateTimeAddIntervalEnum:Months = new DateTimeAddIntervalEnum('Months')
               DateTimeAddIntervalEnum:Weeks = new DateTimeAddIntervalEnum('Weeks')
               DateTimeAddIntervalEnum:Days = new DateTimeAddIntervalEnum('Days')
               DateTimeAddIntervalEnum:Hours = new DateTimeAddIntervalEnum('Hours')
               DateTimeAddIntervalEnum:Minutes = new DateTimeAddIntervalEnum('Minutes')
               DateTimeAddIntervalEnum:Seconds = new DateTimeAddIntervalEnum('Seconds')
               DateTimeAddIntervalEnum:Milliseconds = new DateTimeAddIntervalEnum('Milliseconds')
               
               DateTimeAddIntervalEnum:Default = DateTimeAddIntervalEnum:Milliseconds
               .
    end constructor.
    
    constructor public DateTimeAddIntervalEnum(pcName as character):
        super(pcName).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : EnumMember
    Purpose     : Abstract class for Enumerations' members.  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jan 21 10:07:10 EST 2010
    Notes       : * We could add a temp-table to manage the EnumMembers' values
                    etc. That's not done right now because there's no pressing 
                    need for it.
                 * Value takes precedence over name, when both are specified.
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Lang.EnumMember abstract:
    
    define public property Name as character no-undo get. private set.
    define public property Value as integer no-undo get. private set.
    
    constructor public EnumMember(input piValue as integer, input pcName as character):        
        assign this-object:Name = pcName
               this-object:Value = piValue.
    end constructor.

    constructor public EnumMember(input piValue as integer):
        this-object(piValue, ?).
    end constructor.

    constructor public EnumMember(input pcName as character):        
        this-object(?, pcName).
    end constructor.

    method public logical Equals(input pcName as character):
        define variable lEquals as logical no-undo.
        
        lEquals = this-object:Name eq pcName. 
        
        return lEquals.
    end method.
    
    method public override logical Equals(poEnumMember as Object):
        define variable lEquals as logical no-undo.

        lEquals = super:Equals(poEnumMember).
        
        /* ABL deals with unknown values just fine */
        if not lEquals then
            lEquals = type-of(poEnumMember, EnumMember) and 
                      this-Object:ToString() eq  cast(poEnumMember, EnumMember):ToString().

        return lEquals.
    end method.

    method public override character ToString():
        define variable cName as character no-undo.
        
        if this-object:Name ne ? then
            cName = substitute('&1', this-object:Name).
        else
        if this-object:Value eq ? then
            cName = substitute('&1_Value_&2', this-object:GetClass():TypeName, this-object:Value).
        else
            cName = substitute('&1_&2', this-object:GetClass():TypeName, this-object).
        
        return cName.
    end method.
    
end class. /** ------------------------------------------------------------------------
    File        : FillModeEnum
    Purpose     : Enumeration of ProDataSet fill modes 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 12 15:07:13 EDT 2009
    Notes       : * Based on the ABL documentation 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.FillModeEnum final inherits EnumMember:
    
    define public static property Default as FillModeEnum no-undo get. private set.
    define public static property Append  as FillModeEnum no-undo get. private set.
    define public static property Empty   as FillModeEnum no-undo get. private set.
    define public static property Merge   as FillModeEnum no-undo get. private set.
    define public static property NoFill  as FillModeEnum no-undo get. private set.
    define public static property Replace as FillModeEnum no-undo get. private set.
    
    constructor static FillModeEnum():
        FillModeEnum:Append = new FillModeEnum('Append').
        FillModeEnum:Empty = new FillModeEnum('Empty').
        FillModeEnum:Merge = new FillModeEnum('Merge').
        FillModeEnum:NoFill = new FillModeEnum('No-Fill').
        FillModeEnum:Replace = new FillModeEnum('Replace').
        
        FillModeEnum:Default = FillModeEnum:Merge.
    end constructor.
    
    constructor public FillModeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public FillModeEnum StringToEnum(input pcName as character):
        define variable oEnum as FillModeEnum no-undo.
        
        case pcName:
            when FillModeEnum:Append:Name then oEnum = FillModeEnum:Append.
            when FillModeEnum:Empty:Name then oEnum = FillModeEnum:Empty.
            when FillModeEnum:Merge:Name then oEnum = FillModeEnum:Merge.
            when FillModeEnum:NoFill:Name then oEnum = FillModeEnum:NoFill.
            when FillModeEnum:Replace:Name then oEnum = FillModeEnum:Replace.  
        end case.
        
        return oEnum.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : FindTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.FindTypeEnum. 
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.FindTypeEnum final inherits EnumMember: 
    
    define public static property First    as FindTypeEnum no-undo get. private set.
    define public static property Next     as FindTypeEnum no-undo get. private set.
    define public static property Prev     as FindTypeEnum no-undo get. private set.
    define public static property Last     as FindTypeEnum no-undo get. private set.    
    define public static property Unique   as FindTypeEnum no-undo get. private set.
    
    constructor static FindTypeEnum():
         FindTypeEnum:First  = new FindTypeEnum('first').
         FindTypeEnum:Next   = new FindTypeEnum('next').
         FindTypeEnum:Prev   = new FindTypeEnum('prev').
         FindTypeEnum:Last   = new FindTypeEnum('last').
         FindTypeEnum:Unique = new FindTypeEnum('unique').        
    end constructor.
        
    constructor public FindTypeEnum (input pcName as character ):
        super (input pcName).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : FlagsEnum
    Purpose     : Parent class for flags enumerations: enumerations that contain
                  values that can be 'stacked' or stored together in one
                  property/variable.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri May 15 15:41:08 EDT 2009
    Notes       : * These kinds of enumerations allow us to store multiple values
                    in a single value. OpenEdge.PresentationLayer.Common.ActionStateEnum 
                    contains an example of their use.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.EnumMember.
using Progress.Lang.AppError.

class OpenEdge.Lang.FlagsEnum abstract inherits EnumMember:
    /** Determines whether a variable or member contains the particular specified
        flag enumeration value.
        
        @param piValueSum Contains the value that is being checked to determine whether
        it contains a particular flag.
        @param poCheckEnum The flag being checked for inclusion.
        @return Whether the value includes the specified member     */
    method static public logical IsA (piValueSum as int, poCheckEnum as EnumMember):
        define variable iPos as integer no-undo.
        define variable iVal as integer no-undo.
        define variable iCheckVal as integer no-undo.
        
        /** This value should always be a power of 2. */
        iCheckVal = poCheckEnum:Value.
        
        /** This loop looks for the position of the bit (the '1') in our value
            so for an iVal of 2, it'll be the right-most position, ie 32. */
        do iPos = 1 to 32 while iVal eq 0:
            iVal = get-bits(iCheckVal, iPos, 1).
        end.
        
        /** Now we look to whether the total enum contains a bit set (ie a '1') set
            at the position we established above.  Because we're dealing with powers 
            of 2, we know that if a bit is set that the check flag appears in the value. */
        return (get-bits(piValueSum, iPos - 1, 1) eq iVal).
    end method.
    
    /* Private ctor so that a derived class can't bypass the necessary checks for
       power-of-two-ness. */
    constructor private FlagsEnum():
        super(-1).
    end constructor.
    
    constructor public FlagsEnum(input piValue as integer):
        this-object(piValue, ?).
    end constructor.
    
    constructor public FlagsEnum ( input piValue as integer, input pcName as character ):
        super(input piValue, input pcName).
        
        ValidateEnumMemberValue(piValue).
    end constructor.
    
    /** The value must be a power of 2 for it to be a flag enumeration value.
        The algorithm below adapted from the following comment on Stackoverflow:
        http://stackoverflow.com/questions/600293/how-to-check-if-a-number-is-a-power-of-2/2552559#2552559 */
    method private void ValidateEnumMemberValue(input piValue as integer):
        if not piValue eq exp(2, log(piValue, 2)) then
          undo, throw new AppError(string(piValue) + ' is not a power of 2, which is required for a flag enumeration value').
    end method.

end class./*------------------------------------------------------------------------
    File        : ICloneable
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jan 15 14:35:27 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Lang.*.

interface OpenEdge.Lang.ICloneable:  
  
end interface.
@todo(task="implement", action="complete this shadow object").
/*------------------------------------------------------------------------
    File        : Int
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 08:22:29 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Int.
using OpenEdge.Lang.ABLPrimitive.

class OpenEdge.Lang.Int:
    define public property Value as int64 no-undo get. private set.
    
    constructor public Int(piValue as int64):
        super().
        this-object:Value = piValue.
    end constructor.

    constructor public Int(piValue as int):
        super().
        this-object:Value = piValue.
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : IOModeEnum
    Purpose     : IO Mode enumeration (for parameters). 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 11:22:58 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.IOModeEnum final inherits EnumMember: 

    define public static property Default                   as IOModeEnum no-undo get. private set.                                 
    define public static property Input                     as IOModeEnum no-undo get. private set.
    define public static property Output                    as IOModeEnum no-undo get. private set.
    define public static property OutputAppend              as IOModeEnum no-undo get. private set.
    define public static property InputOutput               as IOModeEnum no-undo get. private set.
    define public static property TableHandle               as IOModeEnum no-undo get. private set.
    define public static property TableHandleByReference    as IOModeEnum no-undo get. private set.
    define public static property DatasetHandle             as IOModeEnum no-undo get. private set.
    define public static property DatasetHandleByReference  as IOModeEnum no-undo get. private set.
    define public static property Return                    as IOModeEnum no-undo get. private set.
    
    constructor static IOModeEnum():
        IOModeEnum:Input = new IOModeEnum('Input').
        IOModeEnum:Output = new IOModeEnum('Output').
        IOModeEnum:OutputAppend = new IOModeEnum('Output-Append').
        IOModeEnum:InputOutput = new IOModeEnum('Input-Output').
        IOModeEnum:TableHandle = new IOModeEnum('Table-Handle').
        IOModeEnum:TableHandleByReference = new IOModeEnum('Table-Handle-By-Reference').
        IOModeEnum:DatasetHandle = new IOModeEnum('Dataset-Handle').
        IOModeEnum:DatasetHandleByReference = new IOModeEnum('Dataset-Handle-By-Reference').
        IOModeEnum:Return = new IOModeEnum('Return').
        
        IOModeEnum:Default = IOModeEnum:Input.
    end constructor.

    constructor public IOModeEnum(input pcName as character):
        super (input pcName).
    end constructor.
    
end class./** ------------------------------------------------------------------------
    File        : JoinEnum
    Purpose     : Enumeration of ABL join types 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 12 15:03:46 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.JoinEnum final inherits EnumMember:
     
    define public static property None as JoinEnum no-undo get. private set.
    define public static property And  as JoinEnum no-undo get. private set.
    define public static property Or   as JoinEnum no-undo get. private set.
    define public static property Not  as JoinEnum no-undo get. private set.
    
    constructor static JoinEnum():
        JoinEnum:None = new JoinEnum('none').
        JoinEnum:And  = new JoinEnum('and').
        JoinEnum:Or   = new JoinEnum('or').
        JoinEnum:Not  = new JoinEnum('not').
    end constructor.

    constructor public JoinEnum ( input pcName as character ):
        super (input pcName).
    end constructor.

    method static public JoinEnum EnumFromString (input pcName as character):
        define variable oEnum as JoinEnum no-undo.
        
        case pcName:
            when JoinEnum:None:ToString() then oEnum = JoinEnum:None.
            when JoinEnum:And:ToString() then oEnum = JoinEnum:And.
            when JoinEnum:Or:ToString() then oEnum = JoinEnum:Or.
            when JoinEnum:Not:ToString() then oEnum = JoinEnum:Not.
        end case.
        
        return oEnum.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : LockModeEnum
    Purpose     : Enumeration of record locking modes in ABL 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 11:56:34 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.LockModeEnum final inherits EnumMember: 

    define public static property Default       as LockModeEnum no-undo get. private set.
    define public static property ShareLock     as LockModeEnum no-undo get. private set.
    define public static property ExclusiveLock as LockModeEnum no-undo get. private set.
    define public static property NoLock        as LockModeEnum no-undo get. private set.
        
    constructor static LockModeEnum():
        LockModeEnum:ShareLock = new LockModeEnum(share-lock, 'share-lock').
        LockModeEnum:ExclusiveLock = new LockModeEnum(exclusive-lock, 'exclusive-lock').
        LockModeEnum:NoLock = new LockModeEnum(no-lock, 'no-lock').
        
        /* ABL Default is ShareLock, but NoLock preferred here */                              
        LockModeEnum:Default = LockModeEnum:NoLock.
    end constructor.

    constructor public LockModeEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    method static public LockModeEnum EnumFromValue(input piValue as integer):
        define variable oLockModeEnum as LockModeEnum no-undo.
        
        case piValue:
            when LockModeEnum:ShareLock:Value then oLockModeEnum = LockModeEnum:ShareLock.
            when LockModeEnum:ExclusiveLock:Value then oLockModeEnum = LockModeEnum:ExclusiveLock.
            when LockModeEnum:NoLock:Value then oLockModeEnum = LockModeEnum:NoLock. 
        end case.
        
        return oLockModeEnum.
    end method.

    method static public LockModeEnum EnumFromString(input pcName as character):
        define variable oLockModeEnum as LockModeEnum no-undo.
        
        case pcName:
            when LockModeEnum:ShareLock:ToString() then oLockModeEnum = LockModeEnum:ShareLock.
            when LockModeEnum:ExclusiveLock:ToString() then oLockModeEnum = LockModeEnum:ExclusiveLock.
            when LockModeEnum:NoLock:ToString() then oLockModeEnum = LockModeEnum:NoLock. 
        end case.
        
        return oLockModeEnum.
    end method.

end class./** ------------------------------------------------------------------------
    File        : LoginStateEnum
    Purpose     : Enumerate the CLIENT-PRINCIPAL's LOGIN-STATEs
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 05 16:31:17 EDT 2011
    Notes       : * See ABL documentation for details.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.
  
using OpenEdge.Lang.LoginStateEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.LoginStateEnum inherits EnumMember final: 
    
    define static public property Login as LoginStateEnum no-undo get. private set.
    define static public property Logout as LoginStateEnum no-undo get. private set.
    define static public property Expired as LoginStateEnum no-undo get. private set.
    define static public property Failed as LoginStateEnum no-undo get. private set.

    constructor static LoginStateEnum():
        LoginStateEnum:Login = new LoginStateEnum('Login').
        LoginStateEnum:Logout = new LoginStateEnum('Logout').
        LoginStateEnum:Expired = new LoginStateEnum('Expired').
        LoginStateEnum:Failed = new LoginStateEnum('Failed').
    end constructor.
    
	constructor public LoginStateEnum ( input pcName as character ):
		super (input pcName).
	end constructor.
	
    method public static LoginStateEnum EnumFromString(input pcLoginState as character):
        define variable oMember as LoginStateEnum no-undo.
        
        case pcLoginState:
            when LoginStateEnum:Login:Name then oMember = LoginStateEnum:Login.
            when LoginStateEnum:Logout:Name then oMember = LoginStateEnum:Logout.
            when LoginStateEnum:Expired:Name then oMember = LoginStateEnum:Expired.
            when LoginStateEnum:Failed:Name then oMember = LoginStateEnum:Failed.
        end.
        
        return oMember.
    end method.
	
end class./** ------------------------------------------------------------------------
    File        : OperatorEnum
    Purpose     : Enumeration of ABL operators 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 12 15:05:08 EDT 2009
    Notes       : * IsEqual property should be 'Equals' but compiler barfs. 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.OperatorEnum final inherits EnumMember :
    
    define public static property IsEqual       as OperatorEnum no-undo get. private set.
    define public static property GreaterThan   as OperatorEnum no-undo get. private set.
    define public static property GreaterEqual  as OperatorEnum no-undo get. private set.
    define public static property LessThan      as OperatorEnum no-undo get. private set.
    define public static property LessEqual     as OperatorEnum no-undo get. private set.
    define public static property NotEqual      as OperatorEnum no-undo get. private set.
    define public static property Matches       as OperatorEnum no-undo get. private set.
    define public static property Begins        as OperatorEnum no-undo get. private set.
    define public static property Contains      as OperatorEnum no-undo get. private set.
    define public static property None          as OperatorEnum no-undo get. private set.
    
    constructor static OperatorEnum():
        OperatorEnum:IsEqual = new OperatorEnum('eq').
        OperatorEnum:GreaterThan = new OperatorEnum('gt').
        OperatorEnum:GreaterEqual = new OperatorEnum('ge').
        OperatorEnum:LessThan = new OperatorEnum('lt').
        OperatorEnum:LessEqual = new OperatorEnum('le').
        OperatorEnum:NotEqual = new OperatorEnum('ne').
        OperatorEnum:Matches = new OperatorEnum('matches').
        OperatorEnum:Begins = new OperatorEnum('begins').
        OperatorEnum:Contains = new OperatorEnum('contains').
        OperatorEnum:None = new OperatorEnum('').
    end constructor.
    
    constructor public OperatorEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public logical Equals (pcOperator as char, poOperator as OperatorEnum):
        define variable lEqual as logical no-undo.
        
        lEqual = poOperator:ToString() eq pcOperator.
        
        /* Alternate */
        if not lEqual then
        case pcOperator:
            when '=' then lEqual = poOperator eq OperatorEnum:IsEqual.
            when '>' then lEqual = poOperator eq OperatorEnum:GreaterThan.
            when '>=' then lEqual = poOperator eq OperatorEnum:GreaterEqual.
            when '<' then lEqual = poOperator eq OperatorEnum:LessThan.
            when '<=' then lEqual = poOperator eq OperatorEnum:LessEqual.
            when '<>' then lEqual = poOperator eq OperatorEnum:NotEqual.
        end case.
        
        return lEqual.
    end method.
    
    method static public OperatorEnum EnumFromString (input pcName as character):
        define variable oEnum as OperatorEnum no-undo.
        
        case pcName:
            when OperatorEnum:IsEqual:ToString() then oEnum = OperatorEnum:IsEqual.
            when OperatorEnum:GreaterThan:ToString() then oEnum = OperatorEnum:GreaterThan.
            when OperatorEnum:GreaterEqual:ToString() then oEnum = OperatorEnum:GreaterEqual.
            when OperatorEnum:LessThan:ToString() then oEnum = OperatorEnum:LessThan.
            when OperatorEnum:LessEqual:ToString() then oEnum = OperatorEnum:LessEqual.
            when OperatorEnum:NotEqual:ToString() then oEnum = OperatorEnum:NotEqual.
            when OperatorEnum:Matches:ToString() then oEnum = OperatorEnum:Matches.
            when OperatorEnum:Begins:ToString() then oEnum = OperatorEnum:Begins.
            when OperatorEnum:Contains:ToString() then oEnum = OperatorEnum:Contains.
            when OperatorEnum:None:ToString() then oEnum = OperatorEnum:None.
        end case.
        
        return oEnum.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : QueryBlockTypeEnum
    Purpose     : numeration of the query block type (for, preselect)
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 07 12:21:09 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Lang.QueryBlockTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.QueryBlockTypeEnum final inherits EnumMember:
    
    define public static property Default   as QueryBlockTypeEnum no-undo get. private set.
    define public static property For       as QueryBlockTypeEnum no-undo get. private set.
    define public static property Preselect as QueryBlockTypeEnum no-undo get. private set.
    
    constructor static QueryBlockTypeEnum():
        QueryBlockTypeEnum:For = new QueryBlockTypeEnum('For').
        QueryBlockTypeEnum:Preselect = new QueryBlockTypeEnum('Preselect').
        
        /* Using Preselect instead of For since I'm assuming that these
           queries are going to be used for binding to a ProBindingSource,
           which prefers a preselect. */
        QueryBlockTypeEnum:Default = QueryBlockTypeEnum:Preselect.        
    end constructor.
    
    constructor public QueryBlockTypeEnum (input pcName as character):
        super (input pcName).
    end constructor.
    
    method static public QueryBlockTypeEnum EnumFromString(input pcName as character):
        define variable oEnum as QueryBlockTypeEnum no-undo.
        
        case pcName:
            when QueryBlockTypeEnum:For:ToString() then oEnum = QueryBlockTypeEnum:For. 
            when QueryBlockTypeEnum:Preselect:ToString() then oEnum = QueryBlockTypeEnum:Preselect.
        end case.
        
        return oEnum.
    end method. 
    
end class./** ------------------------------------------------------------------------
    File        : QueryTypeEnum
    Purpose     : Query type enumeration - each, first etc 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 07 10:27:16 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.QueryTypeEnum inherits EnumMember:
    
    define public static property Default as QueryTypeEnum no-undo get. private set.
    define public static property Each    as QueryTypeEnum no-undo get. private set.
    define public static property First   as QueryTypeEnum no-undo get. private set.
    define public static property Last    as QueryTypeEnum no-undo get. private set.
    
    constructor static QueryTypeEnum():
        QueryTypeEnum:Each  = new QueryTypeEnum('Each').
        QueryTypeEnum:First = new QueryTypeEnum('First').
        QueryTypeEnum:Last  = new QueryTypeEnum('Last').
        
        QueryTypeEnum:Default = QueryTypeEnum:Each.
    end constructor.

    constructor public QueryTypeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method public static QueryTypeEnum EnumFromString(pcQueryType as char):        
        define variable oMember as QueryTypeEnum no-undo.
        
        case pcQueryType:
            when QueryTypeEnum:Each:ToString() then oMember = QueryTypeEnum:Each. 
            when QueryTypeEnum:First:ToString() then oMember = QueryTypeEnum:First.
            when QueryTypeEnum:Last:ToString() then oMember = QueryTypeEnum:Last.
        end.
        
        return oMember.
    end method.
    
end class./** ------------------------------------------------------------------------
    Append        : ReadModeEnum
    Purpose     : Enumeration of READ-*() method modes.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Oct 12 14:26:03 EDT 2010
    Notes       : * Based on the ABL documentation
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.ReadModeEnum. 
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.ReadModeEnum inherits EnumMember final: 
    
    define static public property Append as ReadModeEnum  no-undo get. private set.
    define static public property Empty as ReadModeEnum  no-undo get. private set.
    define static public property Merge as ReadModeEnum  no-undo get. private set.
    define static public property Replace as ReadModeEnum  no-undo get. private set.
    define static public property Default as ReadModeEnum  no-undo get. private set.
    
    constructor static ReadModeEnum():
        ReadModeEnum:Append = new ReadModeEnum('Append').
        ReadModeEnum:Empty = new ReadModeEnum('Empty').
        ReadModeEnum:Merge = new ReadModeEnum('Empty-Handle').
        ReadModeEnum:Replace = new ReadModeEnum('Replace').
        ReadModeEnum:Default = ReadModeEnum:Merge. 
    end constructor.
    
    constructor public ReadModeEnum(input pcName as character):
        super (input pcName).
    end constructor.     

    method static public ReadModeEnum EnumFromString(pcReadMode as character):
        define variable oMember as ReadModeEnum no-undo.
        
        case pcReadMode:
            when ReadModeEnum:Append:ToString()  then oMember = ReadModeEnum:Append.
            when ReadModeEnum:Empty:ToString()   then oMember = ReadModeEnum:Empty.
            when ReadModeEnum:Merge:ToString()   then oMember = ReadModeEnum:Merge.
            when ReadModeEnum:Replace:ToString() then oMember = ReadModeEnum:Replace.
        end case.
        
        return oMember.   
    end method.
end class./*------------------------------------------------------------------------
    File        : RoutineTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Nov 18 15:25:50 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.RoutineTypeEnum. 
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.RoutineTypeEnum inherits EnumMember: 
    
    define static public property Constructor as RoutineTypeEnum no-undo get. private set.
    define static public property Destructor as RoutineTypeEnum no-undo get. private set.
    define static public property Method as RoutineTypeEnum no-undo get. private set.
    define static public property PropertySetter as RoutineTypeEnum no-undo get. private set.
    define static public property PropertyGetter as RoutineTypeEnum no-undo get. private set.
    define static public property UserDefinedFuntion as RoutineTypeEnum no-undo get. private set.
    define static public property Procedure as RoutineTypeEnum no-undo get. private set.

    constructor static RoutineTypeEnum():
        RoutineTypeEnum:Constructor = new RoutineTypeEnum('Constructor').
        RoutineTypeEnum:Destructor = new RoutineTypeEnum('Destructor').
        RoutineTypeEnum:Method = new RoutineTypeEnum('Method').
        RoutineTypeEnum:PropertySetter = new RoutineTypeEnum('PropertySetter').
        RoutineTypeEnum:PropertyGetter = new RoutineTypeEnum('PropertyGetter').
        
        RoutineTypeEnum:UserDefinedFuntion = new RoutineTypeEnum('Function').
        RoutineTypeEnum:Procedure = new RoutineTypeEnum('Procedure').
    end constructor.
    
    constructor public RoutineTypeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method public static RoutineTypeEnum EnumFromString(input pcName as character):
        define variable oEnum as RoutineTypeEnum no-undo.
        
        case pcName:
            when RoutineTypeEnum:Constructor:ToString() then oEnum = RoutineTypeEnum:Constructor.
            when RoutineTypeEnum:Destructor:ToString() then oEnum = RoutineTypeEnum:Destructor.
            when RoutineTypeEnum:Method:ToString() then oEnum = RoutineTypeEnum:Method.
            when RoutineTypeEnum:PropertySetter:ToString() then oEnum = RoutineTypeEnum:PropertySetter.
            when RoutineTypeEnum:PropertyGetter:ToString() then oEnum = RoutineTypeEnum:PropertyGetter.
            when RoutineTypeEnum:UserDefinedFuntion:ToString() then oEnum = RoutineTypeEnum:UserDefinedFuntion.
            when RoutineTypeEnum:Procedure:ToString() then oEnum = RoutineTypeEnum:Procedure.
        end case.
        
        return oEnum.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : RowStateEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Aug 25 11:17:38 EDT 2010
    Notes       : * Derived from ABL Decoumentation
     
    Table 58:   Row state values   Compiler constant  Value  Description  
                ROW-UNMODIFIED  0  The row was not modified.  
                ROW-DELETED  1  The row was deleted.  
                ROW-MODIFIED  2  The row was modified.  
                ROW-CREATED  3  The row was created.  

    
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.EnumMember.
using OpenEdge.Lang.RowStateEnum.

class OpenEdge.Lang.RowStateEnum inherits EnumMember final:

    define static public property Unmodified    as RowStateEnum no-undo get. private set.
    define static public property Deleted       as RowStateEnum no-undo get. private set.
    define static public property Modified      as RowStateEnum no-undo get. private set.
    define static public property Created       as RowStateEnum no-undo get. private set.     

    constructor static RowStateEnum():
        RowStateEnum:Unmodified = new RowStateEnum(0, 'ROW-UNMODIFIED').
        RowStateEnum:Deleted = new RowStateEnum(1, 'ROW-DELETED').
        RowStateEnum:Modified = new RowStateEnum(2, 'ROW-MODIFIED').
        RowStateEnum:Created = new RowStateEnum(3, 'ROW-CREATED').
    end constructor.
             
    constructor public RowStateEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    method static public RowStateEnum ValueToEnum(input piValue as integer):
        define variable oRowStateEnum as RowStateEnum no-undo.
        
        case piValue:
            when RowStateEnum:Unmodified:Value then oRowStateEnum = RowStateEnum:Unmodified.
            when RowStateEnum:Deleted:Value then oRowStateEnum = RowStateEnum:Deleted.
            when RowStateEnum:Modified:Value then oRowStateEnum = RowStateEnum:Modified.
            when RowStateEnum:Created:Value then oRowStateEnum = RowStateEnum:Created.              
        end case.
        
        return oRowStateEnum.
    end method. 

    method static public RowStateEnum NameToEnum(input pcName as character):
        define variable oRowStateEnum as RowStateEnum no-undo.
        
        case pcName:
            when RowStateEnum:Unmodified:ToString() then oRowStateEnum = RowStateEnum:Unmodified.
            when RowStateEnum:Deleted:ToString() then oRowStateEnum = RowStateEnum:Deleted.
            when RowStateEnum:Modified:ToString() then oRowStateEnum = RowStateEnum:Modified.
            when RowStateEnum:Created:ToString() then oRowStateEnum = RowStateEnum:Created.            
        end case.
        
        return oRowStateEnum.
    end method.

end class./** ------------------------------------------------------------------------
    File        : SaxWriteStatusEnum
    Purpose     : Enumerates the values of the SAX=WRITE WRITE-STATUS attribute 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 22 15:48:43 EST 2010
    Notes       : * See the ABL Help and//or documentation for details 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.SaxWriteStatusEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.SaxWriteStatusEnum inherits EnumMember: 
    /* No writing has occurred. */
    define static public property Idle as SaxWriteStatusEnum no-undo get. private set.
    
    /* The START-DOCUMENT method has been called and writing has begun. */
    define static public property Begin as SaxWriteStatusEnum no-undo get. private set.
    /* The writer has written an opening tag. This is the only time that attributes can 
        be inserted with INSERT-ATTRIBUTE and DECLARE-NAMESPACE. */
    define static public property Tag as SaxWriteStatusEnum no-undo get. private set.
    /* The writer is within an element. */
    define static public property Element as SaxWriteStatusEnum no-undo get. private set.
    /* The writer has written the content of an element. In other words, the WRITE-CHARACTERS method has been called. */
    define static public property Content as SaxWriteStatusEnum no-undo get. private set.
    /* The END-DOCUMENT method has been called and writing is complete.  */
    define static public property Complete as SaxWriteStatusEnum no-undo get. private set.
    /* The SAX-writer could not start or could not continue. Likely causes include: SAX-writer 
       could not be loaded, the XML target could not be written to, a method call fails, etc.
       This is the status if there is an invalid XML generated while STRICT is TRUE.
       If the status is SAX-WRITE-ERROR then no attributes can be written and the only
       method that can be called is RESET. */
    define static public property Error as SaxWriteStatusEnum no-undo get. private set.
    
    define static public property Default as SaxWriteStatusEnum no-undo get. private set.              
    
    constructor static SaxWriteStatusEnum():
        SaxWriteStatusEnum:Idle = new SaxWriteStatusEnum(1, 'SAX-WRITE-IDLE').
        SaxWriteStatusEnum:Begin = new SaxWriteStatusEnum(2, 'SAX-WRITE-BEGIN').
        SaxWriteStatusEnum:Tag = new SaxWriteStatusEnum(3, 'SAX-WRITE-TAG').
        SaxWriteStatusEnum:Element = new SaxWriteStatusEnum(4, 'SAX-WRITE-ELEMENT').
        SaxWriteStatusEnum:Content = new SaxWriteStatusEnum(5, 'SAX-WRITE-CONTENT').
        SaxWriteStatusEnum:Complete = new SaxWriteStatusEnum(6, 'SAX-WRITE-COMPLETE').
        SaxWriteStatusEnum:Error = new SaxWriteStatusEnum(7, 'SAX-WRITE-ERROR').
        
        SaxWriteStatusEnum:Default = SaxWriteStatusEnum:Idle.
    end constructor.

    constructor public SaxWriteStatusEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.

    method static public SaxWriteStatusEnum EnumFromString(input pcName as character):
        define variable oEnum as SaxWriteStatusEnum no-undo.
        
        case pcName:
            when SaxWriteStatusEnum:Idle:ToString() then oEnum = SaxWriteStatusEnum:Idle.
            when SaxWriteStatusEnum:Begin:ToString() then oEnum = SaxWriteStatusEnum:Begin.
            when SaxWriteStatusEnum:Tag:ToString() then oEnum = SaxWriteStatusEnum:Tag.
            when SaxWriteStatusEnum:Element:ToString() then oEnum = SaxWriteStatusEnum:Element.
            when SaxWriteStatusEnum:Content:ToString() then oEnum = SaxWriteStatusEnum:Content.
            when SaxWriteStatusEnum:Complete:ToString() then oEnum = SaxWriteStatusEnum:Complete.
            when SaxWriteStatusEnum:Error:ToString() then oEnum = SaxWriteStatusEnum:Error.
        end case.
        
        return oEnum.
    end method.

    method static public SaxWriteStatusEnum EnumFromValue(input piValue as integer):
        define variable oEnum as SaxWriteStatusEnum no-undo.
        
        case piValue:
            when SaxWriteStatusEnum:Idle:Value then oEnum = SaxWriteStatusEnum:Idle.
            when SaxWriteStatusEnum:Begin:Value then oEnum = SaxWriteStatusEnum:Begin.
            when SaxWriteStatusEnum:Tag:Value then oEnum = SaxWriteStatusEnum:Tag.
            when SaxWriteStatusEnum:Element:Value then oEnum = SaxWriteStatusEnum:Element.
            when SaxWriteStatusEnum:Content:Value then oEnum = SaxWriteStatusEnum:Content.
            when SaxWriteStatusEnum:Complete:Value then oEnum = SaxWriteStatusEnum:Complete.
            when SaxWriteStatusEnum:Error:Value then oEnum = SaxWriteStatusEnum:Error.
        end case.
        
        return oEnum.
    end method.

end class./** ------------------------------------------------------------------------
    File        : SerializationModeEnum
    Purpose     : Enumeration of WRITE-*() and READ-*() method modes.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Oct 12 14:17:26 EDT 2010
    Notes       : * Based on the ABL documentation 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.SerializationModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.SerializationModeEnum inherits EnumMember final:

    define static public property File as SerializationModeEnum  no-undo get. private set.
    define static public property Stream as SerializationModeEnum  no-undo get. private set.
    define static public property StreamHandle as SerializationModeEnum  no-undo get. private set.
    define static public property Memptr as SerializationModeEnum  no-undo get. private set.
    define static public property Handle as SerializationModeEnum  no-undo get. private set.
    define static public property LongChar as SerializationModeEnum  no-undo get. private set.
    
    constructor static SerializationModeEnum():
        SerializationModeEnum:File = new SerializationModeEnum('File').
        SerializationModeEnum:Stream = new SerializationModeEnum('Stream').
        SerializationModeEnum:StreamHandle = new SerializationModeEnum('Stream-Handle').
        SerializationModeEnum:Memptr = new SerializationModeEnum('Memptr').
        SerializationModeEnum:Handle = new SerializationModeEnum('Handle').
        SerializationModeEnum:LongChar = new SerializationModeEnum('Longchar').
    end constructor.
    
    constructor public SerializationModeEnum(input pcName as character):
        super (input pcName).
    end constructor.     

    method static public SerializationModeEnum EnumFromString(input pcWriteMode as character):
        define variable oMember as SerializationModeEnum no-undo.
        
        case pcWriteMode:
            when SerializationModeEnum:File:ToString()         then oMember = SerializationModeEnum:File.
            when SerializationModeEnum:Stream:ToString()       then oMember = SerializationModeEnum:Stream.
            when SerializationModeEnum:StreamHandle:ToString() then oMember = SerializationModeEnum:StreamHandle.
            when SerializationModeEnum:Memptr:ToString()       then oMember = SerializationModeEnum:Memptr.
            when SerializationModeEnum:Handle:ToString()       then oMember = SerializationModeEnum:Handle.
            when SerializationModeEnum:LongChar:ToString()     then oMember = SerializationModeEnum:LongChar.
        end case.
                
        return oMember.   
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : SessionClientTypeEnum
    Purpose     : Enumeration of ABL client types, as per the SESSION:CLIENT-TYPE 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 18 15:08:28 EST 2010
    Notes       : * Descriptions appear in the ABL documentation.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.SessionClientTypeEnum. 
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.SessionClientTypeEnum final inherits EnumMember:
    
    define static public property ABLClient as SessionClientTypeEnum no-undo get. private set.
    define static public property WebClient as SessionClientTypeEnum no-undo get. private set.
    define static public property AppServer as SessionClientTypeEnum no-undo get. private set.
    define static public property WebSpeed  as SessionClientTypeEnum no-undo get. private set.
    define static public property Other     as SessionClientTypeEnum no-undo get. private set.
    
    /** The CurrentSession is settable for debug purposes: for instance, it allows you to debug server-side
        code without having to run it on the server. */    
    define static public property CurrentSession as SessionClientTypeEnum no-undo get. set.
    
    constructor static SessionClientTypeEnum():
        SessionClientTypeEnum:ABLClient = new SessionClientTypeEnum('4GLCLIENT').
        SessionClientTypeEnum:WebClient = new SessionClientTypeEnum('WEBCLIENT').
        SessionClientTypeEnum:AppServer = new SessionClientTypeEnum('APPSERVER').
        SessionClientTypeEnum:WebSpeed  = new SessionClientTypeEnum('WEBSPEED').
        SessionClientTypeEnum:Other     = new SessionClientTypeEnum(?).
        
        SessionClientTypeEnum:CurrentSession = SessionClientTypeEnum:EnumFromString(session:client-type).
    end constructor.
    
    constructor public SessionClientTypeEnum(input pcName as character):
        super(pcName).
    end constructor.
    
    method public static SessionClientTypeEnum EnumFromString(input pcSessionClientType as character):
        define variable oMember as SessionClientTypeEnum no-undo.
        
        case pcSessionClientType:
            when SessionClientTypeEnum:ABLClient:Name then oMember = SessionClientTypeEnum:ABLClient.
            when SessionClientTypeEnum:WebClient:Name then oMember = SessionClientTypeEnum:WebClient.
            when SessionClientTypeEnum:AppServer:Name then oMember = SessionClientTypeEnum:AppServer.
            when SessionClientTypeEnum:WebSpeed:Name then oMember = SessionClientTypeEnum:WebSpeed.
            otherwise SessionClientTypeEnum:Other.
        end.
        
        return oMember.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : SortDirectionEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 12 17:14:09 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.SortDirectionEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.SortDirectionEnum final inherits EnumMember: 
    
    define public static property Default    as SortDirectionEnum no-undo get. private set.
    define public static property Ascending  as SortDirectionEnum no-undo get. private set.
    define public static property Descending as SortDirectionEnum no-undo get. private set.
    
    constructor static SortDirectionEnum():
        /* Values taken from INDEX-INFORMATION() method doc, for easy ABL conversion.
           Note that they start at ZERO not 1. */
        SortDirectionEnum:Ascending = new SortDirectionEnum(0, 'Ascending').
        SortDirectionEnum:Descending = new SortDirectionEnum(1, 'Descending').
        
        SortDirectionEnum:Default = SortDirectionEnum:Ascending.        
    end constructor.

    constructor public SortDirectionEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    method static public SortDirectionEnum EnumFromString(pcSortDirection as character):
        define variable oMember as SortDirectionEnum no-undo.
        
        case pcSortDirection:
            when SortDirectionEnum:Ascending:ToString() then oMember = SortDirectionEnum:Ascending.
            when SortDirectionEnum:Descending:ToString() then oMember = SortDirectionEnum:Descending.
        end case.
        
        return oMember.
    end method.

    method static public SortDirectionEnum EnumFromValue(piSortDirection as integer):
        define variable oMember as SortDirectionEnum no-undo.
        
        case piSortDirection:
            when SortDirectionEnum:Ascending:Value then oMember = SortDirectionEnum:Ascending.
            when SortDirectionEnum:Descending:Value then oMember = SortDirectionEnum:Descending.
        end case.
                
        return oMember.
    end method.
                
end class./** ------------------------------------------------------------------------
    File        : String
    Purpose     : Primitive class for character/longchar variables
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 11 13:08:46 EDT 2009
    Notes       : * Named 'String' because of keyword/namespace conflicts with
                    ABL Primitive 'character'. There's no built-in class for this.
                  * Initial requirement for collections; having a class for the
                    primitive value means that we don't have to distinguish between
                    primitives and types, which makes the code more readable.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.

/* Don't have a USING for this class, so that we can avoid conflicts with the STRING() ABL keyword/function
using OpenEdge.Lang.String.*/
using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.Lang.String
        implements IExternalizable:

    define static public property Type as class Class no-undo
        get():
            if not valid-object(OpenEdge.Lang.String:Type) then
                OpenEdge.Lang.String:Type = Class:GetClass('OpenEdge.Lang.String').
            
            return OpenEdge.Lang.String:Type.
        end.
        private set.
    
    define static private variable moEmptyString as OpenEdge.Lang.String no-undo.
    define public property Value as longchar no-undo get. private set.
    
    constructor public String():
        super().        
    end constructor.

    constructor public String(pcString as longchar):
        super().
        this-object:Value = pcString.
    end constructor.
    
    constructor public String(pcString as char):
        super().
        this-object:Value = pcString.
    end constructor.
    
    method public void Trim():
        /* we can't use the ABL TRIM keyword, since we run into 
           name conflicts, so do a left- and right-trim instead. */
        right-trim(left-trim(this-object:Value)).
    end method.
    
    method static public OpenEdge.Lang.String Empty ():
        if not valid-object(moEmptyString) then
            moEmptyString = new OpenEdge.Lang.String('').
        
        return moEmptyString.
    end method.
    
    method override public logical Equals(input p0 as Object):
        if type-of(p0, OpenEdge.Lang.String) then
            return (this-object:Value eq cast(p0, OpenEdge.Lang.String):Value).
        else
            return super:Equals(p0).    
    end method.
    
/** IExternalizable **/
    method public void WriteObject(input po as IObjectOutput):
        po:WriteLongChar(this-object:Value).
    end method.
    
    method public void ReadObject(input po as IObjectInput):
        this-object:Value = po:ReadLongChar().
    end method.

    method public character extent Split(input pcDelimiter as character):
        return OpenEdge.Lang.String:Split(this-object:Value, pcDelimiter).
    end method.
    
    method public character extent Split():
        return OpenEdge.Lang.String:Split(this-object:Value).
    end method.
        
    method static public character extent Split(input pcValue as longchar):
        return OpenEdge.Lang.String:Split(pcValue, ',').
    end method.
            
    method static public character extent Split(input pcValue as longchar,
                                                input pcDelimiter as character):
        define variable cArray as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = num-entries(pcValue, pcDelimiter).
        extent(cArray) = iMax.
        
        do iLoop = 1 to iMax:
            cArray[iLoop] = entry(iLoop, pcValue, pcDelimiter).
        end. 
        
        return cArray.
    end method.
    
    method static public longchar Join(input poValue as OpenEdge.Lang.String extent,
                                       input pcDelimiter as character):
        define variable cJoinedString as longchar no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poValue).
        do iLoop = 1 to iMax:
            if iLoop eq 1 then
                cJoinedString = poValue[iLoop]:Value.
            else
                cJoinedString = cJoinedString + pcDelimiter + poValue[iLoop]:Value.
        end.
        
        return cJoinedString.
    end method.
    
    method override public character ToString():
        define variable cValue as character no-undo.
        cValue = this-object:Value.
        
        return cValue.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : TimeStamp
    Purpose     : Primitive class for date, TimeStamp and TimeStamp-tz values
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 22 14:29:32 EST 2010
    Notes       : * Named 'TimeStamp' because of keyword/namespace conflicts with
                    ABL Primitive DATETIME. There's no built-in class for this.
                  * Initial requirement for collections; having a class for the
                    primitive value means that we don't have to distinguish between
                    primitives and types, which makes the code more readable.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.TimeStamp.
using OpenEdge.Lang.DateTimeAddIntervalEnum.
using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Object.

class OpenEdge.Lang.TimeStamp:
    
    define public property Format as DataTypeEnum no-undo get. private set.
    
    define private variable mtDate as date no-undo.
    define private variable miTime as integer no-undo.
    define private variable miTZOffset as integer no-undo.
    
    constructor public TimeStamp(piTimeStamp as integer):
        super().
        
        assign miTime = piTimeStamp
               this-object:Format = DataTypeEnum:Integer.
    end constructor.

    constructor public TimeStamp(ptTimeStamp as date):
        super().
        
        assign mtDate = ptTimeStamp
               this-object:Format = DataTypeEnum:Date.
    end constructor.
    
    constructor public TimeStamp(ptTimeStamp as datetime):
        super().
        
        assign mtDate = date(ptTimeStamp)
               miTime = mtime(ptTimeStamp)
               this-object:Format = DataTypeEnum:DateTime.
    end constructor.

    constructor public TimeStamp(ptTimeStamp as datetime-tz):
        super().
        
        assign mtDate = date(ptTimeStamp)
               miTime = mtime(ptTimeStamp)
               miTZOffset = timezone(ptTimeStamp)
               this-object:Format = DataTypeEnum:DateTimeTZ.
    end constructor.

    constructor public TimeStamp(input pcTimeStamp as character):
        define variable tTimeStamp as datetime-tz no-undo.
        
        super().
        
        tTimeStamp = TimeStamp:ToABLDateTimeFromISO(pcTimeStamp).
        
        assign mtDate = date(tTimeStamp)
               miTime = mtime(tTimeStamp)
               miTZOffset = timezone(tTimeStamp)
               this-object:Format = DataTypeEnum:DateTimeTZ.
    end constructor.
    
    constructor public TimeStamp():
        this-object(now).
    end constructor.
    
    method override public logical Equals(input p0 as Object):
        if type-of(p0, TimeStamp) then
        case this-object:Format:
            when DataTypeEnum:Integer then return (ToTime() eq cast(p0, TimeStamp):ToTime()).
            when DataTypeEnum:Date then return (ToDate() eq cast(p0, TimeStamp):ToDate()).
            when DataTypeEnum:DateTime then return (ToDateTime() eq cast(p0, TimeStamp):ToDateTime()).
            when DataTypeEnum:DateTimeTZ then return (ToDateTimeTz() eq cast(p0, TimeStamp):ToDateTimeTz()).
        end case.
        else
            return super:Equals(p0).
    end method.

    /** Converts an ABL datetime into a correct ISO date. The ISO-DATE()
        function requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @return character An ISO date.      */
    method public character ToISODate():
        define variable cDateFormat as character no-undo.
        
        cDateFormat = session:date-format.
        session:date-format = 'ymd'.
        
        return iso-date(ToDateTimeTz()).
        finally:
            session:date-format = cDateFormat.        
        end finally.
    end method.
    
    /** Converts an ABL datetime into a correct ISO date. The ISO-DATE()
        function requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @param datetime-tz The date value to convert
        @return character An ISO date.      */
    method static public character ToISODateFromABL(input ptValue as datetime-tz):
        define variable cDateFormat as character no-undo.
        
        cDateFormat = session:date-format.
        session:date-format = 'ymd'.
        
        return iso-date(ptValue).
        finally:
            session:date-format = cDateFormat.        
        end finally.
    end method.
    
    /** Converts an ISO date into an ABL DATETIME-TZ. The ISO-DATE()
        requires the session's date format to be YMD before
        performing the conversion; this method wraps that.
        
        @param character An ISO date
        @return datetime-tz The date value to convert.      */
    method static public datetime-tz ToABLDateTimeFromISO(input pcValue as character):
        define variable cDateFormat as character no-undo.
        
        cDateFormat = session:date-format.
        session:date-format = 'ymd'.
        
        return datetime-tz(pcValue).
        finally:
            session:date-format = cDateFormat.        
        end finally.
    end method.
    
    method public datetime-tz ToDateTimeTz():
        return datetime-tz(mtDate, miTime, miTZOffset).
    end method.
        
    method public datetime ToDateTime():
        return datetime(mtDate, miTime).
    end method.

    method public date ToDate():
        return mtDate.
    end method.
    
    method public integer ToTime():
        return miTime.
    end method.
    
end class./** ------------------------------------------------------------------------
    Ignore        : VerifySchemaModeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Oct 12 14:29:25 EDT 2010
    Notes       : * Based on the ABL documentation
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.VerifySchemaModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.VerifySchemaModeEnum inherits EnumMember final: 

    define static public property Ignore as VerifySchemaModeEnum  no-undo get. private set.
    define static public property Loose as VerifySchemaModeEnum  no-undo get. private set.
    define static public property Strict as VerifySchemaModeEnum  no-undo get. private set.
    define static public property Default as VerifySchemaModeEnum  no-undo get. private set.
    
    constructor static VerifySchemaModeEnum():
        VerifySchemaModeEnum:Ignore = new VerifySchemaModeEnum('Ignore').
        VerifySchemaModeEnum:Loose = new VerifySchemaModeEnum('Loose').
        VerifySchemaModeEnum:Strict = new VerifySchemaModeEnum('Loose-Handle').
        VerifySchemaModeEnum:Default = VerifySchemaModeEnum:Loose.
    end constructor.
    
    constructor public VerifySchemaModeEnum(input pcName as character):
        super (input pcName).
    end constructor.     

    method static public VerifySchemaModeEnum EnumFromString(pcVerifyMode as character):
        define variable oMember as VerifySchemaModeEnum no-undo.
        
        case pcVerifyMode:
            when VerifySchemaModeEnum:Ignore:ToString() then oMember = VerifySchemaModeEnum:Ignore.
            when VerifySchemaModeEnum:Loose:ToString()  then oMember = VerifySchemaModeEnum:Loose.
            when VerifySchemaModeEnum:Strict:ToString() then oMember = VerifySchemaModeEnum:Strict.
        end case.
        
        return oMember.   
    end method.
end class./** ------------------------------------------------------------------------
    File        : WidgetHandle
    Purpose     : Primitive class for widget-handle variables    
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 19 09:47:07 EDT 2011
    Notes       : * Initial requirement for collections; having a class for the
                    primitive value means that we don't have to distinguish between
                    primitives and types, which makes the code more readable.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Lang.WidgetHandle.

using Progress.Lang.Class.
using Progress.Lang.Object.
 
class OpenEdge.Lang.WidgetHandle implements IExternalizable: 
    define static public property Type as class Class no-undo
        get():
            if not valid-object(WidgetHandle:Type) then
                WidgetHandle:Type = Class:GetClass('OpenEdge.Lang.WidgetHandle').
            
            return WidgetHandle:Type.
        end.
        private set.
        
    define public property Value as handle no-undo get. private set.
    
    constructor public WidgetHandle():
        this-object(?).
    end constructor.

    constructor public WidgetHandle(input phValue as handle):
        super().
        
        this-object:Value = phValue.
    end constructor.
    
    method override public logical Equals(input p0 as Object):
        if type-of(p0, WidgetHandle) then
            return (this-object:Value eq cast(p0, WidgetHandle):Value).
        else
            return super:Equals(p0).    
    end method.    
            
/** IExternalizable **/
	method public void ReadObject(input poStream as IObjectInput ):
        this-object:Value = poStream:ReadHandle().		
	end method.
	
	method public void WriteObject(input poStream as IObjectOutput):
	    poStream:WriteHandle(this-object:Value).
	end method.

end class./** ------------------------------------------------------------------------
    File        : DataSlotInstance
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jul 06 12:13:31 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.DataSlotInstance.
using OpenEdge.Lang.BPM.DataSlotTemplate.

using OpenEdge.Lang.BPM.DataSlotTemplate.
using OpenEdge.Lang.BPM.SavvionType.

using OpenEdge.Core.XML.SaxReader.
using OpenEdge.Core.XML.SaxWriter.

using Progress.Lang.Object.

class OpenEdge.Lang.BPM.DataSlotInstance inherits SavvionType:
    
    define public property Choices as character no-undo get. set.
    define public property ReadOnly as logical no-undo get. set.
    define public property WriteOnly as logical no-undo get. set.
    define public property Name as character no-undo get. set.
    define public property ProcessInstanceId as int64 no-undo get. set.
    define public property ProcessTemplateId as int64 no-undo get. set.
    /* This is an XML schema type, not an ABL type. */
    define public property Type as character no-undo get. set.
    define public property Value as longchar no-undo get. set.
        
    define static private temp-table DataSlotInstance no-undo
        field Choices as character
        field ReadOnly as logical
        field WriteOnly as logical
        field Name as character
        field ProcessInstanceId as int64
        field ProcessTemplateId as int64
        field Type as character
        field DataSlotValue as character label 'Value'
        field DataSlotInstance as Object
        index idx1 as primary Name
        index idx2 DataSlotInstance.
    
    constructor public DataSlotInstance():
        super().
    end constructor.
    
    /** Returns a table handle for the type; typically this is an empty
        table and is used in for serializing the SavvionType objects
        
        @param table-handle The output table handle for the type. */
    method static public void GetTable(output table-handle phTable):
        phTable = temp-table DataSlotInstance:handle.
    end method.
    
    /** Serializes the SavvionType object to the input buffer handle. 
        
        @param handle The buffer handle into which the object is serialised. */
    method override public void ObjectToBuffer(input phBuffer as handle):
        assign phBuffer::Choices = this-object:Choices
               phBuffer::ReadOnly = this-object:ReadOnly
               phBuffer::WriteOnly = this-object:WriteOnly
               phBuffer::Name = this-object:Name
               phBuffer::ProcessInstanceId = this-object:ProcessInstanceId
               phBuffer::ProcessTemplateId = this-object:ProcessTemplateId
               phBuffer::Type = this-object:Type
               phBuffer::DataSlotValue = this-object:Value
               phBuffer::DataSlotInstance = this-object.
    end method.
    
    /** Serializes this instance of the type to XML, using a SAXWriter object.
        
        @param SaxWriter The SAX writer used to serialize the object.
        @param longchar The namespace used. */
    method override public void ObjectToXML(input poSaxWriter as SaxWriter,
                                            input pcNamespace as longchar):
        SavvionType:WriteElement(poSaxWriter,
                                 'choices', this-object:Choices,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'isReadOnly', this-object:ReadOnly,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'isWriteOnly', this-object:WriteOnly,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'name', this-object:Name,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'piid', this-object:ProcessInstanceId,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'ptid', this-object:ProcessTemplateId,
                                 pcNamespace).       
        SavvionType:WriteElement(poSaxWriter,
                                 'type', this-object:Type,
                                 pcNamespace).                                 
        SavvionType:WriteElement(poSaxWriter,
                                 'value', this-object:Value,
                                 pcNamespace,
                                 this-object:Type).
    end method.
    
    method override public void ReadElement(input pcElementName as longchar,
                                            input pcValue as longchar ):
        case string(pcElementName):
            when 'choices' then this-object:Choices = pcValue.
            when 'isReadOnly' then this-object:ReadOnly = logical(pcValue).
            when 'isWriteOnly' then this-object:WriteOnly = logical(pcValue).
            when 'name' then this-object:Name = pcValue.
            when 'piid' then this-object:ProcessInstanceId = int64(pcValue).
            when 'ptid' then this-object:ProcessTemplateId = int64(pcValue).
            when 'type' then this-object:Type = pcValue.
            when 'value' then this-object:Value = pcValue.
        end case.
    end method.
    
end class.
/** ------------------------------------------------------------------------
    File        : DataSlotTemplate
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jul 06 12:13:31 EDT 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.DataSlotTemplate.
using OpenEdge.Lang.BPM.SavvionType.

using OpenEdge.Core.XML.SaxReader.
using OpenEdge.Core.XML.SaxWriter.
using OpenEdge.Core.XML.WebServiceProtocol.

using Progress.Lang.Object.

class OpenEdge.Lang.BPM.DataSlotTemplate inherits SavvionType: 
    define public property Choices as character no-undo get. set.
    define public property ReadOnly as logical no-undo get. set.
    define public property WriteOnly as logical no-undo get. set.
    define public property Name as character no-undo get. set.
    define public property ProcessTemplateId as int64 no-undo get. set.
    /* This is an XML schema type, not an ABL type. */
    define public property Type as character no-undo get. set.
    define public property Value as longchar no-undo get. set.
    
    define static private temp-table DataSlotTemplate no-undo
        field Choices as character
        field ReadOnly as logical
        field WriteOnly as logical
        field Name as character
        field ProcessTemplateId as int64
        field Type as character
        field DataSlotValue as character    label 'Value'
        field DataSlotTemplate as Object /* DataSlotTemplate */
        index idx1 as primary Name
        index idx2 DataSlotTemplate.
        
    
    constructor public DataSlotTemplate():
        super().
    end constructor.
    
    /** Returns a table handle for the type; typically this is an empty
        table and is used in for serializing the SavvionType objects
        
        @param table-handle The output table handle for the type. */
    method static public void GetTable(output table-handle phTable):
        phTable = temp-table DataSlotTemplate:handle.
    end method.
    
    /** Serializes the SavvionType object to the input buffer handle. 
        
        @param handle The buffer handle into which the object is serialised. */
    method override public void ObjectToBuffer(input phBuffer as handle):
        assign phBuffer::Choices = this-object:Choices
               phBuffer::ReadOnly = this-object:ReadOnly
               phBuffer::WriteOnly = this-object:WriteOnly
               phBuffer::Name = this-object:Name
               phBuffer::ProcessTemplateId = this-object:ProcessTemplateId
               phBuffer::Type = this-object:Type
               phBuffer::DataSlotValue = this-object:Value
               phBuffer::DataSlotInstance = this-object.
    end method.
    
    /** Serializes this instance of the type to XML, using a SAXWriter object.
        
        @param SaxWriter The SAX writer used to serialize the object.
        @param longchar The namespace used. */
    method override public void ObjectToXML(input poSaxWriter as SaxWriter,
                                            input pcNamespace as longchar):
        SavvionType:WriteElement(poSaxWriter,
                                 'choices', this-object:Choices,
                                 pcNamespace).
        
        SavvionType:WriteElement(poSaxWriter,
                                 'isReadOnly', this-object:ReadOnly,
                                 pcNamespace).
        
        SavvionType:WriteElement(poSaxWriter,
                                 'isWriteOnly', this-object:WriteOnly,
                                 pcNamespace).

        SavvionType:WriteElement(poSaxWriter,
                                 'name', this-object:Name,
                                 pcNamespace).

        SavvionType:WriteElement(poSaxWriter,
                                 'ptid', this-object:ProcessTemplateId,
                                 pcNamespace).
        
        SavvionType:WriteElement(poSaxWriter,
                                 'type', this-object:Type,
                                 pcNamespace).

        SavvionType:WriteElement(poSaxWriter,
                                 'value',
                                 this-object:Value,
                                 pcNamespace,this-object:Type).
    end method.
    
    method override public void ReadElement(input pcElementName as longchar,
                                            input pcValue as longchar ):
        case string(pcElementName):
            when 'choices' then this-object:Choices = pcValue.
            when 'isReadOnly' then this-object:ReadOnly = logical(pcValue).
            when 'isWriteOnly' then this-object:WriteOnly = logical(pcValue).
            when 'name' then this-object:Name = pcValue.
            when 'ptid' then this-object:ProcessTemplateId = int64(pcValue).
            when 'type' then this-object:Type = pcValue.
            when 'value' then this-object:Value = pcValue.
        end case.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : IBizLogicAPI
    Purpose     : ABL interface into the Savvion BizLogic API
    Syntax      :
    Description :
    @author pjudge
    Created     : Mon Nov 22 12:18:05 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
using OpenEdge.Lang.BPM.IBizLogicAPI.

using OpenEdge.Lang.BPM.ProcessTemplate.
using OpenEdge.Lang.BPM.ProcessInstance.
using OpenEdge.Lang.BPM.WorkItem.
using OpenEdge.Lang.BPM.WorkStepTemplate.
using OpenEdge.Lang.BPM.WorkStepInstance.
using OpenEdge.Lang.BPM.DataSlotTemplate.
using OpenEdge.Lang.BPM.DataSlotInstance.
using OpenEdge.Lang.BPM.Task.

interface OpenEdge.Lang.BPM.IBizLogicAPI:

    /* The Savvion Session ID */
    define public property SessionId as longchar no-undo get.

    /** Connects to a Savvion server, and establishes a session.

        @param character Username
        @param character Password  */
    method public void Login(input pcUser as character,
                             input pcPassword as character).

    /** Re-estaablishes an existing session without requiring a new login.

        @param longchar An existing session id. */
    method public void EstablishSession(input pcSessionId as longchar).

    /** Ends an existing session without performing a logout from the server. */
    method public void EndSession().

    /** Disconnects the specified session

        @param character A unique session id for the session. */
    method public void Logout().

    method public character GetStatus().

    method public ProcessTemplate GetProcessTemplate(input pcProcessTemplateName as character).

    method public ProcessTemplate GetProcessTemplate(input piProcessTemplateId as int64).

    method public logical IsSessionValid().

    method public ProcessTemplate extent GetUserAuthorizedProcessTemplateList().

    method public void CompleteWorkItem(input pcWorkItemName as character,
                                        input poDataSlotInstance as DataSlotInstance extent).

    method public void CompleteWorkItem(input piWorkItemInstanceId as int64,
                                        input poDataSlotInstance as DataSlotInstance extent).

    method public ProcessInstance extent GetProcessInstanceList().

    method public void AssignWorkItem(input pcWorkItemName as character,
                                      input pcPerformer as character).
    method public void AssignWorkItem(input piWorkItemInstanceId as int64,
                                      input pcPerformer as character).

    /* @param character A unique session id for the session. */
    method public int64 GetProcessTemplateID(input pcProcessTemplateName as character).

    /* @param character A unique session id for the session. */
    method public ProcessInstance CreateProcessInstance(input pcProcessTemplateName as character,
                                                        input pcProcessInstanceNamePrefix as character,
                                                        input pcPriority as character,
                                                        input poDataSlotTemplate as DataSlotTemplate extent).

    method public WorkStepInstance GetWorkStepInstance(input pcProcessInstanceName as character,
                                                       input pcWorkStepName as character).

    method public WorkStepInstance GetWorkStepInstance(input piProcessInstanceId as int64,
                                                       input pcWorkStepName as character).

    method public WorkStepTemplate GetWorkStepTemplate(input pcProcessTemplateName as character,
                                                       input pcWorkStepName as character).

    method public WorkItem extent GetAvailableWorkItemList().
    method public WorkItem extent GetAssignedWorkItemList().

    /** Tasks are not a complex type in Savvion, but are a logical type (workitems + their dataslots) */
    method public Task extent GetAvailableTasks().
    method public Task extent GetAssignedTasks().

    @todo(task="implement", action="").
    /* returns the tasks for a particular process (template, not instance)
    method public Task extent GetAvailableTasks(input piProcessTemplateId as int64).
    method public Task extent GetAssignedTasks(input piProcessTemplateId as int64).
    */

    /** Allows for lazy-loading of dataslots */
    method public Task extent CreateTasks(input poWorkItem as WorkItem extent).
    method public void CompleteTask(input poTask as Task).

    method public ProcessInstance GetProcessInstance(input pcProcessInstanceName as character).
    method public ProcessInstance GetProcessInstance(input piProcessInstanceId as int64).

    method public WorkItem GetWorkItem(input pcWorkItemName as character).
    method public WorkItem GetWorkItem(input piWorkItemInstanceId as int64).

    method public character extent GetProcessTemplateVersions(input pcApplicationName as character).

    method public void SetProcessInstancePriority(input pcProcessInstanceName as character,
                                                  input pcPriority as character).

    method public longchar GetProcessTemplateXML(input pcProcessTemplateName as character).

    method public void RemoveProcessTemplate(input pcProcessTemplateName as character).

    method public void ResumeProcessInstance(input pcProcessInstanceName as character).

    method public void SuspendProcessInstance(input pcProcessInstanceName as character).

    method public logical IsProcessTemplateExist(input pcProcessTemplateName as character).

    method public WorkItem extent GetProxyAssignedWorkItemList().

    method public WorkItem extent GetProxyAvailableWorkItemList().

    method public WorkItem extent GetSuspendedWorkItemList().

    method public character extent GetUserAuthorizedProcessTemplateNames().

    method public character GetProcessTemplateAppName(input pcProcessTemplateName as character).

    method public character GetProcessTemplateName(input pcProcessInstanceName as character).
    method public character GetProcessTemplateName(input piProcessTemplateId as int64).

    method public WorkSteptemplate extent GetProcessTemplateWorkSteps(input pcProcessTemplateName as character).

    method public DataSlotTemplate extent GetProcessTemplateDataSlots(input pcProcessTemplateName as character).

    method public DataSlotTemplate extent GetProcessTemplateDataSlot(input pcProcessTemplateName as character,
                                                                     input pcDataslotName as character extent).

    method public DataSlotInstance extent GetProcessInstanceDataSlots(input pcProcessInstanceName as character).

    method public DataSlotInstance extent GetProcessInstanceDataSlot(input pcProcessInstanceName as character,
                                                                     input pcDataslotName as character extent).

    method public DataSlotInstance extent GetProcessInstanceDataSlot(input piProcessInstanceId as int64,
                                                                     input pcDataslotName as character extent).

    method public DataSlotInstance extent GetWorkStepInstanceDataSlots(input pcProcessInstanceName as character,
                                                                       input pcWorkstepInstanceName as character).
    method public DataSlotInstance extent GetWorkStepInstanceDataSlots(input piProcessInstanceId as int64,
                                                                       input pcWorkstepInstanceName as character).

    method public DataSlotInstance extent GetWorkItemDataSlots(input pcWorkItemName as character).
    method public DataSlotInstance extent GetWorkItemDataSlots(input piWorkstepInstanceId as int64).

    method public DataSlotTemplate extent GetWorkStepTemplateDataSlots(input pcProcessTemplateName as character,
                                                                       input pcWorkStepName as character).
    method public DataSlotTemplate extent GetWorkStepTemplateDataSlots(input piProcessTemplateId as int64,
                                                                       input pcWorkStepName as character).

    method public void SetProcessTemplateDataSlotValue(input pcProcessTemplateName as character,
                                                       input poDataSlotTemplate as DataSlotTemplate).

    method public void SetProcessTemplateDataSlotsValue(input pcProcessTemplateName as character,
                                                        input poDataSlotTemplate as DataSlotTemplate extent).

    method public void SetProcessInstanceDataSlotValue(input pcProcessInstanceName as character,
                                                       input poDataSlotInstance as DataSlotInstance).

    method public void SetProcessInstanceDataSlotsValue(input pcProcessInstanceName as character,
                                                        input poDataSlotInstance as DataSlotInstance extent).

    method public void SetWorkItemDataSlotsValue(input pcWorkItemName as character,
                                                 input poDataSlotInstance as DataSlotInstance extent).

    method public void SetWorkItemDataSlotValue(input pcWorkItemName as character,
                                                input poDataSlotInstance as DataSlotInstance).

    method public void SetProcessInstanceDueDate(input pcProcessInstanceName as character,
                                                 input ptDueDate as datetime-tz).

    method public void SuspendWorkItem(input pcWorkItemName as character).

    method public void ResumeWorkItem(input pcWorkItemName as character).

    method public void ReassignWorkItem(input pcWorkItemName as character,
                                        input pcPerformer as character).
    method public void ReassignWorkItem(input piWorkItemInstanceId as int64,
                                        input pcPerformer as character).

    method public void MakeAvailableWorkItem(input pcWorkItemName as character,
                                             input pcPerformers as character extent).
    method public void MakeAvailableWorkItem(input piWorkItemInstanceId as int64,
                                             input pcPerformers as character extent).

    method public WorkStepInstance extent GetProcessInstanceWorkSteps(input pcProcessInstanceName as character).

    method public void SuspendWorkStepInstance(input pcProcessInstanceName as character,
                                               input pcWorkStepName as character).

    method public void ResumeWorkStepInstance(input pcProcessInstanceName as character,
                                              input pcWorkStepName as character).

    method public WorkSteptemplate extent GetStartWorkStepTemplate(input pcProcessTemplateName as character).

end interface./** ------------------------------------------------------------------------
    File        : PriorityEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 24 13:42:31 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.PriorityEnum.
using OpenEdge.Lang.EnumMember.


class OpenEdge.Lang.BPM.PriorityEnum inherits EnumMember:
    define static public property Low as PriorityEnum no-undo get. private set.     
    define static public property Medium as PriorityEnum no-undo get. private set.
    define static public property High as PriorityEnum no-undo get. private set.
    define static public property Critical as PriorityEnum no-undo get. private set.
    
    constructor static PriorityEnum():
        PriorityEnum:Low = new PriorityEnum('Low').
        PriorityEnum:Medium = new PriorityEnum('Medium').
        PriorityEnum:High = new PriorityEnum('High').
        PriorityEnum:Critical = new PriorityEnum('Critical').
    end constructor.

    constructor public PriorityEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public PriorityEnum EnumFromString(input pcName as character):
        define variable oEnum as PriorityEnum no-undo.
        
        case pcName:
            when PriorityEnum:Low:ToString() then oEnum = PriorityEnum:Low.
            when PriorityEnum:Medium:ToString() then oEnum = PriorityEnum:Medium.
            when PriorityEnum:High:ToString() then oEnum = PriorityEnum:High.
            when PriorityEnum:Critical:ToString() then oEnum = PriorityEnum:Critical.
        end case.
        return oEnum.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : ProcessInstance
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 06 12:11:46 EDT 2010
    Notes       : 
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.ProcessInstanceStateEnum.
using OpenEdge.Lang.BPM.ProcessInstance.
using OpenEdge.Lang.BPM.SavvionType.

using OpenEdge.Core.XML.SaxWriter.
using OpenEdge.Lang.TimeStamp.
using Progress.Lang.Object.

class OpenEdge.Lang.BPM.ProcessInstance inherits SavvionType:
    
    define public property Creator as character no-undo get. set.
    define public property DueDate as datetime-tz no-undo get. set.
    define public property Id as int64 no-undo get. set.
    define public property IsSubProcess as logical no-undo get. set.
    define public property IsSyncSubProcess as logical no-undo get. set.
    define public property Name as character no-undo get. set.
    define public property Priority as character no-undo get. set.
    define public property ProcessTemplateId as int64 no-undo get. set.
    define public property StartTime as datetime-tz no-undo get. set.
    define public property Status as ProcessInstanceStateEnum no-undo get. set.
    define public property SubProcess as logical no-undo get. set.
    define public property SyncSubProcess as logical no-undo get. set.
    
    define static private temp-table ProcessInstance no-undo
        field Creator as character
        field DueDate as datetime-tz
        field Id as int64 
        field IsSubProcess as logical 
        field IsSyncSubProcess as logical 
        field Name as character 
        field Priority as character 
        field ProcessTemplateId as int64 
        field StartTime as datetime-tz 
        field ProcessInstanceStatus as Object /* ProcessInstanceStateEnum */ label 'Status' 
        field SubProcess as logical
        field SyncSubProcess as logical 
        field ProcessInstance as Object /* ProcessInstance */
        index idx1 as primary Id
        index idx2 ProcessInstance.
    
    constructor public ProcessInstance():
        super().
    end constructor.

    /** Returns a table handle for the type; typically this is an empty
        table and is used in for serializing the SavvionType objects
        
        @param table-handle The output table handle for the type. */
    method static public void GetTable(output table-handle phTable):
        phTable = temp-table ProcessInstance:handle.
    end method.

    /** Serializes the SavvionType object to the input buffer handle. 
        
        @param handle The buffer handle into which the object is serialised. */
    method override public void ObjectToBuffer(input phBuffer as handle):
        assign phBuffer::Creator = this-object:Creator
               phBuffer::DueDate = this-object:DueDate
               phBuffer::Id = this-object:Id
               phBuffer::IsSubProcess = this-object:IsSubProcess
               phBuffer::IsSyncSubProcess = this-object:IsSyncSubProcess
               phBuffer::Name = this-object:Name
               phBuffer::Priority = this-object:Priority
               phBuffer::ProcessTemplateId = this-object:ProcessTemplateId
               phBuffer::StartTime = this-object:StartTime
               phBuffer::ProccessInstanceStatus = this-object:Status
               phBuffer::SubProcess = this-object:SubProcess
               phBuffer::SyncSubProcess = this-object:SyncSubProcess
               phBuffer::ProcessInstance = this-object.
    end method.

    method override public void ObjectToXML(input poSaxWriter as SaxWriter,
                                            input pcNamespace as longchar ):
        SavvionType:WriteElement(poSaxWriter,
                                 'creator', this-object:Creator,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'duedate', this-object:DueDate,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'id', this-object:Id,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'isSubProcess', this-object:IsSubProcess,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'isSyncSubProcess', this-object:IsSyncSubProcess,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'name', this-object:Name,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'priority', this-object:Priority, 
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'ptid', this-object:ProcessTemplateId,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'startTime', this-object:StartTime,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'status', this-object:Status:ToString(),
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'subProcess', this-object:SubProcess,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'syncSubProcess', this-object:SyncSubProcess,
                                 pcNamespace).
    end method.

    method override public void ReadElement(input pcElementName as longchar,
                                            input pcValue as longchar ):
        case string(pcElementName):
            when 'creator' then this-object:Creator= pcValue.
            when 'dueDate' then this-object:DueDate = TimeStamp:ToABLDateTimeFromISO(string(pcValue)).
            when 'id' then this-object:Id = int64(pcValue).
            when 'isSubProcess' then this-object:IsSubProcess = logical(pcValue).
            when 'isSyncSubProcess' then this-object:IsSyncSubProcess = logical(pcValue).
            when 'name' then this-object:Name = pcValue.
            when 'priority' then this-object:Priority = pcValue.
            when 'ptid' then this-object:ProcessTemplateId = int64(pcValue).
            when 'startTime' then this-object:StartTime = TimeStamp:ToABLDateTimeFromISO(string(pcValue)).
            when 'status' then this-object:Status = ProcessInstanceStateEnum:EnumFromString(string(pcValue)).
            when 'subProcess' then this-object:SubProcess = logical(pcValue).
            when 'syncSubProcess' then this-object:SyncSubProcess = logical(pcValue).
        end case.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : ProcessInstanceStateEnum
    Purpose     : Enumeration or process instance states
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 24 13:28:56 EST 2010
    Notes       : * As per Savvion documentation
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.ProcessInstanceStateEnum.
using OpenEdge.Lang.EnumMember.


class OpenEdge.Lang.BPM.ProcessInstanceStateEnum inherits EnumMember: 
    
    define static public property Created as ProcessInstanceStateEnum no-undo get. private set.
    define static public property Activated as ProcessInstanceStateEnum no-undo get. private set.
    define static public property Suspended as ProcessInstanceStateEnum no-undo get. private set.
    define static public property Complete as ProcessInstanceStateEnum no-undo get. private set.

    constructor static ProcessInstanceStateEnum():
        ProcessInstanceStateEnum:Created = new ProcessInstanceStateEnum('PI_CREATED').
        ProcessInstanceStateEnum:Activated = new ProcessInstanceStateEnum('PI_ACTIVATED').
        ProcessInstanceStateEnum:Suspended = new ProcessInstanceStateEnum('PI_SUSPENDED').
        ProcessInstanceStateEnum:Created = new ProcessInstanceStateEnum('PI_COMPLETE').
    end constructor.
    
    constructor public ProcessInstanceStateEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public ProcessInstanceStateEnum EnumFromString(input pcName as character):
        define variable oEnum as ProcessInstanceStateEnum no-undo.
        case pcName:
            when ProcessInstanceStateEnum:Created:ToString() then oEnum = ProcessInstanceStateEnum:Created.
            when ProcessInstanceStateEnum:Activated:ToString() then oEnum = ProcessInstanceStateEnum:Activated.
            when ProcessInstanceStateEnum:Suspended:ToString() then oEnum = ProcessInstanceStateEnum:Suspended.
            when ProcessInstanceStateEnum:Complete:ToString() then oEnum = ProcessInstanceStateEnum:Complete.
        end case.
        return oEnum.
    end method. 

end class./** ------------------------------------------------------------------------
    File        : ProcessTemplate
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 06 11:57:08 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.ProcessTemplateStateEnum.
using OpenEdge.Lang.BPM.ProcessTemplate.
using OpenEdge.Lang.BPM.SavvionType.

using OpenEdge.Core.XML.SaxWriter.
using OpenEdge.Lang.TimeStamp.
using Progress.Lang.Object.

class OpenEdge.Lang.BPM.ProcessTemplate inherits SavvionType:
     
    define public property AppName as character no-undo get. set.
    define public property Category as character no-undo get. set.
    define public property Description as character no-undo get. set.
    define public property Group as character no-undo get. set.
    define public property Id as int64 no-undo get. set.
    define public property Manager as character no-undo get. set.
    define public property Name as character no-undo get. set.
    define public property Priority as character no-undo get. set.
    define public property StartTime as datetime-tz no-undo get. set.
    define public property State as ProcessTemplateStateEnum no-undo get. set.
    
    define static private temp-table ProcessTemplate no-undo
        field AppName as character 
        field Category as character 
        field Description as character 
        field ProcessTemplateGroup as character label 'Group' 
        field Id as int64 
        field Manager as character 
        field Name as character 
        field Priority as character 
        field StartTime as datetime-tz
        field State as Object /*ProcessTemplateStateEnum*/
        field ProcessTemplate as Object /* ProcessTemplate */    
        index idx1 as primary Id
        index idx2 ProcessTemplate.

    constructor public ProcessTemplate():
        super().
    end constructor.
    
    /** Returns a table handle for the type; typically this is an empty
        table and is used in for serializing the SavvionType objects
        
        @param table-handle The output table handle for the type. */
    method static public void GetTable(output table-handle phTable):
        phTable = temp-table ProcessTemplate:handle.
    end method.

    /** Serializes the SavvionType object to the input buffer handle. 
        
        @param handle The buffer handle into which the object is serialised. */
    method override public void ObjectToBuffer(input phBuffer as handle):
        assign phBuffer::AppName = this-object:AppName
               phBuffer::Category = this-object:Category
               phBuffer::Description = this-object:Description
               phBuffer::ProcessTemplateGrou = this-object:Group
               phBuffer::Id = this-object:Id
               phBuffer::Manager = this-object:Manager
               phBuffer::Name = this-object:Name
               phBuffer::Priority = this-object:Priority
               phBuffer::StartTime = this-object:StartTime
               phBuffer::State = this-object:State
               phBuffer::ProcessTemplate = this-object.
    end method.

    method override public void ObjectToXML(input poSaxWriter as SaxWriter,
                                            input pcNamespace as longchar ):
        SavvionType:WriteElement(poSaxWriter,
                                 'appName', this-object:AppName,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'category', this-object:Category,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'description', this-object:Description,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'group', this-object:Group,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'id', this-object:Id,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'manager', this-object:Manager,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'name', this-object:Name,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'priority', this-object:Priority, 
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'startTime', this-object:StartTime,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'state', this-object:State:ToString(),
                                 pcNamespace).
    end method.

    method override public void ReadElement(input pcElementName as longchar,
                                            input pcValue as longchar ):
        case string(pcElementName):
            when 'appName' then this-object:AppName = pcValue.
            when 'category' then this-object:Category = pcValue.
            when 'description' then this-object:Description = pcValue.
            when 'group' then this-object:Group = pcValue.
            when 'id' then this-object:Id = int64(pcValue).
            when 'manager' then this-object:Manager = pcValue.
            when 'name' then this-object:Name = pcValue.
            when 'priority' then this-object:Priority = pcValue.
            when 'startTime' then this-object:StartTime = TimeStamp:ToABLDateTimeFromISO(string(pcValue)).
            when 'state' then this-object:State = ProcessTemplateStateEnum:EnumFromString(string(pcValue)).
        end case.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : ProcessTemplateStateEnum
    Purpose     : State enumeration for Process Template objects 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 24 13:22:26 EST 2010
    Notes       : * As per Savvion documentation
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.ProcessTemplateStateEnum.
using OpenEdge.Lang.EnumMember.


class OpenEdge.Lang.BPM.ProcessTemplateStateEnum inherits EnumMember: 

    define static public property Created as ProcessTemplateStateEnum no-undo get. private set.
    define static public property Installed as ProcessTemplateStateEnum no-undo get. private set.
    define static public property Suspended as ProcessTemplateStateEnum no-undo get. private set.

    constructor static ProcessTemplateStateEnum():
        ProcessTemplateStateEnum:Created = new ProcessTemplateStateEnum('P_CREATED').
        ProcessTemplateStateEnum:Installed = new ProcessTemplateStateEnum('P_INSTALLED').
        ProcessTemplateStateEnum:Suspended = new ProcessTemplateStateEnum('P_SUSPENDED').
    end constructor.
    
    constructor public ProcessTemplateStateEnum ( input pcName as character ):
        super (input pcName).
    end constructor.

    method static public ProcessTemplateStateEnum EnumFromString(input pcName as character):
        define variable oEnum as ProcessTemplateStateEnum no-undo.
        
        case pcName:
            when ProcessTemplateStateEnum:Created:ToString() then oEnum = ProcessTemplateStateEnum:Created.
            when ProcessTemplateStateEnum:Installed:ToString() then oEnum = ProcessTemplateStateEnum:Installed.
            when ProcessTemplateStateEnum:Suspended:ToString() then oEnum = ProcessTemplateStateEnum:Suspended.
        end case.
        
        return oEnum.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : SavvionType
    Purpose     : Common parent class for Savvion complex types like DataSlotInstances.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 23 11:10:25 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.SavvionType.

using OpenEdge.Core.XML.SaxWriter.
using OpenEdge.Core.XML.SaxReader.
using OpenEdge.Core.XML.WebServiceProtocol.

using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.SerializationModeEnum.
using OpenEdge.Lang.TimeStamp.
using OpenEdge.Lang.Assert.
using Progress.Lang.ParameterList.
using Progress.Lang.Class.


class OpenEdge.Lang.BPM.SavvionType abstract:
    
    define static private variable mcCurrentParseOperation as character no-undo.
    define static private variable mcCurrentParseElement as character no-undo.
    define static private variable moCurrentParseType as class Class no-undo.
    define static private variable moCurrentParseObject as SavvionType no-undo.
    define static private variable moCurrentParseCollection as ICollection no-undo.
    
    constructor public SavvionType ():
    end constructor.
    
    /** Serializes an array of SavvionType objects into XML.
        
        @param SaxWriter The SaxWriter object being used for the serialization
        @param longchar The (complex) element name for the array
        @param longchar The namespace in use
        @param DataSlotInstance[] The array of dataslots being serialized.  */
    method static void ArrayToXml(input poSaxWriter as SaxWriter,
                                  input pcElementName as longchar,
                                  input pcNamespace as longchar,  
                                  input poSavvionType as SavvionType extent):   
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poSavvionType).
        if iMax gt 0 then
        do:
            do iloop = 1 to iMax:
                poSaxWriter:StartElement(substitute('&1:&2', pcNamespace, pcElementName)).
                poSavvionType[iLoop]:ObjectToXML(poSaxWriter, pcNamespace).
                poSaxWriter:EndElement(substitute('&1:&2', pcNamespace, pcElementName)).
            end.
        end.        
    end method.
    
    /** Serializes an array of characters into XML.
        
        @param SaxWriter The SaxWriter object being used for the serialization
        @param longchar The (complex) element name for the array
        @param longchar The namespace in use
        @param longchar[] The array of character values being serialized.  */
    method static void ArrayToXml(input poSaxWriter as SaxWriter,
                                  input pcElementName as longchar,
                                  input pcNamespace as longchar,  
                                  input pcValue as longchar extent):   
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(pcValue).
        if iMax gt 0 then
        do iloop = 1 to iMax:
            SavvionType:WriteElement(poSaxWriter, pcElementName, pcValue[iLoop], pcNamespace).
        end.
    end method.
    
    /** Serializes this instance of the type to XML, using a SAXWriter object.
        
        @param SaxWriter The SAX writer used to serialize the object.
        @param longchar The namespace used. */
    method abstract public void ObjectToXML(input poSaxWriter as SaxWriter,
                                            input pcNamespace as longchar  ).

    /** Serializes an array of SavvionType objects into a table.
        
        @param Class The concrete type of the SavvionType being serialised.
        @param SavvionType[] An array of Savvion types to serialise as a table
        @param table-handle The output table handle. */    
    method static void ArrayToTable(input poType as class Class,
                                    input poSavvionType as SavvionType extent,
                                    output table-handle phTable):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oPL as ParameterList no-undo.
        define variable hBuffer as handle no-undo.
        
        oPL = new ParameterList(1).
        oPL:SetParameter(1,
                         IOModeEnum:TableHandle:ToString(),
                         IOModeEnum:Output:ToString(),
                         phTable).
        poType:Invoke('GetTable', oPL).
        hBuffer = phTable:default-buffer-handle.
        
        iMax = extent(poSavvionType).
        do iLoop = 1 to iMax
           transaction:
            hBuffer:buffer-create().
            poSavvionType[iLoop]:ObjectToBuffer(hBuffer).
            hBuffer:buffer-release().
        end.
    end method.
    
    /** Returns a table handle for the type; typically this is an empty
        table and is used in for serializing the SavvionType objects
        
        @param table-handle The output table handle for the type. 
    method abstract public void GetTable(output table-handle phTable).
        */
    
    /** Serializes the SavvionType object to the input buffer handle. 
        
        @param handle The buffer handle into which the object is serialised. */
    method abstract public void ObjectToBuffer(input phBuffer as handle).
        

    /** Helper method that writes an element to the SaxWriter.
    
        @param SaxWriter The SAX writer in use
        @param longchar The name of the element being written
        @param longchar The element's value
        @param longchar The namespace used. */ 
    method static protected void WriteElement(input poSaxWriter as SaxWriter,
                                              input pcElementName as longchar,
                                              input pcValue as longchar,
                                              input pcNamespace as longchar):
        SavvionType:WriteElement(
                poSaxWriter,
                pcElementName,
                pcValue,
                pcNamespace,
                ? /* value type */).
    end method.

    /** Helper method for writing logical/boolean elements.
        
        @param SaxWriter The SAX writer in use
        @param longchar The name of the element being written
        @param logical The element's value
        @param longchar The namespace used. */ 
    method static protected void WriteElement(input poSaxWriter as SaxWriter,
                                              input pcElementName as longchar,
                                              input plValue as logical,
                                              input pcNamespace as longchar):
        SavvionType:WriteElement(
            poSaxWriter,
            pcElementName,
            string(plValue, 'true/false'),
            pcNamespace).                                                  
    end method.

    /** Helper method for writing datetime elements.
        
        @param SaxWriter The SAX writer in use
        @param longchar The name of the element being written
        @param datetime-tz The element's value
        @param longchar The namespace used. */ 
    method static protected void WriteElement(input poSaxWriter as SaxWriter,
                                              input pcElementName as longchar,
                                              input ptValue as datetime-tz,
                                              input pcNamespace as longchar):
        SavvionType:WriteElement(
            poSaxWriter,
            pcElementName,
            TimeStamp:ToISODateFromABL(ptValue),
            pcNamespace).                                                  
    end method.

    /** Helper method for writing int64 elements.
        
        @param SaxWriter The SAX writer in use
        @param longchar The name of the element being written
        @param int64 The element's value
        @param longchar The namespace used. */ 
    method static protected void WriteElement(input poSaxWriter as SaxWriter,
                                              input pcElementName as longchar,
                                              input piValue as int64,
                                              input pcNamespace as longchar):
        SavvionType:WriteElement(
            poSaxWriter,
            pcElementName,
            string(piValue),
            pcNamespace).                                                  
    end method.
    
    /** Helper method that writes an element to the SaxWriter.
    
        @param SaxWriter The SAX writer in use
        @param longchar haracter The name of the element being written
        @param longchar The element's value
        @param longchar The namespace used. 
        @param longchar The Type of the value being written. This will add an attribute
               to the element indicating the type of the value. */
    method static protected void WriteElement(input poSaxWriter as SaxWriter,
                                              input pcElementName as longchar,
                                              input pcValue as longchar,
                                              input pcNamespace as longchar,
                                              input pcValueType as longchar):
        poSaxWriter:StartElement(substitute('&1:&2', pcNamespace, pcElementName)).
        
        if pcValue eq ? or pcValue eq '' then
            poSaxWriter:InsertAttribute("xsi:nil", "true").
        else
        do:
            if pcValueType ne ? and pcValueType ne '' then
                poSaxWriter:InsertAttribute("xsi:type", substitute('xsd:&1', WebServiceProtocol:XmlTypeFromABL(pcValueType))).
            
            poSaxWriter:WriteValue(pcValue).
        end.
        
        poSaxWriter:EndElement(substitute('&1:&2', pcNamespace, pcElementName)).
    end method.
    
    /** Passes data from the SAX Reader/Parser into the SavvionType object,
        where it will be set (probably) to a property of that object.    
        
        @param longchar The name of the element whose data we're reading 
        @param longchar The data value */
    method abstract void ReadElement(input pcElementName as longchar,
                                     input pcValue as longchar).
                                                                         
    /** Converts a SOAP message to an array of objects.
        
        @param longchar The XML message in longchar format (likely how it returns from the WebService)
        @param longchar The WebServices operation name
        @param Progress.Lang.Class The actual/concrete type to create.
        @return SavvionType[] An array of objects of that type, containing data. */
    method static SavvionType extent XMLToArray(input pcDocument as longchar,
                                                input pcOperationName as longchar,
                                                input poOutputType as class Class):
        define variable oSavvionType as SavvionType extent no-undo.
        define variable oSaxReader as SaxReader no-undo.
        
        Assert:ArgumentIsType(
                    poOutputType,
                    Class:GetClass('OpenEdge.Lang.BPM.SavvionType')).
        
        SavvionType:moCurrentParseType = poOutputType.
        SavvionType:mcCurrentParseOperation = pcOperationName.
        if valid-object(SavvionType:moCurrentParseObject) then
            SavvionType:moCurrentParseCollection:Clear().
        else
            SavvionType:moCurrentParseCollection = new Collection().

        oSaxReader = new SaxReader().
        
        oSaxReader:SaxReaderStartElement:Subscribe(SavvionType:SaxReaderStartElementHandler).
        oSaxReader:SaxReaderEndElement:Subscribe(SavvionType:SaxReaderEndElementHandler).
        oSaxReader:SaxReaderCharacters:Subscribe(SavvionType:SaxReaderCharactersHandler).
        
        oSaxReader:ParseDocument(pcDocument).
        
        return cast(SavvionType:moCurrentParseCollection:ToArray(), SavvionType).
        finally:
            SavvionType:moCurrentParseType = ?.
            SavvionType:moCurrentParseCollection:Clear().
            SavvionType:moCurrentParseObject = ?.
            SavvionType:mcCurrentParseOperation = ''.
            SavvionType:mcCurrentParseElement = ''.
            
            oSaxReader:SaxReaderStartElement:Unsubscribe(SavvionType:SaxReaderStartElementHandler).
            oSaxReader:SaxReaderEndElement:Unsubscribe(SavvionType:SaxReaderEndElementHandler).
            oSaxReader:SaxReaderCharacters:Unsubscribe(SavvionType:SaxReaderCharactersHandler).
        end finally.
    end method.
    
    /** START-ELEMENT event handler for the SAX-READER. Method implemented as per 
        ABL documentation.  */
    method static void SaxReaderStartElementHandler(input phSaxReader    as handle,
                                                    input pcNamespaceURI as longchar,
                                                    input pcLocalName    as longchar,
                                                    input pcQName        as longchar,
                                                    input phAttributes   as handle):
        define variable oType as SavvionType no-undo.
        
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        case string(pcLocalName):
            when (SavvionType:mcCurrentParseOperation + 'Response') then .
            when (SavvionType:mcCurrentParseOperation + 'Return') then
            do:
                SavvionType:moCurrentParseObject = cast(SavvionType:moCurrentParseType:New(), SavvionType).
                SavvionType:moCurrentParseCollection:Add(SavvionType:moCurrentParseObject).
            end.
            otherwise
            do:
                SavvionType:mcCurrentParseElement = pcLocalName.
                
                /* If the value is nill/null/known, then pass that through to the object */         
                iMax = phAttributes:num-items.
                do iLoop = 1 to iMax:
                    case phAttributes:get-qname-by-index(iLoop):
                        when 'xsi:nil' then
                            if logical(phAttributes:get-value-by-index(iLoop)) then
                                SavvionType:moCurrentParseObject:ReadElement(pcLocalName, ?).
                    end case.
                end.
            end.
        end case.
    end method.
    
    /** END-ELEMENT event handler for the SAX-READER. Method implemented as per 
        ABL documentation.  */
    method static void SaxReaderEndElementHandler(input phSaxReader as handle,
                                                  input pcName as longchar,
                                                  input pcPublicID as longchar,                                                  
                                                  input pcSystemID as longchar):                                                                
        case string(pcName):
            when (SavvionType:mcCurrentParseOperation + 'Response') then .
            /* when closing the <operation>Return element, we can let go of the SavvionType, since we're done with it. */
            when (SavvionType:mcCurrentParseOperation + 'Return') then
                SavvionType:moCurrentParseObject = ?.
        end case.
        
        SavvionType:mcCurrentParseElement = ''.             
    end method.

    /** CHARACTERS event handler for the SAX-READER. Method implemented as per 
        ABL documentation.  */
    method static void SaxReaderCharactersHandler(input phSaxReader as handle,
                                                  input pcCharData as longchar,
                                                  input piNumChars as integer):
        SavvionType:moCurrentParseObject:ReadElement(SavvionType:mcCurrentParseElement, pcCharData).
        
        catch oError as Progress.Lang.Error:
            message program-name(1) program-name(2) skip(2)
                oError:GetMessage(1) skip
            view-as alert-box error title '[PJ DEBUG]'.
            
            undo, throw oError.
        end catch.
    end method.
    
end class./*------------------------------------------------------------------------
    File        : Task
    Purpose     : An OEBPM Task - composed of a WorkItem and its associated
                  DataSlotInstances
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jul 14 10:34:40 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.WorkItem.
using OpenEdge.Lang.BPM.DataSlotInstance.
using OpenEdge.Lang.BPM.Task.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap. 
using OpenEdge.Lang.Assert.
using OpenEdge.Lang.String.
using Progress.Lang.Class.
using Progress.Lang.Object.


class OpenEdge.Lang.BPM.Task:
    define public property WorkItem as WorkItem no-undo get. private set.
    
    define public property DataSlots as IMap no-undo
        get():
            if not valid-object(DataSlots) then
                DataSlots = new TypedMap(
                                    String:Type,
                                    Class:GetClass('OpenEdge.Lang.BPM.DataSlotInstance')).
            return DataSlots.
        end get.
        private set.
    
    constructor public Task(input poWorkItem as WorkItem,
                            input poDataSlots as DataSlotInstance extent):
        super().
        
        this-object:WorkItem = poWorkItem.
        AddDataSlots(poDataSlots).
    end constructor.

    constructor public Task(poWorkItem as WorkItem):
        define variable oDummy as DataSlotInstance extent no-undo.
        
        this-object(poWorkItem, oDummy).
    end constructor.
    
    method public void AddDataSlots(input poDataSlots as DataSlotInstance extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poDataSlots).
        do iLoop = 1 to iMax:
            DataSlots:Put(new String(poDataSlots[iLoop]:Name), poDataSlots[iLoop]). 
        end.
    end method.

    method public longchar GetDataSlotValue(input pcDataSlotName as character):
        define variable oDSI as DataSlotInstance no-undo.
        define variable cValue as longchar no-undo.
        
        oDSI = cast(DataSlots:Get(new String(pcDataSlotName)), DataSlotInstance).
        Assert:ArgumentNotNull(oDSI, substitute('Dataslot &1', pcDataSlotName)).
        
        return oDSI:Value. 
    end method.
        
    method public void SetDataSlotValue(input pcDataSlotName as character,
                                        input pcDataSlotValue as longchar):
        cast(DataSlots:Get(new String(pcDataSlotName)), DataSlotInstance):value = pcDataSlotValue.
    end method.
    
    method override public logical Equals(input p0 as Object):
        define variable lEquals as logical no-undo.
        
		lEquals = super:Equals(input p0).
        if not lEquals then
            lEquals = type-of(p0, Task).

        if lEquals then
            lEquals = this-object:WorkItem:Equals(cast(p0, Task):WorkItem).
        
        return lEquals.            
	end method.
    
end class./** ------------------------------------------------------------------------
    File        : WorkFlowWebService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jul 02 15:16:37 EDT 2010
    Notes       : * Some of the operations herein - particularly those that have
                    primitive and/or void arguments (in and out) use the RUN syntax
                    and let the ABL perform the datatype transformations.
                    The other operations - those that use the complex types descended
                    from the SavvionType - construct SOAP messages coming and going. 
                    There are currently no mixed-mode calls (where the inputs are primitives and
                    the outputs SOAP) although that's probably a candidate for refactoring.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.IBizLogicAPI.
using OpenEdge.Lang.BPM.WorkFlowWebService.
using OpenEdge.Lang.BPM.SavvionType.
using OpenEdge.Lang.BPM.ProcessTemplate.
using OpenEdge.Lang.BPM.ProcessInstance.
using OpenEdge.Lang.BPM.WorkItem.
using OpenEdge.Lang.BPM.WorkStepTemplate.
using OpenEdge.Lang.BPM.WorkStepInstance.
using OpenEdge.Lang.BPM.DataSlotTemplate.
using OpenEdge.Lang.BPM.DataSlotInstance.
using OpenEdge.Lang.BPM.Task.

using OpenEdge.Core.XML.WebServiceProtocol.
using OpenEdge.Core.XML.SaxWriter.

using OpenEdge.Lang.Assert.
using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.Lang.BPM.WorkFlowWebService inherits WebServiceProtocol
        implements IBizLogicAPI:
    
    define private variable mcPortType as character initial 'WorkFlowWS' no-undo.
    define private variable moSaxWriter as SaxWriter no-undo.
    define private variable mhSoapMessage as memptr no-undo.
    
    /* The Savvion Session ID */
    define public property SessionId as longchar no-undo get. protected set.
    
    constructor public WorkFlowWebService(input pcHost as character):
        super('WorkFlowService',
              substitute('&1/sbm/services/BizLogic1?wsdl', pcHost),
              '').
        
        InitializeSaxWriter().
    end constructor.
    
    destructor public WorkFlowWebService():
        set-size(mhSoapMessage) = 0.
    end destructor.
    
/*  BizLogicAPI implementations */
    /** Re-estaablishes an existing session without requiring a new login.
        
        @param longchar An existing session id. */
    method public void EstablishSession(input pcSessionId as longchar):
        SessionId = pcSessionId.
    end method.
    
    /** Ends an existing session without performing a logout from the server. */
    method public void EndSession():
        SessionId = ''.
    end method.
    
    method public void Login(input pcUser as character,
                             input pcPassword as character):
        define variable cSessionId as longchar no-undo.
        
        ConnectService().
        
        run connect in ConnectPortType(mcPortType) (
                input pcUser,
                input pcPassword,
                output cSessionId).
        
        EstablishSession(cSessionId).
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void Logout():
        Assert:ArgumentNotNullOrEmpty(this-object:SessionId, 'Session Id').
        
        ConnectService().
        
        run disconnect in ConnectPortType(mcPortType) (input this-object:SessionId).
        
        EndSession().
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.
    end method.
            
    method public character GetStatus().
        define variable cStatus as character no-undo.
        
        ConnectService().
        
        run getStatus in ConnectPortType(mcPortType) (output cStatus).
        
        return cStatus.        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public ProcessTemplate GetProcessTemplate(input pcProcessTemplateName as character):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPT as SavvionType extent no-undo.
        define variable cOutputParam as longchar no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplate'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        
        oPT = SavvionType:XMLToArray(cOutputParam,
                                     cOperation,
                                     Class:GetClass('OpenEdge.Lang.BPM.ProcessTemplate')).
        
        return cast(oPT[1] , ProcessTemplate).                                                             
    end method.
    
    method public logical IsSessionValid().
        define variable lValidSession as logical no-undo.
        
        ConnectService().
        
        run isSessionValid in ConnectPortType(mcPortType) (input this-object:SessionId, output lValidSession).
        
        return lValidSession.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public ProcessTemplate extent GetUserAuthorizedProcessTemplateList():
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPT as ProcessTemplate extent no-undo.
        define variable cOutputParam as longchar no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getUserAuthorizedProcessTemplateList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).

        return cast(SavvionType:XMLToArray(
                        cOutputParam,
                        cOperation,
                        Class:GetClass('OpenEdge.Lang.BPM.ProcessTemplate'))
                , ProcessTemplate).    
    end method.
    
    method public void CompleteTask(input poTask as Task):
        CompleteWorkItem(
            poTask:WorkItem:Id,
            cast(poTask:DataSlots:Values:ToArray(), DataSlotInstance)).
    end method.
            
    method public void CompleteWorkItem(input pcWorkItemName as character,
                                        input poDataSlotInstance as DataSlotInstance extent):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'completeWorkItem'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
            if extent(poDataSlotInstance) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsi',
                                       cNamespace,
                                       poDataSlotInstance).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
    
    method public ProcessInstance extent GetProcessInstanceList():
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.ProcessInstance')).                         
        
        return cast(oPI, ProcessInstance).
    end method.
            
    method public void AssignWorkItem(input pcWorkItemName as character,
                                      input pcPerformer as character):
        ConnectService().
        
        run assignWorkItem in ConnectPortType(mcPortType) (
                    input this-object:SessionId,
                    input pcWorkItemName,
                    input pcPerformer).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public int64 GetProcessTemplateID(input pcProcessTemplateName as character):
        define variable cPTId as int64 no-undo.
        
        ConnectService().
        
        run getProcessTemplateID in ConnectPortType(mcPortType) (
                    input this-object:SessionId,
                    input pcProcessTemplateName,
                    output cPTId).
                    
        return cPTId.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public ProcessInstance CreateProcessInstance(input pcProcessTemplateName as character,
                                                        input pcProcessInstanceNamePrefix as character,
                                                        input pcPriority as character,
                                                        input poDataSlotTemplate as DataSlotTemplate extent):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'createProcessInstance'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            WriteElement('piNamePrefix', pcProcessInstanceNamePrefix, cNamespace).
            WriteElement('priority', pcPriority, cNamespace).
            if extent(poDataSlotTemplate) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dst',
                                       cNamespace,
                                       poDataSlotTemplate).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.ProcessInstance')).                         
        
        return cast(oPI[1], ProcessInstance).
    end method.
            
    method public WorkStepInstance GetWorkStepInstance(input pcProcessInstanceName as character,
                                                       input pcWorkStepName as character):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWSI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepInstance'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWSI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkStepInstance')).
        
        return cast(oWSI[1], WorkStepInstance).
    end method.
            
    method public WorkStepTemplate GetWorkStepTemplate(input pcProcessTemplateName as character,
                                                       input pcWorkStepName as character):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepTemplate'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkStepTemplate')).
        
        return cast(oWST[1], WorkStepTemplate).
    end method.
    
    method public WorkItem extent GetAvailableWorkItemList():
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getAvailableWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
    
    
    method public Task extent GetAvailableTasks():
        return CreateTasks(GetAvailableWorkItemList()).
    end method.
    
    method public Task extent GetAssignedTasks():
        return CreateTasks(GetAssignedWorkItemList()).
    end method.
    
    /** Allows for lazy-loading of dataslots */
    method public Task extent CreateTasks(input poWorkItem as WorkItem extent).
        define variable oTask as Task extent no-undo.
        define variable oDSI as DataSlotInstance extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poWorkItem).
        extent(oTask) = iMax.
                
        do iLoop = 1 to iMax:
            oDSI = GetWorkItemDataSlots(poWorkItem[iLoop]:Id).
            oTask[iLoop] = new Task(poWorkItem[iLoop], oDSI).
        end.
        
        return oTask.
    end method.
            
    method public WorkItem extent GetAssignedWorkItemList().
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getAssignedWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
            
    method public ProcessInstance GetProcessInstance(input pcProcessInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstance'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.ProcessInstance')).                         
        
        return cast(oPI[1], ProcessInstance).
    end method.
            
    method public WorkItem GetWorkItem(input pcWorkItemName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkItem'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkItem')).
        
        return cast(oWI[1], WorkItem).
    end method.
            
    method public character extent GetProcessTemplateVersions(input pcApplicationName as character).
        
        define variable cPTVersion as character extent no-undo. 
         
        ConnectService().
        
        run getProcessTemplateVersions in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcApplicationName,
                 output cPTVersion).
        
        return cPTVersion.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public void SetProcessInstancePriority(input pcProcessInstanceName as character,
                                                  input pcPriority as character).
        ConnectService().
        
        run setProcessInstancePriority in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessInstanceName,
                 input pcPriority).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public longchar GetProcessTemplateXML(input pcProcessTemplateName as character).
        define variable cOutputParam as longchar no-undo.
        
        ConnectService().
        
        run getProcessTemplateXML in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessTemplateName,
                 output cOutputParam).
        
        return cOutputParam.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public void RemoveProcessTemplate(input pcProcessTemplateName as character).
        ConnectService().
        
        run removeProcessTemplate in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessTemplateName).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public void ResumeProcessInstance(input pcProcessInstanceName as character).
        ConnectService().
        
        run resumeProcessInstance in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessInstanceName).

        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public void SuspendProcessInstance(input pcProcessInstanceName as character).
        ConnectService().
        
        run suspendProcessInstance in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessInstanceName).

        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public logical IsProcessTemplateExist(input pcProcessTemplateName as character).
        define variable lPTExists as logical no-undo.
        
        ConnectService().
        
        run isProcessTemplateExist in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessTemplateName,
                 output lPTExists).

        return lPTExists.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public WorkItem extent GetProxyAssignedWorkItemList().
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProxyAssignedWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
            
    method public WorkItem extent GetProxyAvailableWorkItemList().
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProxyAvailableWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
            
    method public WorkItem extent GetSuspendedWorkItemList().
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getSuspendedWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
            
    method public character extent GetUserAuthorizedProcessTemplateNames().
        define variable cTemplateName as character extent no-undo.
        
        ConnectService().
        
        run getUserAuthorizedProcessTemplateNames in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 output cTemplateName).

        return cTemplateName.                 
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public character GetProcessTemplateAppName(input pcProcessTemplateName as character).
        define variable cAppName as character no-undo.
        
        ConnectService().
        
        run getProcessTemplateAppName in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessTemplateName,
                 output cAppName).

        return cAppName.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public character GetProcessTemplateName(input pcProcessInstanceName as character).
        define variable cTemplateName as character no-undo.
        
        ConnectService().
        
        run getProcessTemplateNameFromProcessInstance in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessInstanceName,
                 output cTemplateName).

        return cTemplateName.                 
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public character GetProcessTemplateName(input piProcessTemplateId as int64).
        define variable cTemplateName as character no-undo.
        
        ConnectService().
        
        run getProcessTemplateNameFromProcessInstance in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input piProcessTemplateId,
                 output cTemplateName).

        return cTemplateName.                 
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public WorkStepTemplate extent GetProcessTemplateWorkSteps(input pcProcessTemplateName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplateWorkSteps'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkStepTemplate')).
        
        return cast(oWST, WorkStepTemplate).
    end method.
            
    method public ProcessTemplate GetProcessTemplate(input piProcessTemplateId as int64).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPT as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplateFromID'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptid', string(piProcessTemplateId), cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPT = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.ProcessTemplate')).
        
        return cast(oPT[1], ProcessTemplate).
    end method.
            
    method public DataSlotTemplate extent GetProcessTemplateDataSlots(input pcProcessTemplateName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplateDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.DataSlotTemplate')).
        
        return cast(oDST, DataSlotTemplate).
    end method.
            
    method public DataSlotTemplate extent GetProcessTemplateDataSlot(input pcProcessTemplateName as character,
                                                                     input pcDataslotName as character extent).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplateDataSlot'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            if extent(pcDataslotName) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsName',
                                       cNamespace,
                                       pcDataslotName).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.DataSlotTemplate')).
        
        return cast(oDST, DataSlotTemplate).
    end method.
            
    method public DataSlotInstance extent GetProcessInstanceDataSlots(input pcProcessInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetProcessInstanceDataSlot(input pcProcessInstanceName as character,
                                                                     input pcDataslotName as character extent).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceDataSlot'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            if extent(pcDataslotName) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsName',
                                       cNamespace,
                                       pcDataslotName).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetProcessInstanceDataSlot(input piProcessInstanceId as int64,
                                                                             input pcDataslotName as character extent).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceDataSlotFromPiid'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piid', string(piProcessInstanceId), cNamespace).
            if extent(pcDataslotName) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsName',
                                       cNamespace,
                                       pcDataslotName).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetWorkStepInstanceDataSlots(input pcProcessInstanceName as character,
                                                                       input pcWorkstepInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepInstanceDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            WriteElement('wsName', pcWorkstepInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetWorkStepInstanceDataSlots(input piProcessInstanceId as int64,
                                                                               input pcWorkstepInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepInstanceDataSlotsFromPiid'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piid', string(piProcessInstanceId), cNamespace).
            WriteElement('wsiName', pcWorkstepInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetWorkItemDataSlots(input pcWorkItemName as character):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable cOutputParam as longchar no-undo.
        define variable oDataSlotInstance as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkItemDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam =  ExecuteOperation(mcPortType,
                                         cOperation,
                                         SoapMessageToLongchar()).
        
        oDataSlotInstance = SavvionType:XMLToArray(
                                cOutputParam,
                                cOperation,
                                Class:GetClass('OpenEdge.Lang.BPM.DataSlotInstance')).
        
        return cast(oDataSlotInstance, DataSlotInstance). 
    end method.
            
    method public DataSlotInstance extent GetWorkItemDataSlots(input piWorkstepInstanceId as int64):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable cOutputParam as longchar no-undo.
        define variable oDataSlotInstance as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkItemDataSlotsFromWIID'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('wiid', string(piWorkstepInstanceId), cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam =  ExecuteOperation(mcPortType,
                                         cOperation,
                                         SoapMessageToLongchar()).
        
        oDataSlotInstance = SavvionType:XMLToArray(
                                cOutputParam,
                                cOperation,
                                Class:GetClass('OpenEdge.Lang.BPM.DataSlotInstance')).

        
        return cast(oDataSlotInstance, DataSlotInstance). 
    end method.
            
    method public DataSlotTemplate extent GetWorkStepTemplateDataSlots(input pcProcessTemplateName as character,
                                                                       input pcWorkStepName as character):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable cOutputParam as longchar no-undo.
        define variable oDataSlotTemplate as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepTemplateDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam =  ExecuteOperation(mcPortType,
                                         cOperation,
                                         SoapMessageToLongchar()).
        
        oDataSlotTemplate = SavvionType:XMLToArray(
                                cOutputParam,
                                cOperation,
                                Class:GetClass('OpenEdge.Lang.BPM.DataSlotTemplate')).
        
        return cast(oDataSlotTemplate, DataSlotTemplate). 
    end method.
    
    method public DataSlotTemplate extent GetWorkStepTemplateDataSlots(input piProcessTemplateId as int64,
                                                                               input pcWorkStepName as character):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable cOutputParam as longchar no-undo.
        define variable oDataSlotTemplate as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepTemplateDataSlotsFromPtid'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptid', string(piProcessTemplateId), cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam =  ExecuteOperation(mcPortType,
                                         cOperation,
                                         SoapMessageToLongchar()).
        
        oDataSlotTemplate = SavvionType:XMLToArray(
                                cOutputParam,
                                cOperation,
                                Class:GetClass('OpenEdge.Lang.BPM.DataSlotTemplate')).
        
        return cast(oDataSlotTemplate, DataSlotTemplate).    
    end method.
            
    method public void SetProcessTemplateDataSlotValue(input pcProcessTemplateName as character,
                                                       input poDataSlotTemplate as DataSlotTemplate):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setProcessTemplateDataSlotValue'.
        extent(oST) = 1.
        oST[1] = poDataSlotTemplate.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dst',
                                   cNamespace,
                                   oST).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public void SetProcessTemplateDataSlotsValue(input pcProcessTemplateName as character,
                                                        input poDataSlotTemplate as DataSlotTemplate extent).
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setProcessTemplateDataSlotsValue'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dst',
                                   cNamespace,
                                   poDataSlotTemplate).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
    
    method public void SetProcessInstanceDataSlotValue(input pcProcessInstanceName as character,
                                                       input poDataSlotInstance as DataSlotInstance):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setProcessTemplateDataSlotValue'.
        extent(oST) = 1.
        oST[1] = poDataSlotInstance.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dsi',
                                   cNamespace,
                                   oST).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public void SetProcessInstanceDataSlotsValue(input pcProcessInstanceName as character,
                                                        input poDataSlotInstance as DataSlotInstance extent):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setProcessInstanceDataSlotsValue'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dsi',
                                   cNamespace,
                                   poDataSlotInstance).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public void SetWorkItemDataSlotsValue(input pcWorkItemName as character,
                                                 input poDataSlotInstance as DataSlotInstance extent).
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setWorkItemDataSlotsValue'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dsi',
                                   cNamespace,
                                   poDataSlotInstance).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public void SetWorkItemDataSlotValue(input pcWorkItemName as character,
                                                input poDataSlotInstance as DataSlotInstance).
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setWorkItemDataSlotValue'.
        extent(oST) = 1.
        oST[1] = poDataSlotInstance.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dsi',
                                   cNamespace,
                                   oST).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public ProcessInstance GetProcessInstance(input piProcessInstanceId as int64):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceFromID'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piid', string(piProcessInstanceId), cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.ProcessInstance')).
        
        return cast(oPI[1], ProcessInstance).
    end method.
            
    method public void SetProcessInstanceDueDate(input pcProcessInstanceName as character,
                                                 input ptDueDate as datetime-tz):
        ConnectService().
        
        run setProcessInstanceDueDate in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessInstanceName,
                 input ptDueDate).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public WorkItem GetWorkItem(input piWorkItemInstanceId as int64):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkItemFromID'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('wiid', string(piWorkItemInstanceId), cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkItem')).
        
        return cast(oWI[1], WorkItem).
    end method.
            
    method public void SuspendWorkItem(input pcWorkItemName as character).

        ConnectService().
        
        run suspendWorkItem in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcWorkItemName).        
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
                
    method public void ResumeWorkItem(input pcWorkItemName as character).
        ConnectService().
        
        run resumeWorkItem in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcWorkItemName).        
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void AssignWorkItem(input piWorkItemInstanceId as int64,
                                              input pcPerformer as character).
        ConnectService().
        
        run assignWorkItemFromWiid in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input piWorkItemInstanceId,
                 input pcPerformer).        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void ReassignWorkItem(input pcWorkItemName as character,
                                        input pcPerformer as character).
        ConnectService().
        
        run reassignWorkItem in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcWorkItemName,
                 input pcPerformer).        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
          
    method public void ReassignWorkItem(input piWorkItemInstanceId as int64,
                                                input pcPerformer as character).
        ConnectService().
        
        run reassignWorkItemFromWiid in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input piWorkItemInstanceId,
                 input pcPerformer).        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void MakeAvailableWorkItem(input pcWorkItemName as character,
                                             input pcPerformers as character extent).
        ConnectService().
        
        run makeAvailableWorkItem in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcWorkItemName,
                 input pcPerformers).        
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void MakeAvailableWorkItem(input piWorkItemInstanceId as int64,
                                                     input pcPerformers as character extent).
        ConnectService().
        
        run makeAvailableWorkItemFromWiid in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input piWorkItemInstanceId,
                 input pcPerformers).
                   
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void CompleteWorkItem(input piWorkItemInstanceId as int64,
                                                input poDataSlotInstance as DataSlotInstance extent).
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'completeWorkItemFromWIID'.
        
        StartSoapMessage(cOperation, cNamespace).        
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('wiid', string(piWorkItemInstanceId), cNamespace).        
            if extent(poDataSlotInstance) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsi',
                                       cNamespace,
                                       poDataSlotInstance).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
    
    method public WorkStepInstance GetWorkStepInstance(input piProcessInstanceId as int64,
                                                               input pcWorkStepName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWSI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepInstanceFromPiid'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piid', string(piProcessInstanceId), cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWSI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkStepInstance')).
        
        return cast(oWSI[1], WorkStepInstance).
    end method.
    
    method public WorkStepInstance extent GetProcessInstanceWorkSteps(input pcProcessInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWSI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceWorkSteps'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWSI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkStepInstance')).
        
        return cast(oWSI, WorkStepInstance).
    end method.
    
    method public void SuspendWorkStepInstance(input pcProcessInstanceName as character,
                                               input pcWorkStepName as character).
        ConnectService().
        
        run suspendWorkStepInstance in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessInstanceName,
                 input pcWorkStepName).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void ResumeWorkStepInstance(input pcProcessInstanceName as character,
                                              input pcWorkStepName as character).
        ConnectService().
        
        run resumeWorkStepInstance in ConnectPortType(mcPortType)
                (input this-object:SessionId,
                 input pcProcessInstanceName,
                 input pcWorkStepName).        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public WorkStepTemplate extent GetStartWorkStepTemplate(input pcProcessTemplateName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getStartWorkStepTemplate'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', this-object:SessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.Lang.BPM.WorkStepTemplate')).
        
        return cast(oWST, WorkStepTemplate).
    end method.
    
/* SOAP Message Helper methods */
    method protected void InitializeSaxWriter():   
        moSaxWriter = new SaxWriter().
        moSaxWriter:IsFragment = true.
        moSaxWriter:IsStrict = false.
        /* for debugging 
        moSaxWriter:IsFormatted = true.
        */
        
        moSaxWriter:WriteTo(mhSoapMessage).
    end method.
    
    method protected void ResetSaxWriter():
        if not moSaxWriter:Reset() then
            InitializeSaxWriter().
        
        /* no leaks, please */
        set-size(mhSoapMessage) = 0.        
    end method.
    
    method protected void StartSoapMessage(input pcElementName as character,
                                           input pcNamespace as character):
        ResetSaxWriter().
        
        moSaxWriter:StartDocument().
        moSaxWriter:StartElement(substitute('&1:&2', pcNamespace, pcElementName)).
        
        /* standard namespaces */
        moSaxWriter:DeclareNamespace("http://workflow.webservice.savvion.com", pcNamespace).
        moSaxWriter:DeclareNamespace("http://www.w3.org/2001/XMLSchema-instance", 'xsi').        
        moSaxWriter:DeclareNamespace("http://www.w3.org/2001/XMLSchema", 'xsd').
    end method.

    method protected void WriteElement(input pcElementName as character,
                                       input pcValue as longchar,
                                       input pcNamespace as character):
        moSaxWriter:StartElement(substitute('&1:&2', pcNamespace, pcElementName)).
        moSaxWriter:WriteValue(pcValue).
        moSaxWriter:EndElement(substitute('&1:&2', pcNamespace, pcElementName)).
    end method.
    
    method protected void EndSoapMessage(input pcElementName as character,
                                         input pcNamespace as character):
        moSaxWriter:EndElement(substitute('&1:&2', pcNamespace, pcElementName)).
        moSaxWriter:EndDocument().
    end method.
    
    /** Converts the current soap message to LONGCHAR for use as an operation.
        
        @return longchar The current SOAP message.  */
    method protected longchar SoapMessageToLongchar():        
        define variable cMessage as longchar no-undo.
        
        copy-lob mhSoapMessage to cMessage.
        set-size(mhSoapMessage) = 0.
        
        return cMessage.
    end method.
        
end class./** ------------------------------------------------------------------------
    File        : WorkItem
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 06 11:59:56 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.WorkItem.
using OpenEdge.Lang.BPM.PriorityEnum.
using OpenEdge.Lang.BPM.WorkItemStatusEnum.  
using OpenEdge.Lang.BPM.SavvionType.

using OpenEdge.Core.XML.SaxWriter.
using OpenEdge.Lang.TimeStamp.
using Progress.Lang.Object.

class OpenEdge.Lang.BPM.WorkItem inherits SavvionType:
    
    define public property DueDate as datetime-tz no-undo get. set.
    define public property Id as int64 no-undo get. set.
    define public property Name as character no-undo get. set.
    define public property Performer as character no-undo get. set.
    define public property ProcessInstanceCreator as character no-undo get. set.
    define public property ProcessInstanceName as character no-undo get. set.
    define public property ProcessInstanceId as int64 no-undo get. set.
    define public property Priority as PriorityEnum no-undo get. set.
    define public property ProcessTemplateId as int64 no-undo get. set.
    define public property Status as WorkItemStatusEnum no-undo get. set.
    define public property TimeStarted as datetime-tz no-undo get. set.
    define public property WorkStepName as character no-undo get. set.
    
    define static private temp-table WorkItem no-undo
        field DueDate as datetime-tz
        field Id as int64
        field Name as character
        field Performer as character
        field ProcessInstanceCreator as character
        field ProcessInstanceName as character
        field ProcessInstanceId as int64
        field Priority as Object /*PriorityEnum*/ 
        field ProcessTemplateId as int64
        field WorkStepStatus as Object /*WorkItemStatusEnum*/ label 'Status'
        field TimeStarted as datetime-tz
        field WorkStepName as character
        field WorkItem as Object    /* WorkItem */
        index idx1 as primary Id
        index idx2 WorkItem.

    constructor public WorkItem():
        super().
    end constructor.

    /** Returns a table handle for the type; typically this is an empty
        table and is used in for serializing the SavvionType objects
        
        @param table-handle The output table handle for the type. */
    method static public void GetTable(output table-handle phTable):
        phTable = temp-table WorkItem:handle.
    end method.
    
    /** Serializes the SavvionType object to the input buffer handle. 
        
        @param handle The buffer handle into which the object is serialised. */
    method override public void ObjectToBuffer(input phBuffer as handle):
        assign phBuffer::DueDate = this-object:DueDate
               phBuffer::Id = this-object:Id
               phBuffer::Name = this-object:Name
               phBuffer::Performer = this-object:Performer
               phBuffer::ProcessInstanceCreator = this-object:ProcessInstanceCreator
               phBuffer::ProcessInstanceName = this-object:ProcessInstanceName
               phBuffer::ProcessInstanceId = this-object:ProcessInstanceId
               phBuffer::Priority = this-object:Priority
               phBuffer::ProcessTemplateId = this-object:ProcessTemplateId
               phBuffer::WorkItemStatus = this-object:Status
               phBuffer::TimeStarted = this-object:TimeStarted
               phBuffer::WorkStepName = this-object:WorkStepName
               phBuffer::WorkItem = this-object.
    end method.
    
    method override public void ObjectToXML(input poSaxWriter as SaxWriter,
                                            input pcNamespace as longchar ):
        SavvionType:WriteElement(poSaxWriter,
                                 'duedate', this-object:DueDate,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'id', this-object:Id,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'name', this-object:Name,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'performer', this-object:Performer,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'piCreator', this-object:ProcessInstanceCreator,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'piName', this-object:ProcessInstanceName,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'piid', this-object:ProcessInstanceId,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'priority', this-object:Priority:ToString(), 
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'ptid', this-object:ProcessTemplateId,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'status', this-object:Status:ToString(),
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'timeStarted', this-object:TimeStarted,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'wsName', this-object:WorkStepName,
                                 pcNamespace).
    end method.
    
    method override public void ReadElement(input pcElementName as longchar,
                                            input pcValue as longchar ):
        case string(pcElementName):
            when 'duedate' then this-object:DueDate = TimeStamp:ToABLDateTimeFromISO(string(pcValue)).
            when 'id' then this-object:Id = int64(pcValue).
            when 'name' then this-object:Name = pcValue.
            when 'performer' then this-object:Performer = pcValue.
            when 'piCreator' then this-object:ProcessInstanceCreator = pcValue.
            when 'piName' then this-object:ProcessInstanceName = pcValue.
            when 'piid' then this-object:ProcessInstanceId = int64(pcValue).
            when 'priority' then this-object:Priority = PriorityEnum:EnumFromString(string(pcValue)).
            when 'ptid' then this-object:ProcessTemplateId = int64(pcValue).
            when 'status' then this-object:Status = WorkItemStatusEnum:EnumFromString(string(pcValue)).
            when 'timeStarted' then this-object:TimeStarted = TimeStamp:ToABLDateTimeFromISO(string(pcValue)).
            when 'wsName' then this-object:WorkStepName = pcValue.
        end case.
    end method.
    
    method override public logical Equals( input p0 as Object ):
        define variable lEquals as logical no-undo.
        
        lEquals = super:Equals(input p0).
        if not lEquals then
            lEquals = type-of(p0, WorkItem).
        if lEquals then
            lEquals = this-object:Id eq cast(p0, WorkItem):Id.
        
        return lEquals.

	end method.

end class./** ------------------------------------------------------------------------
    File        : WorkItemWorkItemStatusEnum
    Purpose     : Enumeration of BixLogic Status types  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 24 13:14:52 EST 2010
    Notes       : * As per Savvion doc.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.WorkItemStatusEnum. 
using OpenEdge.Lang.EnumMember.


class OpenEdge.Lang.BPM.WorkItemStatusEnum inherits EnumMember: 

    define static public property Created as WorkItemStatusEnum no-undo get. private set.
    define static public property Assigned as WorkItemStatusEnum no-undo get. private set.
    define static public property Available as WorkItemStatusEnum no-undo get. private set.
    define static public property Suspended as WorkItemStatusEnum no-undo get. private set.
    define static public property Completed as WorkItemStatusEnum no-undo get. private set.
    define static public property Removed as WorkItemStatusEnum no-undo get. private set.
    
    constructor static WorkItemStatusEnum():
        WorkItemStatusEnum:Created = new WorkItemStatusEnum('I_CREATED').
        WorkItemStatusEnum:Assigned = new WorkItemStatusEnum('I_ASSIGNED').
        WorkItemStatusEnum:Available = new WorkItemStatusEnum('I_AVAILABLE').
        WorkItemStatusEnum:Suspended  = new WorkItemStatusEnum('I_SUSPENDED').
        WorkItemStatusEnum:Completed  = new WorkItemStatusEnum('I_COMPLETED').
        WorkItemStatusEnum:Removed = new WorkItemStatusEnum('I_REMOVED').
    end constructor.
    
    constructor public WorkItemStatusEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public WorkItemStatusEnum EnumFromString(input pcName as character):
        define variable oEnum as WorkItemStatusEnum no-undo.
        
        case pcName:
            when WorkItemStatusEnum:Created:ToString() then oEnum = WorkItemStatusEnum:Created.
            when WorkItemStatusEnum:Assigned:ToString() then oEnum = WorkItemStatusEnum:Assigned.
            when WorkItemStatusEnum:Available:ToString() then oEnum = WorkItemStatusEnum:Available.
            when WorkItemStatusEnum:Suspended:ToString() then oEnum = WorkItemStatusEnum:Suspended.
            when WorkItemStatusEnum:Completed:ToString() then oEnum = WorkItemStatusEnum:Completed.
            when WorkItemStatusEnum:Removed:ToString() then oEnum = WorkItemStatusEnum:Removed. 
        end case.
        
        return oEnum.
    end method.
    
end class./** ------------------------------------------------------------------------
   File        : WorkStepInstance
   Purpose     : 
   Syntax      : 
   Description : 
   @author pjudge
   Created     : Tue Jul 06 12:05:15 EDT 2010
   Notes       : 
 ---------------------------------------------------------------------- */
routine-level on error undo, throw.
  
using OpenEdge.Lang.BPM.WorkItem.
using OpenEdge.Lang.BPM.SavvionType.

using OpenEdge.Core.XML.SaxWriter.
using OpenEdge.Lang.TimeStamp.
using Progress.Lang.Object.
 
class OpenEdge.Lang.BPM.WorkStepInstance inherits SavvionType:
     
    define public property DueDate as datetime-tz no-undo get. set.
    define public property LoopCounter as integer no-undo get. set.
    define public property Name as character no-undo get. set.
    define public property Performer as character no-undo get. set.
    define public property ProcessInstanceName as character no-undo get. set.
    define public property ProcessInstanceId as int64 no-undo get. set.
    define public property Priority as character no-undo get. set.
    define public property ProcessTemplateId as int64 no-undo get. set.
    define public property StartTime as datetime-tz no-undo get. set.
    define public property Status as character no-undo get. set.
    define public property Type as character no-undo get. set.
    
    define static private temp-table WorkStepInstance no-undo
        field DueDate as datetime-tz 
        field LoopCounter as integer 
        field Name as character 
        field Performer as character 
        field ProcessInstanceName as character 
        field ProcessInstanceId as int64 
        field Priority as character 
        field ProcessTemplateId as int64 
        field StartTime as datetime-tz 
        field WorkStepInstanceStatus as character label 'Status' 
        field Type as character
        field WorkStepInstance as Object /* WorkStepInstance */
        index idx1 as primary Name
        index idx2 WorkStepInstance.
    
    constructor public WorkStepInstance():
        super().
    end constructor.
    
    /** Returns a table handle for the type; typically this is an empty
        table and is used in for serializing the SavvionType objects
        
        @param table-handle The output table handle for the type. */
    method static public void GetTable(output table-handle phTable):
        phTable = temp-table WorkStepInstance:handle.
    end method.

    /** Serializes the SavvionType object to the input buffer handle. 
        
        @param handle The buffer handle into which the object is serialised. */
    method override public void ObjectToBuffer(input phBuffer as handle):
        assign phBuffer::DueDate = this-object:DueDate
               phBuffer::LoopCounter = this-object:LoopCounter
               phBuffer::Name = this-object:Name
               phBuffer::Performer = this-object:Performer
               phBuffer::ProcessInstanceName = this-object:ProcessInstanceName
               phBuffer::ProcessInstanceId = this-object:ProcessInstanceId
               phBuffer::Priority = this-object:Priority
               phBuffer::ProcessTemplateId = this-object:ProcessTemplateId
               phBuffer::StartTime = this-object:StartTime
               phBuffer::WorkStepInstanceStatus = this-object:Status
               phBuffer::Type = this-object:Type
               phBuffer::WorkStepInstance = this-object.
    end method.    
    
    method override public void ObjectToXML(input poSaxWriter as SaxWriter,
                                            input pcNamespace as longchar ):
        SavvionType:WriteElement(poSaxWriter,
                                 'duedate', this-object:DueDate,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'loopCounter', this-object:LoopCounter,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'name', this-object:Name,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'performer', this-object:Performer,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'piName', this-object:ProcessInstanceName,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'piid', this-object:ProcessInstanceId,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'priority', this-object:Priority, 
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'ptid', this-object:ProcessTemplateId,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'startTime', this-object:StartTime,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'status', this-object:Status,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'type', this-object:Type,
                                 pcNamespace).
    end method.

    method override public void ReadElement(input pcElementName as longchar,
                                            input pcValue as longchar ):
        case string(pcElementName):
            when 'duedate' then this-object:DueDate = TimeStamp:ToABLDateTimeFromISO(string(pcValue)).
            when 'loopCounter' then this-object:LoopCounter = int(pcValue).
            when 'name' then this-object:Name = pcValue.
            when 'performer' then this-object:Performer = pcValue.
            when 'piName' then this-object:ProcessInstanceName = pcValue.
            when 'piid' then this-object:ProcessInstanceId = int64(pcValue).
            when 'priority' then this-object:Priority = pcValue.
            when 'ptid' then this-object:ProcessTemplateId = int64(pcValue).
            when 'startTime' then this-object:StartTime = TimeStamp:ToABLDateTimeFromISO(string(pcValue)).
            when 'status' then this-object:Status = pcValue.
            when 'type' then this-object:Type = pcValue.
        end case.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : WorkStepTemplate
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 06 12:03:30 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.WorkStepTemplateTypeEnum.
using OpenEdge.Lang.BPM.WorkItem.
using OpenEdge.Lang.BPM.SavvionType.

using OpenEdge.Core.XML.SaxWriter.
using OpenEdge.Lang.TimeStamp.
using Progress.Lang.Object.

class OpenEdge.Lang.BPM.WorkStepTemplate inherits SavvionType:
    
    define public property Duration as int64 no-undo get. set.
    define public property Name as character no-undo get. set.
    define public property Performer as character no-undo get. set.
    define public property Priority as character no-undo get. set.
    define public property ProcessTemplateId as int64 no-undo get. set.
    define public property Type as WorkStepTemplateTypeEnum no-undo get. set.
    
    define static private temp-table WorkStepTemplate no-undo
        field Duration as int64
        field Name as character
        field Performer as character 
        field Priority as character 
        field ProcessTemplateId as int64 
        field Type as Object /* WorkStepTemplateTypeEnum */ 
        field WorkStepTemplate as Object /* WorkStepTemplate */
        index idx1 as primary name
        index idx2 WorkStepTemplate.

    constructor public WorkStepTemplate():
        super().
    end constructor.
    
    /** Returns a table handle for the type; typically this is an empty
        table and is used in for serializing the SavvionType objects
        
        @param table-handle The output table handle for the type. */
    method static public void GetTable(output table-handle phTable):
        phTable = temp-table WorkStepTemplate:handle.
    end method.

    /** Serializes the SavvionType object to the input buffer handle. 
        
        @param handle The buffer handle into which the object is serialised. */
    method override public void ObjectToBuffer(input phBuffer as handle):
        assign phBuffer::Duration = this-object:Duration
               phBuffer::Name = this-object:Name
               phBuffer::Performer = this-object:Performer
               phBuffer::Priority = this-object:Priority
               phBuffer::ProcessTemplateId = this-object:ProcessTemplateId
               phBuffer::Type = this-object:Type
               phBuffer::WorkStepTemplate = this-object.
    end method.
    
    method override public void ObjectToXML(input poSaxWriter as SaxWriter,
                                            input pcNamespace as longchar ):
        SavvionType:WriteElement(poSaxWriter,
                                 'duration', this-object:Duration,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'name', this-object:Name,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter, 
                                 'performer', this-object:Performer,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'priority', this-object:Priority, 
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'ptid', this-object:ProcessTemplateId,
                                 pcNamespace).
        SavvionType:WriteElement(poSaxWriter,
                                 'type', this-object:Type:ToString(),
                                 pcNamespace).
    end method.

    method override public void ReadElement(input pcElementName as longchar,
                                            input pcValue as longchar ):
        case string(pcElementName):
            when 'duration' then this-object:Duration = int(pcValue).
            when 'name' then this-object:Name = pcValue.
            when 'performer' then this-object:Performer = pcValue.
            when 'priority' then this-object:Priority = pcValue.
            when 'ptid' then this-object:ProcessTemplateId = int64(pcValue).
            when 'type' then this-object:Type = WorkStepTemplateTypeEnum:EnumFromString(string(pcValue)).
        end case.
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : WorkStepTemplateTypeEnum
    Purpose     : Enumeration of WorkStepTemplate types
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 24 13:34:42 EST 2010
    Notes       : * As per Savvion documentation
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.BPM.WorkStepTemplateTypeEnum.
using OpenEdge.Lang.EnumMember.


class OpenEdge.Lang.BPM.WorkStepTemplateTypeEnum inherits EnumMember:
    
    define static public property Start as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property End as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property OrJoin as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property AndJoin as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property ParallelSplit as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property DecisionSplit as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property Atomic as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property External as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property WebService as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property MessageDriven as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property Notification as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property Nested as WorkStepTemplateTypeEnum no-undo get. private set.
    define static public property Delay as WorkStepTemplateTypeEnum no-undo get. private set.
        
    constructor static WorkStepTemplateTypeEnum():
        WorkStepTemplateTypeEnum:Start = new WorkStepTemplateTypeEnum('START').
        WorkStepTemplateTypeEnum:End = new WorkStepTemplateTypeEnum('END').
        WorkStepTemplateTypeEnum:OrJoin = new WorkStepTemplateTypeEnum('OR-JOIN').
        WorkStepTemplateTypeEnum:AndJoin = new WorkStepTemplateTypeEnum('AND-JOIN').
        WorkStepTemplateTypeEnum:ParallelSplit = new WorkStepTemplateTypeEnum('PARALLEL-SPLIT').
        WorkStepTemplateTypeEnum:DecisionSplit = new WorkStepTemplateTypeEnum('DECISION-SPLIT').
        WorkStepTemplateTypeEnum:Atomic = new WorkStepTemplateTypeEnum('ATOMIC').
        WorkStepTemplateTypeEnum:External = new WorkStepTemplateTypeEnum('EXTERNAL').
        WorkStepTemplateTypeEnum:WebService = new WorkStepTemplateTypeEnum('WEBSERVICE').
        WorkStepTemplateTypeEnum:MessageDriven = new WorkStepTemplateTypeEnum('MESSAGEDRIVEN').
        WorkStepTemplateTypeEnum:Notification = new WorkStepTemplateTypeEnum('NOTIFICATION').
        WorkStepTemplateTypeEnum:Nested = new WorkStepTemplateTypeEnum('NESTED').
        WorkStepTemplateTypeEnum:Delay = new WorkStepTemplateTypeEnum('DELAY').
    end constructor.        
        
    constructor public WorkStepTemplateTypeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method static public WorkStepTemplateTypeEnum EnumFromString(input pcName as character):
        define variable oEnum as WorkStepTemplateTypeEnum no-undo.
        
        case pcName:
            when WorkStepTemplateTypeEnum:Start:ToString() then oEnum = WorkStepTemplateTypeEnum:Start.
            when WorkStepTemplateTypeEnum:End:ToString() then oEnum = WorkStepTemplateTypeEnum:End.
            when WorkStepTemplateTypeEnum:OrJoin:ToString() then oEnum = WorkStepTemplateTypeEnum:OrJoin.
            when WorkStepTemplateTypeEnum:AndJoin:ToString() then oEnum = WorkStepTemplateTypeEnum:AndJoin.
            when WorkStepTemplateTypeEnum:ParallelSplit:ToString() then oEnum = WorkStepTemplateTypeEnum:ParallelSplit.
            when WorkStepTemplateTypeEnum:DecisionSplit:ToString() then oEnum = WorkStepTemplateTypeEnum:DecisionSplit.
            when WorkStepTemplateTypeEnum:Atomic:ToString() then oEnum = WorkStepTemplateTypeEnum:Atomic.
            when WorkStepTemplateTypeEnum:External:ToString() then oEnum = WorkStepTemplateTypeEnum:External.
            when WorkStepTemplateTypeEnum:WebService:ToString() then oEnum = WorkStepTemplateTypeEnum:WebService.
            when WorkStepTemplateTypeEnum:MessageDriven:ToString() then oEnum = WorkStepTemplateTypeEnum:MessageDriven.
            when WorkStepTemplateTypeEnum:Notification:ToString() then oEnum = WorkStepTemplateTypeEnum:Notification.
            when WorkStepTemplateTypeEnum:Nested:ToString() then oEnum = WorkStepTemplateTypeEnum:Nested.
            when WorkStepTemplateTypeEnum:Delay:ToString() then oEnum = WorkStepTemplateTypeEnum:Delay.
        end case.
        return oEnum.
    end method.
    
end class./*------------------------------------------------------------------------------
    File        : AbstractTTCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 22:41:40 EST 2007
    Notes       : This is an ABL specific abstraction that uses only dynamic 
                  constructs to access temp-tables and buffers in order to 
                  allow it to be reused by subclasses that have different 
                  temp-tables.  
                - The most important behavioral encapsulation/reuse provided by 
                  this is the management of the size().               
------------------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.Lang.Collections.AbstractTTCollection.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.Iterator.
 
class OpenEdge.Lang.Collections.AbstractTTCollection abstract implements ICollection: 

   /*---------------------------------------------------------------------------
    Purpose: Abstract collection class                                                                
    Notes:   All temp-table operations are dynamic
             Subclasses should define internal temp-table and pass the 
             handle to super the constructor. They must override 
             findBufferUseObject (see below) and could also override other 
             methods with static code for performance.                   
    --------------------------------------------------------------------------*/
    define private variable mhTempTable     as handle no-undo. 
    define private variable mhDefaultBuffer as handle no-undo.      
    define private variable mhField         as handle no-undo. 

    define public property Size as integer no-undo get. private set.
    
    /* pass Collection  */ 
    constructor protected AbstractTTCollection (poCol as ICollection,phtt as handle,pcField as char):
        this-object(phtt,pcField).
        poCol:ToTable(output table-handle phtt).
        Size = poCol:Size.  
    end constructor.
    
    /* pass temp-table handle and name of object field */ 
    constructor protected AbstractTTCollection ( phtt as handle, pcField as char ):
        this-object(phtt,phtt:default-buffer-handle:buffer-field(pcField)).
    end constructor.

    /* pass temp-table handle and object field */ 
    constructor protected AbstractTTCollection (phtt as handle, hField as handle ):
        super ().
        assign
            mhTempTable     = phtt
            mhDefaultBuffer = phtt:default-buffer-handle
            mhField         = hField.
    end constructor.
     
     method public logical Add( newObject as Object):
        if valid-object(newObject) then
        do:
            mhDefaultBuffer:buffer-create().
            assign
                mhField:buffer-value = newObject  
                Size = Size + 1.    
            mhDefaultBuffer:buffer-release().
            return true.
        end.
        return false.
    end method.
    
    method public logical AddArray(objectArray as Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(objectArray).
        do iLoop = 1 to iMax:
            this-object:Add(objectArray[iLoop]).
        end.
        
        return true.
    end method.
    
    method public logical AddAll(newCollection as ICollection):
        define variable iterator as IIterator no-undo.
        if newCollection:getClass():Equals(getClass()) then
        do:
            newCollection:ToTable(output table-handle mhTempTable append).
            Size = Size + newCollection:Size.
        end.
        else do:
            iterator = newCollection:iterator(). 
            do while iterator:hasNext():
                this-object:Add(iterator:Next()).
            end.                                       
        end.    
        return true. 
    end method.
    
    method public void Clear(  ):
        mhTempTable:default-buffer-handle:empty-temp-table.        
    end method.
    
    method public abstract logical Contains( checkObject as Object ).        
    
    /* Returns a new IIterator over the collection. */
    method public IIterator Iterator( ):    
        return new Iterator(this-object,mhTempTable,mhField:name).
    end method.
     
    method public logical IsEmpty(  ):
        return not (mhTempTable:has-records).
    end method.

    method public void ToTable( output table-handle tt ):
        tt = mhTempTable.
    end method.
    
    method public logical Remove( oldObject as Object ):
        FindBufferUseObject(oldObject).
        if mhDefaultBuffer:avail then
        do:
            mhDefaultBuffer:buffer-delete(). 
            Size = Size - 1.
            return true.
        end.    
        return false.
    end method.
    
    method public logical RemoveAll(collection as ICollection):
        define variable iterator as IIterator. 
        define variable oRemove  as Object. 
        define variable lAny as logical no-undo.        
        iterator = collection:iterator().
        do while iterator:HasNext():
            oRemove = iterator:Next().
            do while Remove(oRemove):
                lAny = true.
            end.    
        end.
        return lAny.
    end method.
    
    method public logical RetainAll(oCol as ICollection):
        define variable iterator as IIterator no-undo.
        define variable oChild as Object no-undo.  
        define variable lAny as logical no-undo.        
        iterator = Iterator().
        do while iterator:HasNext():
            oChild = iterator:Next().
            if not oCol:Contains(oChild) then 
            do:
                do while Remove(oChild):
                    lAny = true.
                end.
            end.     
        end.                                     
        return lAny.     
    end method.
    
    /* ToArray should not be used with large collections
       If there is too much data the ABL will throw:  
       Attempt to update data exceeding 32000. (12371) */
    method public Object extent ToArray():
        define variable i as integer no-undo.
        define variable oObjArray as Object extent no-undo.
        define variable iterator as IIterator no-undo.   
         
        if Size eq 0 then
            return oObjArray.
        
        extent(oObjarray) = Size.
        iterator = Iterator(). 
        do while iterator:hasNext():
           i = i + 1.
           oObjArray[i] = iterator:Next().  
        end.                                     
        return oObjArray.
    end method.
    
    /* override this in subclass - used by remove   */      
    method protected abstract void FindBufferUseObject (obj as Object).
    
    /* Deep clone. or rather deep enough since we don't know what the elements' Clone()
       operations do, so this may end up being a memberwise clone */
    method override public Object Clone():
        define variable oClone as ICollection no-undo.
        
        oClone = cast(this-object:GetClass():New(), ICollection).
        CloneElements(oClone).
        
        return oClone.        
    end method.
    
    method protected void CloneElements(input poClone as ICollection):
        define variable oIterator as IIterator no-undo. 

        oIterator = this-object:Iterator().
        do while oIterator:HasNext():
           poClone:Add(oIterator:Next():Clone()).
        end.
    end method.
    
    
end class./*---------------------------------------------------------------------------------------
    File        : CharacterList
    Purpose     : lightweight class for character entries 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Tue Sep 29 21:48:14 EDT 2009
    Notes       : Does NOT implement IList (kind of IList<character>) and has no iterator 
  --------------------------------------------------------------------------------------*/
 
using Progress.Lang.*.
using OpenEdge.Lang.Collections.IList.

routine-level on error undo, throw.

class OpenEdge.Lang.Collections.CharacterList /*implements IList*/: 
    define variable mList as character no-undo.
    define variable mDlm  as character no-undo.
    
    define public property Size as integer no-undo 
    get():
       return num-entries(mList,mDlm).
    end.
    
    constructor CharacterList():
        mdlm = chr(1).
    end constructor.    
    
    constructor CharacterList(dlm as char):
        mDlm = dlm.
    end constructor. 
        
    method public logical Add(  i as integer,  c as character ):
        define variable oldVal as character no-undo. 
        if i > Size + 1 then 
            return false.
        if i = Size + 1 then 
            return this-object:Add(c).
        else do:
            oldVal = Get(i).
            entry(i,mList,mDlm) = mDlm + oldVal.
            entry(i,mList,mdlm) = c.
            return true.
        end.              
    end method.
   
    method public logical Add(  c as character ):
        mList = (if mList = "" then "" else mList + mDlm) 
              + c. 
        return true.      
    end method.
    
    method public void Clear(  ):
        mList = "".
    end method.

    method public logical Contains( c as character ):
        return lookup(c,mList,mDlm) > 0. 
    end method.
     
    method public character Get( i as integer ):
        if i <= Size and i > 0 then
           return entry(i,mList,mDlm).
         return ?.      
    end method.
    
    method public integer IndexOf(c as character):
        return lookup(c,mList,mDlm).
    end method.

    method public logical IsEmpty(  ):
        return mList = "".
    end method.

    method public character Remove(  i as integer ):
        define variable oldVal  as character.
        oldVal = Get(i). 
        if oldVal <> ? then 
        do:
            entry(i,mList,mDlm) = "".
            mList = trim(mList,mDlm).
            mList = replace(mList,mDlm + mdlm,mDlm).
        end.
        return oldVal.          
    end method.
    
    method public logical Remove(  c as character ):
        define variable i as integer no-undo.
        i = IndexOf(c).
        if i > 0 then
           return Remove(i) <> ?.
        return false.    
    end method.

    method public character Set(  i as integer,  c as character ):
        define variable oldVal  as character.
        oldVal = Get(i). 
        if oldVal <> ? then 
            entry(i,mList,mDlm) = c.
        return oldVal.
    end method.
 
end class./*------------------------------------------------------------------------
    File        : CharacterStack
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 13:50:43 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.CharacterStack.
using OpenEdge.Lang.Collections.Stack.

class OpenEdge.Lang.Collections.CharacterStack inherits Stack:
    
    constructor public CharacterStack(pcArray as character extent):
        super(pcArray).
    end constructor.
    
    constructor public CharacterStack(piDepth as integer):
        super(piDepth).
    end constructor.
        
    constructor public CharacterStack():
        super().
    end constructor.
    
    method public void Push(pcValue as character):
        PrimitivePush(pcValue).
    end method.
    
    method public character Peek():
        return PrimitivePeek().
    end method.
    
    method public character Pop():
        return PrimitivePop().
    end method.
    
    method public character extent ToArray():
        return PrimitiveToArray().
    end method.
    
end class./*------------------------------------------------------------------------------
    File        : Collection
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 22:41:40 EST 2007
    Notes       : 
------------------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.*.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.Collections.AbstractTTCollection.

class OpenEdge.Lang.Collections.Collection inherits AbstractTTCollection: 
   /*---------------------------------------------------------------------------
    Purpose: General collection class                                                                
    Notes:   
    --------------------------------------------------------------------------*/
     
    /* default temp-table  */ 
    define private temp-table ttCollection
      field objectref as Object
      index objidx objectref.
      
    constructor public Collection():
        super (temp-table ttCollection:handle,"objectref").
    end constructor.
    
    constructor public Collection (c as ICollection):
        super (c,temp-table ttCollection:handle, "objectref").
    end constructor.

    method public override logical Contains( checkObject as Object):
        define variable lContains as logical no-undo.
        define buffer lbCollection for ttCollection.
        
        if not valid-object(checkObject) then
            return false.
        
        /* try by-reference first */
        lContains = can-find(lbCollection where lbCollection.ObjectRef = checkObject). 
        for each lbCollection while lContains = false:
            lContains = lbCollection.ObjectRef:Equals(checkObject).
        end.
        
        return lContains.
    end method.
    
   /*  
    a custom equals method for a collection class that implements neither the List nor Set interface must 
    return false when this collection is compared to any list or set. ... 
    */
/*    method public override logical Equals(o as Object):               */
/*        define buffer btCollection for ttCollection.                  */
/*        define variable oColl as ICollection no-undo.                 */
/*                                                                      */
/*        if super:Equals(o) then                                       */
/*            return true.                                              */
/*        if type-of(o,ICollection)                                     */
/*        and o:Equals(this-object) then                                */
/*        do:                                                           */
/*            oColl = cast(o,ICollection).                              */
/*            if oColl:Size = Size then                                 */
/*            do:                                                       */
/*                for each btCollection:                                */
/*                    if not oColl:Contains(btCollection.objectref) then*/
/*                        return false.                                 */
/*                end.                                                  */
/*                return true.                                          */
/*            end.                                                      */
/*        end.                                                          */
/*        return false.                                                 */
/*    end method.                                                       */
/*                                                                      */
    method protected override void FindBufferUseObject ( o as Object ):
        find first ttCollection where ttCollection.objectref = o no-error.
    end.
     
end class./*------------------------------------------------------------------------
    File        : EntrySet
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : apr 2010
    Notes       : no empty constructor, specialized for KeySet of IMap 
                 - Changes to the map are reflected here, and vice-versa. 
                 - Supports removal and removes the corresponding map entry from the map
                   (Iterator.remove, Collection.remove, removeAll, retainAll and clear) .
                 - Do not support add and addAll.   
                 - no empty constructor, specialised for IMap 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.Object.
using Progress.Lang.AppError. 

using OpenEdge.Lang.Collections.KeySet. 
using OpenEdge.Lang.Collections.EntrySetIterator. 
using OpenEdge.Lang.Collections.IIterator. 
using OpenEdge.Lang.Collections.IMap. 
using OpenEdge.Lang.Collections.IMapEntry. 

class OpenEdge.Lang.Collections.EntrySet inherits KeySet: 
    define private variable mhTempTable     as handle no-undo. 
    define private variable mcField         as char  no-undo. 
      
    constructor public EntrySet (poMap as IMap,phTT as handle,pcKeyField as char):
        super (poMap,phTT,pcKeyField ).        
        mhTempTable = phTT.
        mcField = pcKeyField. 
    end constructor.
    
    method public override logical Contains(poObj as Object):     
        return super:Contains(CastEntry(poObj):Key).
    end method.
   
    method private IMapEntry CastEntry(poObj as Object).
         if not type-of(poObj,IMapEntry) then 
             undo, throw new AppError("Can only pass IMapEntry to method").
         return cast(poObj,IMapEntry).    
    end method.
        
    method public override logical Remove( poOld as Object ):
       return super:Remove(CastEntry(poOld):Key).
    end method.
     
     /* Returns a new IIterator over the entryset. */
    method public override IIterator Iterator( ):    
        return new EntrySetIterator(OwningMap, this-object,mhTempTable,mcField).
    end method.
    
end class. 
 /*------------------------------------------------------------------------
    File        : EntrySetIterator
    Purpose     : Iterator for entrysets
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Mon Apr 12 00:18:04 EDT 2010
    Notes       : The IMappedEntry Key Value are created in next().      
  ----------------------------------------------------------------------*/

using Progress.Lang.Object.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Iterator.
using OpenEdge.Lang.Collections.MapEntry.
 
routine-level on error undo, throw.

class OpenEdge.Lang.Collections.EntrySetIterator inherits Iterator: 
    define protected property OwningMap as IMap no-undo get. set. 
    constructor public EntrySetIterator (poMap as IMap, poCol as ICollection, tt as handle,ofield as char):
        super(poCol,tt,ofield).  
        OwningMap = poMap.          
    end constructor.    
    
    method public override Object Next():
        define variable oKey as Object no-undo.
        oKey = super:Next().
        return new MapEntry(OwningMap,oKey). 
    end method.    
     
end class./*------------------------------------------------------------------------
    File        : ICollection
    Purpose     : A collection represents a group of objects, known as its 
                  elements.
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 20:04:13 EST 2007
    Notes       : All methods (and comments) except ToTable and AddArray 
                  are an exact match to Java Collection interface. 
                  Size is implemented as property                                                                     
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
 
interface OpenEdge.Lang.Collections.ICollection:
  define public property Size as integer no-undo get.
  
  method public logical Add(o as Object).
  method public logical AddAll(c as ICollection).
  method public logical AddArray(c as Object extent).  
  method public void Clear().
  method public logical Contains (o as Object).
  /*  method override public logical equals (o as Object). */
  method public IIterator Iterator().
  method public logical IsEmpty().
  method public logical Remove (o as Object). 
  /* Removes from this list all the elements that are contained in the 
      specified collection (optional operation). */
  method public logical RemoveAll (c as ICollection). 
  /* Retains only the elements in this list that are contained in the 
      specified collection (optional operation). return true if the object changed */
  method public logical RetainAll (c as ICollection). 
  method public void ToTable (output table-handle tt). 
  method public Object extent ToArray (). 
end interface. 
 /*------------------------------------------------------------------------
    File        : IIterator
    Purpose     : traverses a collection forward 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface OpenEdge.Lang.Collections.IIterator:  
  method public logical HasNext().
  method public Object Next().
  method public logical Remove(). 
end interface.

 
/*------------------------------------------------------------------------
    File        : IList
    Purpose     : An ordered collection that gives control over where in the 
                  list each element is inserted. 
                  Allows elements to be accessed by their integer index in 
                  addition to by the element. 
    Description : 
    @author hdaniels
    Created     : Wed Jan 09 09:57:42 EST 2008
    Notes       : All methods (and comments) except ToTable are an exact match to Java  
                  List interface. Size is implemented as property                                 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator. 
using OpenEdge.Lang.Collections.IListIterator. 
using OpenEdge.Lang.Collections.IList. 

interface OpenEdge.Lang.Collections.IList:  
   /* Returns the number of elements in this list. */
   define public property Size as integer no-undo get.
    
   /* Inserts the specified element at the specified position in this list 
       (optional operation).*/      
   method public logical Add(i as int, o as Object).
   
   /* Appends the specified element to the end of this list 
       (optional operation). */
   method public logical Add(o as Object).
   
   /* Appends all of the elements in the specified collection to the end 
      of this list, in the order that they are returned by the specified 
      collection's iterator (optional operation). */
   method public logical AddAll(c as ICollection).
   
   /* Inserts all of the elements in the specified collection into this list 
      at the specified position (optional operation).  */
   method public logical AddAll(i as int,c as ICollection).
   
   /** Appends all the elements in the array this list, optionally
       at the specified position. */
   method public logical AddArray(c as Object extent).
   method public logical AddArray(i as int, c as Object extent).
   
   /* Removes all of the elements from this list (optional operation). */
   method public void Clear().
   
   /* Returns true if this list contains the specified element. */
   method public logical Contains (o as Object). 
   
   /* Returns true if this list contains all of the elements of the 
      specified collection. */
   method public logical ContainsAll(c as ICollection). 
   
   /* Returns the element at the specified position in this list. */       
   method public Object Get(i as int). 
 
   /* Returns the index in this list of the first occurrence of the specified 
      element, or 0 if this list does not contain this element.  */       
   method public integer IndexOf(o as Object). 
   
   /* Returns an iterator over the elements in this list in proper sequence. */        
   method public IIterator Iterator().
  
   /* Returns a list iterator over the elements in this list in proper sequence. */        
   method public IListIterator ListIterator().
 
   /* Returns a list iterator of the elements in this list (in proper sequence),
      starting at the specified position in this list. */
   method public IListIterator ListIterator(i as int).
   
   /*  Returns the index in this list of the last occurrence of the 
       specified element, or 0 if this list does not contain this element. */
   method public integer LastIndexOf(o as Object).
  
   /* Returns true if this list contains no elements. */
   method public logical IsEmpty().
   
   /* Removes the element at the specified position in this list
     (optional operation). */
   method public Object Remove (i as integer). 
   
   /* Removes the first occurrence in this list of the specified element 
     (optional operation). */
   method public logical Remove (o as Object). 

   /* Removes from this list all the elements that are contained in the 
      specified collection (optional operation). */
   method public logical RemoveAll (c as ICollection). 
  
   /* Retains only the elements in this list that are contained in the 
      specified collection (optional operation).*/
   method public logical RetainAll (c as ICollection). 
  
   /* Replaces the element at the specified position in this list with the 
      specified element (optional operation). */
   method public Object    Set (i as int, o as Object).
        
   /* Returns a view of the portion of this list between the specified 
      fromIndex, inclusive, and toIndex, exclusive. */
   method public IList SubList(fromIndex as int, toIndex as int).
      
   /* Returns a temp-table containing all of the elements in this list */
   method public void ToTable (output table-handle tt).   
   
   /* returns the contents of the list as an array */
   method public Object extent ToArray ().
    
end interface.
 
 /*------------------------------------------------------------------------
    File        : IListIterator
    Purpose     : An iterator for lists that can traverse the list in 
                  both directions
    Syntax      : 
    Description : 
    @author hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.Object.

interface OpenEdge.Lang.Collections.IListIterator:  
  method public logical HasNext().
  method public Object Next().
  method public integer NextIndex().
  method public logical Remove ().
  method public logical HasPrevious().
  method public Object Previous().   
  method public integer PreviousIndex().
 /* method public void set(o as Object).     */
end interface.

 /** ------------------------------------------------------------------------
    File        : IMap
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Apr 11 01:17:48 EDT 2010
    Notes       : All methods (and comments) except ToTable matches 
                  Java Map interface.
                  Collection views are properties 
                  Size is property
  ---------------------------------------------------------------------- */

using Progress.Lang.*.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.ISet.


interface OpenEdge.Lang.Collections.IMap:  
 
    /* Returns the number of key-value mappings in this map.*/
    define public property Size as integer no-undo get.
    
    /* Returns a collection view of the values contained in this map.
       reflects changes to the map and vice-versa. 
       Supports removal and removes the corresponding map entry from the map
       (Iterator.remove, Collection.remove, removeAll, retainAll and clear) .*/
    define public property Values as ICollection no-undo get.
    
    /* Returns a set view of the keys contained in this map.*/
    define public property KeySet as ISet no-undo get.
    
    /* Returns a set view of the mappings contained in this map.*/
    define public property EntrySet as ISet no-undo get.
     
    /* Removes all mappings from this map (optional operation). */
    method public void Clear().
    
    /* Returns true if this map contains a mapping for the specified key. */
    method public logical ContainsKey(poKey as Object).
    
    /* Returns true if this map maps one or more keys to the specified value.*/
    method public logical ContainsValue(poValue as Object).
   
    /* Returns the value to which this map maps the specified key.*/
    method public Object Get(poKey as Object).
    
    /* Returns the hash code value for this map.*/
    /*    int    hashCode()*/
    /* Returns true if this map contains no key-value mappings.*/
    method public logical IsEmpty().
     
    /* Associates the specified value with the specified key in this map (optional operation).*/
    method public Object Put(poKey as Object,poValue as Object).
    
    /* Copies all of the mappings from the specified map to this map (optional operation).*/
    method public void PutAll(poMap as IMap).
    
    /* Removes the mapping for this key from this map if it is present (optional operation).*/
    method public Object Remove(poKey as Object).
    
end interface.
/*------------------------------------------------------------------------
    File        : IMapEntry
    Purpose     : A map entry (key-value pair). 
                  The IMap:EntrySet returns a set-view of the map, 
                  whose elements are of this class. 
                   
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Apr 11 23:46:14 EDT 2010
    Notes       : The only way to obtain a reference to a map entry is 
                  from the iterator of the IEntrySet.
                  The IMapEntry objects are valid only for the duration 
                  of the iteration.                      
  ----------------------------------------------------------------------*/

using Progress.Lang.Object.

interface OpenEdge.Lang.Collections.IMapEntry:  
    define property Key   as Object no-undo get. set.
    define property Value as Object no-undo get. set.
    
end interface./*------------------------------------------------------------------------
    File        : IntegerStack
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 13:50:43 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.IntegerStack.
using OpenEdge.Lang.Collections.Stack.

class OpenEdge.Lang.Collections.IntegerStack inherits Stack:
        
    constructor public IntegerStack(piDepth as integer):
        super (piDepth).
    end constructor.
    
    constructor public IntegerStack():
    end constructor.
    
    method public void Push(piValue as integer):
        PrimitivePush(string(piValue)).
    end method.
    
    method public integer Peek():
        return integer(PrimitivePeek()).
    end method.
    
    method public integer Pop():
        return integer(PrimitivePop()).
    end method.
    
end class.
/*------------------------------------------------------------------------
    File        : ISet
    Purpose     : A collection that contains no duplicate elements.
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Jan 09 09:57:42 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.

interface OpenEdge.Lang.Collections.ISet:  
   /* Returns the number of elements in this list. */
   define public property Size as integer no-undo get.
    
   /* Appends the specified element to list if not already present
      (optional operation). */
   method public logical Add(o as Object).
   
   /* Appends all of the elements in the specified collection if not already 
     present (optional operation). */
   method public logical AddAll(c as ICollection).
    
   /* Removes all of the elements from this list (optional operation). */
   method public void Clear().
   
   /* Returns true if this list contains the specified element. */
   method public logical Contains (o as Object). 
   
   /* Returns true if this list contains all of the elements of the 
      specified collection. */
   method public logical ContainsAll(c as ICollection). 
   
   /*  method override public logical equals (o as Object). */
   
   /* Returns true if this list contains no elements. */
   method public logical IsEmpty().
     
   /* Returns an iterator over the elements in this list in proper sequence. */        
   method public IIterator Iterator().
   
   /* Removes the first occurrence in this list of the specified element 
     (optional operation). */
   method public logical Remove (o as Object). 

   /* Removes from this list all the elements that are contained in the 
      specified collection (optional operation). */
   method public logical RemoveAll (c as ICollection). 
  
   /* Retains only the elements in this list that are contained in the 
      specified collection (optional operation).*/
   method public logical RetainAll (c as ICollection). 
      
   /* Returns a temp-table containing all of the elements in this list */
   method public void ToTable (output table-handle tt).   
   
   /* retruns the contents of the set as an array */
   method public Object extent ToArray (). 
end interface. /*------------------------------------------------------------------------
    File        : OEIterator
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 21:26:22 EST 2007
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.Object.
using Progress.Lang.*.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.Iterator.


class OpenEdge.Lang.Collections.Iterator use-widget-pool implements IIterator :
    /*------------------------------------------------------------------------------
            Purpose:                                                                        
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    define protected property OwnerCollection   as ICollection no-undo  get. set .     
    define protected property QueryHandle       as handle no-undo  get. set .     
    define protected property BufferHandle      as handle no-undo  get. set .    
    define protected property ObjectFieldHandle as handle no-undo  get. set  .    
    
    constructor public Iterator (poCol as ICollection, tt as handle,ofield as char):
        this-object(poCol,tt,ofield,'','').            
    end constructor.
    
    constructor public Iterator (poCol as ICollection,tt as handle,ofield as char, sortfield as char):
        this-object(poCol,tt,ofield,sortfield,'').            
    end.
    
    constructor public Iterator (poCol as ICollection,tt as handle,ofield as char, sortfield as char, querystring as char):
        super ().    
        create buffer BufferHandle for table tt.
        create query QueryHandle.
        
        QueryHandle:add-buffer(BufferHandle).
        ObjectFieldHandle = BufferHandle:buffer-field(ofield).
        PrepareQuery(querystring,sortfield,sortfield = '').
        /* it is generally bad practice to open the query in the constructor 
           - excuse 1: iterators are only newed when you really want to iterate
                      (i.e. you don't new an Iterator at start up or in a constrcutor) 
           - excuse 2: if not done here it would be needed in most methods here and 
                       in ListIterator  */  
        QueryHandle:query-open().    
    end constructor.    
    
    method private void PrepareQuery (queryExp as char,sortExp as char,forwardOnly as logical):
        QueryHandle:query-prepare('preselect each ' + bufferHandle:name         
                                  + (if queryExp > '' 
                                     then ' where ' + queryExp 
                                     else '') 
                                  + if sortExp > '' 
                                    then ' by ' + sortExp
                                    else ''). 
        QueryHandle:forward-only = forwardOnly.
    end. 
       
    method public logical HasNext(  ):
        define variable offend as logical no-undo.
        
        if QueryHandle:query-off-end then 
        do:
            QueryHandle:reposition-forward(1).
            offend = QueryHandle:query-off-end.
            if not QueryHandle:forward-only then
                QueryHandle:reposition-backward(1).
            return not offend. 
        end. 
        else 
        if  QueryHandle:num-results = 1 
        and QueryHandle:current-result-row = 1 then 
            return not QueryHandle:get-buffer-handle(1):avail.
        else
            return QueryHandle:current-result-row lt QueryHandle:num-results.   
    end method.

    method public Object Next(  ):
        define variable nextobject as Object no-undo.
            
        QueryHandle:get-next().
        if bufferHandle:avail then 
        do:
            nextobject = ObjectFieldHandle:buffer-value().
            return nextobject.
        end.    
        else 
            return ?.
/*          return if bufferHandle:avail then objectFieldHandle:buffer-value() else ?.*/
    end method.
    
    /* removes the current item from the underlying collection  */
    method public logical Remove(  ):    
        define variable lOk as logical no-undo.
        if BufferHandle:avail then
        do:
            lOk = OwnerCollection:Remove(ObjectFieldHandle:buffer-value).
            if lok then 
                QueryHandle:delete-result-list-entry().
        end.   
        return lok.          
    end method.

    destructor public Iterator ( ):
        if valid-handle(BufferHandle) then
            delete object bufferHandle.
        if valid-handle(QueryHandle) then
            delete object QueryHandle.
    end destructor.

 end class. 
 /*------------------------------------------------------------------------
    File        : KeySet
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : apr 2010
    Notes       : no empty constructor, specialized for KeySet of IMap 
                 - Changes to the map are reflected here, and vice-versa. 
                 - Supports removal and removes the corresponding map entry from the map
                   (Iterator.remove, Collection.remove, removeAll, retainAll and clear) .
                 - Do not support add and addAll.   
                 - no empty constructor, specialised for IMap 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.

using Progress.Lang.Object.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IMap. 
using OpenEdge.Lang.Collections.IIterator. 
using OpenEdge.Lang.Collections.ISet. 
using OpenEdge.Lang.Collections.KeySet. 
using OpenEdge.Lang.Collections.ValueCollection. 
 
class OpenEdge.Lang.Collections.KeySet inherits ValueCollection implements ISet: 
  
        
    constructor public KeySet (poMap as IMap,phTT as handle,pcKeyField as char):
        super (poMap,phTT,pcKeyField ).        
    end constructor.
    
    method public override logical Contains(poObj as Object):        
         return OwningMap:ContainsKey(poObj).
    end method.
   
    method public logical ContainsAll(collection as ICollection):            
        define variable iterator as IIterator no-undo.
        define variable found    as logical   no-undo.
        iterator = collection:Iterator(). 
        do while iterator:HasNext():
            if not this-object:Contains(iterator:Next()) then 
                return false.
            found = true.      
        end.    
        return found.         
    end method.
    
    /* Equals if Set and every member of the specified set is contained in this set */
    method public override logical Equals(o as Object):
        define variable oSet as ISet no-undo.
        define variable oIter as IIterator no-undo.
        if super:Equals(o) then 
            return true.
        if type-of(o,ISet) then
        do:
            oSet = cast(o,ISet).
            if oSet:Size = Size then
            do:
                oIter = Iterator().
                do while oIter:HasNext():
                    if oSet:Contains(oIter:Next()) = false then
                        return false. 
                end.    
                return true.
            end.    
        end.
        return false.    
    end method.   
     
    method public override logical Remove( poOld as Object ):
         define variable i as integer no-undo.
         /* OwningMap:Remove() returns oldvalue, but it could be unknown, so use size to check if deleted */
         i = Size.  
         OwningMap:Remove(poOld).
         if i > Size then 
             return true.
         return false.    
    end method.
    
    method public override logical RemoveAll(collection as ICollection):
        define variable iterator   as IIterator no-undo.         
        define variable anyRemoved as logical no-undo.
        iterator = collection:Iterator().
        do while iterator:HasNext():
            if Remove(iterator:Next()) then 
                anyRemoved = true. 
        end.
        return anyRemoved.
    end method.
    
    method public override logical RetainAll(collection as ICollection):
        define variable iterator   as IIterator no-undo.    
        define variable oObj      as Object no-undo.     
        define variable anyRemoved as logical no-undo.
        iterator = collection:Iterator().
        do while iterator:HasNext():
            oObj = iterator:Next().
            if not Contains(oObj) then
            do:
                Remove(oObj). 
                anyRemoved = true. 
            end.
        end.
        return anyRemoved.
    end method.
     
end class. 
 /*------------------------------------------------------------------------
    File        : List
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Jan 09 10:45:45 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.AbstractTTCollection.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.Iterator.
using OpenEdge.Lang.Collections.IListIterator.
using OpenEdge.Lang.Collections.ListIterator.
using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Collections.List.
using Progress.Lang.Object.

class OpenEdge.Lang.Collections.List inherits AbstractTTCollection implements IList : 
    /*------------------------------------------------------------------------------
            Purpose:                                                                        
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    /* default temp-table  */ 
    define temp-table ttList 
      field sequence as int 
      field objectref as Object 
      index objidx objectref
      index seq as unique primary sequence.
        .
        
    constructor public List(  ):
        super (temp-table ttList:handle,'objectref').        
    end constructor.
       
    constructor public List (list as IList):
        super (cast (list,ICollection),temp-table ttList:handle,'objectref').        
    end constructor.
    
    constructor protected List ( input poCol as ICollection, input phtt as handle, input pcField as character ):
        super (input poCol, input phtt, input pcField).
    end constructor.
        
    constructor protected List ( input phtt as handle, input pcField as character ):
        super (input phtt, input pcField).
    end constructor.

    constructor protected List ( input phtt as handle, input hField as handle ):
        super (input phtt, input hField).
    end constructor.
        
    method public override logical Contains(checkObject as Object):        
        define variable lContains as logical no-undo.
        define buffer lbList for ttList.
        
        /* try by-reference first */
        lContains = can-find(lbList where lbList.ObjectRef = checkObject). 
        for each lbList while lContains = false:
            lContains = lbList.ObjectRef:Equals(checkObject).
        end.
        
        return lContains.
    end method.
    
    method protected override void FindBufferUseObject (findObject as Object):
        define variable lFoundRecord as logical no-undo.
        lFoundRecord = false.
        
        for each ttList where objectref = findObject by ttList.sequence:
            lFoundRecord = true.
            return.
        end.
        
        for each ttList     
                 by ttList.sequence
                 while not lFoundRecord:
            lFoundRecord = ttList.objectref:Equals(findObject).
        end.
    end method.

    method public logical Add(seq as integer, obj as Object ):    
        define buffer btList for ttList.
        
        if super:Add(obj) then
        do:
            for each btList where btList.sequence >= seq by btList.sequence desc:
                btList.sequence = btList.sequence + 1. 
            end.
            
            ttList.Sequence = seq.
            return true.
        end.
        return false.
    end method.
   
    method public override logical Add(obj as Object ):    
        define variable iSeq as integer no-undo.
        if super:Add(obj) then
        do:
            /* once in a while we lose the availability of the ttList buffer. */
            findBufferUseObject(obj).
            
            ttList.Sequence = Size.
            return true.
        end.
        return false.
    end method.
    
    method public logical AddAll(seq as int,c as ICollection):
        define buffer btList for ttList.
        define variable iterator as IIterator no-undo.
        for each btList where btList.sequence >= seq by btList.sequence desc:
            btList.sequence = btList.sequence + c:Size + 1. 
        end.
        iterator = c:Iterator(). 
        do while iterator:HasNext():
            super:Add(iterator:Next()).
            ttList.Sequence = Seq.
            seq = seq + 1.
        end.                                     
        return true.         
    end method.
    
    method public logical AddArray(seq as int, obj as Object extent):       
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        define buffer btList for ttList.
        
        iMax = extent(obj).
        
        for each btList where btList.sequence >= seq by btList.sequence desc:
            btList.sequence = btList.sequence + iMax + 1. 
        end.
        
        do iLoop = 1 to iMax:
            super:Add(obj[iLoop]).
            ttList.Sequence = Seq.
            seq = seq + 1.
        end.
        
        return true.         
    end method.
     
    method public logical ContainsAll( collection as ICollection ):            
        define variable iterator as IIterator no-undo.
        iterator = collection:Iterator(). 
        do while iterator:hasNext():
            if not this-object:Contains(iterator:Next()) then 
                return false.  
        end.                                     
        return true.         
    end method.
    
    /* two lists are defined to be equal if they contain the same elements in the same order */
    method public override logical Equals(o as Object):
        define buffer btList for ttList.
        define variable oList as List no-undo.
        if super:Equals(o) then 
            return true.
        if type-of(o,List) then
        do:
            oList = cast(o,List).
            if oList:Size = Size then
            do:
                for each btList:
                    if btList.objectref <> oList:Get(btList.Sequence) then
                        return false. 
                end.    
                return true.
            end.    
        end.
        return false.    
    end method.    
                                                                     
    method public Object Get(i as integer):    
        find ttList where ttList.sequence = i no-error.
        if avail ttList then 
            return ttList.objectref.
        else
            return ?.    
    end method.
    
    method public integer IndexOf(obj as Object ):
        define variable iIndex as integer no-undo.
        
        for first ttList where objectref = obj by ttList.sequence:
            iIndex = ttList.sequence. 
        end.
        
        for each ttList 
                 by ttList.Sequence
                 while iIndex eq 0: 
            if ttList.objectref:Equals(obj) then
                iIndex = ttList.sequence. 
        end.
        
        return iIndex.    
    end method.
     
    /* Returns a new IIterator over the collection.  */
    method public override IIterator Iterator(  ):        
        return new Iterator(this-object,temp-table ttList:handle,"objectref","sequence").
    end method.
    
    /* Returns a new IListIterator over the collection.  */
    method public IListIterator ListIterator(  ):        
        return new ListIterator(this-object,temp-table ttList:handle,"objectref","sequence").
    end method.
    
    /* Returns a new IListIterator over the collection.*/
    method public IListIterator ListIterator(i as integer):
        return new ListIterator(this-object,temp-table ttList:handle,"objectref","sequence","sequence >= " + string(i)).
    end method.
    
    method public integer LastIndexOf(obj as Object ):
        define variable iIndex as integer no-undo.
        
        for last ttList where objectref = obj by ttList.sequence:
            iIndex = ttList.sequence. 
        end.
        
        for each ttList 
                 by ttList.Sequence descending
                 while iIndex eq 0: 
            if ttList.objectref:Equals(obj) then
                iIndex = ttList.sequence. 
        end.
        
        return iIndex.    
    end method.
    
    method override public logical Remove(oldObject as Object ):
        define variable iStart as integer no-undo.
        define buffer btList for ttList.
        findBufferUseObject(oldObject). 
        if avail ttList then
        do:
            iStart = ttList.sequence.
            if super:remove(oldobject) then
            do:
                for each btList where btList.Sequence > iStart:
                    btList.sequence = btList.Sequence - 1.     
                end.
                return true.
            end. 
        end.    
        return false.
    end method.
    
    method public Object Remove(i as integer):        
        define variable oldObject as Object.
        oldObject = get(i).
        Remove(oldObject).
        return oldObject.
    end method.
    
    method public Object Set( input i as integer, input poReplacement as Object ):
        define variable oldObject as Object.
        find ttList where ttList.sequence = i no-error.
        if avail ttList then 
        do: 
            assign 
                oldObject        = ttList.objectref  
                ttList.objectref = poReplacement.
            return oldObject. 
        end.
    end method.
    
    method public IList SubList(fromIndex as integer, toIndex as integer):
        define variable list as IList no-undo.
        define variable oObject as Object no-undo.
        list = new List().
        do fromIndex = fromIndex to toIndex - 1:
           oObject = get(fromIndex).
           if valid-object(oObject) then
              list:add(oObject).  
           else do: 
              delete object list. 
              return ?. 
           end.     
        end.
        return list.
    end method. 
end class. /*------------------------------------------------------------------------
    File        : ListIterator
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Jan 02 23:38:28 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.Object.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IListIterator.
using OpenEdge.Lang.Collections.Iterator.

class OpenEdge.Lang.Collections.ListIterator inherits Iterator implements IListIterator:

    constructor public ListIterator (poCol as ICollection,tt as handle, objField as char, seqField as char):
        super (poCol,tt,objfield, seqField).               
    end constructor. 
    
    constructor public ListIterator (poCol as ICollection,tt as handle, objField as char, seqField as char,querystring as char):
        super (poCol,tt,objfield, seqField, querystring).               
    end constructor. 
      
    method public logical HasPrevious(  ):
        define variable offend as logical no-undo.
        if QueryHandle:query-off-end then 
        do:
            QueryHandle:reposition-backward(1).
            offend = QueryHandle:query-off-end.
            QueryHandle:reposition-forward(1).
            return not offend. 
        end. 
        else 
            return QueryHandle:current-result-row > 1.       
    end method.        
    
    method public Object Previous(  ):
        QueryHandle:get-prev().
          return if BufferHandle:avail then ObjectFieldHandle:buffer-value() else ?. 
    end method.
    
    method public integer PreviousIndex(  ):
        if QueryHandle:query-off-end = false then 
            return QueryHandle:current-result-row - 1.
    end method.
    
    method public integer NextIndex(  ):
        if QueryHandle:query-off-end = false then 
            return max(QueryHandle:current-result-row + 1,
                        QueryHandle:num-results).
        else if HasNext() then
            return 1.
    end method.
    
end class. 
 /*------------------------------------------------------------------------
    File        : Map
    Purpose     : 
    Syntax      :  
    Description : 
    @author hdaniels
    Created     : Sun Apr 11 01:35:13 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
 
using Progress.Lang.Object.
using Progress.Lang.AppError.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.ISet.
using OpenEdge.Lang.Collections.EntrySet.
using OpenEdge.Lang.Collections.KeySet.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.ValueCollection.

class OpenEdge.Lang.Collections.Map implements IMap: 
    
    define temp-table ttMap 
      field KeyRef as Object 
      field ValueRef as Object 
      index validx ValueRef
      index keyidx as unique primary KeyRef.
     
    define public property Size as integer no-undo 
    get.
    private set. 
    
    define public property Values as ICollection no-undo 
    get():
        if not valid-object(this-object:Values) then 
            this-object:Values = new ValueCollection(this-object,temp-table ttMap:handle,"ValueRef"). 
        return this-object:Values.   
    end.   
    private set. 
   
    define public property KeySet as ISet no-undo 
    get():
        if not valid-object(this-object:KeySet) then 
            this-object:KeySet = new KeySet(this-object,temp-table ttMap:handle,"KeyRef"). 
        return this-object:KeySet.   
    end.   
    private set. 
    define public property EntrySet as ISet no-undo 
    get():
        if not valid-object(this-object:EntrySet) then
            this-object:EntrySet = new EntrySet(this-object,temp-table ttMap:handle,"KeyRef").
        return this-object:EntrySet.
    end.   
    private set.    
            
    constructor public Map (poMap as IMap ):
        super ().    
        if type-of(poMap,Map) then
        do:
            poMap:Values:ToTable(output table ttMap).
            Size = poMap:Size.
        end. 
        else PutAll(poMap).  
    end constructor.
    
    constructor public Map (  ):
        super ().   
    end constructor.

    method public void Clear(  ):
        empty temp-table ttMap.
    end method.

    method public logical ContainsKey(poKey as Object):
        define variable lContainsKey as logical no-undo.
        define buffer lbMap for ttMap.
        
        if not valid-object(poKey) then
            return false.
        
        /* try by-reference first */
        lContainsKey = can-find(lbMap where lbMap.KeyRef = poKey). 
        for each lbMap while lContainsKey = false:
            lContainsKey = lbMap.KeyRef:Equals(poKey).
        end.
               
        return lContainsKey.
    end method.

    method public logical ContainsValue(poValue as Object):
        define variable lContainsValue as logical no-undo.
        define buffer lbMap for ttMap.
        
        if not valid-object(poValue) then
            return false.
        
        /* try by-reference first */
        lContainsValue = can-find(lbMap where lbMap.ValueRef = poValue). 
        for each lbMap while lContainsValue = false:
            lContainsValue = lbMap.ValueRef:Equals(poValue).
        end.
                       
        return lContainsValue.
    end method.
    
    /* Returns true if the given object is also a map and the two Maps represent the same mappings.  */
    method public override logical Equals(o as Object):
        define buffer btMap for ttMap.
        define variable oMap as IMap no-undo.
        define variable oValue as Object no-undo.
        
        if super:Equals(o) then 
            return true.
        if type-of(o,IMap) then
        do:
            oMap = cast(o,IMap).
            if oMap:Size = Size then
            do:
                for each btMap:
                    oValue = oMap:Get(btMap.KeyRef).
                    if oValue <> ? and oValue <> btMap.ValueRef then
                        return false.
                    
                    if oValue = ? then
                    do:
                       if not oMap:ContainsKey(btMap.KeyRef) then
                           return false. 
                       if btMap.ValueRef <> ? then
                           return false.
                    end.       
                    
                end.    
                return true.
            end.    
        end.
        return false.    
    end method.    
    
    /* This must be the buffer handle passed to the constructor of the 2 sets of this Map 
       (they all call back here for find of BufferHandle) */ 
    method public Object Get(poKey as Object):
        define variable oValue as Object no-undo.
        define buffer lbMap for ttMap.
       
        if not valid-object(poKey) then
            return oValue.
        
        find lbMap where lbMap.KeyRef = poKey no-error.
        if avail lbMap then
            oValue = lbMap.ValueRef.
        
        for each lbMap while not valid-object(oValue):
            if lbMap.KeyRef:Equals(poKey) then
                oValue = lbMap.ValueRef.
        end.
        
        return oValue.
    end method.

    method public logical IsEmpty(  ):
        return not can-find(first ttMap).
    end method.

    /* add entry to the map, return old value of any. Note that return of unknown could 
       also mean that the old mapped value was unknown... (check Size before and after) */   
    method public Object Put(poKey as Object, poValue as Object):
        define variable oOld as Object no-undo.
        define buffer lbMap for ttMap.

        if poKey:Equals(this-object) then 
             undo, throw new AppError("A Map cannot have itself as key.").
        /* not a real transaction, but scoping of updates 
          (not tested without, so not sure if it is really needed... )  */
        do transaction:
            /* try by-reference first */
            find ttMap where ttMap.KeyRef = poKey no-error.
            if not available ttMap then        
            for each lbMap while not available ttMap:
                if lbMap.KeyRef:Equals(poKey) then
                    find ttMap where rowid(ttMap) = rowid(lbMap) no-error.
            end.
                        
            if not avail ttMap then
            do:
                create ttMap.
                assign ttMap.KeyRef = poKey
                       Size = Size + 1.
            end.
            else 
                oOld = ttMap.ValueRef.
            
            ttMap.ValueRef = poValue.
        end.
        return oOld.
    end method.

    method public void PutAll(poMap as IMap):
        define variable oKey as Object no-undo.
        define variable oIter as IIterator no-undo.    
 
        oIter = poMap:KeySet:Iterator(). 
        do while oIter:hasNext():
            oKey = oIter:Next().
            this-object:Put(oKey,poMap:Get(oKey)).
        end.
    end method.
    
    /* return old value of any. Note that return of unknown could 
       also mean that the old mapped value was unknown. */ 
    method public Object Remove(poKey as Object):
        define variable oOld as Object no-undo.
        define buffer lbMap for ttMap.
        
        /* try by-reference first */
        find ttMap where ttMap.KeyRef = poKey no-error.
        if not available ttMap and valid-object(poKey) then
        for each lbMap while not available ttMap:
            if lbMap.KeyRef:Equals(poKey) then
                find ttMap where rowid(ttMap) = rowid(lbMap) no-error.
        end.
        
        if avail ttMap then
        do:
            oOld = ttMap.ValueRef.
            delete ttMap.
            Size = Size - 1.
        end.
        
        return oOld.
    end method.

    destructor public Map ( ):
        this-object:Values = ?.
        this-object:KeySet = ?.
    end destructor.
      
end class. 
 /*------------------------------------------------------------------------
    File        : MapEntry
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Mon Apr 12 00:24:25 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.Object.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.IMapEntry.

routine-level on error undo, throw.
 
class OpenEdge.Lang.Collections.MapEntry implements IMapEntry: 
    define protected property OwningMap as IMap no-undo get. set.
    
       define public property Key as  Object no-undo 
    get.
    set. 

    define public property Value as  Object no-undo 
    get.
    set(poValue as  Object): 
        if valid-object(OwningMap) then 
           OwningMap:Put(Key,poValue).

        this-object:Value = poValue.    
    end.
    
    constructor public MapEntry (poMap as IMap, poKey as Object):
        super ().
        assign
            this-object:Key = poKey
            /* Set value before OwningMap! see Set override */
            this-object:Value = poMap:Get(poKey)
            OwningMap = poMap .
    end constructor.
   
    method public override logical Equals(o as Object):
         define variable oMapEntry as IMapEntry no-undo.
         if o:Equals(this-object) then
             return true.
         if type-of(o,IMapEntry) then
         do: 
             oMapEntry = cast(o,IMapEntry).
             return this-object:Key:Equals(oMapEntry:Key) 
                    and 
                    this-object:Value:Equals(oMapEntry:Value).
         end.
         return false.
    end method.
    

end class./*------------------------------------------------------------------------
    File        : ObjectStack
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 13:50:43 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.ObjectStack.
using OpenEdge.Lang.Collections.Stack.
using Progress.Lang.Object.

class OpenEdge.Lang.Collections.ObjectStack inherits Stack:
        
    constructor public ObjectStack (poArray as Object extent):
        super(poArray).
    end constructor.
    
    constructor public ObjectStack (piDepth as integer):
        super(piDepth).
    end constructor.

    constructor public ObjectStack():
    end constructor.
    
    method public void Push(poValue as Object):
        super:ObjectPush(poValue).
    end method.
    
    method public Object Peek():
        return super:ObjectPeek().
    end method.
    
    method public Object Pop():
        return super:ObjectPop().
    end method.
    
    method public Object extent ToArray():
        return super:ObjectToArray().
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : Queue
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Oct 21 09:11:48 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */

using Progress.Lang.*.

routine-level on error undo, throw.

class OpenEdge.Lang.Collections.Queue abstract: 

end class. 
 /*------------------------------------------------------------------------
    File        : Set
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Jan 09 10:45:45 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.*.
using OpenEdge.Lang.Collections.*. 
 
class OpenEdge.Lang.Collections.Set inherits AbstractTTCollection implements ISet : 
    /*------------------------------------------------------------------------------
            Purpose:                                                                        
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    /* temp-table  */ 
    define private temp-table ttSet 
      field objectref as Object 
      index objidx as unique primary objectref.
        
    constructor public Set (  ):
        super (temp-table ttSet:handle,"objectref").        
    end constructor.
    
    constructor public Set (copyset as ISet):
        super (cast(copyset,ICollection),temp-table ttSet:handle,"objectref").        
    end constructor.    

    method public override logical Contains( checkObject as Object):
        define variable lContains as logical no-undo.
        
        if not valid-object(checkObject) then
            return false.
        
        /* try by-reference first */
        lContains = can-find(first ttSet where ttSet.ObjectRef = checkObject). 
        for each ttSet while lContains = false:
            lContains = ttSet.ObjectRef:Equals(checkObject).
        end.
        
        return lContains.
    end method.
       
    method protected override void FindBufferUseObject (obj as Object):
        find ttSet where ttSet.objectref = obj no-error.
    end.
   
    method public override logical Add(obj as Object):    
        find ttSet where ttSet.objectref = obj no-error.
        if not avail ttSet then     
            return super:add(obj).
        else
            return false.
    end method.
    
    method public override logical AddAll(collection as ICollection):
        define variable iterator as IIterator no-undo.
        define variable anyAdded as logical   no-undo.

        iterator = collection:Iterator().
        do while iterator:HasNext():
            if this-object:add(Iterator:Next()) then
               anyAdded = true.
        end.
        delete object iterator.
        return anyAdded.
    end method.
    
    method public logical ContainsAll(collection as ICollection):            
        define variable iterator as IIterator no-undo.
        define variable found    as logical   no-undo.
        iterator = collection:Iterator(). 
        do while iterator:HasNext():
            if not this-object:Contains(iterator:Next()) then 
                return false.
            found = true.      
        end.    
        return found.         
    end method.
    
    /* Equals if Set and every member of the specified set is contained in this set */
    method public override logical Equals(o as Object):
        define buffer btSet for ttSet.
        define variable oSet as ISet no-undo.
        if super:Equals(o) then 
            return true.
        if type-of(o,ISet) then
        do:
            oSet = cast(o,ISet).
            if oSet:Size = Size then
            do:
                for each btSet:
                    if not oSet:Contains(btSet.objectref) then
                        return false. 
                end.    
                return true.
            end.    
        end.
        return false.    
    end method.    
    
    method public override logical RemoveAll(collection as ICollection):
        define variable iterator   as IIterator no-undo.         
        define variable anyRemoved as logical no-undo.
        iterator = collection:Iterator().
        do while iterator:HasNext():
            if remove(iterator:Next()) then 
                anyRemoved = true. 
        end.
        return anyRemoved.
    end method.
     
end class./** ------------------------------------------------------------------------
    File        : Stack
    Purpose     : A stack is a last-in-first-out collection. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 15:09:51 EST 2010
    Notes       : * Non-char primitive values will have their own IntegerStack() say,that calls PrimitivePush and
                    converts to/from character to their native datatype. 
                  * The Stack temp-table could probably be dynamic, and have a single value field that
                    is dynamically constructed, but stacks need to be lightweight at runtime (IMO anyway). 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.Stack.
using OpenEdge.Lang.Collections.StackError.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.ParameterList.
using Progress.Lang.Object.

class OpenEdge.Lang.Collections.Stack abstract:
    define public static variable DEFAULT_STACK_DEPTH as integer no-undo.
    
    /** NOTE/ the expand/shrink behaviour could be handled with an enumeration,
        but as of 10.2B performance is better when using logical variables.
     **/
    /* Keep incrementally growing stack Depth as new elements are added.
       This will negatively impact performance. */
    define public property AutoExpand as logical no-undo get. set.
    
    /* If true, we'll discard stuff off the bottom of the stack if
       we resize the stack smaller than its contents. */
    define public property DiscardOnShrink as logical no-undo get. set.
    
    define public property Depth as integer no-undo 
        get.
        set (piDepth as int):
            SetStackDepth(piDepth).
            Depth = piDepth.
        end set.
    
    define public property Size as integer no-undo get. protected set.
    
    define private variable mcPrimitiveStack as character extent no-undo.
    define private variable moObjectStack as Object extent no-undo.
    define private variable mlObjectStack as logical no-undo.
    
    constructor protected Stack(poArray as Object extent):
        define variable iLoop as integer no-undo.
        
        this-object(extent(poArray)).
        
        /* The Size may not equal Depth for the input array, especially
           if this is a Stack being cloned. */        
        do iLoop = 1 to Depth while valid-object(poArray[iLoop]):
            this-object:ObjectPush(poArray[iLoop]).
        end.
    end constructor.
    
    constructor protected Stack(pcArray as character extent):
        this-object(extent(pcArray)).
        
        define variable iLoop as integer no-undo.
        do iLoop = 1 to Depth:
            this-object:PrimitivePush(pcArray[iLoop]).
        end.
    end constructor.
    
    constructor static Stack():
        Stack:DEFAULT_STACK_DEPTH = 10.
    end constructor.
    
    constructor public Stack(piDepth as int):
        assign Depth = piDepth
               mlObjectStack = ?
               AutoExpand = false
               DiscardOnShrink = false.
    end constructor.
    
    constructor public Stack():
        this-object(Stack:DEFAULT_STACK_DEPTH).
    end constructor.
    
    method private void SetStackDepth(piDepth as int):
        define variable cTempPrimitive as character extent no-undo.
        define variable oTempObject as Object extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        /* do nothing if there's nothing to do */
        if piDepth ne Depth then
        do:
            if piDepth lt Size and not DiscardOnShrink then
                undo, throw new StackError(StackError:RESIZE).
            
            /* On init there's no need for any of this. */
            if Depth eq 0 then
                assign iMax = 0.
            else
                assign extent(oTempObject) = Depth
                       extent(cTempPrimitive) = Depth
                       oTempObject = moObjectStack
                       cTempPrimitive = mcPrimitiveStack
                       extent(moObjectStack) = ?
                       extent(mcPrimitiveStack) = ?
                       iMax = Size.
            
            assign extent(moObjectStack) = piDepth
                   extent(mcPrimitiveStack) = piDepth
                   Size = 0.
            
            /* On init this loop won't execute */
            do iLoop = 1 to iMax:
                /* A stack can only be one or the other ... */
                if mlObjectStack then
                    ObjectPush(oTempObject[iLoop]).
                else
                    PrimitivePush(cTempPrimitive[iLoop]).
            end.
        end.
    end method.
    
    method protected void ObjectPush(poValue as Object):
        Assert:ArgumentNotNull(poValue, 'Value').
        
        if Size eq Depth then
        do:
            if AutoExpand then 
                Depth = Size + round(0.5 * Size, 0).
            else
                undo, throw new StackError(StackError:OVERFLOW).
        end.
        
        assign Size = Size + 1
               moObjectStack[Size] = poValue
               mlObjectStack = true when mlObjectStack eq ?.
    end method.
    
    method protected Object ObjectPeek():
        /* Size should never be <= 0 but hey! ... */
        if Size le 0 then
            undo, throw new StackError(StackError:UNDERFLOW).
        
        if Size gt Depth then
            undo, throw new StackError(StackError:OVERFLOW).
        
        return moObjectStack[Size].
    end method.
    
    method protected Object ObjectPop():
        define variable oValue as Object no-undo.
        
        assign oValue = ObjectPeek()
               /* clean out necessary even though Size defines what's on top, 
                  so that we don't leak by holding a reference */
               moObjectStack[Size] = ?
               Size = Size - 1
               .
        return oValue.
    end method.    

    method protected void PrimitivePush(pcValue as character):
        if Size eq Depth then
        do:
            if AutoExpand then 
                Depth = Size + round(0.5 * Size, 0).
            else
                undo, throw new StackError(StackError:OVERFLOW).
        end.
        
        assign Size = Size + 1
               mcPrimitiveStack[Size] = pcValue
               mlObjectStack = false when mlObjectStack eq ?.
    end method.
    
    method protected character PrimitivePeek():
        /* Size should never be < 0 but hey! ... */
        if Size eq 0 then
            undo, throw new StackError(StackError:UNDERFLOW).
                        
        if Size gt Depth then
            undo, throw new StackError(StackError:OVERFLOW).
        
        return mcPrimitiveStack[Size].        
    end method.
    
    method protected character PrimitivePop():
        define variable cValue as character no-undo.
        
        assign cValue = PrimitivePeek()
               /* clean out not totally necessary, since Size defines what's on top */
               mcPrimitiveStack[Size] = ?   
               Size = Size - 1.
        
        return cValue.
    end method.
    
    method public void Swap(piFromPos as integer, piToPos as integer):
        define variable cTempPrimitive as character no-undo.
        define variable oTempObject as Object no-undo.

        if piFromPos eq piToPos then
            return.
        
        /* keep the first item */        
        if mlObjectStack then
            assign oTempObject = moObjectStack[piFromPos]
                   moObjectStack[piFromPos] = moObjectStack[piToPos]
                   moObjectStack[piToPos] = oTempObject.
        else
            assign cTempPrimitive = mcPrimitiveStack[piFromPos]
                   mcPrimitiveStack[piFromPos] = mcPrimitiveStack[piToPos]
                   mcPrimitiveStack[piToPos] = cTempPrimitive.
    end method.
    
    method public void Rotate(piItems as integer):
        define variable cTempPrimitive as character no-undo.
        define variable oTempObject as Object no-undo.
        define variable iLoop as integer no-undo.
        
        if piItems le 1 then
            return.
        
        /* keep the first item */        
        if mlObjectStack then
            oTempObject = moObjectStack[1].
        else
            cTempPrimitive = mcPrimitiveStack[1]. 
        
        do iLoop = 1 to piItems - 1:
            if mlObjectStack then
                moObjectStack[iLoop] = moObjectStack[iLoop + 1].
            else
                mcPrimitiveStack[iLoop] = mcPrimitiveStack[iLoop + 1]. 
        end.
        
        /* put the first item at the bottom of the rotation */
        if mlObjectStack then
            moObjectStack[piItems] = oTempObject.
        else
            mcPrimitiveStack[piItems] = cTempPrimitive.
    end method.
    
    method protected Object extent ObjectToArray():
        return moObjectStack.
    end method.

    method protected character extent PrimitiveToArray():
        return mcPrimitiveStack.        
    end method.
    
    method public void Invert():
        define variable cTempPrimitive as character extent no-undo.
        define variable oTempObject as Object extent no-undo.
        define variable iLoop as integer no-undo.
        
        /* No point, really */
        if Size le 1 then
            return.
        
        /* keep the first item */
        if mlObjectStack then
            oTempObject = moObjectStack.
        else            
            cTempPrimitive = mcPrimitiveStack.
        
        do iLoop = 1 to Size:
            if mlObjectStack then
                moObjectStack[iLoop] = oTempObject[Size - iLoop + 1].
            else
                mcPrimitiveStack[iLoop] = cTempPrimitive[Size - iLoop + 1].
        end.
    end method.
    
    method public override Object Clone():
        define variable oParams as ParameterList no-undo.
        
        oParams = new ParameterList(1).
        if Size eq 0 then
            oParams:SetParameter(1,
                                 DataTypeEnum:Integer:ToString(),
                                 IOModeEnum:Input:ToString(),
                                 this-object:Depth).
        else
        if mlObjectStack then
            oParams:SetParameter(1,
                                 substitute(DataTypeEnum:ClassArray:ToString(), DataTypeEnum:ProgressLangObject:ToString()),  
                                 IOModeEnum:Input:ToString(),
                                 this-object:ObjectToArray() ).
        else
            oParams:SetParameter(1,
                                 DataTypeEnum:CharacterArray:ToString(),
                                 IOModeEnum:Input:ToString(),
                                 this-object:PrimitiveToArray() ).
        
        return this-object:GetClass():New(oParams).
    end method.
    
    method protected logical ObjectContains(poItem as Object):
        define variable lContains as logical no-undo.
        define variable iLoop as integer no-undo.
        
        lContains = false.
        do iLoop = Size to 1 by -1 while not lContains:
            lContains = moObjectStack[iLoop]:Equals(poItem).
        end.
        
        return lContains.
    end method.
    
    method protected logical PrimitiveContains(pcItem as character):
        define variable lContains as logical no-undo.
        define variable iLoop as integer no-undo.

        lContains = false.
        do iLoop = Size to 1 by -1 while not lContains:
            lContains = mcPrimitiveStack[iLoop] eq pcItem.
        end.
        
        return lContains.
    end method.
    
end class./*------------------------------------------------------------------------
    File        : StackError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 14:44:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.StackError.
using Progress.Lang.AppError.

class OpenEdge.Lang.Collections.StackError inherits AppError: 
    define static public property OVERFLOW as character init 'Stack overflow' no-undo get.
    define static public property UNDERFLOW as character init 'Stack underflow' no-undo get.
    define static public property RESIZE as character init 'Stack resize smaller than contents' no-undo get.
    
    constructor public StackError():
        super().
    end constructor.

    constructor public StackError (pcArg1 as char):
        this-object().
        AddMessage(pcArg1, 1).
    end constructor.
    
end class./*------------------------------------------------------------------------
    File        : TypedCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 10 10:43:01 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.TypedCollection.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Lang.Collections.TypedCollection inherits Collection:
    define public property CollectionType as class Class no-undo get. private set. 
    
    constructor public TypedCollection (poType as class Class):
        super().
        CollectionType = poType.
    end constructor.
    
    constructor public TypedCollection(c as TypedCollection):
        super(input c).
        
        CollectionType = c:CollectionType.
    end constructor.
    
    method override public logical Add(newObject as Object):
        Assert:ArgumentIsType(newObject, CollectionType).
        return super:Add(newObject).
    end method.
    
    method override public logical Remove(oldObject as Object):
        Assert:ArgumentIsType(oldObject, CollectionType).
        return super:Remove(oldObject).
    end method.
    
    method override public logical Contains(checkObject as Object):
        Assert:ArgumentIsType(checkObject, CollectionType).
        return super:Contains(checkObject).
    end method.
    
    /* Deep clone. or rather deep enough since we don't know what the elements' Clone()
       operations do, so this may end up being a memberwise clone */
    method override public Object Clone():
        define variable oClone as ICollection no-undo.
        
        oClone = new TypedCollection(this-object:CollectionType). 
        CloneElements(oClone).
        
        return oClone.      
    end method.

end class.
/*------------------------------------------------------------------------
    File        : TypedList
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Apr 08 13:19:02 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.TypedList.
using OpenEdge.Lang.Collections.List.
using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Lang.Collections.TypedList inherits List: 
    define public property CollectionType as class Class no-undo get. private set. 
    
    constructor public TypedList (poType as class Class):
        super().
        CollectionType = poType.
    end constructor.
    
    constructor public TypedList (c as TypedList):
        super(input c).
        
        CollectionType = c:CollectionType.
    end constructor.

    constructor protected TypedList (input poCol as ICollection, input phtt as handle, input pcField as character ):
        super (input poCol, input phtt, input pcField).
    end constructor.
        
    constructor protected TypedList (poType as class Class, input phtt as handle, input pcField as character ):
        super (input phtt, input pcField).
        CollectionType = poType.
    end constructor.
        
    constructor protected TypedList (poType as class Class, input phtt as handle, input hField as handle ):
        super (input phtt, input hField).
        CollectionType = poType.
    end constructor.

    method override public logical Add(poNewObject as Object):
        Assert:ArgumentIsType(poNewObject, CollectionType).
        return super:Add(poNewObject).
    end method.
    
end class./** ------------------------------------------------------------------------
    File        : TypedMap
    Purpose     : A Map collections that's typed: this means that only
                  objects of a specific type can be added as a Key or Value.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 21 11:51:17 EDT 2010
    Notes       : * This class basically allows pseudo-generic collections
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Lang.Collections.TypedMap inherits Map: 
    define public property KeyType as class Class no-undo get. private set. 
    define public property ValueType as class Class no-undo get. private set. 
        
    constructor public TypedMap(poMap as TypedMap):
        super(poMap).

        assign KeyType = poMap:KeyType
               ValueType = poMap:ValueType.
    end constructor.

    constructor public TypedMap(pcKeyType as character, pcValueType as character):
        this-object(Class:GetClass(pcKeyType), Class:GetClass(pcValueType)).
    end constructor.
    
    constructor public TypedMap(poKeyType as class Class, poValueType as class Class):
        super().
        
        Assert:ArgumentNotNull(poKeyType, 'Key type').
        Assert:ArgumentNotNull(poValueType, 'Value type').
        
        assign KeyType = poKeyType
               ValueType = poValueType.
    end constructor.

    /* Associates the specified value with the specified key in this map (optional operation).*/
    method override public Object Put(poKey as Object, poValue as Object):
        Assert:ArgumentIsType(poKey, KeyType).
        Assert:ArgumentIsType(poValue, ValueType).
        return super:Put(poKey, poValue).
    end method.
    
    /* Removes the mapping for this key from this map if it is present (optional operation).*/
    method override public Object Remove(poKey as Object):
        Assert:ArgumentIsType(poKey, KeyType).
        return super:Remove(poKey).
    end method.
    
    /* Returns true if this map contains a mapping for the specified key. */
    method override public logical ContainsKey(poKey as Object):
        Assert:ArgumentIsType(poKey, KeyType).
        return super:ContainsKey(poKey).
    end method.
    
    /* Returns true if this map maps one or more keys to the specified value.*/
    method override public logical ContainsValue(poValue as Object):
        Assert:ArgumentIsType(poValue, ValueType).
        return super:ContainsValue(poValue).
    end method.
   
    /* Returns the value to which this map maps the specified key.*/
    method override public Object Get(poKey as Object):
        Assert:ArgumentIsType(poKey, KeyType).
        return super:Get(poKey).
    end method.
    
    method override public void PutAll( input poMap as IMap):
        Assert:ArgumentIsType(poMap, this-object:GetClass()).
        super:PutAll(poMap).
    end method.
    
end class./*------------------------------------------------------------------------------
    File        : ValueCollection
    Purpose     : ICollection implementation over values in an IMap (also TT based) 
                  object that needs collection capabilities.. 
                  used to return Values IMap 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : 2010
    Notes       : no empty constructor, specialized for IMap 
                 - Changes to the map are reflected here, and vice-versa. 
                 - Supports removal and removes the corresponding map entry from the map
                   (Iterator.remove, Collection.remove, removeAll, retainAll and clear) .
                 - Do not support add and addAll.   
                 - no empty constructor, specialised for IMap 
----------------------------------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.Object.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.Iterator.
using OpenEdge.Lang.Collections.IMap.

class OpenEdge.Lang.Collections.ValueCollection implements ICollection: 
    define protected property OwningMap as IMap no-undo get. set.
    
    define public property Size as integer no-undo 
    get():
        return OwningMap:Size.
    end. 
    
    define private variable mhTempTable     as handle no-undo. 
    define private variable mhField         as handle no-undo. 
 
    constructor public ValueCollection(poMap as IMap,phTT as handle, pcValuefield as char):
        super ().
        assign
            mhTempTable = phTT
            mhField = mhTempTable:default-buffer-handle:buffer-field (pcValuefield)
            OwningMap = poMap.
    end constructor.
    
    method public logical Add(newObject as Object ):
        return false.
        /* undo, throw new AppError("Cannot add, use Map:AddAll instead"). */
    end method.

    method public logical AddAll( newCollection as ICollection ):
        return false.
        /* undo, throw new AppError("Cannot addAll, use Map:AddAll instead"). */
    end method.
    
    method public logical AddArray( o as Object extent ):
        return false.
        /* undo, throw new AppError("Cannot addAll, use Map:AddAll instead"). */
    end method.

    method public void Clear(  ):
        OwningMap:Clear().
    end method.
   
    method public logical IsEmpty(  ):
        return OwningMap:IsEmpty().
    end method.

    method public logical Contains( checkObject as Object):
        return OwningMap:ContainsValue(checkObject).
    end method.
    
    /* Returns a new IIterator over the collection. */
    method public IIterator Iterator( ):    
        return new Iterator(this-object,mhTempTable,mhField:name).
    end method.
      
    /* slow... use Remove on Map or Map:KeySet() instead  */
    method public logical Remove( poOld as Object ):
        define variable oIter as IIterator no-undo.
        define variable oKey  as Object    no-undo.
        define variable oVal  as Object    no-undo.
        oIter = OwningMap:KeySet:Iterator().
        do while oIter:HasNext():
            oKey = oIter:Next().
            oVal  = OwningMap:Get(oKey).
            if oVal:Equals(poOld) then
            do:
                OwningMap:Remove(oKey).
                return true.
            end.    
        end.     
        return false.
    end method.
    
    method public logical RemoveAll(poRemoveCol as ICollection):
        define variable oIter as IIterator no-undo.
        define variable oKey  as Object    no-undo.
        define variable oVal  as Object    no-undo.
        define variable lany as logical no-undo.
        oIter = OwningMap:KeySet:Iterator().
        do while oIter:HasNext():
            oKey = oIter:Next().
            oVal  = OwningMap:Get(oKey).
            if poRemoveCol:Contains(oVal) then
            do:  
                OwningMap:Remove(oKey).
                lAny = true.
            end.    
        end.
        return lAny.
    end method.
    
    method public logical RetainAll(poCol as ICollection):
        define variable oIter as IIterator no-undo.
        define variable oKey  as Object    no-undo.
        define variable oVal  as Object    no-undo.
        define variable lany as logical no-undo.
        oIter = OwningMap:KeySet:Iterator().
        do while oIter:HasNext():
            oKey = oIter:Next().
            oVal  = OwningMap:Get(oKey).
            if not poCol:Contains(oVal) then
            do:  
                OwningMap:Remove(oKey).
                lAny = true.
            end.    
        end.
        return lAny.
    end method.
    
    /* ToArray should not be used with large collections
       If there is too much data the ABL will throw:  
       Attempt to update data exceeding 32000. (12371) */
    method public Object extent ToArray():
        define variable i as integer no-undo.
        define variable oObjArray as Object extent no-undo.
        define variable iterator as IIterator no-undo.
        
        if Size eq 0 then
            return oObjArray.
            
        extent(oObjarray) = Size.
        iterator = Iterator(). 
        do while iterator:hasNext():
           i = i + 1.
           oObjArray[i] = iterator:Next().  
        end.                                     
        return oObjArray.
    end method.
    
    method public void ToTable( output table-handle tt ):
        tt = mhTempTable.
    end method. 
end class.�load_injectabl_modules.pq�       *�  QO��N�G�                        �routinelevel.ib`      {�  O��N�G�                        �OpenEdge/Core/package.htmlȝ      ��  O��N�G�                        �!OpenEdge/Core/InjectABL/Cache.cls��      ��  ,O��N�G�                        �.OpenEdge/Core/InjectABL/ComponentContainer.cls��      $��  �O��N�G�                        �"OpenEdge/Core/InjectABL/ICache.clsB      >��  O��N�G�                        �                                        �-OpenEdge/Core/InjectABL/IInjectionRequest.cls��      I��  �O��N�G�                        �#OpenEdge/Core/InjectABL/IKernel.cls��      MN�  gO��N�G�                        �,OpenEdge/Core/InjectABL/InjectionRequest.cls�u      g��  �O��N�G�                        �&OpenEdge/Core/InjectABL/KernelBase.clsWX      m@�  LjO��N�G�                        �*OpenEdge/Core/InjectABL/KernelSettings.cls%      ���  RO��N�G�                        �                                                              �*OpenEdge/Core/InjectABL/StandardKernel.cls,�      ���  	[O��N�G�                        �+OpenEdge/Core/InjectABL/Binding/Binding.clsV�      �W�  �O��N�G�                        �2OpenEdge/Core/InjectABL/Binding/BindingBuilder.cls׆      ��  d�O��N�G�                        �/OpenEdge/Core/InjectABL/Binding/BindingRoot.cls-     E��  �O��N�G�                        �5OpenEdge/Core/InjectABL/Binding/BindingTargetEnum.cls��     T��  mO��N�G�                        �                               �,OpenEdge/Core/InjectABL/Binding/IBinding.clsW     \�  xO��N�G�                        �6OpenEdge/Core/InjectABL/Binding/IBindingCollection.cls{l     h��  �O��N�G�                        �4OpenEdge/Core/InjectABL/Binding/IBindingResolver.clsu     k=�  DO��N�G�                        �0OpenEdge/Core/InjectABL/Binding/IBindingRoot.cls�]     o��  �O��N�G�                        �2OpenEdge/Core/InjectABL/Binding/IBindingSyntax.cls��     xa�  -tO��N�G�                        �                  �;OpenEdge/Core/InjectABL/Binding/StandardBindingResolver.cls�/     ���  �O��N�G�                        �8OpenEdge/Core/InjectABL/Binding/Conditions/Condition.cls<#     ���  9O��N�G�                        �?OpenEdge/Core/InjectABL/Binding/Conditions/ConditionBuilder.clsh�     ��  O��N�G�                        �BOpenEdge/Core/InjectABL/Binding/Conditions/ConnectionCondition.clsB�     ��  O��N�G�                        �                                                                       �JOpenEdge/Core/InjectABL/Binding/Conditions/ConnectionConditionResolver.clsVs     �!�  vO��N�G�                        �9OpenEdge/Core/InjectABL/Binding/Conditions/ICondition.cls��     ��  �O��N�G�                        �AOpenEdge/Core/InjectABL/Binding/Conditions/IConditionResolver.cls*F     �w�  <O��N�G�                        �?OpenEdge/Core/InjectABL/Binding/Conditions/IConditionSyntax.cls6�     ��  �O��N�G�                        �                                                        �COpenEdge/Core/InjectABL/Binding/Conditions/SessionTypeCondition.cls�     ���  	�O��N�G�                        �KOpenEdge/Core/InjectABL/Binding/Conditions/SessionTypeConditionResolver.cls�H     ��  KO��N�G�                        �HOpenEdge/Core/InjectABL/Binding/Conditions/StandardConditionResolver.cls�      ��  	�O��N�G�                        �>OpenEdge/Core/InjectABL/Binding/Conditions/UITypeCondition.clsQ�     ��  �O��N�G�                        �                                       �<OpenEdge/Core/InjectABL/Binding/Modules/IInjectionModule.cls�m     ��  #O��N�G�                        �FOpenEdge/Core/InjectABL/Binding/Modules/IInjectionModuleCollection.cls�     #��  
�O��N�G�                        �;OpenEdge/Core/InjectABL/Binding/Modules/InjectionModule.cls�&     .��  �O��N�G�                        �8OpenEdge/Core/InjectABL/Binding/Modules/ModuleLoader.clsU�     ?��  �O��N�G�                        �                                                                      �9OpenEdge/Core/InjectABL/Binding/Parameters/IParameter.cls��     E#�  �O��N�G�                        �8OpenEdge/Core/InjectABL/Binding/Parameters/Parameter.cls!�     N"�  %�O��N�G�                        �6OpenEdge/Core/InjectABL/Binding/Parameters/Routine.cls�     s��  �O��N�G�                        �7OpenEdge/Core/InjectABL/Lifecycle/ILifecycleContext.cls��     {g�  �O��N�G�                        �                                                                                             �8OpenEdge/Core/InjectABL/Lifecycle/ILifecycleStrategy.clsB�     ���  pO��N�G�                        �BOpenEdge/Core/InjectABL/Lifecycle/ILifecycleStrategyCollection.cls��     �_�  xO��N�G�                        �/OpenEdge/Core/InjectABL/Lifecycle/IPipeline.cls�^     ���  �O��N�G�                        �/OpenEdge/Core/InjectABL/Lifecycle/IProvider.cls�     ���  O��N�G�                        �                                                                                                   �6OpenEdge/Core/InjectABL/Lifecycle/LifecycleContext.clssG     ���  0O��N�G�                        �7OpenEdge/Core/InjectABL/Lifecycle/LifecycleStrategy.clsU     ���  �O��N�G�                        �FOpenEdge/Core/InjectABL/Lifecycle/MethodInjectionLifecycleStrategy.cls�     ���  �O��N�G�                        �HOpenEdge/Core/InjectABL/Lifecycle/PropertyInjectionLifecycleStrategy.cls^&     ���  �O��N�G�                        �                                                                �6OpenEdge/Core/InjectABL/Lifecycle/StandardPipeline.cls��     �q�  VO��N�G�                        �6OpenEdge/Core/InjectABL/Lifecycle/StandardProvider.clsH�     ���  5�O��N�G�                        �3OpenEdge/Core/InjectABL/Lifecycle/StandardScope.cls:�     �w�  
�O��N�G�                        �7OpenEdge/Core/InjectABL/Lifecycle/StandardScopeEnum.cls>�     �j�  	�O��N�G�                        � OpenEdge/Core/Logger/ILogger.cls7�     [�  �O��N�G�                        �                    �-OpenEdge/Core/System/AccessViolationError.clsl�     	�  vO��N�G�                        �)OpenEdge/Core/System/ApplicationError.cls��     w�  �O��N�G�                        �&OpenEdge/Core/System/ArgumentError.cls     /q�  O��N�G�                        �1OpenEdge/Core/System/BufferFieldMismatchError.clsC|     4�  �O��N�G�                        �0OpenEdge/Core/System/BufferNotAvailableError.cls��     9S�  �O��N�G�                        �                                             �*OpenEdge/Core/System/DoesNotExistError.cls(3     ?+�  �O��N�G�                        �*OpenEdge/Core/System/ErrorSeverityEnum.cls�     D��  �O��N�G�                        �"OpenEdge/Core/System/EventArgs.clsFF     M��  =O��N�G�                        �#OpenEdge/Core/System/ILoginData.cls�     S�  O��N�G�                        �+OpenEdge/Core/System/InvalidActionError.cls>(     U;�  cO��N�G�                        �                                                                      �)OpenEdge/Core/System/InvalidCallError.cls��     Z��  3O��N�G�                        �)OpenEdge/Core/System/InvalidTypeError.cls5�     ^��  %O��N�G�                        �3OpenEdge/Core/System/InvalidValueSpecifiedError.cls8.     d��  �O��N�G�                        �(OpenEdge/Core/System/InvocationError.cls@�     k��  �O��N�G�                        �OpenEdge/Core/System/IQuery.clsq     r9�  O��N�G�                        �                                                              �)OpenEdge/Core/System/IQueryDefinition.cls+     �O�  /O��N�G�                        �$OpenEdge/Core/System/ITableOwner.cls�@     �c�  �O��N�G�                        �"OpenEdge/Core/System/LoginData.cls�	     ���  �O��N�G�                        �&OpenEdge/Core/System/NotFoundError.cls�     ���  �O��N�G�                        �OpenEdge/Core/System/Query.cls��     �p�  DO��N�G�                        �$OpenEdge/Core/System/QueryBuffer.cls�     =��  O��N�G�                        �  �(OpenEdge/Core/System/QueryDefinition.cls��     L��  ��O��N�G�                        �1OpenEdge/Core/System/QueryDefinitionEventArgs.cls     ���  O��N�G�                        �5OpenEdge/Core/System/QueryDefinitionOperationEnum.cls�     ��  CO��N�G�                        �%OpenEdge/Core/System/QueryElement.cls#�     
��  �O��N�G�                        �)OpenEdge/Core/System/QueryElementEnum.cls�7     ��  YO��N�G�                        �                                              �$OpenEdge/Core/System/QueryFilter.cls(�     �  	O��N�G�                        �$OpenEdge/Core/System/QueryHeader.clsO�     '�  �O��N�G�                        �"OpenEdge/Core/System/QueryJoin.cls�     (��  pO��N�G�                        �"OpenEdge/Core/System/QuerySort.clsק     :8�  vO��N�G�                        �(OpenEdge/Core/System/RowPositionEnum.cls��     E��  {O��N�G�                        �#OpenEdge/Core/System/UITypeEnum.cls""     L)�  #O��N�G�                        �  �'OpenEdge/Core/System/UnhandledError.cls��     RL�  [O��N�G�                        �2OpenEdge/Core/System/UnsupportedOperationError.cls�     X��  �O��N�G�                        �/OpenEdge/Core/System/ValueNotSpecifiedError.clsA     ^��  �O��N�G�                        �-OpenEdge/Core/Util/BinaryOperationsHelper.clsZ     ed�  �O��N�G�                        �#OpenEdge/Core/Util/BufferHelper.cls�y     sT�  �O��N�G�                        �                                                  �&OpenEdge/Core/Util/IExternalizable.cls�H     ���  �O��N�G�                        �#OpenEdge/Core/Util/IObjectInput.cls0<     ���  	O��N�G�                        �$OpenEdge/Core/Util/IObjectOutput.cls��     �
�  GO��N�G�                        �$OpenEdge/Core/Util/ISerializable.cls��     �Q�  �O��N�G�                        �'OpenEdge/Core/Util/ObjectInputError.cls"�     ��  	�O��N�G�                        �                                                                                  �(OpenEdge/Core/Util/ObjectInputStream.cls��     ���  �O��N�G�                        �(OpenEdge/Core/Util/ObjectOutputError.cls�l     ���  �O��N�G�                        �)OpenEdge/Core/Util/ObjectOutputStream.cls�*     ���  ��O��N�G�                        �,OpenEdge/Core/Util/ObjectStreamConstants.clsɻ     Ls�  �O��N�G�                        �OpenEdge/Core/XML/SaxReader.cls�d     j�  'O��N�G�                        �                                                                      �#OpenEdge/Core/XML/saxreaderfacade.p6i     �%�  �O��N�G�                        �OpenEdge/Core/XML/SaxWriter.cls�|     ��  4AO��N�G�                        �+OpenEdge/Core/XML/SaxWriterDataTypeEnum.cls{�     �E�  �O��N�G�                        �$OpenEdge/Core/XML/SaxWriterError.cls�     ���  9O��N�G�                        �/OpenEdge/Core/XML/WebServiceInvocationError.cls�     ��  �O��N�G�                        �                                                                          �(OpenEdge/Core/XML/WebServiceProtocol.clsI�     ��  O��N�G�                        �OpenEdge/Lang/ABLPrimitive.clsT�     ��  �O��N�G�                        �OpenEdge/Lang/ABLSession.cls)�     a�   �O��N�G�                        �!OpenEdge/Lang/AgentConnection.clsU�     '��  �O��N�G�                        �OpenEdge/Lang/AgentRequest.cls�<     .��  �O��N�G�                        �OpenEdge/Lang/Assert.cls     4��  3�O��N�G�                        �                                �$OpenEdge/Lang/BufferJoinModeEnum.cls^�     h?�  �O��N�G�                        �OpenEdge/Lang/ByteOrderEnum.cls��     o��  
+O��N�G�                        �"OpenEdge/Lang/CallbackNameEnum.cls�n     z�  �O��N�G�                        �%OpenEdge/Lang/CompareStrengthEnum.cls�     ���  	&O��N�G�                        �OpenEdge/Lang/DataTypeEnum.cls�     ���  M#O��N�G�                        �)OpenEdge/Lang/DateTimeAddIntervalEnum.cls�/     ��  	�O��N�G�                        �        �OpenEdge/Lang/EnumMember.cls�K     ���  
qO��N�G�                        �OpenEdge/Lang/FillModeEnum.cls�@     �l�  �O��N�G�                        �OpenEdge/Lang/FindTypeEnum.cls>M     �Z�  gO��N�G�                        �OpenEdge/Lang/FlagsEnum.cls��     ���  �O��N�G�                        �OpenEdge/Lang/ICloneable.cls$%     	��  �O��N�G�                        �OpenEdge/Lang/Int.cls+Z     	7�  XO��N�G�                        �                                                     �OpenEdge/Lang/IOModeEnum.cls�     	��  	�O��N�G�                        �OpenEdge/Lang/JoinEnum.clsm�     	)�  �O��N�G�                        �OpenEdge/Lang/LockModeEnum.clst�     	 ��  
YO��N�G�                        � OpenEdge/Lang/LoginStateEnum.cls��     	+I�  �O��N�G�                        �OpenEdge/Lang/OperatorEnum.cls     	3�  =O��N�G�                        �$OpenEdge/Lang/QueryBlockTypeEnum.cls�Z     	CD�  �O��N�G�                        �                                   �OpenEdge/Lang/QueryTypeEnum.clsD�     	K�  O��N�G�                        �OpenEdge/Lang/ReadModeEnum.cls�     	R	�  7O��N�G�                        �!OpenEdge/Lang/RoutineTypeEnum.cls��     	Z@�  6O��N�G�                        �OpenEdge/Lang/RowStateEnum.cls�     	ev�  �O��N�G�                        �$OpenEdge/Lang/SaxWriteStatusEnum.cls��     	q`�  �O��N�G�                        �'OpenEdge/Lang/SerializationModeEnum.clsh�     	���  O��N�G�                        �                  �'OpenEdge/Lang/SessionClientTypeEnum.clsR�     	��  IO��N�G�                        �#OpenEdge/Lang/SortDirectionEnum.cls��     	�O�  	&O��N�G�                        �OpenEdge/Lang/String.clsm     	�u�  �O��N�G�                        �OpenEdge/Lang/TimeStamp.cls�N     	��  O��N�G�                        �&OpenEdge/Lang/VerifySchemaModeEnum.cls��     	��  �O��N�G�                        �OpenEdge/Lang/WidgetHandle.cls�     	���  ^O��N�G�                        �                        �&OpenEdge/Lang/BPM/DataSlotInstance.cls�     	�]�  #O��N�G�                        �&OpenEdge/Lang/BPM/DataSlotTemplate.cls1     	���  VO��N�G�                        �"OpenEdge/Lang/BPM/IBizLogicAPI.clsL     
	��  ,O��N�G�                        �"OpenEdge/Lang/BPM/PriorityEnum.cls+     
5��  5O��N�G�                        �%OpenEdge/Lang/BPM/ProcessInstance.cls�?     
=�  �O��N�G�                        �                                                                                     �.OpenEdge/Lang/BPM/ProcessInstanceStateEnum.cls]5     
X��  �O��N�G�                        �%OpenEdge/Lang/BPM/ProcessTemplate.cls.�     
a��  �O��N�G�                        �.OpenEdge/Lang/BPM/ProcessTemplateStateEnum.clsv     
y��  �O��N�G�                        �!OpenEdge/Lang/BPM/SavvionType.cls��     
���  B]O��N�G�                        �OpenEdge/Lang/BPM/Task.clsT�     
���  �O��N�G�                        �                                                                              �(OpenEdge/Lang/BPM/WorkFlowWebService.clss�     
О� cO��N�G�                        �OpenEdge/Lang/BPM/WorkItem.cls�t     ��  �O��N�G�                        �(OpenEdge/Lang/BPM/WorkItemStatusEnum.clsZ^     ��  
�O��N�G�                        �&OpenEdge/Lang/BPM/WorkStepInstance.cls�+     �+�  �O��N�G�                        �&OpenEdge/Lang/BPM/WorkStepTemplate.cls��     ��  �O��N�G�                        �                                                                                �.OpenEdge/Lang/BPM/WorkStepTemplateTypeEnum.clsQ�     %��  �O��N�G�                        �2OpenEdge/Lang/Collections/AbstractTTCollection.cls=R     9�  �O��N�G�                        �+OpenEdge/Lang/Collections/CharacterList.cls՟     W��  PO��N�G�                        �,OpenEdge/Lang/Collections/CharacterStack.cls+k     dH�  �O��N�G�                        �(OpenEdge/Lang/Collections/Collection.cls     i=�  �O��N�G�                        �                                           �&OpenEdge/Lang/Collections/EntrySet.cls}f     x��  �O��N�G�                        �.OpenEdge/Lang/Collections/EntrySetIterator.cls��     ���  �O��N�G�                        �)OpenEdge/Lang/Collections/ICollection.cls��     ���  O��N�G�                        �'OpenEdge/Lang/Collections/IIterator.cls6Y     ���  O��N�G�                        �#OpenEdge/Lang/Collections/IList.cls��     ���  _O��N�G�                        �                                                                   �+OpenEdge/Lang/Collections/IListIterator.clsdw     ��  1O��N�G�                        �"OpenEdge/Lang/Collections/IMap.cls�     �O�  
TO��N�G�                        �'OpenEdge/Lang/Collections/IMapEntry.cls�A     ���  �O��N�G�                        �*OpenEdge/Lang/Collections/IntegerStack.cls��     �d�  
O��N�G�                        �"OpenEdge/Lang/Collections/ISet.cls��     �n�  	�O��N�G�                        �                                                                          �&OpenEdge/Lang/Collections/Iterator.cls;�     ��  hO��N�G�                        �$OpenEdge/Lang/Collections/KeySet.clsz�     Ղ�  O��N�G�                        �"OpenEdge/Lang/Collections/List.clsen     ��  (�O��N�G�                        �*OpenEdge/Lang/Collections/ListIterator.cls5      F�  �O��N�G�                        �!OpenEdge/Lang/Collections/Map.cls!8     ��   BO��N�G�                        �                                                                                   �&OpenEdge/Lang/Collections/MapEntry.cls�S     7
�  �O��N�G�                        �)OpenEdge/Lang/Collections/ObjectStack.cls|�     =��  �O��N�G�                        �#OpenEdge/Lang/Collections/Queue.cls�4     B��  �O��N�G�                        �!OpenEdge/Lang/Collections/Set.cls��     D��  �O��N�G�                        �#OpenEdge/Lang/Collections/Stack.cls6     U{�  /�O��N�G�                        �                                                                                    �(OpenEdge/Lang/Collections/StackError.cls     �	�  O��N�G�                        �-OpenEdge/Lang/Collections/TypedCollection.cls/�     ��  'O��N�G�                        �'OpenEdge/Lang/Collections/TypedList.cls�4     �@�  sO��N�G�                        �&OpenEdge/Lang/Collections/TypedMap.cls     ���  �O��N�G�                        �-OpenEdge/Lang/Collections/ValueCollection.cls�     �q�  lO��N�G�                        � �:        d   '                                �          