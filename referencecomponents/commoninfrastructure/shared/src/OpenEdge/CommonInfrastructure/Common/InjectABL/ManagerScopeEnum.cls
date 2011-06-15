/** ------------------------------------------------------------------------
    File        : ManagerScopeEnum
    Purpose     : CommonInfrastructure Scope enumeration. Used with 
                  OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScope.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Jun 07 09:03:40 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScopeEnum.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.

class OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScopeEnum inherits StandardScopeEnum:
     
    define static public property ServiceManager as ManagerScopeEnum no-undo get. private set.
    define static public property SecurityManager as ManagerScopeEnum no-undo get. private set.
    define static public property ConnectionManager as ManagerScopeEnum no-undo get. private set.
    
    constructor static ManagerScopeEnum():
        ManagerScopeEnum:ServiceManager  = new ManagerScopeEnum(OpenEdge.CommonInfrastructure.Common.ServiceManager:IServiceManagerType:TypeName).
        ManagerScopeEnum:SecurityManager = new ManagerScopeEnum(OpenEdge.CommonInfrastructure.Common.SecurityManager:ISecurityManagerType:TypeName).
        ManagerScopeEnum:ConnectionManager = new ManagerScopeEnum(OpenEdge.CommonInfrastructure.Common.ConnectionManager:IConnectionManagerType:TypeName).
    end constructor.
    
    constructor public ManagerScopeEnum(input pcName as character):
        super(pcName).
    end constructor.
    
end class.