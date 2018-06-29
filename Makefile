# Copyright 2017 Intel Corporation.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

PATH_TO_MK = mk
SUBDIRS = nff-go-base dpdk test examples utilities
DOC_TARGETS = flow packet
CI_TESTING_TARGETS = packet low common
TESTING_TARGETS = $(CI_TESTING_TARGETS) test/stability

all: $(SUBDIRS)

dpdk: nff-go-base

test: dpdk

examples: dpdk

perf_testing:
	$(MAKE) -C test perf_testing

.PHONY: testing $(TESTING_TARGETS)
.NOTPARALLEL: testing $(TESTING_TARGETS)
testing: $(TESTING_TARGETS)

.PHONY: citesting $(CI_TESTING_TARGETS)
.NOTPARALLEL: citesting $(CI_TESTING_TARGETS)
citesting: $(CI_TESTING_TARGETS)

$(TESTING_TARGETS):
	$(MAKE) -C $@ testing

.PHONY: doc
doc: $(DOC_TARGETS)
	mkdir doc
	$(foreach package,$(DOC_TARGETS),godoc -analysis=type -analysis=pointer -html github.com/intel-go/nff-go/$(package) > doc/$(package).html;)

include $(PATH_TO_MK)/intermediate.mk
