/*------------------------------------------------------------------------
    File        : ManagerScopeEnum
    Purpose     : CommonInfrastructure Scope enumeration. Used with 
                  OpenEdge.CommonInfrastructure.InjectABL.ManagerScope.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jun 07 09:03:40 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.InjectABL.ManagerScopeEnum.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.

class OpenEdge.CommonInfrastructure.InjectABL.ManagerScopeEnum inherits StandardScopeEnum: 
    define static public property ServiceManager as ManagerScopeEnum no-undo get. private set.
    define static public property TenantManager as ManagerScopeEnum no-undo get. private set.
    define static public property SecurityManager as ManagerScopeEnum no-undo get. private set.
    
    constructor static ManagerScopeEnum():
        ManagerScopeEnum:ServiceManager  = new ManagerScopeEnum('ServiceManager Scope').
        ManagerScopeEnum:TenantManager   = new ManagerScopeEnum('TenantManager Scope').
        ManagerScopeEnum:SecurityManager = new ManagerScopeEnum('SecurityManager Scope').
    end constructor.
    
	constructor public ManagerScopeEnum(input pcName as character):
		super(pcName).
	end constructor.
	
end class.