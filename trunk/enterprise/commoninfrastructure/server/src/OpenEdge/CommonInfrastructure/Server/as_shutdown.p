/** ------------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/as_shutdown.p
    Purpose     : 

    Syntax      :

    Description : AppServer shutdown procedure

    @author pjudge
    Created     : Fri Jun 04 13:57:59 EDT 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

/** -- main -- **/
run OpenEdge/CommonInfrastructure/Common/stop_session.p.

/* eof */