Name:           xproto
Version:        7.0.25
Release:        0
License:        MIT
Summary:        X
Url:            http://www.x.org
Group:          Development/System
Source0:        %{name}-%{version}.tar.bz2
Source1001: 	xproto.manifest
BuildRequires:  pkgconfig
BuildRequires:  pkgconfig(xorg-macros)

%description
%{summary}

%prep
%setup -q
cp %{SOURCE1001} .

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

