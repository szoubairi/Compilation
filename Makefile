TST+=
all:	
	make -C src/

compile:
	TEST="${TST}" make -C src/ compile 
clean:
	make -C src/ clean