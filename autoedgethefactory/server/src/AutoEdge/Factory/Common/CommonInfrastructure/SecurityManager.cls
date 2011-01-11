/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : Application-specific security manager 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 22 09:27:08 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.IUserContext.
using OpenEdge.CommonInfrastructure.UserContext.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.IComponentInfo. 
using OpenEdge.CommonInfrastructure.SecurityManager.

using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.ApplicationError.

class AutoEdge.Factory.Common.CommonInfrastructure.SecurityManager inherits SecurityManager: 

    constructor public SecurityManager ( input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo ):
        super (input poServiceManager, input poComponentInfo).
    end constructor.
    
    method override public void ValidateCredentials(input pcUserName as character,
                                                    input pcUserDomain as character,
                                                    input pcPassword as character):
        define buffer lbUser for ApplicationUser.
        
        /* validate login credentials */
        find lbUser where
             lbUser.LoginName = pcUserName and
             lbUser.LoginDomain = pcUserDomain
             no-lock no-error.
        if not available lbUser then        
           undo, throw new InvalidValueSpecifiedError(substitute('user name', '(&1)', pcUserName),'').
        
        if lbUser.Password ne pcPassword then
           undo, throw new InvalidValueSpecifiedError('password', substitute(' for user ', '(&1)', pcUserName)).
        
        find current lbUser exclusive-lock.
        assign lbUser.LastLoginDate = now.
    end method.
    
end class.