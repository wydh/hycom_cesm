      module mod_xc
      use mod_dimensions  !include 'dimensions.h'
      implicit none
c
c --- HYCOM communication interface.
c --- see README.src.mod_xc for more details.
c
      include 'unit_offset.h'
c
c --- tile dimensions and tile numbers (counting from 1), see xcspmd
      integer, public, save      :: ipr,  jpr,  ijpr,
     &                              mproc,nproc,mnproc,
     &                              mp_1st
#if defined(MPI)
c
c --- needed for some versions of mod_za
      integer, public, save      :: group_1st_in_row
#endif
c
c --- region type (-1==unknown,
c ---               0==  closed/closed,
c ---               1==periodic/closed,
c ---               2==periodic/arctic,
c ---               3==periodic/fplane
c ---               4==  closed/fplane)
      integer, public, save      :: nreg
c
c --- timers on, usually and default .true.
      logical, public, save      :: timer_on=.true.
c
c --- fill value for land, usually 0.0
      real,    public, save      :: vland
      real*4,  public, save      :: vland4  !xcget4 only
c
c --- xctilr halo options
      integer, public, parameter :: halo_ps=1, halo_pv=11,
     &                              halo_qs=2, halo_qv=12,
     &                              halo_us=3, halo_uv=13,
     &                              halo_vs=4, halo_vv=14
c
c --- xcsync stdout flushing options
      logical, public, parameter :: flush_lp=.true.,
     &                              no_flush=.false.
c
c --- generic subroutine names
      interface xcmaxr
         module procedure xcmaxr_0  ! rank 0 array (i.e. scalar)
         module procedure xcmaxr_1  ! rank 1 array
         module procedure xcmaxr_0o ! rank 0 array, old interface
         module procedure xcmaxr_1o ! rank 1 array, old interface
      end interface

      interface xcminr
         module procedure xcminr_0  ! rank 0 array (i.e. scalar)
         module procedure xcminr_1  ! rank 1 array
         module procedure xcminr_0o ! rank 0 array, old interface
         module procedure xcminr_1o ! rank 1 array, old interface
      end interface
#if defined(USE_ESMF)
c
c --- public data structures for ESMF, see xcspmd
      integer, public,  save :: countde1(iqr),
     &                          countde2(jqr)
#endif
c
c --- private timer variables, see xctmri
      character*6, private, dimension(97), save :: cc
      integer,     private,                save :: nxc
      integer,     private, dimension(97), save :: nc
      real*8,      private, dimension(97), save :: tc,t0
      real*8,      private, dimension(2),  save :: tcxc,tcxl
#if defined(MPI) || defined(SHMEM)
c
c --- private message passing data structures, see xcspmd
      integer, private, save :: idproc( 0: iqr+1,0:jqr+1),
     &                          idproc1(0:ijqr+1),idhalo(2),
     &                          i0_pe(iqr,jqr),ii_pe(iqr,jqr),
     &                          j0_pe(iqr,jqr),jj_pe(iqr,jqr),
     &                          mpe_1(     jqr),
     &                          mpe_e(     jqr),
     &                          mpe_i(itdm,jqr),npe_j(jtdm)
      integer, private, save :: i1sum(iqr,jqr),iisum(iqr,jqr)
      integer, private, save :: m0_top,i0_st(iqr),ii_st(iqr),
     &                          mm_top,i0_gt(iqr),ii_gt(iqr),
     &                          m0_bot,i0_sb(iqr),ii_sb(iqr),
     &                          mm_bot,i0_gb(iqr),ii_gb(iqr)
      integer, private, save :: null_tile
#endif
#if defined(MPI)
      integer, private, save :: mpi_comm_hycom
#endif
#if defined(NUOPC)
c
c --- NUOPC glue code structures

c==>  import from atm
      real nstep1_cpl,nstep2_cpl
      logical cpl_taux, cpl_tauy, cpl_wndspd, cpl_ustara,
     & cpl_airtmp, cpl_vapmix, cpl_swdnflx, cpl_swflx, cpl_lwflx,
     & cpl_precip, cpl_surtmp, cpl_seatmp

      real cpl_w2, cpl_w3
      logical cpl_implicit
      logical t0flag

      real, target, dimension (1-nbdy:idm+nbdy,1-nbdy:jdm+nbdy,2) ::
     & imp_taux, imp_tauy, imp_wndspd, imp_ustara,
     & imp_airtmp, imp_vapmix, imp_swdnflx, imp_swflx, imp_lwflx,
     & imp_precip, imp_surtmp, imp_seatmp

c==>  import from ice
      logical cpl_sic, cpl_sitx, cpl_sity, cpl_siqs, cpl_sifh,
     &        cpl_sifs, cpl_sifw, cpl_sit, cpl_sih, cpl_siu,
     &        cpl_siv

c
      real, target, dimension (1-nbdy:idm+nbdy,1-nbdy:jdm+nbdy) ::
     &       sic_import !Sea Ice Concentration
     &,     sitx_import !Sea Ice X-Stress
     &,     sity_import !Sea Ice Y-Stress
     &,     siqs_import !Solar Heat Flux thru Ice to Ocean
     &,     sifh_import !Ice Freezing/Melting Heat Flux
     &,     sifs_import !Ice Freezing/Melting Salt Flux
     &,     sifw_import !Ice Net Water Flux
     &,      sit_import !Sea Ice Temperature
     &,      sih_import !Sea Ice Thickness
     &,      siu_import !Sea Ice X-Velocity
     &,      siv_import !Sea Ice Y-Velocity
     
#endif
c
c --- actual module subroutines
      contains
#if defined(MPI) || defined(SHMEM)
# include "mod_xc_mp.h"
#else
# include "mod_xc_sm.h"
#endif
      end module mod_xc
