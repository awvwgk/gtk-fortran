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
! Contributed by Vincent Magnin, Jerry DeLisle, "jtappin" and Tobias Burnus, 2011-01-23
! Last modification: 2020-02-12

module gtk
  use, intrinsic :: iso_c_binding
  implicit none
  include "gtkenums-auto.f90"

  interface
    subroutine gtk_init_real(argc,argv) bind(c,name='gtk_init')
      use, intrinsic :: iso_c_binding, only: c_int, c_ptr
      integer(c_int) :: argc
      type(c_ptr)    :: argv
    end subroutine 

    !**************************************************************************
    ! The interfaces automatically generated by cfwrapper.py are included here.
    ! Do not modify.
    include "gtk-auto.f90"
    !**************************************************************************
  end interface 

  ! In GLib, a gboolean is int:
  integer(c_int), parameter   :: FALSE = 0
  integer(c_int), parameter   :: TRUE = 1

contains
  subroutine g_signal_connect (instance, detailed_signal, c_handler, data0)
    use, intrinsic :: iso_c_binding, only: c_ptr, c_char, c_funptr
    use g, only: g_signal_connect_data
    character(kind=c_char):: detailed_signal(*)
    type(c_ptr)      :: instance
    type(c_funptr)   :: c_handler
    type(c_ptr), optional :: data0
    integer(c_long) :: handler_id

    if (present(data0)) then
      handler_id =  g_signal_connect_data (instance, detailed_signal, &
           & c_handler, data0, c_null_funptr, 0_c_int)
    else
      handler_id =  g_signal_connect_data (instance, detailed_signal, &
           & c_handler, c_null_ptr, c_null_funptr, 0_c_int)
    end if
  end subroutine


  subroutine gtk_init()
    use, intrinsic :: iso_c_binding, only: c_ptr, c_char, c_int, c_null_char, c_loc
    character(len=256,kind=c_char) :: arg
    character(len=1,kind=c_char), dimension(:),pointer :: carg
    type(c_ptr), allocatable, target :: argv(:)
    integer(c_int) :: argc, j
    integer :: strlen, i

    argc = command_argument_count()
    allocate(argv(0:argc))

    do i = 0, argc
      call get_command_argument (i,arg,strlen)
      allocate(carg(0:strlen))
      do j = 0, strlen-1
        carg(j) = arg(j+1:j+1)
      end do
      carg(strlen) = c_null_char
      argv(i) = c_loc (carg(0))
    end do

    argc = argc + 1

    ! This is a workaround to prevent locales with decimal comma
    ! from behaving wrongly reading reals after gtk_init is called
    ! when the code is compiled using gfortran.
    call gtk_disable_setlocale()

    call gtk_init_real (argc, c_loc(argv))

    ! carg being local can be deallocated:
    deallocate(carg)
  end subroutine gtk_init
  
end module gtk
