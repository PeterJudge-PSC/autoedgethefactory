/*------------------------------------------------------------------------
    File        : DepartmentDS
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 15 09:20:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.

using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.

using OpenEdge.Core.System.InvalidValueSpecifiedError.

class OpenEdge.Test.Roundtrip1.BusinessComponents.DepartmentDS use-widget-pool inherits StandardDataSource: 
    
    define private variable mhDepartmentDataSource as handle no-undo.
    define private variable mlDataSourceAttached as logical no-undo.
    
    define private property DepartmentBuffer as handle no-undo
        get():
            if not valid-handle(DepartmentBuffer) then
                DepartmentBuffer = buffer Department:handle.
            return DepartmentBuffer.
        end get.
        set.
    
    constructor public DepartmentDS (  ):
        super ().
    end constructor.
    
    method override public handle GetTableHandle( input pcTableName as character ):
        if pcTableName ne 'Department' then
            undo, throw new InvalidValueSpecifiedError('table',': must be "Department"').
        
        return DepartmentBuffer.
    end method.

    method override protected void CreateDataStore(  ):
      create data-source mhDepartmentDataSource.
      
      mhDepartmentDataSource:add-source-buffer(DepartmentBuffer, DepartmentBuffer:keys).  
    end method.

    method override protected void DeleteDataStore(  ):
        delete object mhDepartmentDataSource no-error.
    end method.

    method override protected void AttachDataStoreToTarget(  ):
        mhDepartmentDataSource:prefer-dataset = true.
                        
        case DataTargetFormat:
            when DataFormatEnum:ProDataSet then
                HandleDataTarget:get-buffer-handle(DepartmentBuffer:name):attach-data-source(mhDepartmentDataSource).
            when DataFormatEnum:TempTable then
                HandleDataTarget:attach-data-source(mhDepartmentDataSource).
            otherwise
                undo, throw new OpenEdge.Core.System.ArgumentError('Data target format','IDataSource:DataTargetFormat').
        end case.
        
        mlDataSourceAttached = true.
    end method.

    method override protected void DetachDataStoreFromTarget(  ):
        if mlDataSourceAttached then
        case DataTargetFormat:
            when DataFormatEnum:ProDataSet then
                HandleDataTarget:get-buffer-handle(DepartmentBuffer:name):detach-data-source().
            when DataFormatEnum:TempTable then
                HandleDataTarget:detach-data-source().
            otherwise
                undo, throw new OpenEdge.Core.System.ArgumentError('Data target format','IDataSource:DataTargetFormat').
        end case.
        
        mlDataSourceAttached = false.
    end method.
    
end class.