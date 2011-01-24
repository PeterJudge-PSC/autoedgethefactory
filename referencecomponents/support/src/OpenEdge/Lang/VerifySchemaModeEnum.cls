/** ------------------------------------------------------------------------
    Ignore        : VerifySchemaModeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Oct 12 14:29:25 EDT 2010
    Notes       : * Based on the ABL documentation
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Lang.VerifySchemaModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.VerifySchemaModeEnum inherits EnumMember final: 

    define static public property Ignore as VerifySchemaModeEnum  no-undo get. private set.
    define static public property Loose as VerifySchemaModeEnum  no-undo get. private set.
    define static public property Strict as VerifySchemaModeEnum  no-undo get. private set.
    define static public property Default as VerifySchemaModeEnum  no-undo get. private set.
    
    constructor static VerifySchemaModeEnum():
        VerifySchemaModeEnum:Ignore = new VerifySchemaModeEnum('Ignore').
        VerifySchemaModeEnum:Loose = new VerifySchemaModeEnum('Loose').
        VerifySchemaModeEnum:Strict = new VerifySchemaModeEnum('Loose-Handle').
        VerifySchemaModeEnum:Default = VerifySchemaModeEnum:Loose.
    end constructor.
    
    constructor public VerifySchemaModeEnum(input pcName as character):
        super (input pcName).
    end constructor.     

    method static public VerifySchemaModeEnum EnumFromString(pcVerifyMode as character):
        define variable oMember as VerifySchemaModeEnum no-undo.
        
        case pcVerifyMode:
            when VerifySchemaModeEnum:Ignore:ToString() then oMember = VerifySchemaModeEnum:Ignore.
            when VerifySchemaModeEnum:Loose:ToString()  then oMember = VerifySchemaModeEnum:Loose.
            when VerifySchemaModeEnum:Strict:ToString() then oMember = VerifySchemaModeEnum:Strict.
        end case.
        
        return oMember.   
    end method.
end class.