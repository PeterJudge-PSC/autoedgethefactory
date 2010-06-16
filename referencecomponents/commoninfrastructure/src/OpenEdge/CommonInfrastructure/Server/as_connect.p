/*------------------------------------------------------------------------
    File        : as_connect.p
    Purpose     : 

    Syntax      :

    Description : AppServer connect procedure

    Author(s)   : pjudge
    Created     : Fri Jun 04 16:01:48 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

define input parameter user-id          as character no-undo.
define input parameter password         as character no-undo.
define input parameter app-server-info  as character no-undo.

/* ***************************  Main Block  *************************** */

/* This starts the connection object and sets its ID */
OpenEdge.Lang.AgentConnection:Instance.

/* eof */