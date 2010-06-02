/*------------------------------------------------------------------------
    File        : InjectionModule
    Purpose     : 
    Syntax      :
    Description : A loadable unit that defines bindings for your application.
    Author(s)   : pjudge
    Created     : Tue Mar 02 11:08:44 EST 2010 
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.InjectABL.Binding.BindingRoot.
using OpenEdge.Core.InjectABL.Binding.IBindingRoot.
using OpenEdge.Core.InjectABL.Binding.Binding.
using OpenEdge.Core.InjectABL.Binding.BindingBuilder.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.IBindingCollection.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModule.
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
    
    define override public property Bindings as IBindingCollection no-undo get. private set.
         
    constructor protected InjectionModule():
        Bindings = new IBindingCollection().
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
        @param kernel The kernel that is unloading the module.
       */
    method public void OnUnload(poKernel as IKernel):
        Assert:ArgumentNotNull(poKernel, "Injection kernel").
        
        define variable oIterator as IIterator.
        define variable oBinding as IBinding.
        
        Unload().
        
        oIterator = Bindings:Iterator().
                                        
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
        @param binding The binding to add.
       */
    method override public void AddBinding(poBinding as IBinding):
        Assert:ArgumentNotNull(poBinding, "binding").
        
        cast(Kernel, IBindingRoot):AddBinding(poBinding).
        Bindings:Add(poBinding).
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
    
end class.