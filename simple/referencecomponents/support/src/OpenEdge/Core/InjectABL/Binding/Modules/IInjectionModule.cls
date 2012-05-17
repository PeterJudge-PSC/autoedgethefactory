/** ------------------------------------------------------------------------
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
          
end interface.