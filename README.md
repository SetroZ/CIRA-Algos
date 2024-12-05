## Running code

#### Linux instructions

- `git clone https://github.com/SetroZ/CIRA-Algos.git`
- `cd cpu/scripts`
- `chmod +x ./install.sh`
- `./install.sh`
- Verify that /usr/local is in $LD*LIBRARY_PATH" after running the script by typing*`echo $LD_LIBRARY_PATH"`
- `./run.sh <input dir> <output dir>`

## Folder Structure

- **doc**: contains explanation of how the algorithm works.

- **data**: contains test data

### cpu

- **scripts** _cd into repo directory first_

  - **build.sh** compiles main
  - **run.sh** builds + runs code `./run.sh <input dir> <output dir>`
  - **install.sh** Installs Cfitsio & CCfits and links Cfitsio

- **dug**

  - **dugcompile** compiles code on dug
  - **dugrun** runs code on dug
  - **dugsubmit** submits a job on dug

- **src**

  - **brute.cpp** bruteforce functions
  - **main.cpp** main program
  - **io.cpp** file writing

## gpu

TODO

## Dug cheatsheet

- squeue -u `<username>` _Shows job queue information for specific user_
- scontrol show job `JOBID` _Shows job information_
- scancel `JOBID` _Cancels job_
