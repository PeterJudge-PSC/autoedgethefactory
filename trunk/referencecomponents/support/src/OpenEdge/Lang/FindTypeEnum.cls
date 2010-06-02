/*------------------------------------------------------------------------
    File        : FindTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*. 
using OpenEdge.Lang.*. 

class OpenEdge.Lang.FindTypeEnum final : 
    
    define public static property First    as EnumMember no-undo get. private set.
    define public static property Next     as EnumMember no-undo get. private set.
    define public static property Prev     as EnumMember no-undo get. private set.
    define public static property Last     as EnumMember no-undo get. private set.
    define public static property Unique   as EnumMember no-undo get. private set.
    
    constructor static FindTypeEnum():
         FindTypeEnum:First    = new EnumMember(1, 'first').
         FindTypeEnum:Next     = new EnumMember(2, 'next').
         FindTypeEnum:Prev     = new EnumMember(3, 'prev').
         FindTypeEnum:Last     = new EnumMember(4, 'last').        
         FindTypeEnum:Unique = new EnumMember(5, 'unique').        
          
    end constructor.
    
    method public static EnumMember EnumFromValue(piNavigationAction as integer):        
        define variable oMember as EnumMember no-undo.
        
        case piNavigationAction:
            when  FindTypeEnum:First:Value then oMember = FindTypeEnum:First.
            when  FindTypeEnum:Last:Value then oMember =  FindTypeEnum:Last.
            when  FindTypeEnum:Next:Value then oMember =  FindTypeEnum:Next.
            when  FindTypeEnum:Prev:Value then oMember =  FindTypeEnum:Prev.
            when  FindTypeEnum:Unique:Value then oMember =  FindTypeEnum:Unique.
        end.
        
        return oMember.
    end method.
        
end class.