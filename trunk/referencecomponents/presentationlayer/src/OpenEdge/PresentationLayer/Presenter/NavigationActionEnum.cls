/*------------------------------------------------------------------------
    File        : NavigationActionEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 05 15:45:20 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
  
using OpenEdge.PresentationLayer.Presenter.*.
using OpenEdge.Lang.*.
  
class OpenEdge.PresentationLayer.Presenter.NavigationActionEnum final: 
    
    define public static property First as EnumMember no-undo get. private set.
    define public static property Next  as EnumMember no-undo get. private set.
    define public static property Prev  as EnumMember no-undo get. private set.
    define public static property Last  as EnumMember no-undo get. private set.
    
    constructor static NavigationActionEnum():
        NavigationActionEnum:First = new EnumMember(1, 'first').
        NavigationActionEnum:Next  = new EnumMember(2, 'next').
        NavigationActionEnum:Prev  = new EnumMember(3, 'prev').
        NavigationActionEnum:Last  = new EnumMember(4, 'last').        
    end constructor.
    
    method public static EnumMember EnumFromValue(piNavigationAction as integer):        
        define variable oMember as EnumMember no-undo.
        
        case piNavigationAction:
            when NavigationActionEnum:First:Value then oMember = NavigationActionEnum:First.
            when NavigationActionEnum:Last:Value then oMember = NavigationActionEnum:Last.
            when NavigationActionEnum:Next:Value then oMember = NavigationActionEnum:Next.
            when NavigationActionEnum:Prev:Value then oMember = NavigationActionEnum:Prev.
        end.
        
        return oMember.
    end method.
    
end class.