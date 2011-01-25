
/*------------------------------------------------------------------------
    File        : load_statusdetail.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Wed Dec 15 08:59:41 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/*routine-level on error undo, throw.*/

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
create StatusDetail.
assign 
    StatusDetail.StatusDetailId = guid(generate-uuid)
    StatusDetail.Code           = 'WORKFLOW-STARTING'
    StatusDetail.Description    = 'WorkFlow [ STARTING ]'.

create StatusDetail.
assign 
    StatusDetail.StatusDetailId = guid(generate-uuid)
    statusdetail.code           = 'WORKFLOW-OK'
    StatusDetail.Description    = 'WorkFlow [ OK ]'.

create statusdetail.
assign 
    statusdetail.statusdetailid = guid(generate-uuid)
    statusdetail.code           = 'WORKFLOW-ERROR'
    statusdetail.description    = 'WorkFlow [ ERROR ]'.



create statusdetail.
assign 
    statusdetail.statusdetailid = guid(generate-uuid)
    statusdetail.code           = 'WORKSTEP-STARTING'
    statusdetail.description    = 'WorkStep [ STARTING ]'
    .


create statusdetail.
assign 
    statusdetail.statusdetailid = guid(generate-uuid)
    statusdetail.code           = 'WORKSTEP-OK'
    statusdetail.description    = 'WorkStep [ OK ]'
    .



create statusdetail.
assign 
    statusdetail.statusdetailid = guid(generate-uuid)
    statusdetail.code           = 'WORKSTEP-ERROR'
    statusdetail.description    = 'WorkStep [ ERROR ]'
    .



create statusdetail.
assign 
    statusdetail.statusdetailid = guid(generate-uuid)
    statusdetail.code           = 'ORDER-NEW'
    statusdetail.description    = 'Order Submitted'
    .


create statusdetail.
assign 
    statusdetail.statusdetailid = guid(generate-uuid)
    statusdetail.code           = 'ORDER-BUILD-START'
    statusdetail.description    = 'Order Build Started'
    .

create statusdetail.
assign 
    statusdetail.statusdetailid = guid(generate-uuid)
    statusdetail.code           = 'ORDER-BUILD-COMPLETE'
    statusdetail.description    = 'Order Built'
    .

create statusdetail.
assign 
    statusdetail.statusdetailid = guid(generate-uuid)
    statusdetail.code           = 'ORDER-SHIPPED'
    statusdetail.description    = 'Order Shipped'
    .




