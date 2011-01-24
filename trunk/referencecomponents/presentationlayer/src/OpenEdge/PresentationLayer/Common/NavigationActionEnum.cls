/** ------------------------------------------------------------------------
    File        : NavigationActionEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 05 15:45:20 EST 2009
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}
  
using OpenEdge.PresentationLayer.Common.NavigationActionEnum.
using OpenEdge.Lang.EnumMember.
  
class OpenEdge.PresentationLayer.Common.NavigationActionEnum final inherits EnumMember: 
    
    define public static property First as NavigationActionEnum no-undo get. private set.
    define public static property Next  as NavigationActionEnum no-undo get. private set.
    define public static property Prev  as NavigationActionEnum no-undo get. private set.
    define public static property Last  as NavigationActionEnum no-undo get. private set.
    
    constructor static NavigationActionEnum():
        NavigationActionEnum:First = new NavigationActionEnum(1, 'first').
        NavigationActionEnum:Next  = new NavigationActionEnum(2, 'next').
        NavigationActionEnum:Prev  = new NavigationActionEnum(3, 'prev').
        NavigationActionEnum:Last  = new NavigationActionEnum(4, 'last').
    end constructor.

    constructor public NavigationActionEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    method public static NavigationActionEnum EnumFromValue(piNavigationAction as integer):        
        define variable oMember as NavigationActionEnum no-undo.
        
        case piNavigationAction:
            when NavigationActionEnum:First:Value then oMember = NavigationActionEnum:First.
            when NavigationActionEnum:Last:Value then oMember = NavigationActionEnum:Last.
            when NavigationActionEnum:Next:Value then oMember = NavigationActionEnum:Next.
            when NavigationActionEnum:Prev:Value then oMember = NavigationActionEnum:Prev.
        end.
        
        return oMember.
    end method.
    
end class.