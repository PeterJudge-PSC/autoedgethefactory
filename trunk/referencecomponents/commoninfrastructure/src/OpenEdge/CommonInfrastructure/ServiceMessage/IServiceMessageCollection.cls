/*------------------------------------------------------------------------
    File        : IServiceMessageCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 15:18:23 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessageCollection.
using OpenEdge.Lang.Collections.TypedList.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessageCollection inherits TypedList:
        
    constructor public IServiceMessageCollection():
        super(Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage')).
    end constructor.
    
    constructor public IServiceMessageCollection(c as IServiceMessageCollection):
        super(c).
    end constructor.

end class.