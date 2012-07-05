! Copyright (C) 2011
! Free Software Foundation, Inc.

! This file is part of the gtk-fortran gtk+ Fortran Interface library.

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
! gfortran -I../src ../src/gtk.o cairo-basics.f90 `pkg-config --cflags --libs gtk+-3.0`
! Contributed by James Tappin,
! originally derived from cairo_basics.f90 by Vindent Magnin & Jerry DeLisle

module handlers
  use iso_c_binding
  
  use gtk, only: gtk_container_add, gtk_drawing_area_new, gtk_events_pending, gtk&
  &_main, gtk_main_iteration, gtk_main_iteration_do, gtk_widget_get_window, gtk_w&
  &idget_show, gtk_window_new, gtk_window_set_default, gtk_window_set_default_siz&
  &e, gtk_window_set_title, gtk_widget_show_all, gtk_main_quit, &
  & gtk_widget_queue_draw, &
  & TRUE, FALSE, c_null_char, GTK_WINDOW_TOPLEVEL, gtk_init, g_signal_connect, &
  & CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL, gtk_event_box_new, &
  & GDK_ENTER_NOTIFY, GDK_LEAVE_NOTIFY, GDK_2BUTTON_PRESS, GDK_KEY_RELEASE, &
  & GDK_CONTROL_MASK, GDK_POINTER_MOTION_MASK, GDK_BUTTON_PRESS, &
  & GDK_BUTTON_MOTION_MASK, &
  & GDK_KEY_PRESS, GDK_POINTER_MOTION_HINT_MASK, GDK_ALL_EVENTS_MASK
  
  use cairo, only: cairo_arc, cairo_create, cairo_curve_to, cairo_destroy, cairo_&
  &get_target, cairo_line_to, cairo_move_to, cairo_new_sub_path, cairo_select_fon&
  &t_face, cairo_set_font_size, cairo_set_line_width, cairo_set_source, cairo_set&
  &_source_rgb, cairo_show_text, cairo_stroke, cairo_surface_write_to_png, &
  & cairo_paint, cairo_rectangle
  
  use gdk, only: gdk_cairo_create, gdk_keyval_from_name, gdk_keyval_name, &
       & gdk_cairo_set_source_window

  use g, only: g_usleep

  use gdk_events
  use gtk_draw_hl
  use gtk_sup
  use gtk_hl

  implicit none
!  integer(c_int) :: run_status = TRUE
  integer(c_int) :: boolresult
  logical :: boolevent
  integer :: width, height
  
contains
  ! User defined event handlers go here
  function delete_h (widget, event, gdata) result(ret)  bind(c)
    use iso_c_binding, only: c_ptr, c_int
    integer(c_int)    :: ret
    type(c_ptr), value :: widget, event, gdata
!    run_status = FALSE
    call gtk_main_quit
    ret = FALSE
  end function delete_h

 function button_event_h(widget, event, gdata) result(rv) bind(c)
    integer(kind=c_int) :: rv
    type(c_ptr), value, intent(in) :: widget, event, gdata
    
    type(gdkeventbutton), pointer :: bevent
    integer(kind=c_int) :: event_mask

    print *, "Button press detected"
    if (c_associated(event)) then
       call c_f_pointer(event,bevent)
       print *, "Clicked at:", int(bevent%x), int(bevent%y)
       print *, "Type:", bevent%type
       print *, "State, Button:", bevent%state, bevent%button
       print *, "Root x,y:", int(bevent%x_root), int(bevent%y_root)
       if (bevent%type == GDK_2BUTTON_PRESS .and. &
            & bevent%button == 3) call gtk_main_quit
    end if
    print *
    rv = FALSE
  end function button_event_h

  function motion_event_h(widget, event, gdata) bind(c) result(rv)
    integer(kind=c_int) :: rv
    type(c_ptr), value, intent(in) :: widget, event, gdata

    type(gdkeventscroll), pointer :: bevent

    if (c_associated(event)) then
       call c_f_pointer(event,bevent)

       write(*, "(2I5,A)", advance='no') int(bevent%x), &
            & int(bevent%y), c_carriage_return
    end if
    rv = FALSE
  end function motion_event_h

  function scroll_event_h(widget, event, gdata) bind(c) result(rv)
    integer(kind=c_int) :: rv
    type(c_ptr), value, intent(in) :: widget, event, gdata

    type(gdkeventscroll), pointer :: bevent

    print *, "Wheel event detected"
    if (c_associated(event)) then
       call c_f_pointer(event,bevent)
       print *, "Clicked at:", int(bevent%x), int(bevent%y)
       print *, "State, direction:", bevent%state, bevent%direction
       print *, "Root x,y:", int(bevent%x_root), int(bevent%y_root)
    end if
    print *
    rv = FALSE
  end function scroll_event_h

  function cross_event_h(widget, event, gdata) bind(c) result(rv)
    integer(kind=c_int) :: rv
    type(c_ptr), value, intent(in) :: widget, event, gdata

    type(gdkeventcrossing), pointer :: bevent

    if (c_associated(event)) then
       call c_f_pointer(event,bevent)
       select case(bevent%type)
       case(GDK_ENTER_NOTIFY)
          print *, "Pointer entered at", int(bevent%x), int(bevent%y)
       case(GDK_LEAVE_NOTIFY)
          print *, "Pointer left at", int(bevent%x), int(bevent%y)
       case default
          print *, "Unknown type", bevent%type
       end select
    end if
    print *
    rv = FALSE
  end function cross_event_h

  function key_event_h(widget, event, gdata) bind(c) result(rv)
    integer(kind=c_int) :: rv
    type(c_ptr), value, intent(in) :: widget, event, gdata

    type(gdkeventkey), pointer :: bevent
    integer(kind=c_int) :: key_q
    type(c_ptr) :: keystr
    character(len=20) :: keyname

    key_q = gdk_keyval_from_name("q"//c_null_char)
    print *, "Key event"
    if (c_associated(event)) then
       call c_f_pointer(event,bevent)
       call convert_c_string(gdk_keyval_name(bevent%keyval), 20, keyname)
       print *, "Code: ",bevent%keyval," Name: ", trim(keyname), &
            & " Modifier: ", bevent%state
       if (bevent%type == GDK_KEY_PRESS .and. &
            & iand(bevent%state, GDK_CONTROL_MASK) /= 0 .and.&
            & bevent%keyval == key_q) call gtk_main_quit
    end if
    rv = FALSE
  end function key_event_h

  subroutine draw_pattern(widget)
    type(c_ptr) :: widget

    real(kind=c_double), parameter :: pi = 3.14159265358979323846_c_double

    type(c_ptr) :: my_cairo_context, pixbuf
    integer :: cstatus
    integer :: t

    my_cairo_context = hl_gtk_drawing_area_cairo_new(widget)
    if (.not. c_associated(my_cairo_context)) then
       print *, "ERROR failed to create cairo context"
       return
    end if

    ! Background
    call cairo_set_source_rgb(my_cairo_context, 0.6_c_double, 0.6_c_double, &
         & 0.6_c_double)
    call cairo_rectangle(my_cairo_context, 0._c_double, 0._c_double,&
         & real(width, c_double), real(height, c_double))
    call cairo_paint(my_cairo_context)

    ! Bezier curve:
    call cairo_set_source_rgb(my_cairo_context, 0.9_c_double, 0.8_c_double, &
         & 0.8_c_double)
    call cairo_set_line_width(my_cairo_context, 4._c_double)
    call cairo_move_to(my_cairo_context, 0._c_double, 0._c_double)  
    call cairo_curve_to(my_cairo_context, 600._c_double, 50._c_double, &
         & 115._c_double, 545._c_double, &
         & real(width, c_double), real(height, c_double))
    call cairo_stroke(my_cairo_context) 

    ! Lines:
    call cairo_set_source_rgb(my_cairo_context, 0._c_double, 0.5_c_double, &
         & 0.5_c_double)
    call cairo_set_line_width(my_cairo_context, 2._c_double)
    do t = 0, int(height), +20
      call cairo_move_to(my_cairo_context, 0._c_double, real(t, c_double))
      call cairo_line_to(my_cairo_context, real(t, c_double), &
           & real(height, c_double))
      call cairo_stroke(my_cairo_context) 
    end do
  
    ! Text:
    call cairo_set_source_rgb(my_cairo_context, 0._c_double, 0._c_double, &
         & 1._c_double)
    call cairo_select_font_face(my_cairo_context, "Times"//c_null_char, &
         & CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    call cairo_set_font_size (my_cairo_context, 40._c_double)
    call cairo_move_to(my_cairo_context, 100._c_double, 30._c_double)
    call cairo_show_text (my_cairo_context, "gtk-fortran"//c_null_char)
    call cairo_move_to(my_cairo_context, 100._c_double, 75._c_double)
    call cairo_show_text (my_cairo_context, "Cairo & Fortran are good friends"//c_null_char)

    ! Circles:
    call cairo_new_sub_path(my_cairo_context)
    do t = 1, 50
        call cairo_set_source_rgb(my_cairo_context, t/50._c_double, &
             & 0._c_double, 0._c_double)
        call cairo_set_line_width(my_cairo_context, 5._c_double*t/50._c_double)
        call cairo_arc(my_cairo_context, 353._c_double+ &
             & 200._c_double*cos(t*2_c_double*pi/50), &
             & 350._c_double+200._c_double*sin(t*2._c_double*pi/50.), &
             & 50._c_double, 0._c_double, 2.*pi) 
        call cairo_stroke(my_cairo_context) 
    end do
    
    ! Save:
    cstatus = cairo_surface_write_to_png(cairo_get_target(my_cairo_context), &
         & "cairo.png"//c_null_char)
    
    call gtk_widget_queue_draw(widget)
    call hl_gtk_drawing_area_cairo_destroy(my_cairo_context)
  end subroutine draw_pattern

end module handlers


program cairo_basics_click
  use iso_c_binding, only: c_ptr, c_funloc
  use handlers
  implicit none
  type(c_ptr) :: my_window
  type(c_ptr) :: my_drawing_area
  type(c_ptr) :: my_scroll_box

  call gtk_init ()
  
  ! Properties of the main window :
  width = 700
  height = 700
  my_window = hl_gtk_window_new("Cairo events demo"//c_null_char, &
       & delete_event = c_funloc(delete_h))
      
  my_drawing_area = hl_gtk_drawing_area_new(&
       & scroll=my_scroll_box, &
       & size = (/width, height /), &
       & ssize = (/ 400, 300 /), &
       & button_press_event=c_funloc(button_event_h), &
       & scroll_event=c_funloc(scroll_event_h), &
       & enter_event=c_funloc(cross_event_h), &
       & leave_event=c_funloc(cross_event_h), &
       & key_press_event=c_funloc(key_event_h), &
       & motion_event=c_funloc(motion_event_h), &
       & event_exclude=GDK_POINTER_MOTION_MASK, &
       & event_mask=GDK_BUTTON_MOTION_MASK)

  call gtk_container_add(my_window, my_scroll_box)
!  call gtk_widget_add_events(my_window, themask)

  call gtk_widget_show_all (my_window)
  call draw_pattern(my_drawing_area)

  ! The window stays opened after the computation:

  call gtk_main()
  print *, "All done"

end program cairo_basics_click