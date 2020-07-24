*&---------------------------------------------------------------------*
*& Report  ZMMR_REPORTE_TEXTOS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zmmr_reporte_textos.

INCLUDE zmmr_reporte_textos_top.
INCLUDE zmmr_reporte_textos_f01.

START-OF-SELECTION.

  PERFORM f_obtiene_materiales.
  IF i_dtext[] IS NOT INITIAL.
    PERFORM f_muestra_alv.
  ENDIF.
