/** ------------------------------------------------------------------------
    File        : IService
    Purpose     : Interface definition for base OERA Service
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Apr 15 14:59:18 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.IComponent.
using OpenEdge.CommonInfrastructure.IServiceManager.

interface OpenEdge.CommonInfrastructure.IService /* inherits IComponent */:
      
    /** (mandatory) Stores a reference to the session's Service Manager */
    define public property ServiceManager as IServiceManager no-undo get.
    
end interface.