/*------------------------------------------------------------------------
    File        : IKernel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Mar 02 11:24:26 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.InjectABL.Binding.IBindingCollection.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.Core.InjectABL.IInjectionRequest.
using OpenEdge.Core.InjectABL.ComponentContainer.
using OpenEdge.Core.InjectABL.KernelSettings.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using OpenEdge.Lang.Collections.*.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.IKernel: /* inherits IBindingRoot */
    
    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module. 
    
        @param pcService A string version of a class/interface type name. 
        @return An instance of the requested service/interface    */
    method public Object Get(input pcService as character).
    
    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module. 
    
        @param poService A service represented by a Progress.Lang.Class type instance.  
        @return An instance of the requested service/interface    */
    method public Object Get(input poService as class Class).
    
    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module. 
    
        @param poService A service represented by a Progress.Lang.Class type instance.
        @param poParameters A collection of parameters to add to the bindings for the
                            object being instantiated.  
        @return An instance of the requested service/interface    */
    method public Object Get(input poService as class Class,
                             input poParameters as IParameterCollection).
    
    /** Gets the injection kernel settings  */
    define public property Settings as KernelSettings no-undo get.
            
    /** Gets the component container, which holds components that contribute to InjectABL.  */
    define public property Components as ComponentContainer no-undo get.

    /** Gets the modules that have been loaded into the kernel.  */
    define public property Modules as IInjectionModuleCollection no-undo get.

    /** Determines whether a module with the specified name has been loaded in the kernel.
        @param name The name of the module.
        @return <c>True</c> if the specified module has been loaded. otherwise, <c>false</c>.
     */
    method public logical HasModule(input pcName as char).

    /** Loads the module(s) into the kernel.
        @param modules The modules to load.
      */
    method public void Load(input poModules as IInjectionModuleCollection).
    method public void Load(input poModules as IInjectionModule).

    /** Loads modules from the files that match the specified pattern(s).
        @param filePatterns The file patterns (i.e. "*.dll", "modules/ *.rb") to match.
      */
    method void Load(input pcFilePatterns as character extent).

    /** Unloads the plugin with the specified name.
        @param name The plugin's name.
      */
    method public void Unload(input pcName as char).

    /** Injects the specified existing instance, without managing its lifecycle.
        @param instance The instance to inject.
        @param parameters The parameters to pass to the request.
      */
    method public void Inject(input poInstance as Object,
                              input poParameters as IParameterCollection).

    /** Deactivates and releases the specified instance if it is currently managed by InjectABL.
    
        @param instance The instance to release.
        @return true if the instance was found and released. otherwise false.
      */
    method public logical Release(input poInstance as Object).

    /** Deactivates and releases all instances scoped to the specified object.
    
        @param poScope The scope for which to release instances.        
      */
    method public void Clear(input poScope as Object).
    
    /** Gets the bindings registered for the specified service.
        @param service The service in question.
        @return A series of bindings that are registered for the service.
     */
    method public IBindingCollection GetBindings(input poService as class Class).
    
    /** Gets the bindings registered for the specified scope.
        @param service The service in question.
        @return A series of bindings that are registered for the service.
     */
    method public IBindingCollection GetBindings(input poScopeCallback as class Class,
                                                 input poScope as EnumMember).
    
end interface.