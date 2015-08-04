#!/bin/csh

setenv TOP $PWD
setenv CDS_LIC_QUEUE_POLL
setenv CDS_LIC_QUEUE_POLL_INT 40
setenv CDS_LIC_QA_TesT ./license.log 
setenv FLEXLM_DIAGNOSTICS 3
setenv CADENCE_VIP_LIC_DEBUG 1
setenv DENALI_LICENSE_DEBUG 1

vm_launch.pl -batch -enterprise -vsif test.vsif
