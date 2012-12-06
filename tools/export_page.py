#!/usr/bin/env python
import os
import re

BASE_DIR = os.path.join(os.path.dirname(__file__), '..')
PAGE_DIR = os.path.join(BASE_DIR, 'pages')

# Note there is an extra '..' in here since it needs to be relative from the PAGE_DIR
THIRD_PARTY_DIR = os.path.join(BASE_DIR, '..', 'third_party')
THIRD_PARTY_FILES = [
    # CSS
    'normalize.css',
    'main.css',
    'bootstrap.min.css',
    'bootstrap-responsive.min.css',
    'datepicker.css',
    'nv.d3.css',
    'redactor.css',

    # Javascript
    'jquery.min.js',
    'jquery.fitvids.js',
    'bootstrap-datepicker.js',
    'jquery.validate.js',
    'modernizr-2.6.2.min.js',
    'redactor.min.js',
    'csrf_protect.js',
    'ga.js',
    'underscore-min.js',
    'bootstrap.min.js',
    'jquery.fittext.js',
    'backbone-min.js',
    'filepicker.js',
    'css3-mediaqueries.js',
    'bootbox.js',
    'additional-methods.js',
    'jquery.bootstrap.wizard.js',
]

# Note there is an extra '..' in here since it needs to be relative from the PAGE_DIR
IMAGE_DIR = os.path.join(BASE_DIR, '..', 'source', 'images')
IMAGE_FILES = [
    'favicon.ico',
    'project_card_avatar_placeholder',
]

# Note there is an extra '..' in here since it needs to be relative from the PAGE_DIR
LOGO_IMAGE_DIR = os.path.join(BASE_DIR, '..', 'source', 'images', 'logo')
LOGO_IMAGE_FILES = [
    'openfire_large_animated.gif',
    'openfire_large.png',
    'openfire_large_animated_slow.gif',
    'of_small_transparent.png',
]


def replace_third_party_locations(file_dir, html):

    """ Replace all third party file locations with the common ones. """

    for file_name in THIRD_PARTY_FILES:
        # Replace the project_files location with the third party location.
        replace = './project_files/' + file_name
        replace_with = os.path.join(THIRD_PARTY_DIR, file_name)
        html = re.sub(replace, replace_with, html)

        # Also remove the file from the project_files if it exists.
        try:
            os.remove(os.path.join(file_dir, 'project_files', file_name))
        except OSError:
            pass

    return html


def replace_image_file_locations(file_dir, html):

    """ Replace all openfire image file locations with the common ones. """

    for file_name in IMAGE_FILES:
        # Replace all image file locations with /source/images/.
        replace = 'http://localhost:8000/_static/img/' + file_name
        replace_with = os.path.join(IMAGE_DIR, file_name)
        html = re.sub(replace, replace_with, html)

        try:
            os.remove(os.path.join(file_dir, 'project_files', file_name))
        except OSError:
            pass


    for file_name in LOGO_IMAGE_FILES:
        # Replace all image file locations with /source/images/.
        replace = './project_files/' + file_name
        replace_with = os.path.join(LOGO_IMAGE_DIR, file_name)
        html = re.sub(replace, replace_with, html)

        try:
            os.remove(os.path.join(file_dir, 'project_files', file_name))
        except OSError:
            pass

    return html


if __name__ == '__main__':

    """
    Load an html page, rename common file location, write to a temp file,
    then rename the temp file to overwrite original file.

    NOTE that right now this ONLY does the project page. More to come.
    """

    project_file_dir = os.path.join(PAGE_DIR, 'project')
    project_file_name = os.path.join(project_file_dir, 'project.html')
    tmp_file_name = os.path.join(PAGE_DIR, 'project', 'TMP_FILE.html')

    print 'loading html file...'
    with open(project_file_name, 'r') as project_file:
        project_html = project_file.read()

    print 'Replacing common third party and image file locations...'
    new_html = replace_third_party_locations(project_file_dir, project_html)
    new_html = replace_image_file_locations(project_file_dir, new_html)

    print 'Writing temp file...'
    with open(tmp_file_name, 'w') as tmp_file:
        tmp_file.write(new_html)

    print 'Renaming to original file...'
    os.rename(tmp_file_name, project_file_name)

    print 'Done!'
