Name:           xproto
Version:        7.0.27
Release:        0
License:        MIT
Summary:        X
Url:            http://www.x.org
Group:          Development/System
Source0:        %{name}-%{version}.tar.bz2
Source1001: 	xproto.manifest
BuildRequires:  pkgconfig
BuildRequires:  pkgconfig(xorg-macros)
%if "%{?profile}" == "common"
%else
BuildRequires:  python
BuildRequires:  e-tizen-data
%endif

%description
%{summary}

%prep
%setup -q
cp %{SOURCE1001} .
%if "%{?profile}" == "common"
%else
chmod a+x ./make_tizen_keymap.sh
./make_tizen_keymap.sh
%endif

%build
%autogen --disable-static \
             --libdir=%{_datadir} \
             --without-xmlto

make %{?_smp_mflags}

%install
%make_install

%remove_docs

%files
%manifest %{name}.manifest
%license COPYING
%defattr(-,root,root,-)
%{_includedir}/X11/*.h
%{_datadir}/pkgconfig/*.pc
