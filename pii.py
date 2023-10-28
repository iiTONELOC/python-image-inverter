'''
Script:  Python Image Inverter
Author:  Anthony Tropeano
Date:    October 28, 2023
Version: 0.0.1
Purpose: The purpose of this script is to process a directory of images and invert the colors of each image.
'''

import os
import sys
from typing import Callable

try:
    from PIL import Image
except ImportError:
    print('\nThe Pillow library was not found, installing now...')
    print('Installing Pillow via pip...\n')
    os.system('pip install Pillow')
    from PIL import Image
    

def get_filename_or_directory_from_user():
    ''' Get the filename or directory from the user. '''
    filename_or_directory = input('\nEnter the filename or directory for the image(s) to invert: ')
    return filename_or_directory

def walk_directory_with_callback(directory:str, callback:Callable)->list:
    '''
        Walks the provided directory and processes each file with the provided callback function.
        
        args:
            directory: The directory to walk.
            callback: The callback function to call for each file. 
                Needs to accept a single argument, the file path.
    '''
    
    try:
        for root, dirs, filenames in os.walk(directory):
            for filename in filenames:
                file_path = os.path.join(root, filename)
                callback(file_path)
    except Exception as err:
        print(f'Error walking dir <{directory}>: {err}')

def invert_image_colors(image_path:str):
    ''' Inverts the colors of the provided image. '''
    try:
        image = Image.open(image_path)
        inverted_image = Image.eval(image, lambda p: 255 - p)
        inverted_image.save(image_path)
        print(f'  Inverted: {image_path}')
    except Exception as err:
        if 'cannot identify image file' not in str(err):
            print(f'\tError: {err}')
        

def process_file_or_directory(filename_or_directory:str):
    if os.path.isfile(filename_or_directory):
        invert_image_colors(filename_or_directory)
    elif os.path.isdir(filename_or_directory):
        walk_directory_with_callback(filename_or_directory, invert_image_colors)
    else:
        print(f'  Error: {filename_or_directory} is not a valid file or directory.')


def main():
    print('\nPython Image Inverter')
    print('---------------------')
    try:
        if len(sys.argv) > 1:
            
            process_file_or_directory(sys.argv[1])
        else:
            process_file_or_directory(get_filename_or_directory_from_user())
    except Exception as err:
        print(f'  Error: {err}')

''' MAIN ENTRY POINT '''

if __name__ == '__main__':
    main()
    print('\nDone!')
    sys.exit(0)