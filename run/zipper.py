
import shutil
import os

dir = '../bumper_cars_test'
name = 'test_zip'
zip = 'zip'

fullpath = dir + name + '.' + zip
if os.path.isfile(fullpath):
    os.remove(fullpath)

shutil.make_archive(name, zip, dir)