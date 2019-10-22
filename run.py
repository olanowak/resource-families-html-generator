import argparse
import os

from clartable import Clartable
from reader import read_data, read_rules
from utils import table_title, section_title

parser = argparse.ArgumentParser(description='Create html table from given data and rules')
parser.add_argument('-i', metavar='PATH', required=True, help='path to a .csv file or folder with .csv files')
parser.add_argument('-r', metavar='PATH', required=True, help='path to json file with rules')
parser.add_argument('-o', metavar='PATH', required=True, help='path to file where output html table will be written')

args = parser.parse_args()


if __name__ == "__main__":
    rules = read_rules(args.r)
    clartable = Clartable(rules)
    output = open(args.o, 'w')

    # input is a single file
    if os.path.isfile(args.i):
        data = read_data(args.i)
        title = table_title(args.i)
        table = title + clartable.generate(data)
        output.write(table)
    # input is a folder
    else:
        for root, subdir, files in os.walk(args.i):
            subdir.sort()
            files.sort()
            if len(files) > 0:
                if os.path.basename(root) != '':
                    output.write(section_title(root))
                for _file in files:
                    data = read_data(os.path.join(root, _file))
                    # generate table:
                    if _file != '':
                        table = table_title(_file)
                    else:
                        table = ''
                    table += clartable.generate(data)
                    output.write(table)
