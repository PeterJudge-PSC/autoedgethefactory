/*------------------------------------------------------------------------
    File        : FamilyDS
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

class OpenEdge.Test.Roundtrip1.BusinessComponents.FamilyDS use-widget-pool inherits StandardDataSource: 
    
    define private variable mhFamilyDataSource as handle no-undo.
    define private variable mlDataSourceAttached as logical no-undo.
    
    define private property FamilyBuffer as handle no-undo
        get():
            if not valid-handle(FamilyBuffer) then
                FamilyBuffer = buffer Family:handle.
            return FamilyBuffer.
        end get.
        set.
    
    constructor public FamilyDS (  ):
        super ().
    end constructor.
    
    method override public handle GetTableHandle( input pcTableName as character ):
        if pcTableName ne 'Family' then
            undo, throw new InvalidValueSpecifiedError('table',': must be "Family"').
        
        return FamilyBuffer.
    end method.

    method override protected void CreateDataStore(  ):
      create data-source mhFamilyDataSource.
      
      mhFamilyDataSource:add-source-buffer(FamilyBuffer, FamilyBuffer:keys).  
    end method.

    method override protected void DeleteDataStore(  ):
        delete object mhFamilyDataSource no-error.
    end method.

    method override protected void AttachDataStoreToTarget(  ):
        mhFamilyDataSource:prefer-dataset = true.
                        
        case DataTargetFormat:
            when DataFormatEnum:ProDataSet then
                HandleDataTarget:get-buffer-handle(FamilyBuffer:name):attach-data-source(mhFamilyDataSource).
            when DataFormatEnum:TempTable then
                HandleDataTarget:attach-data-source(mhFamilyDataSource).
            otherwise
                undo, throw new OpenEdge.Core.System.ArgumentError('Data target format','IDataSource:DataTargetFormat').
        end case.
        mlDataSourceAttached = true.
    end method.

    method override protected void DetachDataStoreFromTarget(  ):
        if mlDataSourceAttached then
        case DataTargetFormat:
            when DataFormatEnum:ProDataSet then
                HandleDataTarget:get-buffer-handle(FamilyBuffer:name):detach-data-source().
            when DataFormatEnum:TempTable then
                HandleDataTarget:detach-data-source().
            otherwise
                undo, throw new OpenEdge.Core.System.ArgumentError('Data target format','IDataSource:DataTargetFormat').
        end case.
        mlDataSourceAttached = false.
    end method.
    
end class.