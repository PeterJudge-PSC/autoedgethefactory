/** ------------------------------------------------------------------------
    File        : as_shutdown.p
    Purpose     : 

    Syntax      :

    Description : AppServer shutdown procedure

    @author pjudge
    Created     : Fri Jun 04 13:57:59 EDT 2010
    Notes       :
  ---------------------------------------------------------------------- */
{routinelevel.i}

/** -- main -- **/
run OpenEdge/CommonInfrastructure/stop_session.p.

/* eof */