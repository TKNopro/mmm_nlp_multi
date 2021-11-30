.PHONY:	src clean build

clean:
	rm -rf work *.log *.jou *.str

build:
	vivado -nojournal -nolog -mode batch -source make.tcl
