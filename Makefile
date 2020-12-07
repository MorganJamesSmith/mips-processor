# Copyright (C) 2020 by Morgan Smith

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

TARGET=mips

SRC = $(wildcard *.v)

FILES = Makefile binary-instructions.txt readme.org

${TARGET}_tb.vcd:

%.vcd:%.vvp
	vvp $<

%.vvp:%.v ${SRC}
	iverilog -o $@ $^

# This is for submitting my work to my professor
${TARGET}.zip: ${SRC} ${FILES}
	cd ..; \
	zip --verbose ${current_dir}/$@ $(addprefix ${current_dir}/,$^)

clean:
	rm -f *.vcd *.vvp *.zip

.PHONEY: clean
