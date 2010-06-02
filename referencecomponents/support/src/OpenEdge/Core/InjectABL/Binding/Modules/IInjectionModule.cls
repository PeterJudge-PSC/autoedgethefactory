
/*------------------------------------------------------------------------
    File        : IInjectionModule
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Mar 02 11:09:36 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Core.InjectABL.Binding.Modules.*.
using OpenEdge.Core.InjectABL.*.


interface OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule:
    
    /** Gets the module's name. **/
    define public property Name as character no-undo get.
    
    /** Called when the module is loaded into a kernel.
         <param name="kernel">The kernel that is loading the module.</param>
     **/
     method public void OnLoad(poKernel as IKernel).
     
     /** Called when the module is unloaded from a kernel.
         <param name="kernel">The kernel that is unloading the module.</param>
      **/
     method public void OnUnload(poKernel as IKernel).
          
end interface.