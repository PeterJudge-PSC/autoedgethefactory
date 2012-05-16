
/*------------------------------------------------------------------------
    File        : load_statusdetail.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Wed Dec 15 08:59:41 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
if not can-find(StatusDetail where StatusDetail.Code eq 'WORKFLOW-STARTING') then
do: 
    create StatusDetail.
    assign 
        StatusDetail.StatusDetailId = guid(generate-uuid)
        StatusDetail.Code           = 'WORKFLOW-STARTING'
        StatusDetail.Description    = 'WorkFlow [ STARTING ]'.
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'WORKFLOW-OK') then
do: 
    create StatusDetail.
    assign 
        StatusDetail.StatusDetailId = guid(generate-uuid)
        StatusDetail.Code           = 'WORKFLOW-OK'
        StatusDetail.Description    = 'WorkFlow [ OK ]'.
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'WORKFLOW-ERROR') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        StatusDetail.Code           = 'WORKFLOW-ERROR'
        statusdetail.description    = 'WorkFlow [ ERROR ]'.
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'WORKSTEP-STARTING') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        statusdetail.code           = 'WORKSTEP-STARTING'
        statusdetail.description    = 'WorkStep [ STARTING ]'
        .
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'WORKSTEP-OK') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        statusdetail.code           = 'WORKSTEP-OK'
        statusdetail.description    = 'WorkStep [ OK ]'
        .
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'WORKSTEP-ERROR') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        statusdetail.code           = 'WORKSTEP-ERROR'
        statusdetail.description    = 'WorkStep [ ERROR ]'
        .
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'ORDER-NEW') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        statusdetail.code           = 'ORDER-NEW'
        statusdetail.description    = 'Order Submitted'
        .
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'ORDER-REJECTED') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        statusdetail.code           = 'ORDER-REJECTED'
        statusdetail.description    = 'Order Rejected'
        .
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'ORDER-APPROVED') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        statusdetail.code           = 'ORDER-APPROVED'
        statusdetail.description    = 'Order Approved'
        .
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'ORDER-BUILD-START') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        statusdetail.code           = 'ORDER-BUILD-START'
        statusdetail.description    = 'Order Build Started'
        .
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'ORDER-BUILD-COMPLETE') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        statusdetail.code           = 'ORDER-BUILD-COMPLETE'
        statusdetail.description    = 'Order Built'
        .
end.

if not can-find(StatusDetail where StatusDetail.Code eq 'ORDER-SHIPPED') then
do: 
    create statusdetail.
    assign 
        statusdetail.statusdetailid = guid(generate-uuid)
        statusdetail.code           = 'ORDER-SHIPPED'
        statusdetail.description    = 'Order Shipped'
        .
end.

