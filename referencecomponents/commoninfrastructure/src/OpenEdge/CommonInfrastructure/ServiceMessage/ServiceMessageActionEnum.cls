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
    
/* Business Component (entity/task/workflow) Actions */
    /** Data fetch request */
    define public static property FetchData as ServiceMessageActionEnum no-undo get. private set.
    
    /** Data commit/save request */
    define public static property SaveData as ServiceMessageActionEnum no-undo get. private set.
    
    /** Schema fetch request. This is typically only made to a Business Entity. */
    define public static property FetchSchema as ServiceMessageActionEnum no-undo get. private set.

    /** Acknowledge receipt of request */
    define public static property ACK as ServiceMessageActionEnum no-undo get. private set.
    
    /** Service message is a Workflow workstep request. */
    define public static property PerformWorkStep as ServiceMessageActionEnum no-undo get. private set.
    
    /** Service message is a Workflow request. */
    define public static property PerformWorkFlow as ServiceMessageActionEnum no-undo get. private set.
    
/* Security Manager Actions */
    /** Action is a user login */
    define public static property UserLogin as ServiceMessageActionEnum no-undo get. private set.

    /** Action is a user logout */
    define public static property UserLogout as ServiceMessageActionEnum no-undo get. private set.
    
    /** validate that the user token belongs to a valid session */
    define public static property ValidateSession as ServiceMessageActionEnum no-undo get. private set.
    
    constructor static ServiceMessageActionEnum():
        ServiceMessageActionEnum:FetchData       = new ServiceMessageActionEnum('FetchData').
        ServiceMessageActionEnum:SaveData        = new ServiceMessageActionEnum('SaveData').
        ServiceMessageActionEnum:FetchSchema     = new ServiceMessageActionEnum('FetchSchema').
        ServiceMessageActionEnum:ACK             = new ServiceMessageActionEnum('ACK').
        ServiceMessageActionEnum:PerformWorkStep = new ServiceMessageActionEnum('PerformWorkStep').  
        ServiceMessageActionEnum:PerformWorkFlow = new ServiceMessageActionEnum('PerformWorkFlow').
        
        /* ISecurityManager */
        ServiceMessageActionEnum:UserLogin = new ServiceMessageActionEnum('UserLogin').
        ServiceMessageActionEnum:UserLogout = new ServiceMessageActionEnum('UserLogout').
        ServiceMessageActionEnum:ValidateSession = new ServiceMessageActionEnum('ValidateSession').
    end method.
    
    constructor public ServiceMessageActionEnum(pcName as character):
        super(pcName).
    end constructor.
    
end class.