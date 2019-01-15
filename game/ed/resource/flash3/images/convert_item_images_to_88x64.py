# coding: utf-8

# 将所有储存在items文件夹中的文件
# 都修改为88*64的大小

from PIL import Image
import glob, os

def fixFilesInDirectory(directory):
	print("dealing with " + directory)
	for parent, dirnames, fileNames in os.walk(directory):
		for fileName in fileNames:

			filterName, ext = os.path.splitext(fileName)
			if (ext == ".png"):
				fullPath = parent + "/" + fileName
				im = Image.open(fullPath)
				im_resized = im.resize((88, 64), Image.ANTIALIAS)
				im_resized.save(fullPath)
				print("Finished =>", fullPath)

if __name__ == '__main__':
	fixFilesInDirectory("items/memes")
