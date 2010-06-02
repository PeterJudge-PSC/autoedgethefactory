/*------------------------------------------------------------------------
    File        : ServiceManager
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 22 10:53:02 EST 2010
    Notes       : * The service
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Client.ServiceManager.
using OpenEdge.CommonInfrastructure.Client.ServiceTypeEnum.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponent.

using OpenEdge.Core.InjectABL.IKernel. 
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Client.ServiceManager inherits OpenEdge.CommonInfrastructure.Common.ServiceManager:
    
    constructor public ServiceManager(poKernel as IKernel):
        super(poKernel).
    end constructor.
    
end class.