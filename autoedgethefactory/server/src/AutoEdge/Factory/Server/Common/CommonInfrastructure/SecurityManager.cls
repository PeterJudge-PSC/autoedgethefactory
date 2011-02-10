/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : Application-specific security manager 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 22 09:27:08 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.UserContext.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo. 
using OpenEdge.CommonInfrastructure.Server.SecurityManager.

using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Lang.String.

class AutoEdge.Factory.Server.Common.CommonInfrastructure.SecurityManager inherits SecurityManager: 

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
        
        do transaction:
            find current lbUser exclusive-lock.
            assign lbUser.LastLoginDate = now.
        end.
    end method.

    /** Creates a IUserContext object for a validated user/domain. Will usually be 
        overridden to add more details 
        
        @param character The user name
        @param character The user domain
        @return IUserContext The user's context object */
    method override protected IUserContext CreateContextObject(input pcUserName as character,
                                                               input pcUserDomain as character):
        define variable oUC as IUserContext no-undo.
        define variable cEmailAddress as character no-undo.
        
        define buffer lbCustomer for Customer.
        define buffer lbContactDetail for ContactDetail.
        define buffer lbCustomerContact for CustomerContact.
        define buffer lbContactType for ContactType.
        define buffer lbUser for ApplicationUser.
        
        oUC = super:CreateContextObject(pcUserName, pcUserDomain).
        
        if pcUserDomain begins 'customer.' then
        do:
            find lbUser where
                 lbUser.LoginName = pcUserName and
                 lbUser.LoginDomain = pcUserDomain
                 no-lock no-error.
            /* since we've already validated, we know that this user record exists */
            find lbCustomer where
                 lbCustomer.CustomerId = lbUser.CustomerId and
                 lbCustomer.TenantId = lbUser.TenantId
                 no-lock no-error.
            if not available lbCustomer then
               undo, throw new InvalidValueSpecifiedError(substitute('customer', '(&1 - &2)', pcUserName, pcUserDomain), '').
            
            oUC:UserProperties:Put(new String('CustomerId'), new String(lbCustomer.CustomerId)).
            oUC:UserProperties:Put(new String('CreditLimit'), new String(string(lbCustomer.CreditLimit))).
            
            find lbContactType where lbContactType.Name = 'email-home' no-lock.
            find lbCustomerContact where
                 lbCustomerContact.CustomerId = lbCustomer.CustomerId and
                 lbCustomerContact.TenantId = lbCustomer.TenantId and
                 lbCustomerContact.ContactType = lbContactType.Name
                 no-lock no-error.                 
            if available lbCustomerContact then
            find lbContactDetail where
                 lbContactDetail.ContactDetailId = lbCustomerContact.ContactDetailId
                 no-lock no-error.
            if available lbContactDetail then
                cEmailAddress = lbContactDetail.Detail.
                
            oUC:UserProperties:Put(new String('PrimaryEmailAddress'), new String(cEmailAddress)).
        end.
        
        return oUC.                                                          
    end method.
    
end class.