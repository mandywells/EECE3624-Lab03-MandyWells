/**************************************************************************
 *     File: Lab03.asm
 * Lab Name: Lab 03 - Decisions, Decisions, Decisions 
 *						reading data and making choices
 *   Author: Mandy Wells
 *  Created: 09/8/2026
 *
 * This program is written for Lab03
 *************************************************************************/

/************************************************************************
 * NOTE!  To populate the sensor data to memory, follow these steps!
 * 1) Set breakpoint on 1st instruction RJMP
 * 2) Set the stimulus file
 *    - Debug->Set Stimufile.  Select Lab03.stim
 *    - This only needs to be done ONCE (will save in project file)
 *    - Should be in your Project file from the Repo, but do once to be sure.
 * 3) Execute stimulus file
 *    - Debug->Execute Stimufile
 *    - This needs to be run EVERY TIME you restart a debug session.  :-(
 * 4) single step code
 * 5) Check that data IRAM at 0x0100 has changed "61 97"
 * 
 * Sensor1 Located at 0x0100 (preset to 0x61)
 * Sensor2 Located at 0x0101 (preset to 0x97)
 * 
 * NOTE:  For testing, you can modify these after loading them
 * to make sure all of your branches work properly
 ***********************************************************************/
.equ THRESHOLD	= 0x90
.def Sensor1	= R20
.def Sensor2	= R21

.org 0x0000 ; next instruction will be written to address 0x0000
            ; (the location of the reset vector)
RJMP main	; set reset vector to point to the main code entry point

main:       ; jump here on reset

	; initialize the stack (RAMEND = 0x10FF by default for the ATmega128A)
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, low(RAMEND)
	OUT SPL, R16

    ;----------------------------------
    ; student-written code begins here    
start:
	LDI YH, high(0x0100)
	LDI YL, low(0x0100)

	LD Sensor1, Y+		;R20
	LD Sensor2, Y		;R21

	;Sensor1 comparison (unsigned)
	CPI Sensor1, THRESHOLD
	BRSH sensor1_high	;jump to here if sensor1 is greater than or equal to threshold
	;else
	LDI R22, 0x50		;sensor1 is less than threshold
	RJMP store_s1_in2
sensor1_high:
	LDI R22, 0x46		;sensor1 is greater than or equal to threshold

store_s1_in2:
	LDI YH, high(0x0110)
	LDI YL, low(0x0110)
	;store first result in first results location
	ST Y+, R22
	;store sensor1 in second results location
	ST Y+, Sensor1


	;Sensor2 comparison (signed)
	CPI Sensor2, THRESHOLD
	BRLT sensor2_low	;jump to here if sensor2 is less than threshold
	;else
	LDI R22, 's'		;sensor2 is greater than or equal to threshold
	RJMP s1_s2_compare
sensor2_low:
	LDI R22, 'i'		;sensor2 is less than threshold

s1_s2_compare:
	;store third result in third results location
	ST Y+, R22

	;comparison between sensor1 and sensor2 (unsigned)
	CP Sensor1, Sensor2
	BRNE notequal		;jump to here if sensor1 is not equal to sensor2

	LDI R22, 108		;sensor1 is equal to sensor2
	RJMP end
notequal:
	LDI R22, 115		;sensor1 is not equal to sensor2

end:
	;store fourth result in fourth results location
	ST Y, R22

	NOP