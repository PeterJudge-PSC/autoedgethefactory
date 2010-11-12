/*------------------------------------------------------------------------
    File        : ServiceTypeEnum
    Purpose     : Server-side service types
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Feb 22 11:31:42 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Client.ServiceTypeEnum.

class OpenEdge.CommonInfrastructure.Client.ServiceTypeEnum inherits OpenEdge.CommonInfrastructure.Client.ComponentTypeEnum:
    
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