"""
Script:  Python Image Inverter
Author:  Anthony Tropeano
Date:    September 30, 2024
Version: 1.0.0
Purpose: The purpose of this script is to process a directory of images and invert the colors of each image.
"""

import os
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed


num_files_processed = 0
num_file_errors = 0
time_start = 0
time_end = 0

try:
    from PIL import Image
except ImportError:
    print("\nThe Pillow library was not found, installing now...")
    print("Installing Pillow via pip...\n")
    os.system("pip install Pillow")
    from PIL import Image


def get_filename_or_directory_from_user():
    """Get the filename or directory from the user."""
    filename_or_directory = input(
        "\nEnter the filename or directory for the image(s) to invert: "
    )
    return filename_or_directory


def invert_image_colors(image_path: str):
    """Inverts the colors of the provided image."""
    try:
        # Ensure the file exists
        if not os.path.isfile(image_path):
            print(f"  Error: {image_path} is not a valid file.")
            return

        # Check the file extension before processing
        file_extension = os.path.splitext(image_path)[1]
        if file_extension.lower() not in [".jpg", ".jpeg", ".png", ".gif"]:
            return

        # File exists and is an image, process it
        image = Image.open(image_path)
        image = image.convert("RGB")  # Force the image to RGB format
        inverted_image = Image.eval(image, lambda x: 255 - x)  # Invert colors
        inverted_image.save(image_path)  # Save the inverted image
        global num_files_processed
        num_files_processed += 1
        print(f"  Inverted: {os.path.basename(image_path)}")
    except Exception as err:
        if "cannot identify image file" not in str(err):
            print(f"\tError: {err}")
        else:
            global num_file_errors
            num_file_errors += 1


def process_file_or_directory(filename_or_directory: str):
    global time_start
    time_start = time.time()

    # Expand the user's home directory if it's in the path
    if "~" in filename_or_directory:
        filename_or_directory = os.path.expanduser(filename_or_directory)

    # Handle relative paths
    if filename_or_directory.startswith("../"):
        filename_or_directory = os.path.abspath(filename_or_directory)

    if os.path.isfile(filename_or_directory):
        invert_image_colors(filename_or_directory)
    elif os.path.isdir(filename_or_directory):
        process_directory(filename_or_directory)
    else:
        print(f"  Error: {filename_or_directory} is not a valid file or directory.")


def process_directory(directory: str):
    """Process all images in the specified directory using a thread pool."""
    cpu_cores = os.cpu_count() or 1
    max_workers = cpu_cores * 5 % 32

    image_files = []
    try:
        for root, dirs, filenames in os.walk(directory):
            for filename in filenames:
                file_path = os.path.join(root, filename)
                if file_path.lower().endswith((".jpg", ".jpeg", ".png", ".gif")):
                    image_files.append(file_path)

        # Process images in parallel using threading
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            future_to_file = {
                executor.submit(invert_image_colors, file): file for file in image_files
            }
            for future in as_completed(future_to_file):
                file_path = future_to_file[future]
                try:
                    future.result()  # This will raise an exception if the file processing failed

                except Exception as exc:
                    print(f"{file_path} generated an exception: {exc}")

    except Exception as err:
        print(f"Error walking directory <{directory}>: {err}")


def main():
    print("\nPython Image Inverter")
    print("---------------------")
    global time_start, time_end, num_file_errors, num_files_processed

    # Reset globals
    time_start = 0
    time_end = 0
    num_file_errors = 0
    num_files_processed = 0

    try:
        if len(sys.argv) > 1:
            process_file_or_directory(sys.argv[1])
        else:
            process_file_or_directory(get_filename_or_directory_from_user())
    except Exception as err:
        print(f"  Error: {err}")

    time_end = time.time()
    time_elapsed = time_end - time_start
    files = "files" if num_files_processed > 1 else "file"

    print(f"\nProcessed {num_files_processed} {files} in {time_elapsed:.2f} seconds.")
    if num_file_errors > 0:
        print(f"Encountered {num_file_errors} errors.")


""" MAIN ENTRY POINT """
if __name__ == "__main__":
    main()
    sys.exit(0)
