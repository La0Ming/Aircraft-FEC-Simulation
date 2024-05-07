# BER vs SNR Simulations with Forward Error Correction
This repository contains **MATLAB** scripts for simulating **Forward Error Correction (FEC)** codes. The scripts were intended to provide results to be analysed for a Master's Thesis on the performance of **FEC codes** in aircrafts.

## FEC codes
The following FEC codes are supported:
- RS(7,1)
- RS(7,3)
- RS(7,5)
- RS(15,3)
- RS(15,5)
- RS(15,7)
- RS(15,11)
- Binary BCH(7,4)
- Binary BCH(15,5)
- Binary BCH(15,7)
- Binary BCH(15,11)

## Modulation techniques
Currently, only PSK is supported.

## File structure
Each folder is for a certain channel model with a certain block length. For example, if you want to simulate codes with block length 15 in AWGN, simply navigate to awgn_psk_n15 and you'll find simulation scripts for each FEC code. There are also scripts for plotting in each folder, where workspaces need to be saved in .mat file in order for them to work. Edit the plot scripts in accordance to the names of the .mat files if you want to use these scripts.

## Dependencies
To run the scripts, MATLAB needs to be installed with Add-Ons. The scripts were made using MATLAB 2023b for academic use. Communications Toolbox 23.2, DSP System Toolbox 23.2 and Signal Processing Toolbox was used as Add-Ons.
