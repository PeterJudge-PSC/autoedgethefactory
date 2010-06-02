/*------------------------------------------------------------------------
    File        : TableRequestTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequestTypeEnum. 
using OpenEdge.Lang.EnumMember. 

class OpenEdge.CommonInfrastructure.ServiceMessage.TableRequestTypeEnum final : 
    
    define public static property First    as EnumMember no-undo get. private set.
    define public static property Next     as EnumMember no-undo get. private set.
    define public static property Prev     as EnumMember no-undo get. private set.
    define public static property Last     as EnumMember no-undo get. private set.
    define public static property Position as EnumMember no-undo get. private set.
    define public static property Search   as EnumMember no-undo get. private set.
    define public static property All      as EnumMember no-undo get. private set.
    
    constructor static TableRequestTypeEnum():
         TableRequestTypeEnum:First    = new EnumMember(1, 'first').
         TableRequestTypeEnum:Next     = new EnumMember(2, 'next').
         TableRequestTypeEnum:Prev     = new EnumMember(3, 'prev').
         TableRequestTypeEnum:Last     = new EnumMember(4, 'last'). 
         /* position request resort/reopen to current key */       
         TableRequestTypeEnum:Position = new EnumMember(5, 'position').        
         /* search in resultset  */       
         TableRequestTypeEnum:Search   = new EnumMember(6, 'search').
         /* for child tables = default defined by dataset relation 
            (to not use All on a child requires advanced data request management)
            Logically this is possibly more of a jointype, but it will never 
            conflict with the other options */        
         TableRequestTypeEnum:All      = new EnumMember(7, 'all').        
    end constructor.
    
    method public static EnumMember EnumFromValue(piNavigationAction as integer):        
        define variable oMember as EnumMember no-undo.
        
        case piNavigationAction:
            when  TableRequestTypeEnum:First:Value then oMember = TableRequestTypeEnum:First.
            when  TableRequestTypeEnum:Last:Value then oMember =  TableRequestTypeEnum:Last.
            when  TableRequestTypeEnum:Next:Value then oMember =  TableRequestTypeEnum:Next.
            when  TableRequestTypeEnum:Prev:Value then oMember =  TableRequestTypeEnum:Prev.
            when  TableRequestTypeEnum:Position:Value then oMember =  TableRequestTypeEnum:Position.
            when  TableRequestTypeEnum:Search:Value then oMember =  TableRequestTypeEnum:Search.
            when  TableRequestTypeEnum:All:Value then oMember =  TableRequestTypeEnum:All.
        end.
        
        return oMember.
    end method.
        
end class.