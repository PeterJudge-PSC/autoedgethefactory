/** ------------------------------------------------------------------------
    File        : LoginStateEnum
    Purpose     : Enumerate the CLIENT-PRINCIPAL's LOGIN-STATEs
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 05 16:31:17 EDT 2011
    Notes       : * See ABL documentation for details.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.
  
using OpenEdge.Lang.LoginStateEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.LoginStateEnum inherits EnumMember final: 
    define static public property Unknown as LoginStateEnum no-undo get. private set.
    define static public property Initial as LoginStateEnum no-undo get. private set.
    define static public property Login as LoginStateEnum no-undo get. private set.
    define static public property Logout as LoginStateEnum no-undo get. private set.
    define static public property Expired as LoginStateEnum no-undo get. private set.
    define static public property Failed as LoginStateEnum no-undo get. private set.

    constructor static LoginStateEnum():
        LoginStateEnum:Initial = new LoginStateEnum('Initial').
        LoginStateEnum:Login = new LoginStateEnum('Login').
        LoginStateEnum:Logout = new LoginStateEnum('Logout').
        LoginStateEnum:Expired = new LoginStateEnum('Expired').
        LoginStateEnum:Failed = new LoginStateEnum('Failed').

        LoginStateEnum:Unknown = new LoginStateEnum('Unknown').
    end constructor.

    constructor public LoginStateEnum ( input pcName as character ):
        super (input pcName).
    end constructor.

    method public static LoginStateEnum EnumFromString(input pcLoginState as character):
        define variable oMember as LoginStateEnum no-undo.

        case pcLoginState:
            when LoginStateEnum:Initial:Name then oMember = LoginStateEnum:Initial.
            when LoginStateEnum:Login:Name then oMember = LoginStateEnum:Login.
            when LoginStateEnum:Logout:Name then oMember = LoginStateEnum:Logout.
            when LoginStateEnum:Expired:Name then oMember = LoginStateEnum:Expired.
            when LoginStateEnum:Failed:Name then oMember = LoginStateEnum:Failed.
            otherwise
                oMember = LoginStateEnum:Unknown.
        end.

        return oMember.
    end method.
	
end class.