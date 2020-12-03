'''
Simple script to add a CSS stylesheet to index.html
'''
import argparse
import sys


class NoInputFile(Exception):
    """
    No input file passed in command line
    """


def _parse_input_file():

    parser = argparse.ArgumentParser()

    parser.add_argument('--in',
                        dest='in_file',
                        action='store',
                        nargs=1,
                        help='input file')

    args = parser.parse_args()
    
    if not args.in_file:
        print('bla')
        parser.print_help()
        raise NoInputFile

    return args.in_file[0]


def _main():

    # Get input HTML file
    input_file = ""

    try:
        input_file = _parse_input_file()

    except NoInputFile:
        sys.exit(-1)

    # Modify HTML file to add custom CSS stylesheet
    out = []
    found = False

    with open(input_file, "r") as file:
        lines = file.readlines()
        
        for line in lines:
            out.append(line)

            if "<!-- General and theme style sheets -->" in line:
                found = True
                out.append('<link rel="stylesheet" href="html_slides.css">\n')

    if found:
        with open(input_file, "w") as file:
            file.writelines(out)

    else:
        print("The HTML file doesn't seem to have the expected format")



if __name__ == "__main__":

    _main()