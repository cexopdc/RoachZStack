### Control Software ###
streamer.m is the control software. Run the matlab file and it will open a gui that controls the tool set. 

LED arena is controlled via serial port. 
1. Connect the USB cable from the arduino to the computer
2. Use the matlab script transmitLED.m to send a command to the arena
3. Commands are formatted as "x#" where x is either "f" or "b" and # is a digit written as a string. 
	The "f" or "b" set the direction, and the time sets the speed

EMG recording
Connect the CC2531 dongle to the computer. Make sure you can see it in device manager. In the streamer GUI, the left side is to control the ADC. Enter a time in the box, select the COM port that corresponds to the USB dongle and hit open. Inside the gui this calls the transmitADC.m file which sends a control character and the time to the CC2530. This should start streaming back data for the desired amount of time. 

Stimulation
The transmitStimulate.m function is called from the gui. Enter the parameters in the text boxes and hit stimulate. This function reads the parameters, and sends them and a control character to the CC2530. The stimulation is controlled via GPIO pins set. 

Here is a list of characters from 'A' to 'P'. These 16 characters control which combination of electrodes are desired. 

    case 'A':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;
      break;
    case 'B':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;
      break;
    case 'C':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;
      break;
     case 'D':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 0;
      break;
     case 'E':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 0;
      break;
    case 'F':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 0;
      break;
    case 'G':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 0;
      break;
     case 'H':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 0;
      break;
    case 'I':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 1;
      break;
    case 'J':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 1;
      break;
    case 'K':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 1;
      break;
     case 'L':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 0;
      POS_STIM4_SBIT = 1;
      break;
    case 'M':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 1;
      break;
    case 'N':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 0;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 1;
      break;
    case 'O':
      POS_STIM1_SBIT = 0;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 1;
      break;
     case 'P':
      POS_STIM1_SBIT = 1;
      POS_STIM2_SBIT = 1;
      POS_STIM3_SBIT = 1;
      POS_STIM4_SBIT = 1;
      break;