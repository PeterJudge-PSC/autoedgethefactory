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

using OpenEdge.CommonInfrastructure.InjectABL.ManagerScope.
using OpenEdge.CommonInfrastructure.InjectABL.ManagerScopeEnum.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScope.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.InjectABL.ManagerScope inherits StandardScope:
    method static public Object GetScope(poContext as ILifecycleContext,
                                         poScope as ManagerScopeEnum):
        define variable oScope as Object no-undo.
        
        case poScope:
            when ManagerScopeEnum:ServiceManager then
                oScope = poContext:Kernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager')).
            when ManagerScopeEnum:TenantManager then
                oScope = poContext:Kernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ITenantManager')).
            when ManagerScopeEnum:SecurityManager then
                oScope = poContext:Kernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager')).
            otherwise
            do:
                /* Try with what we've got; if nothing, use default. */
                oScope = StandardScope:GetScope(poContext, cast(poScope, StandardScopeEnum)).
                if not valid-object(oScope) and poScope ne StandardScopeEnum:Default then
                    oScope = StandardScope:GetScope(poContext, StandardScopeEnum:Default).
            end.
        end case.
        
        return oScope.
    end method.
    
end class.