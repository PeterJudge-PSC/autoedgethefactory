/*------------------------------------------------------------------------
    File        : ServiceTypeEnum
    Purpose     : Server-side service types
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Feb 22 11:31:42 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.CommonInfrastructure.ServiceTypeEnum.
using OpenEdge.CommonInfrastructure.CommonServiceTypeEnum.

class OpenEdge.CommonInfrastructure.ServiceTypeEnum inherits CommonServiceTypeEnum:
    
    /* Presentation Layer services */
    define public static property Model as ServiceTypeEnum no-undo get. private set.
    define public static property Presenter as ServiceTypeEnum no-undo get. private set.
    
    constructor static ServiceTypeEnum():
        ServiceTypeEnum:Model = new ServiceTypeEnum('Model').
        ServiceTypeEnum:Presenter = new ServiceTypeEnum('Presenter').
    end constructor.

    constructor public ServiceTypeEnum(pcName as character):
        super(pcName).
    end constructor.
    
end class.