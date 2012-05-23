! Copyright (C) 2011
! Free Software Foundation, Inc.

! This file is part of the gtk-fortran GTK+ Fortran Interface library.

! This is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 3, or (at your option)
! any later version.

! This software is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

! Under Section 7 of GPL version 3, you are granted additional
! permissions described in the GCC Runtime Library Exception, version
! 3.1, as published by the Free Software Foundation.

! You should have received a copy of the GNU General Public License along with
! this program; see the files COPYING3 and COPYING.RUNTIME respectively.
! If not, see <http://www.gnu.org/licenses/>.
!
! Contributed by James Tappin
! Last modification: 05-22-2012

! --------------------------------------------------------
! gtk-hl-spin-slider.f90
! Generated: Tue May 22 21:05:56 2012 GMT
! Please do not edit this file directly,
! Edit gtk-hl-spin-slider-tmpl.f90, and use ./mk_gtk_hl.pl to regenerate.
! --------------------------------------------------------


module gtk_hl_spin_slider
  !*
  ! Sliders and Spin buttons
  ! GTK sliders and spin buttons use floating point values, the HL interface
  ! implements an automatic interface selection between a floating point or
  ! an integer slider.
  !
  ! Although they belong to completely different widget families in GTK, the
  ! interfaces are very similar, which is why they are grouped together here.
  !/

  use gtk_sup
  use iso_c_binding
  ! Autogenerated use's
  use gtk, only: gtk_hscale_new, gtk_hscale_new_with_range,&
       & gtk_range_get_value, gtk_range_set_value,&
       & gtk_scale_set_digits, gtk_scale_set_draw_value,&
       & gtk_spin_button_get_value, gtk_spin_button_new,&
       & gtk_spin_button_new_with_range, gtk_spin_button_set_digits,&
       & gtk_spin_button_set_numeric, gtk_spin_button_set_value,&
       & gtk_spin_button_set_wrap, gtk_vscale_new,&
       & gtk_vscale_new_with_range, gtk_widget_set_sensitive,&
       & gtk_widget_set_size_request, gtk_widget_set_tooltip_text, &
       & gtk_spin_button_get_adjustment, gtk_adjustment_get_lower, &
       & gtk_adjustment_get_upper, gtk_range_get_adjustment, &
       & gtk_spin_button_set_range, gtk_range_set_range, &
       & TRUE, FALSE, g_signal_connect, GDK_FOCUS_CHANGE_MASK

  implicit none

  ! A slider or a spin button can use integers or floats for its settings.
  interface hl_gtk_slider_new
     module procedure hl_gtk_slider_flt_new
     module procedure hl_gtk_slider_int_new
  end interface hl_gtk_slider_new
  interface hl_gtk_slider_set_value
     module procedure hl_gtk_slider_set_flt
     module procedure hl_gtk_slider_set_int
  end interface hl_gtk_slider_set_value

  interface hl_gtk_spin_button_new
     module procedure hl_gtk_spin_button_flt_new
     module procedure hl_gtk_spin_button_int_new
  end interface hl_gtk_spin_button_new
  interface hl_gtk_spin_button_set_value
     module procedure hl_gtk_spin_button_set_flt
     module procedure hl_gtk_spin_button_set_int
  end interface hl_gtk_spin_button_set_value

contains

  !+
  function hl_gtk_slider_flt_new(vmin, vmax, step, vertical, initial_value, &
       & value_changed, data, digits, sensitive, tooltip, draw, length) &
       & result(slider)

    type(c_ptr) :: slider
    real(kind=c_double), intent(in) :: vmin, vmax, step
    integer(kind=c_int), intent(in), optional :: vertical
    real(kind=c_double), intent(in), optional :: initial_value
    type(c_funptr), optional :: value_changed
    type(c_ptr), optional :: data
    integer(kind=c_int), optional, intent(in) :: digits
    integer(kind=c_int), optional, intent(in) :: sensitive
    character(len=*), intent(in), optional:: tooltip
    integer(kind=c_int), intent(in), optional :: draw
    integer(kind=c_int), intent(in), optional :: length

    ! Floating point version of a slider
    !
    ! VMIN: c_double: required: The minimum value for the slider
    ! VMAX: c_double: required: The maximum value for the slider
    ! STEP: c_double: required: The step for the slider.
    ! VERTICAL: boolean: optional: if TRUE then a vertical slider is created
    ! 		if FALSE or absent, then a horizontal silder is created.
    ! INITIAL_VALUE: c_double: optional: Set the intial value of the slider
    ! VALUE_CHANGED: c_funptr: optional: Callback function for the
    ! 		"value-changed" signal.
    ! DATA: c_ptr: optional: User data to pass the the value_changed callback.
    ! DIGITS: c_int: optional: Number of decimal places to show.
    ! SENSITIVE: boolean: optional: Whether the widget is created in the
    ! 		sensitive state.
    ! TOOLTIP: string: optional: A tooltip to display.
    ! DRAW: boolean: optional: Set to FALSE to suppress writing the
    ! 		value.
    ! LENGTH: c_int: optional: Set the length of the slider in pixels
    !
    ! This routine is usually called via its generic interface
    ! hl_gtk_slider_new
    !-

    integer(kind=c_int) :: isvertical, idraw

    ! Create the slider
    if (present(vertical)) then
       isvertical = vertical
    else
       isvertical = FALSE
    end if
    if (isvertical == TRUE) then
       slider = gtk_vscale_new_with_range(vmin, vmax, step)
       if (present(length)) &
            & call gtk_widget_set_size_request(slider, 0, length)
    else
       slider = gtk_hscale_new_with_range(vmin, vmax, step)
       if (present(length)) &
            & call gtk_widget_set_size_request(slider, length, 0)
    end if

    ! Formatting
    if (present(draw)) then
       idraw = draw
    else
       idraw = TRUE
    end if
    call gtk_scale_set_draw_value(slider, idraw)
    if (present(digits)) call gtk_scale_set_digits(slider, digits)

    ! Initial value
    if (present(initial_value)) call gtk_range_set_value(slider, initial_value)

    ! Callback connection
    if (present(value_changed)) then
       if (present(data)) then
          call g_signal_connect(slider, "value-changed"//c_null_char, value_changed, data)
       else
          call g_signal_connect(slider, "value-changed"//c_null_char, value_changed)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(slider, &
         & trim(tooltip)//c_null_char)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(slider, sensitive)
  end function hl_gtk_slider_flt_new

  !+
  function hl_gtk_slider_int_new(imin, imax, vertical, initial_value, &
       & value_changed, data, sensitive, tooltip, draw, length) result(slider)

    type(c_ptr) :: slider
    integer(kind=c_int), intent(in) :: imin, imax
    integer(kind=c_int), intent(in), optional :: vertical
    integer(kind=c_int), intent(in), optional :: initial_value
    type(c_funptr), optional :: value_changed
    type(c_ptr), optional :: data
    integer(kind=c_int), optional, intent(in) :: sensitive
    character(len=*), intent(in), optional:: tooltip ! NB the C-type confuses generic interfaces.
    integer(kind=c_int), intent(in), optional :: draw
    integer(kind=c_int), intent(in), optional :: length

    ! Floating point version of a slider
    !
    ! IMIN: c_int: required: The minimum value for the slider
    ! IMAX: c_int: required: The maximum value for the slider
    ! VERTICAL: boolean: optional: if TRUE then a vertical slider is created
    ! 		if FALSE or absent, then a horizontal silder is created.
    ! INITIAL_VALUE: c_int: optional: Set the intial value of the slider
    ! VALUE_CHANGED: c_funptr: optional: Callback function for the
    ! 		"value-changed" signal.
    ! DATA: c_ptr: optional: User data to pass the the value_changed callback.
    ! SENSITIVE: boolean: optional: Whether the widget is created in the
    ! 		sensitive state.
    ! TOOLTIP: string: optional: A tooltip to display.
    ! DRAW: boolean: optional: Set to FALSE to suppress writing the
    ! 		value.
    ! LENGTH: c_int: optional: Set the length of the slider in pixels
    !
    ! This routine is usually called via its generic interface
    ! hl_gtk_slider_new
    !-

    integer(kind=c_int) :: isvertical, idraw

    ! Create the slider
    if (present(vertical)) then
       isvertical = vertical
    else
       isvertical = FALSE
    end if
    if (isvertical == TRUE) then
       slider = gtk_vscale_new_with_range(real(imin, c_double), &
            &real(imax, c_double), 1.0_c_double)
       if (present(length)) &
            & call gtk_widget_set_size_request(slider, 0, length)
    else
       slider = gtk_hscale_new_with_range(real(imin, c_double), &
            &real(imax, c_double), 1.0_c_double)
       if (present(length)) &
            & call gtk_widget_set_size_request(slider, length, 0)
    end if

    ! Formatting
    if (present(draw)) then
       idraw = draw
    else
       idraw = TRUE
    end if
    call gtk_scale_set_draw_value(slider, idraw)

    ! Initial value
    if (present(initial_value)) call gtk_range_set_value(slider, &
         & real(initial_value, c_double))

    ! Callback connection
    if (present(value_changed)) then
       if (present(data)) then
          call g_signal_connect(slider, "value-changed"//c_null_char, &
               & value_changed, data)
       else
          call g_signal_connect(slider, "value-changed"//c_null_char, value_changed)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(slider, &
         & trim(tooltip)//c_null_char)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(slider, sensitive)
  end function hl_gtk_slider_int_new

  !+
  function hl_gtk_slider_get_value(slider) result(val)

    real(kind=c_double) :: val
    type(c_ptr) :: slider

    ! Get the value of a slider
    !
    ! SLIDER: c_ptr: required: The slider to read.
    !
    ! Note even for an integer slider we get a float value but there's
    ! no problem letting Fortran do the truncation
    !-

    val = gtk_range_get_value(slider)
  end function hl_gtk_slider_get_value

  !+
  subroutine hl_gtk_slider_set_flt(slider, val)

    type(c_ptr), intent(in) :: slider
    real(kind=c_double), intent(in) :: val

    ! Set a floating point value for a slider
    !
    ! SLIDER: c_ptr: required: The slider to set.
    ! VAL: c_double: required: The value to set.
    !
    ! This is usually accessed via the generic interface hl_gtk_slider_set_value
    !-

    call gtk_range_set_value(slider, val)
  end subroutine hl_gtk_slider_set_flt

  !+
  subroutine hl_gtk_slider_set_int(slider, val)

    type(c_ptr), intent(in) :: slider
    integer(kind=c_int), intent(in) :: val

    ! Set a floating point value for a slider
    !
    ! SLIDER: c_ptr: required: The slider to set.
    ! VAL: c_int: required: The value to set.
    !
    ! This is usually accessed via the generic interface hl_gtk_slider_set_value
    !-

    call gtk_range_set_value(slider, real(val, c_double))
  end subroutine hl_gtk_slider_set_int

  !+
  subroutine hl_gtk_slider_set_range(slider, lower, upper)
    type(c_ptr), intent(in) :: slider
    real(kind=c_double), intent(in), optional :: lower, upper

    ! Adjust the bounds of a slider
    !
    ! SLIDER: c_ptr: required: The slider to modify
    ! LOWER: c_double: optional: The new lower bound
    ! UPPER: c_double: optional: The new uppper bound
    !
    ! **Note** This routine is not a generic interface as
    ! overloading requires that the interface be distinguishable by its
    ! required arguments, and it seems less annoying to have to convert to
    ! doubles or use a separate call than to specify an unchanged bound.
    !-

    type(c_ptr) :: adjustment
    real(kind=c_double) :: nlower, nupper

    ! Check it's not a do-nothing
    if (.not. (present(upper) .or. present(lower))) return

    adjustment = gtk_range_get_adjustment(slider)
    if (present(lower)) then
       nlower = lower
    else
       nlower = gtk_adjustment_get_lower(adjustment)
    end if

    if (present(upper)) then
       nupper = upper
    else
       nupper = gtk_adjustment_get_upper(adjustment)
    end if

    call gtk_range_set_range(slider, nlower, nupper)

  end subroutine hl_gtk_slider_set_range

  !+
  subroutine hl_gtk_slider_set_range_int(slider, lower, upper)
    type(c_ptr), intent(in) :: slider
    integer(kind=c_int), intent(in), optional :: lower, upper

    ! Adjust the bounds of a slider, integer values
    !
    ! SLIDER: c_ptr: required: The slider to modify
    ! LOWER: c_int: optional: The new lower bound
    ! UPPER: c_int: optional: The new uppper bound
    !
    ! **Note** This routine is not a generic interface as
    ! overloading requires that the interface be distinguishable by its
    ! required arguments, and it seems less annoying to use a separate
    ! call than to specify an unchanged bound.
    !-

    type(c_ptr) :: adjustment
    real(kind=c_double) :: nlower, nupper

    ! Check it's not a do-nothing
    if (.not. (present(upper) .or. present(lower))) return

    adjustment = gtk_range_get_adjustment(slider)
    if (present(lower)) then
       nlower = real(lower, c_double)
    else
       nlower = gtk_adjustment_get_lower(adjustment)
    end if

    if (present(upper)) then
       nupper = real(upper, c_double)
    else
       nupper = gtk_adjustment_get_upper(adjustment)
    end if

    call gtk_range_set_range(slider, nlower, nupper)

  end subroutine hl_gtk_slider_set_range_int

  !+
  function hl_gtk_spin_button_flt_new(vmin, vmax, step, initial_value, &
       & value_changed, data, digits, sensitive, tooltip, wrap, &
       & focus_in_event, focus_out_event, data_focus_in, data_focus_out) &
       & result(spin_button)

    type(c_ptr) :: spin_button
    real(kind=c_double), intent(in) :: vmin, vmax, step
    real(kind=c_double), intent(in), optional :: initial_value
    type(c_funptr), optional :: value_changed
    type(c_ptr), optional :: data
    integer(kind=c_int), optional, intent(in) :: digits
    integer(kind=c_int), optional, intent(in) :: sensitive
    character(len=*), intent(in), optional:: tooltip ! NB the C-type confuses generic interfaces.
    integer(kind=c_int), intent(in), optional :: wrap
    type(c_funptr), optional :: focus_in_event, focus_out_event
    type(c_ptr), optional :: data_focus_in, data_focus_out

    ! Floating point version of a spin_button
    !
    ! VMIN: c_double: required: The minimum value for the spin_button
    ! VMAX: c_double: required: The maximum value for the spin_button
    ! STEP: c_double: required: The step for the spin_button.
    ! INITIAL_VALUE: c_double: optional: Set the intial value of the spin_button
    ! VALUE_CHANGED: c_funptr: optional: Callback function for the
    ! 		"value-changed" signal.
    ! DATA: c_ptr: optional: User data to pass the the value_changed callback.
    ! DIGITS: c_int: optional: Number of decimal places to show.
    ! SENSITIVE: boolean: optional: Whether the widget is created in the
    ! 		sensitive state.
    ! TOOLTIP: string: optional: A tooltip to display.
    ! WRAP: boolean: optional: If set to TRUE then wrap around if limit is
    ! 		exceeded
    ! FOCUS_OUT_EVENT: c_funptr: optional: Callback for the "focus-out-event"
    ! 		signal, this is a GDK event rather than a GTK signal, so the
    ! 		call back is a function of 3 arguments returning gboolean.
    ! DATA_FOCUS_OUT: c_ptr: optional: Data to pass to the focus_out_event
    ! 		callback
    ! FOCUS_IN_EVENT: c_funptr: optional: Callback for the "focus-in-event"
    ! 		signal, this is a GDK event rather than a GTK signal, so the
    ! 		call back is a function of 3 arguments returning gboolean.
    ! DATA_FOCUS_IN: c_ptr: optional: Data to pass to the focus_in_event
    ! 		callback
    !
    ! This routine is usually called via its generic interface
    ! hl_gtk_spin_button_new
    !-

    ! Create the spin_button
    spin_button = gtk_spin_button_new_with_range(vmin, vmax, step)

    ! Formatting
    call gtk_spin_button_set_numeric(spin_button, TRUE)
    if (present(digits)) call gtk_spin_button_set_digits(spin_button, digits)
    if (present(wrap)) call gtk_spin_button_set_wrap(spin_button, wrap)

    ! Initial value
    if (present(initial_value)) &
         & call gtk_spin_button_set_value(spin_button, initial_value)

    ! Callback connection
    if (present(value_changed)) then
       if (present(data)) then
          call g_signal_connect(spin_button, "value-changed"//c_null_char, value_changed, &
               & data)
       else
          call g_signal_connect(spin_button, "value-changed"//c_null_char, value_changed)
       end if
    end if
    if (present(focus_out_event)) then
       if (present(data_focus_out)) then
          call g_signal_connect(spin_button, &
               & "focus-out-event"//C_NULL_CHAR, focus_out_event, data_focus_out)
       else
          call g_signal_connect(spin_button, &
               & "focus-out-event"//C_NULL_CHAR, focus_out_event)
       end if
    end if

    if (present(focus_in_event)) then
       if (present(data_focus_in)) then
          call g_signal_connect(spin_button, &
               & "focus-in-event"//C_NULL_CHAR, focus_in_event, data_focus_in)
       else
          call g_signal_connect(spin_button, &
               & "focus-in-event"//C_NULL_CHAR, focus_in_event)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(spin_button, &
         & trim(tooltip)//c_null_char)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(spin_button, sensitive)
  end function hl_gtk_spin_button_flt_new

  !+
  function hl_gtk_spin_button_int_new(imin, imax, initial_value, &
       & value_changed, data, sensitive, tooltip, wrap, &
       & focus_in_event, focus_out_event, data_focus_in, data_focus_out) &
       & result(spin_button)

    type(c_ptr) :: spin_button
    integer(kind=c_int), intent(in) :: imin, imax
    integer(kind=c_int), intent(in), optional :: initial_value
    type(c_funptr), optional :: value_changed
    type(c_ptr), optional :: data
    integer(kind=c_int), optional, intent(in) :: sensitive
    character(len=*), intent(in), optional:: tooltip ! NB the C-type confuses generic interfaces.
    integer(kind=c_int), intent(in), optional :: wrap
    type(c_funptr), optional :: focus_in_event, focus_out_event
    type(c_ptr), optional :: data_focus_in, data_focus_out

    ! Floating point version of a spin_button
    !
    ! IMIN: c_int: required: The minimum value for the spin_button
    ! IMAX: c_int: required: The maximum value for the spin_button
    ! INITIAL_VALUE: c_int: optional: Set the intial value of the spin_button
    ! VALUE_CHANGED: c_funptr: optional: Callback function for the
    ! 		"value-changed" signal.
    ! DATA: c_ptr: optional: User data to pass the the value_changed callback.
    ! SENSITIVE: boolean: optional: Whether the widget is created in the
    ! 		sensitive state.
    ! TOOLTIP: string: optional: A tooltip to display.
    ! WRAP: boolean: optional: If set to TRUE then wrap around if limit is
    ! 		exceeded
    ! FOCUS_OUT_EVENT: c_funptr: optional: Callback for the "focus-out-event"
    ! 		signal, this is a GDK event rather than a GTK signal, so the
    ! 		call back is a function of 3 arguments returning gboolean.
    ! DATA_FOCUS_OUT: c_ptr: optional: Data to pass to the focus_out_event
    ! 		callback
    ! FOCUS_IN_EVENT: c_funptr: optional: Callback for the "focus-in-event"
    ! 		signal, this is a GDK event rather than a GTK signal, so the
    ! 		call back is a function of 3 arguments returning gboolean.
    ! DATA_FOCUS_IN: c_ptr: optional: Data to pass to the focus_in_event
    ! 		callback
    !
    ! This routine is usually called via its generic interface
    ! hl_gtk_spin_button_new
    !-

    ! Create the spin_button
    spin_button = gtk_spin_button_new_with_range(real(imin, c_double), &
         &real(imax, c_double), 1.0_c_double)

    ! Formatting
    call gtk_spin_button_set_numeric(spin_button, TRUE)
    if (present(wrap)) call gtk_spin_button_set_wrap(spin_button, wrap)

    ! Initial value
    if (present(initial_value)) call gtk_spin_button_set_value(spin_button, &
         & real(initial_value, c_double))

    ! Callback connection
    if (present(value_changed)) then
       if (present(data)) then
          call g_signal_connect(spin_button, "value-changed"//c_null_char, value_changed, &
               & data)
       else
          call g_signal_connect(spin_button, "value-changed"//c_null_char, value_changed)
       end if
    end if

    if (present(focus_out_event)) then
       if (present(data_focus_out)) then
          call g_signal_connect(spin_button, &
               & "focus-out-event"//C_NULL_CHAR, focus_out_event, data_focus_out)
       else
          call g_signal_connect(spin_button, &
               & "focus-out-event"//C_NULL_CHAR, focus_out_event)
       end if
    end if

    if (present(focus_in_event)) then
       if (present(data_focus_in)) then
          call g_signal_connect(spin_button, &
               & "focus-in-event"//C_NULL_CHAR, focus_in_event, data_focus_in)
       else
          call g_signal_connect(spin_button, &
               & "focus-in-event"//C_NULL_CHAR, focus_in_event)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(spin_button, &
         & trim(tooltip)//c_null_char)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(spin_button, sensitive)
  end function hl_gtk_spin_button_int_new

  !+
  function hl_gtk_spin_button_get_value(spin_button) result(val)

    real(kind=c_double) :: val
    type(c_ptr) :: spin_button

    ! Get the value of a spin_button
    !
    ! SPIN_BUTTON: c_ptr: required: The spin_button to read.
    !
    ! Note even for an integer spin_button we get a float value but there's
    ! no problem letting Fortran do the truncation
    !-

    val = gtk_spin_button_get_value(spin_button)
  end function hl_gtk_spin_button_get_value

  !+
  subroutine hl_gtk_spin_button_set_flt(spin_button, val)

    type(c_ptr), intent(in) :: spin_button
    real(kind=c_double), intent(in) :: val

    ! Set a floating point value for a spin_button
    !
    ! SPIN_BUTTON: c_ptr: required: The spin_button to set.
    ! VAL: c_double: required: The value to set.
    !
    ! This is usually accessed via the generic interface hl_gtk_spin_button_set_value
    !-

    call gtk_spin_button_set_value(spin_button, val)
  end subroutine hl_gtk_spin_button_set_flt

  !+
  subroutine hl_gtk_spin_button_set_int(spin_button, val)

    type(c_ptr), intent(in) :: spin_button
    integer(kind=c_int), intent(in) :: val

    ! Set a floating point value for a spin_button
    !
    ! SPIN_BUTTON: c_ptr: required: The spin_button to set.
    ! VAL: c_int: required: The value to set.
    !
    ! This is usually accessed via the generic interface hl_gtk_spin_button_set_value
    !-

    call gtk_spin_button_set_value(spin_button, real(val, c_double))
  end subroutine hl_gtk_spin_button_set_int

  !+
  subroutine hl_gtk_spin_button_set_range(spin_button, lower, upper)
    type(c_ptr), intent(in) :: spin_button
    real(kind=c_double), intent(in), optional :: lower, upper

    ! Adjust the bounds of a spin box
    !
    ! SLIDER: c_ptr: required: The slider to modify
    ! LOWER: c_double: optional: The new lower bound
    ! UPPER: c_double: optional: The new uppper bound
    !
    ! **Note** This routine is not a generic interface as
    ! overloading requires that the interface be distinguishable by its
    ! required arguments, and it seems less annoying to have to convert to
    ! doubles or use a separate call than to specify an unchanged bound.
    !-

    type(c_ptr) :: adjustment
    real(kind=c_double) :: nlower, nupper

    ! Check it's not a do-nothing
    if (.not. (present(upper) .or. present(lower))) return

    adjustment = gtk_spin_button_get_adjustment(spin_button)

    if (present(lower)) then
       nlower = lower
    else
       nlower = gtk_adjustment_get_lower(adjustment)
    end if

    if (present(upper)) then
       nupper = upper
    else
       nupper = gtk_adjustment_get_upper(adjustment)
    end if

    call gtk_spin_button_set_range(spin_button, nlower, nupper)

  end subroutine hl_gtk_spin_button_set_range

  !+
  subroutine hl_gtk_spin_button_set_range_int(spin_button, lower, upper)
    type(c_ptr), intent(in) :: spin_button
    integer(kind=c_int), intent(in), optional :: lower, upper

    ! Adjust the bounds of a spin box, integer values
    !
    ! SLIDER: c_ptr: required: The slider to modify
    ! LOWER: c_int: optional: The new lower bound
    ! UPPER: c_int: optional: The new uppper bound
    !
    ! **Note** This routine is not a generic interface as
    ! overloading requires that the interface be distinguishable by its
    ! required arguments, and it seems less annoying to use a separate
    ! call than to specify an unchanged bound.
    !-

    type(c_ptr) :: adjustment
    real(kind=c_double) :: nlower, nupper

    ! Check it's not a do-nothing
    if (.not. (present(upper) .or. present(lower))) return

    adjustment = gtk_spin_button_get_adjustment(spin_button)

    if (present(lower)) then
       nlower = real(lower, c_double)
    else
       nlower = gtk_adjustment_get_lower(adjustment)
    end if

    if (present(upper)) then
       nupper = real(upper, c_double)
    else
       nupper = gtk_adjustment_get_upper(adjustment)
    end if

    call gtk_spin_button_set_range(spin_button, nlower, nupper)

  end subroutine hl_gtk_spin_button_set_range_int
end module gtk_hl_spin_slider
