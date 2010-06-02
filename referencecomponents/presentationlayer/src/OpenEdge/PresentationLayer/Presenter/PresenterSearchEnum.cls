@deprecated(version="0.0").

/*------------------------------------------------------------------------
    File        : PresenterSearchEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 14 13:51:20 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Presenter.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Presenter.PresenterSearchEnum final : 

    define public static property TypeName  as EnumMember no-undo get. private set.
    define public static property Interface as EnumMember no-undo get. private set.
    
    constructor static PresenterSearchEnum():
        PresenterSearchEnum:TypeName = new EnumMember(1).
        PresenterSearchEnum:Interface = new EnumMember(2).
    end constructor.
    
end class.