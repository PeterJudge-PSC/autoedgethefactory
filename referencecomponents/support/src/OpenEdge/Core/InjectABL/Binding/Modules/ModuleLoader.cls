/*------------------------------------------------------------------------
    File        : ModuleLoader
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 10:23:08 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

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
end class.