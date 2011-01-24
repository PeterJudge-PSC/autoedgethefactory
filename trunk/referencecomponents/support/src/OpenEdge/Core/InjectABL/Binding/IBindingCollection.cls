/*------------------------------------------------------------------------
    File        : IBindingCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 14:07:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Lang.Collections.TypedList.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Binding.IBindingCollection inherits TypedList:
    
    constructor public IBindingCollection():
        super(Class:GetClass('OpenEdge.Core.InjectABL.Binding.IBinding')).
    end constructor.
    
end class.