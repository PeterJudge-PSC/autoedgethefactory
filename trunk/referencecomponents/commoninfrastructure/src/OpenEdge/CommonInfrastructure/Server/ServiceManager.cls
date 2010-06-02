/*------------------------------------------------------------------------
    File        : ServiceManager
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 22 10:55:33 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Server.ServiceManager.
using OpenEdge.CommonInfrastructure.Server.ServiceTypeEnum.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Server.ServiceManager inherits OpenEdge.CommonInfrastructure.Common.ServiceManager:
    
    constructor public ServiceManager(poKernel as IKernel):
        super(poKernel).
    end constructor.
    
end class.