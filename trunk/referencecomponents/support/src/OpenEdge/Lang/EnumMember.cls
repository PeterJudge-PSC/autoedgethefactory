/** ------------------------------------------------------------------------
    File        : EnumMember
    Purpose     : Abstract class for Enumerations' members.  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jan 21 10:07:10 EST 2010
    Notes       : * We could add a temp-table to manage the EnumMembers' values
                    etc. That's not done right now because there's no pressing 
                    need for it.
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Lang.EnumMember abstract:
    define public property Name as character no-undo get. private set.
    define public property Value as integer no-undo get. private set.
    
    constructor public EnumMember(piValue as int, pcName as char):        
        assign this-object:Name = pcName
               this-object:Value = piValue.
    end constructor.
    
    constructor public EnumMember(piValue as int):
        this-object(piValue, ?).
    end constructor.

    constructor public EnumMember(pcName as char):        
        this-object(?, pcName).
    end constructor.
    
    method public logical Equals(pcName as char):
        define variable lEquals as logical no-undo.
        
        lEquals = this-object:Name eq pcName. 
        
        return lEquals.
    end method.
    
    method public override logical Equals(poEnumMember as Object):
        define variable lEquals as logical no-undo.

        lEquals = super:Equals(poEnumMember).
        
        /* ABL deals with unknown values just fine */
        if not lEquals then
            lEquals = type-of(poEnumMember, EnumMember)
                                      and this-object:Value eq cast(poEnumMember, EnumMember):Value.
        
        return lEquals.
    end method.

    method public override character ToString():
        define variable cName as character no-undo.
        
        if this-object:Name ne ? then
            cName = substitute('&1', this-object:Name).
        else
        if this-object:Value eq ? then
            cName = substitute('&1_Value_&2', this-object:GetClass():TypeName, this-object:Value).
        else
            cName = substitute('&1_&2', this-object:GetClass():TypeName, this-object).
        
        return cName.
    end method.
    
end class. 