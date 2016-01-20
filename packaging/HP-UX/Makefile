product = criux
name = $(product)
main_script = ../../opt/$(name)/bin/$(name)
psf_file = ./$(product).psf
depot_dir = /tmp/$(product).depot.dir
log_dir = ../../var/opt/criux/log

all: help

help:
	@echo "+-------------------------+"
	@echo "    criux Makefile    "
	@echo "    =================    "
	@echo "    build: \"make depot\"  "
	@echo "    clean: \"make clean\"  "
	@echo "+-------------------------+"

.PHONY: clean

clean:
	@if [ `whoami` != "root" ]; then echo "Only root may remove packages"; exit 1; fi; \
	rm -rf $(depot_dir) ;  find $(log_dir) -type f -name '*.log' -exec rm {} \; ; \
	rm -f /tmp/$(name)-*.tar.gz ; \
	echo "Depot directory [$(depot_dir)] successfully removed"

man: ../../opt/criux/man/criux.8
	@if [ -f ../../opt/criux/man/criux.8 ]; then cp -p ../../opt/criux/man/criux.8 ../../opt/criux/man/criux.8.txt; \
	compress ../../opt/criux/man/criux.8 ; mv -f ../../opt/criux/man/criux.8.Z ../../opt/criux/man/criux.8 ; fi

validate:
	@echo "== Validating the scripts =="
	find ../../etc/opt/$(name) -name '*.conf' | xargs -n 1 ksh -n ; \
	ksh -n $(main_script) ; \
	find ../../opt/$(name)/lib -name "*.sh" | xargs -n 1 ksh -n ; \
	find ../../opt/$(name)/scripts -name "*.sh" | xargs -n 1 ksh -n ; \
	echo "Scripts were successfully validated."

rewrite: $(psf_file)
	@echo "== Update the $(psf_file) file =="
	ver=`/usr/bin/grep ^VERSION= ../../opt/criux/bin/criux | cut -d= -f2` ; \
	cp -p $(psf_file) $(psf_file).save ; \
	sed -e 's#number.*#number A.0'$$ver'#' -e 's#revision.*#revision A.0'$$ver'#g' < $(psf_file).save >$(psf_file); 
	
depot: clean  man rewrite
	@/usr/sbin/swpackage -vv -s $(psf_file) -x layout_version=1.0 -d $(depot_dir) ; \
	rel=`/usr/bin/grep 'number' $(psf_file) | awk '{print $$2}'` ; \
	ymd=`date +%Y%m%d` ; \
	depot_file="/tmp/$(product)_"$$rel"_"$$ymd".depot" ; \
	/opt/ignite/bin/make_bundles -b -i -n "CRIUX" -t "criux for HP-UX" \
	-o /tmp/criux_bundle.psf -r $$rel $(depot_dir) ; \
	/usr/sbin/swpackage -s /tmp/criux_bundle.psf -xlayout_version=1.0 -xreinstall_files=true -d  $(depot_dir) ; \
	/usr/sbin/swpackage -vv -d $$depot_file  -x target_type=tape -s $(depot_dir) \* ; \
	echo "File depot location is $$depot_file" ; \
	rm -f /tmp/criux_bundle.psf ; \
	mv -f ../../opt/criux/man/criux.8.txt ../../opt/criux/man/criux.8 ; \
	mv -f $(psf_file).save $(psf_file) ; \
	echo "Done."

dist:	clean validate
	@echo "== Building tar archive for $(product) =="
	ver=`/usr/bin/grep ^VERSION= ../../opt/criux/bin/criux | cut -d= -f2` ; \
	tarf="/tmp/$(name)-"$$ver".tar" ; \
	cd ../.. ; \
	tar -cf $$tarf . ; \
	gzip $$tarf ; \
	echo "Wrote $$tarf.gz"

