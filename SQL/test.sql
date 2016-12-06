    create or replace package refcursor_jdbc1 as
    type ref_cursor is ref cursor;
    function getstudents
    return ref_cursor;
    end;
/

    create or replace package body refcursor_jdbc1 as
    function getstudents
    return ref_cursor is
    rc ref_cursor;
    begin
    open rc for
    select * from students;
    return rc;
    end;
    end;
/































