# This file needs to be updated and renamed whenever you copy this template to a new module
# The only things that should need updating initially are:
#     %define base_name
#     Summary
#     %description
#     %changelog
#     remove this top comment (this line and up)
%define base_name repose

Name:      cit-puppet-module-%{base_name}
Version:   0.1
Release:   1
BuildArch: noarch
Summary:   Puppet module to configure %{base_name}
License:   GPLv3+
URL:       http://github.rackspace.com/cloud-integration-ops/%{base_name}
Source0:   %{base_name}.tgz

%description

%define module_dir /etc/puppet/modules/%{base_name}

%prep
%setup -q -c -n %{base_name}

%build
mkdir -p %{buildroot}%{module_dir}

%install
cp -pr * %{buildroot}%{module_dir}/

%files
%defattr (0644,root,root)
%{module_dir}
%config %{module_dir}/manifests/config.pp

%changelog
* Thu Sep 27 2012 Ra Cker <ra.cker@rackspace.com> - 0.1-1
- Initial version of the package
