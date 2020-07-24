*&---------------------------------------------------------------------*
*&  Include           ZMMR_REPORTE_TEXTOS_TOP
*&---------------------------------------------------------------------*
TABLES: mara.

CONSTANTS:
  c_best     TYPE thead-tdid VALUE 'BEST',
  c_material TYPE thead-tdobject VALUE 'MATERIAL', " Object
  c_x        TYPE c                     VALUE 'X',
  c_back     TYPE sy-ucomm              VALUE 'BACK',
  c_fin      TYPE sy-ucomm              VALUE 'FIN',
  c_cancel   TYPE sy-ucomm              VALUE 'CANCEL'.



TYPES: BEGIN OF ty_mara,
         matnr TYPE matnr,
       END OF ty_mara.


TYPES:BEGIN OF ty_lines.
        INCLUDE STRUCTURE tline.   " Long Text
TYPES:END OF ty_lines.


TYPES: BEGIN OF ty_dtext.
TYPES:   matnr LIKE pbim-matnr.
        INCLUDE STRUCTURE tline.
TYPES: END OF ty_dtext.


TYPES: ty_mara_tab  TYPE TABLE OF ty_mara,
       ty_lines_tab TYPE TABLE OF ty_lines,
       ty_dtext_tab TYPE TABLE OF ty_dtext.


DATA: i_mara     TYPE ty_mara_tab,
      w_mara     TYPE ty_mara,
      i_lines    TYPE ty_lines_tab,
      w_lines    TYPE ty_lines,
      i_dtext    TYPE ty_dtext_tab,
      w_dtext    TYPE ty_dtext,
      i_fieldcat TYPE lvc_t_fcat,
      w_layout   TYPE lvc_s_layo,
      i_sort     TYPE lvc_t_sort,
      w_sort     TYPE lvc_s_sort.

DATA: v_ucomm           TYPE sy-ucomm.

*&---------------------------------------------------------------------*
*& Declaración de Objetos
*&---------------------------------------------------------------------*
DATA:
 o_container TYPE REF TO cl_gui_custom_container.

DATA: o_table_alv  TYPE REF TO cl_salv_table,         "Objeto ALV
      o_selections TYPE REF TO cl_salv_selections.


*&---------------------------------------------------------------------*
*& Declaración de Clases
*&---------------------------------------------------------------------*
DATA: cl_grid TYPE REF TO cl_gui_alv_grid.

SELECT-OPTIONS: s_matnr FOR mara-matnr OBLIGATORY.
