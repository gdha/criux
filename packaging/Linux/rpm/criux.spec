%define rpmrelease %{nil}
%define debug_package %{nil}
%define optdir /opt
%define etcopt /etc/opt
%define varopt /var/opt
%define mandir /usr/share/man

### Work-around the fact that OpenSUSE/SLES _always_ defined both :-/
%if 0%{?sles_version} == 0
%undefine sles_version
%endif

Name:		criux
Version:	1.0 
Release:	1%{?rpmrelease}%{?dist}
Summary:	Open Source framework to investigate cluster nodes

Group:		Applications/File
License:	GPLv3
URL:		http://www.it3.be/projects/criux.html
Source:		%{name}-%{version}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
ExclusiveArch:	%ix86 x86_64

#BuildRequires:	
Requires:	ksh

%description
Criux is an open source framework developed to investigate cluster nodes

%prep
%setup -q -n %{name}-%{version}


%build


%install
%{__rm} -rf %{buildroot}
%{__make} -C packaging/Linux install DESTDIR="%{buildroot}"
%{__mkdir} -m 755 -p %{buildroot}/%{mandir}/man8
%{__cp} %{buildroot}/%{optdir}/%{name}/man/man8/%{name}.8  %{buildroot}/%{mandir}/man8/%{name}.8
gzip  %{buildroot}/%{mandir}/man8/%{name}.8

%clean
%{__rm} -rf %{buildroot}


%files
%defattr(-, root, root, 0755)
%doc  LICENSE README.md
%doc %{mandir}/man8/%{name}.8*
%doc %{optdir}/%{name}/man/man8/%{name}.8*
%{optdir}/%{name}/bin/
%{optdir}/%{name}/lib/
%{optdir}/%{name}/scripts/
%{varopt}/%{name}/
%config(noreplace) %{etcopt}/%{name}/

%changelog
* Wed Nov  05 2015 Gratien D'haese <gratien.dhaese@gmail.com> - 1.0
  initial spec file for criux
