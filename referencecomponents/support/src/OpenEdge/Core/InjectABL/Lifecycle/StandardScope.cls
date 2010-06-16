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
    
end class.