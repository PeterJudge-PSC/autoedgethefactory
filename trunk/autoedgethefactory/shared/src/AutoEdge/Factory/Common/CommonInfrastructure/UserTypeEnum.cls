/** ------------------------------------------------------------------------
    File        : UserTypeEnum
    Purpose     : Describes the user type of the currently-logged in user. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Feb 25 10:08:03 EST 2011
    Notes       : * Used for authorising actions
  ---------------------------------------------------------------------- */
using AutoEdge.Factory.Common.CommonInfrastructure.UserTypeEnum.
using OpenEdge.Lang.EnumMember.

class AutoEdge.Factory.Common.CommonInfrastructure.UserTypeEnum inherits EnumMember: 
    
    define static public property Employee as UserTypeEnum no-undo get. private set.
    define static public property Customer as UserTypeEnum no-undo get. private set.
    define static public property Factory as UserTypeEnum no-undo get. private set.    
    define static public property Guest as UserTypeEnum no-undo get. private set.
    define static public property Admin as UserTypeEnum no-undo get. private set.
    
    constructor static UserTypeEnum ():
        UserTypeEnum:Employee = new UserTypeEnum('Employee').
        UserTypeEnum:Customer = new UserTypeEnum('Customer').
        UserTypeEnum:Factory = new UserTypeEnum('Factory').
        UserTypeEnum:Guest = new UserTypeEnum('Guest').
        UserTypeEnum:Admin = new UserTypeEnum('Admin').
    end constructor.
    
	constructor public UserTypeEnum ( input pcName as character ):
		super (input pcName).
	end constructor.
	
	method static public UserTypeEnum EnumFromString (input pcName as character):
        define variable oEnum as UserTypeEnum no-undo.
        
        case pcName:
            when UserTypeEnum:Employee:ToString() then oEnum = UserTypeEnum:Employee.
            when UserTypeEnum:Customer:ToString() then oEnum = UserTypeEnum:Customer.
            when UserTypeEnum:Factory:ToString() then oEnum = UserTypeEnum:Factory.
            when UserTypeEnum:Guest:ToString() then oEnum = UserTypeEnum:Guest.
            when UserTypeEnum:Admin:ToString() then oEnum = UserTypeEnum:Admin.
        end case.
        
        return oEnum.
    end method.
    
end class.