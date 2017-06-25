Name:           crt
Version:        0.4.0
Release:        1%{?dist}
Summary:        crt

Group:          Development/Tools
License:        GPL
#URL:            
Source0:        %{name}-%{version}.tar.gz

#BuildRequires:  
Requires: expect >= 5.4

%description


%prep
%setup -q

#%build

%install
install -d $RPM_BUILD_ROOT
cp -a * $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_bindir}
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/%{name}
mv $RPM_BUILD_ROOT/modules  $RPM_BUILD_ROOT%{_sysconfdir}/%{name}/modules
mv $RPM_BUILD_ROOT/conf $RPM_BUILD_ROOT%{_sysconfdir}/%{name}/conf
mv $RPM_BUILD_ROOT/LICENSE $RPM_BUILD_ROOT%{_sysconfdir}/%{name}/LICENSE
mv $RPM_BUILD_ROOT/README.md $RPM_BUILD_ROOT%{_sysconfdir}/%{name}/README.md
mv $RPM_BUILD_ROOT/crt.sh $RPM_BUILD_ROOT%{_bindir}/crt
rm -rf $RPM_BUILD_ROOT/package

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%{_sysconfdir}/%{name}/modules/
%{_sysconfdir}/%{name}/conf/
%{_sysconfdir}/%{name}/LICENSE
%{_sysconfdir}/%{name}/README.md
%doc
%{_bindir}/crt

%changelog
