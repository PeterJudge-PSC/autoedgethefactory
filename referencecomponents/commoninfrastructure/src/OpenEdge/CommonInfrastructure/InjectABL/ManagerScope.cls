/*------------------------------------------------------------------------
    File        : ManagerScope
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 18 11:51:06 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.InjectABL.ManagerScope.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScope.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.InjectABL.ManagerScope inherits StandardScope: 
    define static public property ServiceManager as EnumMember no-undo get. private set.
    define static public property TenantManager as EnumMember no-undo get. private set.
    define static public property SecurityManager as EnumMember no-undo get. private set.
    
    constructor static ManagerScope():
        ManagerScope:ServiceManager  = new EnumMember().
        ManagerScope:TenantManager   = new EnumMember().
        ManagerScope:SecurityManager = new EnumMember().
    end constructor.
    
    method override static public Object GetScope(poContext as ILifecycleContext,
                                                  poScope as EnumMember  /* derived from StandardScope */ ):
        define variable oScope as Object no-undo.
        
        case poScope:
            when ManagerScope:ServiceManager then
                oScope = poContext:Kernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager')).
            when ManagerScope:TenantManager then
                oScope = poContext:Kernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ITenantManager')).
            when ManagerScope:SecurityManager then
                oScope = poContext:Kernel:Get(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager')).
            otherwise
            do:
                /* Try with what we've got; if nothing, use default. */
                oScope = StandardScope:GetScope(poContext, poScope).
                if not valid-object(oScope) and poScope ne StandardScope:Default then
                    oScope = StandardScope:GetScope(poContext, StandardScope:Default).
            end.
        end case.
        
        return oScope.
    end method.
    
end class.
