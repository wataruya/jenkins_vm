
E_FILES=$(TOP)/xor_verify.e
HDL_FILES=$(TOP)/top_xor.vhd $(TOP)/xor_module.v
TOP_MODULES=top_xor
WAVEFORM="\"-input simvision.svcf\""
SNAPSHOT_PATH := ${BRUN_SESSION_DIR}

elab: $(HDL_FILES) $(E_FILES)
	irun -nclibdirpath ${SNAPSHOT_PATH} -elaborate -access +rwc $(HDL_FILES) $(E_FILES) -top $(TOP_MODULES)

run:
	irun -R -nclibdirpath ${SNAPSHOT_PATH}  -snprerun notest -input $(TOP)/in.tcl
clean:
	-rm -rf *.so dbFiles PDB QTDB tmp xc_work AxisWork waves.shm cov_work .simvision iprof_report_dir  WORK *~ INCA_libs\
		core* *.log *.elog *.esv *.key
