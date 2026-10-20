CLASS LHC_ZR_11GROCERIES DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Zr11groceries
        RESULT result,
      checkExpirationDate FOR MODIFY
            IMPORTING keys FOR ACTION Zr11groceries~checkExpirationDate RESULT result.
ENDCLASS.

CLASS LHC_ZR_11GROCERIES IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD checkExpirationDate.

    DATA: lt_groceries        TYPE TABLE FOR READ RESULT ZR_11GROCERIES,
          ls_grocery          TYPE STRUCTURE FOR READ RESULT ZR_11GROCERIES,
          lv_expiration       TYPE d,
          lv_current_date     TYPE d,
          lv_expired          TYPE abap_boolean,
          lt_update_groceries TYPE TABLE FOR UPDATE ZR_11GROCERIES.

    " 1. Read the selected entity
    READ ENTITIES OF ZR_11GROCERIES
      IN LOCAL MODE ENTITY Zr11groceries
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT lt_groceries.

    lv_current_date = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_groceries INTO ls_grocery.
      lv_expiration = ls_grocery-Expirationdate.

      IF lv_expiration < lv_current_date AND lv_expiration IS NOT INITIAL.
        lv_expired = abap_true.
      ELSE.
        lv_expired = abap_false.
      ENDIF.

      " 2. Prepare update with %control flag explicitly enabled
      APPEND VALUE #(
        %tky     = ls_grocery-%tky
        expired  = lv_expired
        %control = VALUE #( expired = if_abap_behv=>mk-on )
      ) TO lt_update_groceries.
    ENDLOOP.

    " 3. Update the buffer/database
    IF lt_update_groceries IS NOT INITIAL.
      MODIFY ENTITIES OF ZR_11GROCERIES IN LOCAL MODE
        ENTITY Zr11groceries
        UPDATE FIELDS ( expired )
        WITH lt_update_groceries
        FAILED failed
        REPORTED reported.
    ENDIF.

    " 4. Re-read the entity so RAP grabs the fresh state
    READ ENTITIES OF ZR_11GROCERIES
      IN LOCAL MODE ENTITY Zr11groceries
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated_groceries).

    " 5. Send updated records back to the UI
    result = VALUE #( FOR grocery IN lt_updated_groceries
                       ( %tky   = grocery-%tky
                         %param = grocery ) ).

  ENDMETHOD.
ENDCLASS.