/** ------------------------------------------------------------------------
    File        : Service
    Purpose     : General OERA service  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 19 16:29:36 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager. 
using OpenEdge.CommonInfrastructure.Common.Component.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.Service inherits Component
        implements IService:
                
    /** (mandatory) Stores a reference to the session's Service Manager */        
    define public property ServiceManager as IServiceManager no-undo get. private set. 
    
    constructor public Service (poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(cast(poComponentInfo, IComponentInfo)).
        
        Assert:ArgumentNotNull(poServiceManager, 'Service Manager').
        ServiceManager = poServiceManager. 
    end constructor.
    
    method override public logical Equals(p0 as Object):
        return (super:Equals(input p0) and
               this-object:ServiceManager:Equals(cast(p0, Service):ServiceManager)).
    end method.
    
end class.