#!/usr/bin/env python

import ansi
import json
import os
import subprocess
import sys
import time

MYLOGFILE = './logwatch.logs'

class Annotation:
    def __init__(self, start: list, end: list, color: str):
        self.start = start
        self.end = end
        self.color = color

    def __str__(self):
        return f'annotation({self.start}, {self.end}, {self.color})'

    def __repr__(self):
        return f'annotation({self.start}, {self.end}, {self.color})'

class AnnotatedText:
    def __init__(self, text: str, annotations: list):
        self.text = text
        self.annotations = AnnotatedText.read_annotations(annotations)

    @staticmethod
    def read_annotations(annotations: list):
        """
        reads the annotations from file
            start  : [int, int]
            end    : [int, int]
            color  : str
        """
        anns = []
        for annotation in annotations:
            start = annotation[0]
            end = annotation[1]
            color = annotation[2]
            anns.append(Annotation(start, end, color))
        return anns

    def render_text(self):
        """
        renders the text with the annotations
        """
        lines = self.text.split('\n')
        for lidx, line in enumerate(lines):
            for cidx, char in enumerate(line):
                for ann in self.annotations:
                    if ann.start[0] == lidx and ann.start[1] == cidx:
                        print(ansi.getcolor(ann.color), end='')
                        # afile(MYLOGFILE, f'{lidx} {cidx} [on] {ann.color}\n')
                    elif ann.end[0] == lidx and ann.end[1] == cidx:
                        print(ansi.getcolor('reset'), end='')
                        # afile(MYLOGFILE, f'{lidx} {cidx} [off] {ann.color}\n')
                    # else:
                        # afile(MYLOGFILE, f'{lidx} {cidx} [α] {ann.color}\n')
                print(char, end='')
            print()
        print(ansi.getcolor('reset'))


def watch_file():
    """
    watches a file on disk, if it changes, clears the screen and displays the new contents
    annotation files end with .annotations
    example:
        target: out/response
        annotation: out/response.annotations
        response.annotations: [ [ [1,1], [1,5], "red" ] ]
    """
    if len(sys.argv) < 2:
        print('usage: watch.py <file>')
        sys.exit(1)

    args = []
    make_if_not_exists = False
    for arg in sys.argv:
        if arg in ['-m', '--mkdirs']:
            make_if_not_exists = True
        else:
            args.append(arg)


    target = args[1]
    if not os.path.exists(target):
        dirname = os.path.dirname(target)
        if not os.path.exists(dirname):
            if make_if_not_exists:
                os.makedirs(dirname)
            else:
                print(f'error: {dirname} does not exist')
                sys.exit(1)
        with open(target, 'w') as f:
            f.write('')
    annotation_file = target + '.annotations'

    last_modified = os.path.getmtime(target)

    def print_header():
        subprocess.call("clear")
        # print file name in `{white}file:///{cyan}filename{reset}` format
        print(ansi.getcolor('white'), end='')
        print('file:///', end='')
        print(ansi.getcolor('reset'), end='')
        print(ansi.getcolor('blue'), end='')
        print(f'{target} ', end='')
        print(ansi.getcolor('reset'), end='')
        print()
    print_header()

    # read the file
    with open(target, 'r') as f:
        text = f.read()

    # read the annotations
    if os.path.exists(annotation_file):
        with open(annotation_file, 'r') as f:
            annotations = json.load(f)
            afile(MYLOGFILE, f'loaded annotations: {annotations}')
    else:
        annotations = []
        afile(MYLOGFILE, f'no ann for: {target}\n')

    annotated_text = AnnotatedText(text, annotations)
    annotated_text.render_text()
    afile(MYLOGFILE, f'watching file: {target}\n')

    while True:
        time.sleep(0.5)
        if os.path.getmtime(target) != last_modified:
            afile(MYLOGFILE, f'file changed: {target}\n')
            last_modified = os.path.getmtime(target)
            # subprocess.call("clear")
            with open(target, 'r') as f:
                text = f.read()
            annotated_text = AnnotatedText(text, annotations)

            print_header()
            annotated_text.render_text()

def afile(path: str, contents: str, end='\n'):
    with open(path, 'a') as f:
        f.write(contents + end)
def wfile(path: str, contents: str, end='\n'):
    with open(path, 'w') as f:
        f.write(contents + end)


if __name__ == '__main__':
    watch_file()
