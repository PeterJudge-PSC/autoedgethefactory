/*------------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/as_connect.p
    Purpose     : 

    Syntax      :

    Description : AppServer connect procedure

    @author pjudge
    Created     : Fri Jun 04 16:01:48 EDT 2010
    Notes       : * Not run for statefree appservers.
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.AgentConnection.
using OpenEdge.Lang.String.

define input parameter user-id          as character no-undo.
define input parameter password         as character no-undo.
define input parameter app-server-info  as character no-undo.

/* ***************************  Main Block  *************************** */
define variable oProps as IMap no-undo.

/* This starts the connection object and sets its ID */
oProps = AgentConnection:Instance:ConnectionProperties.

oProps:Put(new String('user-id'), new String(user-id)).
oProps:Put(new String('password'), new String(password)).
oProps:Put(new String('app-server-info'), new String(app-server-info)).

/* eof */