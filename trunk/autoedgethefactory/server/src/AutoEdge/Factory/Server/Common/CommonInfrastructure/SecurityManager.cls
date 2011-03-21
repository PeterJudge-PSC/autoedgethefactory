/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : Application-specific security manager 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 22 09:27:08 EST 2010
    Notes       : * The UserDomains are structures as follows:
                        <department>.<employee>.<tenant>
                    or
                        <customer|admin|factory|guest>.<tenant>
  ---------------------------------------------------------------------- */
{routinelevel.i}

using AutoEdge.Factory.Common.CommonInfrastructure.UserTypeEnum.

using OpenEdge.CommonInfrastructure.Server.SecurityManager.

using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.UserContext.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo. 
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.AuthorizationError.

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
        define variable cBizLogicSessionId as character no-undo.
        define variable cDomainType as character no-undo.
        define variable oUserType as UserTypeEnum no-undo.
        
        define buffer lbCustomer for Customer.
        define buffer lbContactDetail for ContactDetail.
        define buffer lbCustomerContact for CustomerContact.
        define buffer lbContactType for ContactType.
        define buffer lbUser for ApplicationUser.
        define buffer lbEmployee for Employee.
        define buffer lbSalesrep for Salesrep.
        define buffer lbDealer for Dealer.
        
        oUC = super:CreateContextObject(pcUserName, pcUserDomain).

        cDomainType = entry(max(num-entries(pcUserDomain, '.') - 1, 1), pcUserDomain, '.').            
        oUserType = UserTypeEnum:EnumFromString(cDomainType).
        
        oUC:UserProperties:Put(new String('UserType'), oUserType).
        
        find lbUser where
             lbUser.LoginName = pcUserName and
             lbUser.LoginDomain = pcUserDomain
             no-lock no-error.

        if oUserType:Equals(UserTypeEnum:Customer) then
        do:
            /* since we've already validated, we know that this user record exists */
            find lbCustomer where
                 lbCustomer.CustomerId = lbUser.CustomerId and
                 lbCustomer.TenantId = lbUser.TenantId
                 no-lock no-error.
            if not available lbCustomer then
               undo, throw new InvalidValueSpecifiedError(substitute('customer', '(&1 - &2)', pcUserName, pcUserDomain), '').
            
            oUC:UserProperties:Put(new String('CustomerId'), new String(lbCustomer.CustomerId)).
            oUC:UserProperties:Put(new String('CustNum'), new String(string(lbCustomer.CustNum))).
            oUC:UserProperties:Put(new String('CreditLimit'), new String(string(lbCustomer.CreditLimit))).
            oUC:UserProperties:Put(new String('Customer.Name'), new String(string(lbCustomer.Name))).
            
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
        else
        if oUserType:Equals(UserTypeEnum:Employee) then
        do:
            find first lbEmployee where
                       lbEmployee.TenantId = lbUser.TenantId and
                       lbEmployee.EmployeeId = lbUser.EmployeeId
                       no-lock no-error.
            if available lbEmployee then
                find first lbDealer where
                           lbDealer.TenantId = lbUser.TenantId and 
                           lbDealer.DealerId = lbEmployee.DealerId
                           no-lock no-error.
            if available lbDealer then
                oUC:UserProperties:Put(new String('Dealer.Code'), new String(lbDealer.Code)).
            
            find first lbSalesrep where
                       lbSalesrep.TenantId = lbUser.TenantId and 
                       lbSalesrep.EmployeeId = lbEmployee.EmployeeId
                       no-lock no-error.
            if available lbSalesrep then
                oUC:UserProperties:Put(new String('Salesrep.Code'), new String(lbSalesrep.Code)).
            
            /* savvion sign-on */
            
            /* store for later 
            oUC:UserProperties:Put(new String('BizLogicSessionId'), new String(cBizLogicSessionId)).
            */
        end.
        
        return oUC.                                                          
    end method.
    
    /** Authorises the current user to undertake the specified action on the
        service. An error is thrown if the authentication fails.
        
        @param character The service being operated upon.
        @param ServiceMessageActionEnum The Action being performed. */
	method override public void AuthenticateServiceAction(input pcService as character,
	                                                      input poServiceMessageAction as ServiceMessageActionEnum):
		super:AuthenticateServiceAction(input pcService, input poServiceMessageAction).
		
		if poServiceMessageAction:Equals(ServiceMessageActionEnum:SaveData) then
        do:
            if IsManagedSession then
            do:
                /* Guests cannot save data */
                if cast(CurrentUserContext:UserProperties:Get(new String('UserType')), UserTypeEnum):Equals(UserTypeEnum:Guest) then                 
                    undo, throw new AuthorizationError('Guest user', poServiceMessageAction:ToString(), pcService).
            end.
            /* Only logged-in users can perform save actions */
            else
                undo, throw new AuthorizationError('Unknown user', poServiceMessageAction:ToString(), pcService).
        end.    /* save */
	end method.
	
end class.