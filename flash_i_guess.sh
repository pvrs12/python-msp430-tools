#!/bin/bash
. venv/bin/activate

# Once the keyboard is in BSL mode we need to flash a programmer
python -m msp430.bsl5.hid -e -r --bsl-flash -vvvvvv --debug 
if [ $? -ne 0 ]; then
	echo "Programming BSL failed or already programmed"
else

	# once the programmer is flashed it takes an indeterminate amount of time
  # since we don't know how long (or really what happens at all) we just retry in a loop
	RESP=1
	while [ $RESP -ne 0 ]; do
		data=$(python -m msp430.bsl5.hid -e -r -vvvvvv --debug working_base.elf 2>&1; RESP=$?)
		echo $data | grep "not in BSL mode" > /dev/null
		if [ $? -eq 0 ]; then
			echo "Device is no longer in BSL mode. It probably worked"
			break
		fi
	done
fi

echo "Press Enter to exit..."
read a

deactivate
