/** ------------------------------------------------------------------------
    File        : ServiceMessageActionEnum
    Purpose     : Enumerates types of service messages (requests).
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sat Feb 20 03:38:25 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum inherits EnumMember: 
    
    /** Data fetch request */
    define public static property Fetch       as ServiceMessageActionEnum no-undo get. private set.
    
    /** Data commit/save request */
    define public static property Save        as ServiceMessageActionEnum no-undo get. private set.
    
    /** Schema fetch request. This is typically only made to a Business Entity. */
    define public static property FetchSchema as ServiceMessageActionEnum no-undo get. private set.

    /** Acknowledge receipt of request */
    define public static property ACK as ServiceMessageActionEnum no-undo get. private set.
    
    constructor static ServiceMessageActionEnum():
        ServiceMessageActionEnum:Fetch       = new ServiceMessageActionEnum('Fetch').
        ServiceMessageActionEnum:Save        = new ServiceMessageActionEnum('Save').
        ServiceMessageActionEnum:FetchSchema = new ServiceMessageActionEnum('FetchSchema').
        ServiceMessageActionEnum:ACK         = new ServiceMessageActionEnum('ACK'). 
    end method.
    
    constructor public ServiceMessageActionEnum(pcName as character):
        super(pcName).
    end constructor.
    
end class.