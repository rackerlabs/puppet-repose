PACKAGE := $(shell basename *.spec .spec)
ARCH = noarch
RPMBUILD = rpmbuild --define "_topdir %(pwd)/build" \
	--define "_sourcedir  %{_topdir}/sdist" \
	--define "_builddir %{_topdir}/rpm-build" \
	--define "_srcrpmdir %{_rpmdir}" \
	--define "_rpmdir %{_topdir}/rpms"
INSTALLDIR=/etc/puppet/modules/${PACKAGE}

all: rpms

clean:
	rm -rf build/ *~

install: 
	mkdir -p ${INSTALLDIR}
	cp -pr . ${INSTALLDIR}

install_rpms: rpms 
	rpm -Uvh build/rpms/noarch/${PACKAGE}*.noarch.rpm

reinstall: uninstall install

uninstall: clean
	rm -f ${INSTALLDIR}

uninstall_rpms: clean
	rpm -e ${PACKAGE}

sdist:
	mkdir -p build/sdist/
	tar -czf sdist/${PACKAGE}.tgz \
		--exclude ".git" --exclude "*.log" \
		--exclude "Makefile" --exclude "README*" \
		--exclude "*.spec" --exclude "build" \
		./

prep_rpmbuild: sdist
	mkdir -p build/rpm-build
	mkdir -p build/rpms
	cp ${PACKAGE}.tgz build/rpm-build/

rpms: prep_rpmbuild
	${RPMBUILD} -ba ${PACKAGE}.spec

srpm: prep_rpmbuild
	${RPMBUILD} -bs ${PACKAGE}.spec
