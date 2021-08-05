import glob
import PIL.Image as Image


def transparent_back(img):
    img = img.convert('RGBA')
    L, H = img.size
    color_0 = img.getpixel((0, 0))
    for h in range(H):
        for l in range(L):
            dot = (l, h)
            color_1 = img.getpixel(dot)
            if color_1 == color_0:
                color_1 = color_1[:-1] + (0, )
                img.putpixel(dot, color_1)
    return img

img = Image.open("D:\\github_repo\\ai-apps\\auto_test_web\\assets\\images\\logo2.jpg")

# imgs = glob.glob("D:\\github_repo\\PencilFace\\dataset\\linedface2\\" +
#                  "*.png")
img=transparent_back(img)

img.save("D:\\github_repo\\ai-apps\\auto_test_web\\assets\\images\\logo2.png")

# for imgpath in imgs:
#     img = Image.open(imgpath)
#     img = transparent_back(img)
#     img.save(imgpath.replace(".png", "t.png"))
