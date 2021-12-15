.PHONY:	src clean build backup

clean:
	rm -rf work *.log *.jou *.str *.txt

build:
	vivado -nojournal -nolog -mode batch -source make.tcl &

backup:
	mv -rf work ./work_bak
