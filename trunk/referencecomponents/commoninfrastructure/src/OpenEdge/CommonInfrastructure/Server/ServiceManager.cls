/*------------------------------------------------------------------------
    File        : ServiceManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Feb 22 10:55:33 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.IKernel.

class OpenEdge.CommonInfrastructure.Server.ServiceManager inherits OpenEdge.CommonInfrastructure.Common.ServiceManager:
    
    constructor public ServiceManager(poKernel as IKernel):
        super(poKernel).
    end constructor.
    
end class.