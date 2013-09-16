PACKAGE := $(shell basename *.spec .spec)
ARCH = noarch
RPMBUILD = rpmbuild --define "_topdir %(pwd)/build" \
	--define "_sourcedir  %{_topdir}/sdist" \
	--define "_builddir %{_topdir}/rpm-build" \
	--define "_srcrpmdir %{_rpmdir}" \
	--define "_rpmdir %{_topdir}/rpms"
INSTALLDIR=/etc/puppet/modules/${PACKAGE}
BUILDDIR=build
DISTDIR=${BUILDDIR}/sdist
RPMBUILDDIR=${BUILDDIR}/rpm-build
RPMDIR=${BUILDDIR}/rpms

all: rpms

clean:
	rm -rf ${BUILDDIR}/ *~

install: 
	mkdir -p ${INSTALLDIR}
	cp -pr . ${INSTALLDIR}

install_rpms: rpms 
	rpm -Uvh ${RPMDIR}/${ARCH}/${PACKAGE}*.${ARCH}.rpm

reinstall: uninstall install

uninstall: clean
	rm -f ${INSTALLDIR}

uninstall_rpms: clean
	rpm -e ${PACKAGE}

sdist:
	mkdir -p ${DISTDIR}
	tar -czf ${DISTDIR}/${PACKAGE}.tgz \
		--exclude ".git" --exclude "*.log" \
		--exclude "Makefile" --exclude "README*" \
		--exclude "*.spec" --exclude "build" \
		./

prep_rpmbuild: sdist
	mkdir -p ${RPMBUILDDIR}
	mkdir -p ${RPMDIR}
	cp ${DISTDIR}/${PACKAGE}.tgz ${RPMBUILDDIR}/

rpms: prep_rpmbuild
	${RPMBUILD} -ba ${PACKAGE}.spec

srpm: prep_rpmbuild
	${RPMBUILD} -bs ${PACKAGE}.spec
