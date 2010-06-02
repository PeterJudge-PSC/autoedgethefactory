/*------------------------------------------------------------------------
    File        : EnumMember
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 21 10:07:10 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.
using Progress.Lang.*.

class OpenEdge.Lang.EnumMember:
    define public property Name as character no-undo get. protected set.
    define public property Value as integer no-undo get. protected set.
    
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
    
    constructor public EnumMember():
        this-object(?, ?).
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
            cName = substitute('EnumMember_Value_&1', this-object:Value).
        else
            cName = substitute('EnumMember_&1', this-object).
        
        return cName.
    end method.
    
end class.