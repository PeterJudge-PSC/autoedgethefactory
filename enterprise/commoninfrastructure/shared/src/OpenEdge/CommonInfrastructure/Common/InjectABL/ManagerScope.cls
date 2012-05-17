/*------------------------------------------------------------------------
    File        : ManagerScope
    Purpose     : InjectABL scopes for Common Infrastructure Managers, per manager.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 18 11:51:06 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScope.
using OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScopeEnum.

using OpenEdge.Core.InjectABL.Lifecycle.StandardScope.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.

using OpenEdge.Lang.Assert.
using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScope inherits StandardScope:
    method static public Object GetScope(poContext as ILifecycleContext,
                                         poScope as ManagerScopeEnum):
        define variable oScope as Object no-undo.
        
        Assert:ArgumentIsValidType(poScope:Name). 
        oScope = poContext:Kernel:Get(Class:GetClass(poScope:Name)).
        
        return oScope.
    end method.
    
end class.