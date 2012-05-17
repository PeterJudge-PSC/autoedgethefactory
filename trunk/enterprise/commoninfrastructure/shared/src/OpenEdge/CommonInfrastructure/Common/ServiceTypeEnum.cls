/** ------------------------------------------------------------------------
    File        : ServiceTypeEnum
    Purpose     : Lists known components in reference components. These are
                  the common/shared service types.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 18 14:26:28 EST 2010
    Notes       : * Not final because we have client- and server-specific
                    service types.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ServiceTypeEnum.
using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.

class OpenEdge.CommonInfrastructure.Common.ServiceTypeEnum inherits ComponentTypeEnum:
    
    /** Common Infrastructure */
    define public static property Manager as ServiceTypeEnum no-undo get. private set.
    
    /** Non-specified application services (shouldn't be many of these though) */
    define public static property AppService as ServiceTypeEnum no-undo get. private set.
    
    constructor static ServiceTypeEnum ():
        ServiceTypeEnum:Manager = new ServiceTypeEnum('Manager').
        ServiceTypeEnum:AppService = new ServiceTypeEnum('AppService').
    end constructor.
    
    constructor public ServiceTypeEnum (pcName as character):
        super(pcName).
    end constructor.
    
end class.