# Balanced Model Truncation Test Code

This Matlab code is used to observe some of the effects of balanced model truncation on HRIR filters.  It was originally built to use the MIT KEMAR HRTF database.  The code generates bode plots of the original and reduced models and also calculates the log spectral distance and interaural level, time, and cross-correlation differences between the two models.  This code is meant to accompany my paper, [An Investigation into Balanced Model Truncation for HRIR Filters](https://sway.office.com/RtO3gWf1BtcgHZs7?ref=Link).

## Getting Started

Open and run the BMT_test code in Matlab, bode plots should appear and the command window will display the calculation results.

### Prerequisites

Make sure all files in this repository are located in the chosen Matlab directory.  Place any additional MIT KEMAR HRTF's you would like to use in the same directory as well.

## Running the tests

Change the value of pos in line 2 if you would like to experiment with a different HRIR out of the MIT KEMAR database, just make sure that audio file is part of the Matlab directory.  Use line 17 to choose whether or not the HRTF's are minimum-phase by using true for minimum-phase and false for non-minimum phase.  The reduced model order can be changed in line 29 to experiment with different reduction ratios.

## Built With

* Matlab
* [Robust Control Toolbox](https://uk.mathworks.com/products/robust.html) - imp2ss function
* [Minimum-Phase Processing Code](http://signal.ece.utexas.edu/software/minphase/mccaslin/) - Function to convert filter impulse to minimum phase
  
  McCaslin, S. (1998) Minimum Phase Processing Code (Version 1.0) [Matlab Code] Available at:
  http://signal.ece.utexas.edu/software/minphase/mccaslin/ (Accessed: 26 February 2019).
* [Log Spectral Distance Calculator](https://uk.mathworks.com/matlabcentral/fileexchange/9998-log-spectral-distance) - Calculates log spectral distance between two signals in frequency domain
  
  Zavarehei, E. (2006) Log Spectral Distance Code (Version 1.0) [Matlab Code] Available at:                              https://uk.mathworks.com/matlabcentral/fileexchange/9998-log-spectral-distance (Accessed: 26 February
  2019).
* [Onset Interaural Time Difference Calculator](https://www2.ak.tu-berlin.de/~akgroup/ak_pub/abschlussarbeiten/2011/EstrellaJorgos_StudA.pdf) - Calculates ITD using onset threshold method
  
  Estrella, J. (2010) On the Extraction of Interaural Time Differences from Binaural Room Impulse
  Responses, Available at: https://www2.ak.tu-berlin.de/~akgroup/ak_pub/abschlussarbeiten/2011/
  EstrellaJorgos_StudA.pdf (Accessed: 26 February 2019).

* [MIT Laboratories' KEMAR HRTF Database](http://sound.media.mit.edu/resources/KEMAR.html) - HRTF database

  MIT Media Laboratory (2000) 'HRTF Measurements of a KEMAR Dummy-Head Microphone'
  Available at: http://sound.media.mit.edu/resources/KEMAR.html (Accessed 26 February 2019).
  
## Versioning

Version 1.0

### Current Concerns/Issues

* It would be ideal to load all angles of a single elevation to view the differences in full HRTF responses between original and reduced models.

* A function should be designed that compiles the data for each angle into one graphical representation for simple analysis of model reduction's effects on different HRIR angles.

## Authors

* **Dan Roth** - *Initial work* 

## Acknowledgments

* Thanks to Dr. Bruce Wiggins at University of Derby for his help and support with this project and his code for reading the MIT KEMAR HRTF's.

