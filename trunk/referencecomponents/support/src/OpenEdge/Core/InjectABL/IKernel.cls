/*------------------------------------------------------------------------
    File        : IKernel
    Purpose     : InjectABL Kernel interface
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:24:26 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.IInjectionRequest.
using OpenEdge.Core.InjectABL.ComponentContainer.
using OpenEdge.Core.InjectABL.KernelSettings.
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
        @param IParameterCollection A collection of parameters to add to the bindings for the
                            object being instantiated.  
        @return Object An instance of the requested service/interface    */
    method public Object Get(input poService as class Class,
                             input poParameters as IParameterCollection).

    @todo(task="question", action="legit?").
    /** Instantiates all instances matching the specified scope. Typically
        used to pre-start a set of objects when a Manager, for example, starts.
        
        @param StandardScopeEnum The scope type (ie manager)
        @param Class The parent scope (eg ServiceManager or SecurityManager).
        @return Object An array of objects matching the scope.  */
    method public Object extent Get(input poScope as StandardScopeEnum,
                                    input poScopeCallback as class Class).
    
    /** Determines whether a module with the specified name has been loaded in the kernel.
        
        @param character The name of the module.
        @return <c>True</c> if the specified module has been loaded. otherwise, <c>false</c>. */
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
    method void Load(input pcFilePatterns as character extent).
    
    /** Unloads the plugin with the specified name.
        @param character The plugin's name. */
    method public void Unload(input pcName as char).
    
    /** Injects the specified existing instance, without managing its lifecycle.
        @param Object The instance to inject.
        @param IParameterCollection The parameters to pass to the request.  */
    method public void Inject(input poInstance as Object,
                              input poParameters as IParameterCollection).

    /** Deactivates and releases the specified instance if it is currently managed by InjectABL.
    
        @param Object The instance to release.
        @return logical True if the instance was found and released. otherwise false. */
    method public logical Release(input poInstance as Object).

    /** Deactivates and releases all instances scoped to the specified object.
    
        @param Object The scope object for which to release instances.  */
    method public void Clear(input poScope as Object).
    
end interface.