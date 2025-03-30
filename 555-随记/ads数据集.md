# Ads 数据集

本数据集再这篇文章中提出 Automatic Understanding of Image and Video Advertisements.
arXiV 链接：https://arxiv.org/abs/1707.03067

数据集公开官网：https://people.cs.pitt.edu/~kovashka/ads/

这个数据集其实包含两个部分：

1. 图片广告：总共 64832 张
2. 视频广告：总共 3477 个视频广告

## 视频广告数据集

https://people.cs.pitt.edu/~kovashka/ads/#video

| Type          | Count  | Example                                           |
| ------------- | ------ | ------------------------------------------------- |
| Topic         | 17,345 | Cars and automobiles, Safety                      |
| Sentiment     | 17,345 | Cheerful, Amazed                                  |
| Action/Reason | 17,345 | I should buy this car because it is pet-friendly. |
| Funny?        | 17,374 | Yes/No                                            |
| Exciting?     | 17,374 | Yes/No                                            |
| English?      | 15,380 | Yes/No/Does not matter                            |
| Effective?    | 16,721 | Not/.../Extremely Effective                       |

- [Readme](https://people.cs.pitt.edu/~kovashka/ads/readme_videos.txt)
- [Video URLs](https://people.cs.pitt.edu/~kovashka/ads/final_video_id_list.csv)
- [Download video annotations](https://people.cs.pitt.edu/~kovashka/ads/annotations_videos.zip)
- [Download new climax annotations](http://people.cs.pitt.edu/~yekeren/ads_climax/)

TODO: 我暂时还没懂这个 climax 数据集和这个 Ads 的关系是什么。

下载标注文件，解压后文件内容如下：

```bash
$ tree .
.
├── readme_videos.txt
└── video
    ├── Sentiments_List.txt
    ├── Topics_List.txt
    ├── cleaned_result
    │   ├── video_Effective_clean.json
    │   ├── video_Exciting_clean.json
    │   ├── video_Funny_clean.json
    │   ├── video_Language_clean.json
    │   ├── video_Sentiments_clean.json
    │   └── video_Topics_clean.json
    ├── final_video_id_list.csv
    └── raw_result
        ├── video_Effective_raw.json
        ├── video_Exciting_raw.json
        ├── video_Funny_raw.json
        ├── video_Language_raw.json
        ├── video_QA_Action_raw.json
        ├── video_QA_Reason_raw.json
        ├── video_Sentiments_raw.json
        └── video_Topics_raw.json

4 directories, 18 files
```

先看这个 README 文件在说什么

# 视频数据集

## 视频：

我们的视频数据集包含来自 YouTube 的共 3,477 个广告视频。我们在文件`final_video_id_list.csv`中以 YouTube ID 列表的形式提供这些视频。这些视频可以在`https://www.youtube.com/watch?v=[在此插入ID]`找到。请在将 ID 输入 URL 之前删除单引号。

http://people.cs.pitt.edu/~kovashka/ads/final_video_id_list.csv

## 标注文件：

标注文件采用 json 格式。标注文件中的键是视频 ID。值可以根据标注类型采取不同形式，具体如下所述。

我们提供两种类型的标注：

1. **直接来自标注者的原始标注** -- 这些分为三个子类型：
   - (a) 自由形式的标注，我们用它来定义主题和情感标注的类别列表；
   - (b) 针对 QA 动作和原因（"我应该做什么？"和"为什么我应该这样做？"）的自由形式标注，我们没有进一步处理；
   - (c) *单个*标注者（通常每个视频有 5 个）对主题(Topics)、情感(Sentiments)、幽默(Funny)、刺激(Exciting)、语言(Language)和有效性(Effective)的多项选择；
2. **清理后的标注** -- 这些是对原始标注进行多数投票计算的结果，QA 标注除外。因此每个视频都有一个单一的标注。如果原始标注是自由形式文本，我们会半手动地将其映射到多项选择选项之一。

对于"主题"和"情感"，为了保持一致性，原始文件仅包含字符串。但请注意，这些字符串本质上有两种类型：(1)标注者自由撰写的字符串，或(2)对应于标注者所做的多项选择的字符串（我们使用缩写来表示类别）。例如：

```json
{
  ...,
  Pzl86IjTpHI: ["media", "award show", "media", "media", "media"],
  h6CcxJQq1x8: ["restaurant", "soda", "soda", "soda", "soda"],
  ...
}
```

相比之下，清理后的文件显示类别 ID，并在单独的 txt 文件（`Topics_List.txt`和`Sentiments_List.txt`）中提供相应的映射。多数类别 ID 是根据标注者选择的主题/情感计算得出的。

对于问答（"动作"，"原因"），我们提供未处理的自由形式句子标注。文件`QA_Action.json`包含"什么"问题的结果，文件`QA_Reason.json`包含同一图像的"为什么"问题的结果。例如：

```json
{
  ...,
  5AuLkMBAFZg: ["Because it could make me sick.",
                "Because what you put in your mouth could be harmful to you.",
                "Because it can be dangerous. ",
                "Because its reminding children to not put things in their mouth and explaining the dangers of it.",
                "Because I could get sick."],
  ...
}
```

对于"幽默"和"刺激"，"1"表示幽默或刺激，"0"表示不幽默/不刺激。对于多数投票，我们根据标注者回应的平均值计算一个从 0 到 1 的分数。例如，如果所有 5 位标注者都同意该视频是幽默的，那么得分为 5/5 = 1；如果 2 位标注者认为它是幽默的，3 位认为不是，那么幽默得分将是 2/5 = 0.4。我们使用这个'得分'作为幽默/刺激的清理后标注。在我们的 SVM 实验中，我们选择 0.7 作为正面（幽默/刺激）的最低阈值，0.3 作为负面的最高阈值。因此，得分超过 0.7 的视频将被视为正面训练样本，得分低于 0.3 的将被视为负面样本。我们没有在模糊不清的视频上训练我们的分类器。

对于"语言"，"1"表示"英语"，"0"表示"非英语"，"-1"表示"理解广告不需要依赖语言"。

对于"有效性"，分数范围从"1"到"5"，"5"表示"最有效"。

---

以上是 README 的翻译与解读

但是今天（也就是 2025.3.30）我发现没有办法完整的获取 3477 个视频文件，很多视频在 youtube 上显示变成私密视频或者已经被删除等等。

考虑用 pytubefix 这个库来自动化检查一下。https://github.com/JuanBindez/pytubefix
