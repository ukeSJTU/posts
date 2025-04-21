# Lecture 2: Image Classification with Linear Classifiers

Image Classification
A Core Task in Computer Vision
Today:
● The image classification task
● Two basic data-driven approaches to image classification
○ K-nearest neighbor and linear classifier

Image Classification: A core task in Computer Vision

The Problem: Semantic Gap

What the computer sees
An image is a tensor of integers
between [0, 255]:
e.g. 800 x 600 x 3
(3 channels RGB)

Challenges: Viewpoint variation 当你从不同角度拍摄（看）同一个物体的时候，图片文件里面所有的像素都会变化。
Challenges: Illumination
Challenges: Background Clutter
Challenges: Occlusion
Challenges: Deformation
Challenges: Intraclass variation
Challenges: Context

IMAGENET 是一个大规模的图像数据集，包含了超过 1400 万张图像和 20000 个类别。它是计算机视觉领域最重要的数据集之一，广泛用于图像分类、目标检测和分割等任务。

为了解决图像分类的问题，我们需要一个 image classifier。

```python
def classify_image(image):
    # Some magic here?
    return class_label
```

可以抽象成上面这样的算法，但是 Unlike e.g. sorting a list of numbers,
no obvious way to hard-code the algorithm for
recognizing a cat, or other classes.

以前尝试对图片 find edges，然后 find corners，但是我们课程要学习的 machine learning：

Machine Learning: Data-Driven Approach

1. Collect a dataset of images and labels
2. Use Machine Learning algorithms to train a classifier
3. Evaluate the classifier on new images

### Nearest Neighbor Classifier

如何设置超参数？
