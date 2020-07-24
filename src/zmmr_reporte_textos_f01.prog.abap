*&---------------------------------------------------------------------*
*&  Include           ZMMR_REPORTE_TEXTOS_F01
*&---------------------------------------------------------------------*


FORM f_obtiene_materiales.
  DATA: lv_name TYPE thead-tdname.

  SELECT matnr
    INTO TABLE i_mara
    FROM mara
   WHERE matnr IN s_matnr.

  LOOP AT i_mara INTO w_mara.

    MOVE w_mara-matnr TO lv_name.

    TRY.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id       = c_best
            language = sy-langu
            name     = lv_name
            object   = c_material
*     IMPORTING
*           HEADER   =
*           OLD_LINE_COUNTER              =
          TABLES
            lines    = i_lines.

        LOOP AT i_lines INTO w_lines.
          IF w_lines-tdline NE ''.
            MOVE w_lines-tdline TO w_dtext-tdline.
            MOVE w_mara-matnr TO w_dtext-matnr.
            APPEND w_dtext TO i_dtext.
          ENDIF.
        ENDLOOP.
    ENDTRY.
  ENDLOOP.

ENDFORM.


FORM f_muestra_alv.
*  DATA: li_toolbar_excluding  TYPE ui_functions.
*
*  REFRESH i_fieldcat.
** se obtiene una instancia del objeto grid
*  IF o_container IS INITIAL.
*
*    CREATE OBJECT o_container
*      EXPORTING
*        container_name = 'CGRID'.
*
*    CREATE OBJECT cl_grid
*      EXPORTING
*        i_parent = o_container.
*
*    PERFORM f_build_fieldcat
*    CHANGING i_fieldcat.
*
*** Permite seleccionar por filas
**    w_layout-sel_mode = 'D'.
**    w_layout-stylefname = 'CELLTAB'.
**    w_layout-no_toolbar = c_x.
**    w_layout-cwidth_opt = c_x.
*
*    w_sort-spos = '1'.
*    w_sort-fieldname = 'MATNR'.
*    APPEND w_sort TO i_sort.
*
*
** Se inicializa la pantalla del reporte
*    CALL METHOD cl_grid->set_table_for_first_display
*      EXPORTING
*        is_layout       = w_layout
*      CHANGING
*        it_fieldcatalog = i_fieldcat
*        it_outtab       = i_dtext[]
*        it_sort         = i_sort[].
*
*  ELSE.
*    CALL METHOD cl_grid->refresh_table_display
*      EXCEPTIONS
*        finished = 1
*        OTHERS   = 2.
*
*  ENDIF.

  DATA lw_key TYPE salv_s_layout_key.

  DATA: lo_functions TYPE REF TO cl_salv_functions_list, "Funciones del ALV
        lo_layout    TYPE REF TO cl_salv_layout,
        lo_events_t  TYPE REF TO cl_salv_events_table,
        lo_columns   TYPE REF TO cl_salv_columns_table,
        lo_column    TYPE REF TO cl_salv_column,
        lo_column_t  TYPE REF TO cl_salv_column_table,
        lo_display   TYPE REF TO cl_salv_display_settings.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = o_table_alv
        CHANGING
          t_table      = i_dtext.

      lo_columns = o_table_alv->get_columns( ).
      lo_columns->set_optimize( ).

      lo_column = lo_columns->get_column( 'MATNR' ).
      lo_column->set_long_text( TEXT-t01 ).
      lo_column_t ?= lo_column.
      lo_column_t->set_key( if_salv_c_bool_sap=>true ).

      lo_column = lo_columns->get_column( 'TDFORMAT' ).
      lo_column->set_long_text( TEXT-t02 ).
      lo_column_t ?= lo_column.
      lo_column_t->set_visible( if_salv_c_bool_sap=>false ).

      lo_column = lo_columns->get_column( 'TDLINE' ).
      lo_column->set_long_text( TEXT-t03 ).

    CATCH cx_salv_msg.
  ENDTRY.

** Set GUI Status
*  o_table_alv->set_screen_status( pfstatus      = 'ZSALV_STANDARD'
*                                  report        = sy-repid
*                                  set_functions = o_table_alv->c_functions_all ).

* Activar todas las funciones estandar del ALV
  lo_functions = o_table_alv->get_functions( ).
  lo_functions->set_all( abap_true ).

* Activa caracteristicas del Layout
  lo_layout     = o_table_alv->get_layout( ).
  lw_key-report = sy-repid.
  lo_layout->set_key( lw_key ).
  lo_layout->set_default( 'X' ).
  lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).

* Establecer Settings Layout
  lo_display = o_table_alv->get_display_settings( ).
  lo_display->set_striped_pattern( cl_salv_display_settings=>true ). "Atributo ZEBRA

  o_selections = o_table_alv->get_selections( ).
  o_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  o_table_alv->display( ).

ENDFORM.


*FORM f_build_fieldcat
*   CHANGING pt_fieldcat TYPE lvc_t_fcat.
*
*  DATA ls_fcat TYPE lvc_s_fcat.
*
*  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_structure_name = 'ZMMES_DTEXT'
*    CHANGING
*      ct_fieldcat      = pt_fieldcat.
*
*
*
*  LOOP AT pt_fieldcat
*    INTO ls_fcat.
*
*    CASE ls_fcat-fieldname.
*      WHEN 'TDFORMAT'.
*        ls_fcat-no_out = c_x.
*        MODIFY pt_fieldcat FROM ls_fcat.
*      WHEN 'TDLINE'.
*        ls_fcat-scrtext_l = TEXT-001.
*        ls_fcat-scrtext_m = TEXT-001.
*        ls_fcat-scrtext_s = TEXT-001.
*        MODIFY pt_fieldcat FROM ls_fcat.
*
*    ENDCASE.
*  ENDLOOP.
*
*ENDFORM.
