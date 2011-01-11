/** ------------------------------------------------------------------------
    File        : ServiceTypeEnum
    Purpose     : Server-side enumeration of service types, used by the ServiceManager
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Feb 22 11:34:26 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceTypeEnum.
using OpenEdge.CommonInfrastructure.CommonServiceTypeEnum.

class OpenEdge.CommonInfrastructure.ServiceTypeEnum inherits CommonServiceTypeEnum: 
    define public static property BusinessEntity    as ServiceTypeEnum no-undo get. private set.
    define public static property BusinessTask      as ServiceTypeEnum no-undo get. private set.
    define public static property BusinessWorkflow  as ServiceTypeEnum no-undo get. private set.
    
    constructor static ServiceTypeEnum():
        ServiceTypeEnum:BusinessEntity   = new ServiceTypeEnum('BusinessEntity').
        ServiceTypeEnum:BusinessTask     = new ServiceTypeEnum('BusinessTask').
        ServiceTypeEnum:BusinessWorkflow = new ServiceTypeEnum('BusinessWorkflow').
    end constructor.
    
    constructor public ServiceTypeEnum(input pcName as character):
        super(pcName).
    end constructor.
    
end class.