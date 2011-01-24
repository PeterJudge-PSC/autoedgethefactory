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
{routinelevel.i}

using OpenEdge.CommonInfrastructure.CommonServiceTypeEnum.
using OpenEdge.CommonInfrastructure.CommonComponentTypeEnum.

class OpenEdge.CommonInfrastructure.CommonServiceTypeEnum inherits CommonComponentTypeEnum:
    
    /** Common Infrastructure */
    define public static property Manager as CommonServiceTypeEnum no-undo get. private set.
    
    /** Non-specified application services (shouldn't be many of these though) */
    define public static property AppService as CommonServiceTypeEnum no-undo get. private set.
    
    constructor static CommonServiceTypeEnum ():
        CommonServiceTypeEnum:Manager = new CommonServiceTypeEnum('Manager').
        CommonServiceTypeEnum:AppService = new CommonServiceTypeEnum('AppService').
    end constructor.
    
    constructor public CommonServiceTypeEnum (pcName as character):
        super(pcName).
    end constructor.
    
end class.