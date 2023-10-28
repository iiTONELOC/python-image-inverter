# Python Image Inverter

## Description

PythonImageInverter is a simple CLI utility to invert color in images using Python and Pillow.

As a student, I prefer dark-mode and find myself manually inverting images for my notes so I am not blinded. Works for a single image or will convert any images found from a provided directory.

## Installation

1.  Open up a terminal and navigate to a directory where you want to save the project then using the following command to copy the repository:

    ```bash
    git clone https://github.com/iiTONELOC/python-image-inverter.git
    ```

2.  Next, run the installation script, this will create a virtual environment for the Pillow dependency, this prevents a global install on your machine.

    ```bash
    sh install.sh
    ```

3.  This next step is optional but a preferred method for better usability. After running the install script an alias or path environment variable to invoke the program by name. This can be whatever you want. I used pii on my system.

    On Linux or MacOS, simple add an alias to your shell configuration file.

    You can use the following command to add the alias to your configuration file, ensure you change the `<path/to/python-image-inverter>` with the correct absolute folder/dir path to the program:

    ```bash
    cd ~ && echo pii="<path/to/python-image-inverter>/start.sh" >> .bashrc
    ```

    If you are using zsh:
c
    ```bash
    cd ~ && echo pii="<path/to/python-image-inverter>/start.sh" >> .zshrc
    ```

    Installation instructions for windows will be added soon.

## Usage

The program will accept a filename or a directory name as an argument when calling. If an argument is not provided, the user will be prompted to provide a file or directory for processing.

If you elected to create an alias, the usage is:

```bash
<alias name> <optional file or directory>
```

If you did not elect to use an alias, you can invoke the program using the start.sh shell script or from the python binary installed in the virtual environment. If you invoke using the python command directly (i.e. python pii.py), it will install the pip dependencies globally.

### Alias

```bash
pii ~/Downloads

Python Image Inverter
---------------------
  Inverted: 03fig06.jpg
  Inverted: 03fig07.jpg
  Inverted: 03fig10.jpg
  Inverted: 03fig08.jpg

Processed 4 files in 0.05 seconds.
```

### As Shell Script

```bash
sh /Volumes/external/code/python\ projects/pii/start.sh ~/Downloads

Python Image Inverter
---------------------
  Inverted: 03fig06.jpg
  Inverted: 03fig07.jpg
  Inverted: 03fig10.jpg
  Inverted: 03fig08.jpg

Processed 4 files in 0.01 seconds.
```

### Manually from the virtual environment

```bash
/Volumes/external/code/python\ projects/pii/venv/bin/python /Volumes/external/code/python\ projects/pii/pii.py ~/Downloads

Python Image Inverter
---------------------
  Inverted: 03fig06.jpg
  Inverted: 03fig07.jpg
  Inverted: 03fig10.jpg
  Inverted: 03fig08.jpg

Processed 4 files in 0.01 seconds.
```

## LICENSE

This project is free to use and is licensed with an MIT license, [which you can find here](./LICENSE).
