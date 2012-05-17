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
                 * Value takes precedence over name, when both are specified.
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Lang.EnumMember abstract:
    
    define public property Name as character no-undo get. private set.
    define public property Value as integer no-undo get. private set.
    
    define private static temp-table ttValue no-undo
      field EnumType   as Object
      field EName      as character
      field EValue     as integer 
      field EnumObject as Progress.Lang.Object
      .
    constructor public EnumMember(input piValue as integer, input pcName as character):        
        assign this-object:Name = pcName
               this-object:Value = piValue.
        create ttValue.
        assign 
          ttValue.EnumType   = this-object:GetClass()
          ttValue.EName      = pcName
          ttValue.EValue     = piValue
          ttValue.EnumObject = this-object
          .
    end constructor.

    constructor public EnumMember(input piValue as integer):
        this-object(piValue, ?).
    end constructor.

    constructor public EnumMember(input pcName as character):        
        this-object(?, pcName).
    end constructor.

    method public logical Equals(input pcName as character):
        define variable lEquals as logical no-undo.
        
        lEquals = this-object:Name eq pcName. 
        
        return lEquals.
    end method.
    
    method public override logical Equals(poEnumMember as Object):
        define variable lEquals as logical no-undo.

        lEquals = super:Equals(poEnumMember).
        
        /* ABL deals with unknown values just fine */
        if not lEquals then
            lEquals = type-of(poEnumMember, EnumMember) and 
                      this-object:ToString() eq  cast(poEnumMember, EnumMember):ToString().

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
    
    method public static EnumMember GetEnumMember(enumName as character, cls as Progress.Lang.Class):
      
      find ttValue where ttValue.EnumType = cls
                     and ttValue.EName    = enumName
                         no-error.
      
      if (not avail ttValue) then 
        undo, throw new Progress.Lang.AppError( quoter(enumName) + " is not a member of Enum " + quoter(cls:TypeName), 1).
        
      return cast(ttValue.EnumObject, OpenEdge.Lang.EnumMember).
          
    end method.
    
    method public static EnumMember GetEnumMember(enumValue as integer, cls as class Class):      
      find ttValue where ttValue.EnumType = cls
                     and ttValue.EValue    = enumValue
                         no-error.
      
      if (not avail ttValue) then 
        undo, throw new Progress.Lang.AppError(quoter(enumValue) + " is not a value of Enum " + quoter(cls:TypeName), 1).
        
      return cast(ttValue.EnumObject, OpenEdge.Lang.EnumMember).      
    end method.

    method public static EnumMember extent ListEnumMembers(cls as class Class):
        define variable oMember as EnumMember extent no-undo.
        define query qryEnum for ttValue.

        open query qryEnum preselect 
            each ttValue where ttValue.EnumType = cls no-lock.
        
        extent(oMember) = query qryEnum:num-results.
        get first qryEnum.
        do while not query-off-end('qryEnum'):
            oMember[query qryEnum:current-result-row] = dynamic-cast(ttValue.EnumObject, cls:TypeName).
            get next qryEnum.
        end.
        close query qryEnum.
        
        return oMember.
    end method.
    
end class. 