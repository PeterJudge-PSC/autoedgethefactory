/*------------------------------------------------------------------------
    File        : test_componenttype.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Fri Feb 19 09:54:30 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
    using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
    using Progress.Lang.Object.
    
    define temp-table ttComponent no-undo
        field ComponentType as Object
        field ComponentName as char
        field InstanceName as char
        field Instance as Object
        index idx1 as primary unique ComponentType InstanceName
        index idx2 ComponentType ComponentName
        .
        
        

    create ttComponent.
    ttComponent.ComponentType = ComponentTypeEnum:Presenter.
    ttComponent.ComponentName = 'a'.   
    ttComponent.InstanceName = ttComponent.ComponentName.
            
    create ttComponent.
    ttComponent.ComponentType = ComponentTypeEnum:View.
    ttComponent.ComponentName = 'b'.   
    ttComponent.InstanceName = ttComponent.ComponentName.
            
    create ttComponent.
    ttComponent.ComponentType = ComponentTypeEnum:Presenter.
    ttComponent.ComponentName = 'c'.   
    ttComponent.InstanceName = ttComponent.ComponentName.        
            
    
    def query q1 for ttComponent.
    
    def var hq as handle.
    def var c as char.
    
    
    c = 'where ttComponent.ComponentType = ' + quoter(int(ComponentTypeEnum:Presenter)).
    
    hq = query q1:handle.
    
    hq:query-prepare ('preselect each ttComponent ' + c).
    
    message 
    hq:prepare-string
    view-as alert-box.
    
    hq:query-open().
    hq:get-first().
    do while not hq:query-off-end with down:
        displ 
        int(ttComponent.ComponentType)
        string(ttComponent.ComponentType)  
        ttComponent.Componentname.
        
        hq:get-next().
    end.
                    