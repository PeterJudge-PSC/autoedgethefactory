/*------------------------------------------------------------------------
    File        : ILoginData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 04 11:32:53 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
interface OpenEdge.Core.System.ILoginData:
    
    define public property UserName as character no-undo get. set.
    define public property Password as character no-undo get. set.     
    
end interface.