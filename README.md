[![Hello VN][hellovn-shield]][hellovn] ![Status][status-shield]
[![MIT][mit-shield]][mit] [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

你可以点击这里访问中文版「说明书」：[https://github.com/HelloVNProject/HelloVN/blob/main/README-CN.md](https://github.com/HelloVNProject/HelloVN/blob/main/README-CN.md)

# 👋Introduction

Hi.

"Hello." (hereinafter referred to as "the game") is a **fan-made** visual novel game based on the game "The Smoke Room", which is a **derivative work** .

The game is a small-scale ensemble adventure that tells the story of an exploration team led by *GR* , including members  *Can* , *Seaon* , and *Romin* , investigating anomalies in a cave. Meanwhile, characters from the "The Smoke Room" world, *Nik* ,  *Sam* , and *Yao* , find themselves unexpectedly in the world of this game due to an "in-plan" event gone "out-of-plan". Accompanying them is *Todd* .

Why do the exploration team and the "The Smoke Room" quartet cross paths? What unexpected situations will arise during their adventures? Will sparks fly between them? Can the "The Smoke Room" quartet eventually return to their original world, and what will be the cost? The answers to these questions will be revealed within the game, and the course of the story and their fate will be determined by **you**.

**❗ Note: Before playing this game, please ensure that you have completed the first two chapters of the Nik route in the game "The Smoke Room" to avoid spoilers.**

The game is developed using the Godot Engine and is currently in development. If you're interested, feel free to follow this project.

The first public version of the game is expected to be released in August 2023. Stay tuned.

Thank you for your patience and understanding. :)

# 💖Project Members

The release of the game wouldn't be possible without the collaborative efforts of these talented individuals.

| This Guy...            | Do These Things...                                                                                              | Find Them On...                                                                                  |
| ---------------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| Rominwolf              | Director, Writer, Character Designer, Illustrator, UI Designer, Game Programmer, Sprites Artist, Goods Designer | [Weibo](https://weibo.com/u/5062069865), [Twitter](https://twitter.com/Rominwolf)                     |
| GeorgeSquares          | Writer (Official storyline of "The Smoke Room"), Special Thanks                                                 | [Twitter](https://twitter.com/GeorgeSquares)                                                        |
| tiAnsxq                | Character Designer, Illustrator                                                                                 | [Weibo](https://weibo.com/n/%E5%8F%82%E5%92%B8%E7%8A%AC), [Twitter](https://twitter.com/tiAnsxq)      |
| GRtheGreat             | Character Designer, Illustrator, Icon Designer                                                                  | [Weibo](https://weibo.com/u/6141025798), [Twitter](https://twitter.com/GR_theGreat)                   |
| lam0rang3              | Character Designer, Illustrator                                                                                 | [Twitter](https://twitter.com/Iam0rang3)                                                            |
| staufdraws             | Illustrator                                                                                                     | [Twitter](https://twitter.com/staufdraws)                                                           |
| EJheptene              | Illustrator                                                                                                     | [Bilibili](https://space.bilibili.com/14985484), [Twitter](https://twitter.com/EJheptene)             |
| Minecraft               | Background Artist                                                                                               |                                                                                                  |
| Anthemics              | Musician                                                                                                        | [Twitter](https://twitter.com/Anthemics)                                                            |
| REDproductions         | Musician                                                                                                        | [Pixabay](https://pixabay.com/zh/users/redproductions-970568)                                       |
| Linkmusicnow           | Musician                                                                                                        | [Bilibili](https://space.bilibili.com/511365691), [Instagram](https://www.instagram.com/linkmusicnow) |
| Placidplace            | Sound Designer                                                                                                  | [Pixabay](https://pixabay.com/zh/users/placidplace-25572496/)                                       |
| compymono              | UI Designer                                                                                                     | [Twitter](https://twitter.com/compymono)                                                            |
| ItzSocn                | Backend Programmer                                                                                              | [Github](https://github.com/Socn), [Twitter](https://twitter.com/ItzSocn)                             |
| Croissant_Daily        | Legal Advisor, Special Thanks                                                                                   | [Twitter](https://twitter.com/Croissant_Daily)                                                      |
| Opossoll               | Special Thanks                                                                                                  | [Twitter](https://twitter.com/Opossoll)                                                             |
| 好想发懒摸鱼           | Special Thanks                                                                                                  |                                                                                                  |
| 登上陆地的鱼           | Special Thanks                                                                                                  |                                                                                                  |
| Romin Villa's Friends | Special Thanks                                                                                                  |                                                                                                  |
| EchoTheVN              | Special Thanks                                                                                                  | [Twitter](https://twitter.com/EchoTheVN)                                                            |
| OpenAI                 | Translator                                                                                                      | [OpenAI](https://openai.com/)                                                                       |

# 🎓What You Can Learn?

In this project, you can learned about...

- Basic use skills of Godot Engine for starter.
- Basic use skills of Dialogic for starter. (This a plugin based on Godot Engine.)

# 🧪Build by Yourself?

You could build this project by yourself just following this part step by step.

1. Clone this project.
2. Make sure you already installed Godot Engine V3.5.2 (not Mono Version).
3. Then open this project from Godot Launcher.
4. That is all. If anything not wrong, you should open this project successfully.

This part will teach you how to build.

1. Make sure you already installed Godot Exporting Template V3.5.2 (not Mono Version).
2. Access the export menu and select the desired platform.

# 💬 Help Us to Translate

If you'd like to help **add another language** to this game (localization), please follow these steps:

1. First, download programs like `Poedit` that support gettext language files, as the game uses `.po` files for localization purposes.
2. Copy the `zh` directory under the `locales` directory and rename the directory to the Unix standard locale abbreviation of the language you intend to translate. For more details, refer to: [Unix Locales][unix-locales].
3. Use a program like Poedit to open the language file within the new directory and begin translating.
4. You can save your progress at any time, and then select this new language in the game client for testing and debugging.
5. Once you've completed the translation, don't forget to submit a Pull Request to this repository. The new language will be added to the official client in the next version.
   
If you're interested in **improving languages that already exist** in the game, please follow these steps:

1. First, download programs like `Poedit` that support gettext language files, as the game uses `.po` files for localization purposes.
2. Navigate to the `locales` directory and enter the language directory you want to improve. For more details, refer to: [Unix Locales][unix-locales].
3. Within the language directory, use a program like Poedit to open the language file and proceed with the translation.
4. You can save your progress at any time, and then select the improved language in the game client for testing and debugging.
5. Once you've finished the translation improvements, remember to submit a Pull Request to this repository. The updated language will be included in the official client in the next version.

Note: If you don't want to submit a Pull Request and only intend to privately distribute the translation to friends, you can package the translated directory and send it to the recipient. They can then unzip and use it within the 'locales' directory.

# ⚠ Assets Requiring Additional Mention

When using any files from this repository personally, as a team, organization, or commercially, be aware of the specified licenses for additional marked assets to avoid copyright and unauthorized usage risks.

This project defaults to the `MIT` license, but does not include the following assets.

| Asset                                                                              | Copyright Holder                             | License                                        |
| ---------------------------------------------------------------------------------- | -------------------------------------------- | ---------------------------------------------- |
| All files under the directory `/images/cgs/`                                     | Production Team of "Hello."                  | CC BY-NC-SA 4.0                                |
| All files under the directory `/images/headers/`                                 | Production Team of "Hello."                  | CC BY-NC-SA 4.0                                |
| All files under the directory `/images/sprites/can/`                             | Production Team of "Hello.",<br />tiAnsxq    | CC BY-NC-SA 4.0                                |
| All files under the directory `/images/sprites/gr/`                              | Production Team of "Hello.",<br />GRtheGreat | CC BY-NC-SA 4.0                                |
| All files under the directory `/images/sprites/romin/`                           | Production Team of "Hello.",<br />Rominwolf  | CC BY-NC-SA 4.0                                |
| All files under the directory `/images/sprites/seaon/`                           | Production Team of "Hello.",<br />GRtheGreat | CC BY-NC-SA 4.0                                |
| All files under the directory `/images/sprites/nik/tsr/`                         | Production Team of "The Smoke Room"          | No License, Original Author Retains All Rights |
| All files under the directory `/images/sprites/sam/tsr/`                         | Production Team of "The Smoke Room"          | No License, Original Author Retains All Rights |
| All files under the directory `/images/sprites/todd/tsr/`                        | Production Team of "The Smoke Room"          | No License, Original Author Retains All Rights |
| All files under the directory `/images/sprites/yao/tsr/`                         | Production Team of "The Smoke Room"          | No License, Original Author Retains All Rights |
| All files under the directory `/images/sprites/skeleton/`                        | "Minecraft"                                  | No License, Original Author Retains All Rights |
| All files under the directory `/images/sprites/zombie/`                          | "Minecraft"                                  | No License, Original Author Retains All Rights |
| All files under the directory `/images/tsr/`                                     | Production Team of "The Smoke Room"          | No License, Original Author Retains All Rights |
| All files under the directory `/dialogic/themes/tsr/images/gui/`                 | Production Team of "The Smoke Room"          | No License, Original Author Retains All Rights |
| All files with `.ttf`format under the directory `/fonts/harmony-os-sans-sc/`   | HarmonyOS                                    | HarmonyOS Sans Font License                    |
| All files with `.ttf`format under the directory `/fonts/intel-one-mono/fonts/` | Intel                                        | SIL License                                    |
| All files with `.otf`format under the directory `/fonts/source-hans-serif/`    | Adobe                                        | SIL License                                    |
| File `/musics/Conflict.ogg`                                                      | Production Team of "The Smoke Room"          | No License, Original Author Retains All Rights |
| File `/musics/Hello.ogg`                                                         | Linkmusicnow                                 | No License, Original Author Retains All Rights |
| All files under the directory `/origin-files/`                                   | Production Team of "Hello."                  | No License, Original Author Retains All Rights |
| All files under the directory `/voices/Amorog/`                                  | Uberduck                                     | No License, Original Author Retains All Rights |
| All files under the directory `/voices/Seaon/`                                   | Uberduck                                     | No License, Original Author Retains All Rights |
| All files under the directory `/voices/Ten/`                                     | Uberduck                                     | No License, Original Author Retains All Rights |
| All files under the directory `/voices/Can/`                                     | Production Team of "Hello.",<br />tiAnsxq    | No License, Original Author Retains All Rights |
| All files under the directory `/voices/GR/`                                      | Production Team of "Hello.",<br />GRtheGreat | CC BY-NC-SA 4.0                                |
| All files under the directory `/voices/Romin/`                                   | Production Team of "Hello.",<br />Rominwolf  | CC BY-NC-SA 4.0                                |

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg?style=flat-square
[mit]: https://github.com/HelloVNProject/HelloVN/blob/main/LICENSE
[mit-shield]: https://img.shields.io/badge/License-CC%20BY--MIT-lightgrey.svg?style=flat-square
[hellovn]: https://github.com/HelloVNProject
[hellovn-shield]: https://img.shields.io/badge/Owner%20By-Hello%20VN-dark.svg?style=flat-square&labelColor=000&color=EAEAEA
[status-shield]: https://img.shields.io/badge/Status-Work%20In%20Progress-dark.svg?style=flat-square
[unix-locales]: https://docs.godotengine.org/zh_CN/stable/tutorials/i18n/locales.html
