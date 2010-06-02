/*------------------------------------------------------------------------
    File        : StandardScope
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 03 14:37:17 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.StandardScope.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.StandardScope:
    define static public property Default as EnumMember no-undo get. private set.
    
    /** One instance, running free   */
    define static public property Transient as EnumMember no-undo get. private set.
    
    /** Only one instance at a time: effectively scoped to the life of the InjectABL kernel. */
    define static public property Singleton as EnumMember no-undo get. private set.
    /** Scoped to the life of the (AppServer/WebSpeed) agent */
    define static public property Agent as EnumMember no-undo get. private set.
    
    define static public property Custom as EnumMember no-undo get. private set.
    
    constructor static StandardScope():
        /* these all use this type as IBinding:ScopeCallbackType */
        StandardScope:Transient = new EnumMember('Transient Scope').
        StandardScope:Singleton = new EnumMember('Singleton Scope').
        StandardScope:Agent = new EnumMember('Agent Scope').
        
        /* IBinding:ScopeCallbackType set to input value */
        StandardScope:Custom = new EnumMember('Custom Scope').
        
        StandardScope:Default = StandardScope:Transient.
    end constructor.
    
    /** Gets the callback for transient scope. **/
    method static public Object GetScope(poContext as ILifecycleContext,
                                         poScope as EnumMember  /* StandardScope */ ):
        case poScope:
            when StandardScope:Transient then return StandardScope:Transient(poContext).
            when StandardScope:Singleton then return StandardScope:Singleton(poContext).
            when StandardScope:Agent then return StandardScope:Agent(poContext).
        end case.
    end method.
    
    method static public Object Transient(poContext as ILifecycleContext):
        return ?.
    end method.
    
    /** Gets the callback for singleton scope. **/
    method static public Object Singleton(poContext as ILifecycleContext):
         return poContext:Kernel.
    end method.
    
    method static public Object Agent(poContext as ILifecycleContext):
        @todo(task="implement agent").
                
        return ?.
    end method.
    
end class.