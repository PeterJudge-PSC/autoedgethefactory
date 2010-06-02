/*------------------------------------------------------------------------
    File        : ITableRequest
    Purpose     : Interface for table fetch request  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Feb 09 18:28:13 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Lang.EnumMember.

interface OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest /** inherits IServiceMessage, IQueryDefinition */:
    /** protected set - not changeable - provide with constructor  */  
    define property TableName as char no-undo get. 
    
    /** aka batch size */
    define property PageSize as integer no-undo get. set.

    /** retrieve full page when page position is at beginning or end of result-set */
    define property FullPage as logical no-undo get. set.
    
    /** TableRequestTypeEnum */
    define property TableRequestType as EnumMember no-undo get. set.
    
    /** FindTypeEnum (default to first) */
    define property SearchType as EnumMember no-undo get. set.
       
    /** context info/key for where to start appending page begin or end */
    define property PageContext as char extent no-undo get. set.
    
    /** return page positioned to this key (i.e. resort request/ reopen ) 
       Typically used with TableRequestTypeEnum:Position */ 
    define property RowKey as char extent no-undo get. set.
    
    /** Add search expression  (need to be kept separate from filter.). 
       - Allthough this in theory could be any complex expression it normally 
         only makes sense when the field(s) correspond(s) to the sort.    
       - AddSearch can be refactored to have type-specific signatures, removing the need to pass a
         DataTypeEnum. */
    method public void AddSearch (pcBufferName as char,
                                  pcFieldName as char,
                                  poOperator as EnumMember,        /** OpenEdge.Lang.OperatorEnum: =,<,> etc */
                                  pcFieldValue as char,
                                  poFieldType as EnumMember,       /** OpenEdge.Core.System.DataTypeEnum */
                                  poJoinType as EnumMember   ).    /** OpenEdge.Lang.JoinEnum: AND, OR etc */
    
    method public void GetSearch (pcBufferName as char,
                                  output pcFieldName as char extent,
                                  output poOperator as EnumMember extent,      /** OpenEdge.Lang.OperatorEnum */
                                  output pcFieldValue as char extent,
                                  output poFieldType as EnumMember extent,     /** OpenEdge.Core.System.DataTypeEnum */
                                  output poJoinType as EnumMember extent).     /** OpenEdge.Lang.JoinEnum */
    
    /** returns the search expression applied to the BuildQueryString */
    method public character BuildSearchString().
        
end interface.