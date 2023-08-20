
import numpy as np
import cv2
import xlwt
import glob as gb
import imageio as iio
import io
from matplotlib import pyplot as plt


# Calculate the distance between the hue and one edge rotating alpha degree
def distanceToOneEdge(hueVal, edge, alphaVal):
    # print("hue=", hueVal, " edge=", edge, " alpha=", alphaVal)
    dis = abs(hueVal - (edge + alphaVal) % 360)
    # print('dis =', dis)
    if (dis > 180):
        return (360 - dis)
    else:
        if dis < 0:
            print('\ndistanceToOneEdge dis =', dis)
            print("When hue=", hueVal, " edge=", " alpha=", alphaVal)
        return dis

# Type i, V, T: only have 2 edges
def distanceToTwoEdges(hueVal, beginEdge, endingEdge, alphaVal):
    # print("hue=", hueVal, " beginEdge=", beginEdge, " endingEdge=", endingEdge, " alpha=", alphaVal)
    if ((beginEdge + alphaVal) % 360 <= hueVal <= (endingEdge + alphaVal) % 360):
        dis = 0
    else:
        val1 = distanceToOneEdge(hueVal, beginEdge, alphaVal)
        val2 = distanceToOneEdge(hueVal, endingEdge, alphaVal)
        if val1 < 0 or val2 < 0:
            print("distanceToTwoEdges val1 =", val1, "val2 =", val2)
        dis = min(val1, val2)
    if dis < 0:
        print("distanceToTwoEdges dis =", dis)
        print("When hue=", hueVal, " beginEdge=", beginEdge, " endingEdge=", endingEdge, " alpha=", alphaVal)
    return dis

# Type I, Y, L, X: have 4 edges
def distanceToFourEdges(hueVal, beginEdge, endingEdge, beginEdge2, endingEdge2, alphaVal):
    dis = min(distanceToTwoEdges(hueVal, beginEdge, endingEdge, alphaVal),
              distanceToTwoEdges(hueVal, beginEdge2, endingEdge2, alphaVal))
    if dis < 0:
        print('distanceToFourEdges dis =', dis)
        print("When hue=", hueVal, " beginEdge=", beginEdge, " endingEdge=", endingEdge, " beginEdge2=", beginEdge2,
              " endingEdge2=", endingEdge2, " alpha=", alphaVal)
    return dis

# based on type to get the distance, considering saturation
# "Type i","Type I","Type V","Type Y","Type L","Type X","Type T"
def getDistanceByTemplateType(hueVal, imageType, alphaVal):
    if (imageType == 0):  # "Type i"
        # print("Processing ImageType 0 - i")
        return distanceToTwoEdges(hueVal, 0, 18, alphaVal)
    if (imageType == 1):  # "Type I"
        # print("\nProcessing ImageType 1 - I")
        return distanceToFourEdges(hueVal, 0, 18, 180, 198, alphaVal)
    if (imageType == 2):  # "Type V"
        # print("\nProcessing ImageType 2 - V")
        return distanceToTwoEdges(hueVal, 0, 94, alphaVal)
    if (imageType == 3):  # "Type Y"
        # print("\nProcessing ImageType 3 - Y")
        return distanceToFourEdges(hueVal, 0, 94, 218, 236, alphaVal)
    if (imageType == 4):  # "Type L"
        # print("\nProcessing ImageType 4 - L")
        return distanceToFourEdges(hueVal, 0, 18, 59, 139, alphaVal)
    if (imageType == 5):  # "Type X"
        # print("\nProcessing ImageType 5 - X")
        return distanceToFourEdges(hueVal, 0, 94, 180, 274, alphaVal)
    if (imageType == 6):  # "Type T"
        # print("\nProcessing ImageType 6 - T")
        return distanceToTwoEdges(hueVal, 0, 180, alphaVal)

def getChangedHueValue(hueVal, distance, imageType, alphaVal):
    if getDistanceByTemplateType(hueVal - distance, imageType, alphaVal) == 0:
        return hueVal - distance
    elif getDistanceByTemplateType(hueVal + distance, imageType, alphaVal) == 0:
        return hueVal + distance
    else:
        return hueVal #don't change it

# the array's row index is hue, the column index is alpha, the value stored in the array
# is the distance for a hue-alpha combination to this template
typeDistance = np.zeros((7, 360, 360))
#typeDistance[0] = np.zeros((360, 360))  #Type i
for h in range(360):
    for alpha in range(360):
        typeDistance[0][h][alpha] = getDistanceByTemplateType(h, 0, alpha)

# typeIDistance = np.zeros((360, 360)) Type I
for h in range(360):
    for alpha in range(360):
        typeDistance[1][h][alpha] = getDistanceByTemplateType(h, 1, alpha)

#typeVDistance = np.zeros((360, 360)) Type V
for h in range(360):
    for alpha in range(360):
        typeDistance[2][h][alpha] = getDistanceByTemplateType(h, 2, alpha)

#typeYDistance = np.zeros((360, 360)) Type Y
for h in range(360):
    for alpha in range(360):
        typeDistance[3][h][alpha] = getDistanceByTemplateType(h, 3, alpha)

#typeLDistance = np.zeros((360, 360)) Type L
for h in range(360):
    for alpha in range(360):
        typeDistance[4][h][alpha] = getDistanceByTemplateType(h, 4, alpha)

# typeXDistance = np.zeros((360, 360)) Type X
for h in range(360):
    for alpha in range(360):
        typeDistance[5][h][alpha] = getDistanceByTemplateType(h, 5, alpha)

#typeTDistance = np.zeros((360, 360)) Type T
for h in range(360):
    for alpha in range(360):
        typeDistance[6][h][alpha] = getDistanceByTemplateType(h, 6, alpha)

# Use workbook to record each image's minimum hue distance to different templates at alpha degree
workbook = xlwt.Workbook()
sheet = workbook.add_sheet('Hue Distance with Alpha')
sheet2 = workbook.add_sheet('most_fitted_model')
sheet2.write(0, 0, "Image Name")
sheet2.write(0, 1, "Template Type")
sheet2.write(0, 2, "Optimal Alpha Value")
sheet2.write(0, 3, "Min Distance")

template_names = ("Type i", "Type-I", "Type V", "Type Y", "Type L", "Type X", "Type T")
for i in range(len(template_names)):
    sheet.write(0, i * 2 + 1, template_names[i])  # template name column followed by alpha column
    sheet.write(0, i * 2 + 2, "Optimal Alpha Value")

# Start processing images
img_path = gb.glob("/Users/heath/PycharmProjects/MyImages/*.png")
#img_path = gb.glob("/Users/heath/PycharmProjects/MyImages/RandomBackground/*.png")
#img_path = gb.glob("/Users/heath/PycharmProjects/MyImages/CalculatedBackground/*.png")
# Loop through each image
imgNum = 0

for path in img_path:
    print('imgNum = ', imgNum)
    image = iio.imread(path)
    imagePathName = path.split("/")[-1]
    print("imagePathName = ", imagePathName)
    imgName = imagePathName.split("\\")[-1]
    print("imgName = ", imgName)
    sheet.write(imgNum + 1, 0, imgName)  # record the image name into workbook

    # Hue range is [0,359], Saturation range is [0,255] and Value range is [0,255]
    img = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    height, width = img.shape[:2]
    num_colored_pixel = 0
    print(height, width)

    # record the occurrence of each hue, considering saturation
    listOfHueOccurrence = np.zeros(360)

    # loop through each pixel
    for i in range(height):
        if i % 200 == 0:
            print('i=', i)
        for j in range(width):
            # only consider pixels with saturation > 0.2 and lightness > 0.15 and < 0.95
            # otherwise the color tends to be white, gray or black
            #if img[i][j][1] > 51 and img[i][j][2] > 38 and img[i][j][2] < 242:
                num_colored_pixel = num_colored_pixel + 1

                # Calculate the pixel's distance to each template and store it
                hue = img[i][j][0] * 2
                listOfHueOccurrence[hue] = listOfHueOccurrence[hue] + img[i][j][1]

    # 2D array: row index is imageType, column index is alpha
    # the value is the sum of hue distance to the template for each imageType
    # "Type i","Type I","Type V","Type Y","Type L","Type X","Type T"
    typeDistanceWithAlpha = np.zeros((7, 360))
    minDistanceWithAlpha = np.zeros((1, 14))
    smallestMin = 0  # out of 7 types' distances, the smallest distances
    finalImageType = 0  # the corresponding template type
    finalAlpha = 0  # the corresponding alpha

    for r in range(7):
        typeDistanceWithAlpha[r] = np.dot(listOfHueOccurrence, typeDistance[r])

        print("r=", r, " length of typeDistanceWithAlpha[r]: ", len(typeDistanceWithAlpha[r]))
        print(typeDistanceWithAlpha[r])
        minVal = min(typeDistanceWithAlpha[r])
        if minVal < 0:
            print("WRONG: LESS THAN 0!!!")
        alphaForMinVal = np.argmax(typeDistanceWithAlpha[r] == minVal)
        minDistanceWithAlpha[0][r * 2] = minVal  # record the min distance
        if r == 0 or smallestMin > minVal:
            smallestMin = minVal
            finalImageType = r
            finalAlpha = alphaForMinVal

        minDistanceWithAlpha[0][r * 2 + 1] = alphaForMinVal
        #print('\nr=', r, ' minDistanceWithAlpha[0][', r * 2, '] =', minDistanceWithAlpha[0][r * 2])
        #print(' minDistanceWithAlpha[0][', r * 2 + 1, '] = ', minDistanceWithAlpha[0][r * 2 + 1])

    # write the result into workbook
    print('\nminDistanceWithAlpha', minDistanceWithAlpha)

    for i in range(len(minDistanceWithAlpha[0])):
        #print('i= ', i, " imgNum =", imgNum)
        sheet.write(imgNum + 1, i + 1, minDistanceWithAlpha[0][i])

    #imgTypeAlpha is not used anymore
    # store the result of imgNum, TemplateType and alpha to an array.
    # row index is the imgNum, column 1 is Template type, column 2 is alpha, column 3 is distance
    imgTypeAlpha = np.zeros((200, 4))
    imgTypeAlpha[imgNum][0] = finalImageType
    imgTypeAlpha[imgNum][1] = finalAlpha
    imgTypeAlpha[imgNum][2] = smallestMin

    print("finalImageType =", finalImageType)
    print("finalAlpha =", finalAlpha)
    sheet2.write(imgNum + 1, 0, imgName)
    sheet2.write(imgNum + 1, 1, template_names[finalImageType])
    sheet2.write(imgNum + 1, 2, str(finalAlpha))
    sheet2.write(imgNum + 1, 3, smallestMin)

######################################################################################################
    # Transform the image. Use minDistanceWithAlpha which has the Template Type and alpha value
    for t in range(7):  # loop through template types
        print("Template ", template_names[t])
        img = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)  # Reset image from input file
        for i in range(height):
            #if i % 200 == 0:
             #   print('i=', i)
            for j in range(width):
                # only consider pixels with saturation > 0.2 and lightness > 0.15 and < 0.95
                # otherwise the color tends to be white, gray or black
                if img[i][j][1] > 51 and img[i][j][2] > 38 and img[i][j][2] < 242:
                    hue = img[i][j][0]*2
                    d = getDistanceByTemplateType(hue, t, minDistanceWithAlpha[0][t * 2 + 1])
                    newHue = getChangedHueValue(hue, d, t, minDistanceWithAlpha[0][t * 2 + 1])
                    #print("old hue=", hue, "d=", d, "newHue=", newHue)
                    img[i][j][0] = newHue//2  # change the hue value

        imgNew = cv2.cvtColor(img, cv2.COLOR_HSV2BGR) #convert
        # back from HSV format
        #fileName = '/Users/heath/PycharmProjects/Outputs/RandomBackground/' + template_names[t] + '-' + imgName
        #fileName = '/Users/heath/PycharmProjects/Outputs/CalculatedBackground/' + template_names[t] + '-' + imgName
        fileName = '/Users/heath/PycharmProjects/Outputs/AllPixel-6 Image Results/' + template_names[t] + '-' + imgName
        #fileName = '/Users/heath/PycharmProjects/Outputs/AllPixel-RandomBackground/' + template_names[t] + '-' + imgName
        #fileName = '/Users/heath/PycharmProjects/Outputs/AllPixel-CalculatedBackground/' + template_names[t] + '-' + imgName
        #fileName = '/Users/heath/PycharmProjects/Outputs/6 Images Results/' + template_names[t] + '-' + imgName
        plt.axis('off')

        plt.imshow(imgNew)
        plt.savefig(fileName, bbox_inches ="tight", pad_inches = 0, transparent = True)
        # plt.show()

    imgNum = imgNum + 1

#workbook.save("/Users/heath/PycharmProjects/Outputs/6 Images Results/6Images.xls")
#workbook.save("/Users/heath/PycharmProjects/Outputs/RandomBackground/RandomBackground.xls")
#workbook.save("/Users/heath/PycharmProjects/Outputs/CalculatedBackground/CalculatedBackground.xls")
workbook.save("/Users/heath/PycharmProjects/Outputs/AllPixel-6 Image Results/AllPixe-6Images.xls")
#workbook.save("/Users/heath/PycharmProjects/Outputs/AllPixel-RandomBackground/AllPixel-RandomBackground.xls")
#workbook.save("/Users/heath/PycharmProjects/Outputs/AllPixel-CalculatedBackground/AllPixel-CalculatedBackground.xls")
