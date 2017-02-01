# BCDiceCord

TRPG dice bot on Discord by bcdice

## how to use?
It's simple!

```sh
bundle install #install dependency
ruby migrate.rb #database(sqlite) setup. DO NOT forget!!!!!
vim token.txt # setup discord bot token. first line: bot clientID, second line: bot token
ruby main.rb #start Bot.
```

Oh, are you emacs user?
sorry, this software is only to vim user...

if you nano user, let's use vim!

## 日本語でOK
上の手順でセットアップしてください

途中の`vim tokne.txt`は、
DiscordのbotのクライアントIDとトークンを設定しているところです。
1行目にクライアントID、2行目にトークンIDを設定してください

あと、マイグレーション(`ruby migrate.rb`)を忘れないでください。
(データベースエラーで３時間も費やした)

## なんでわざわざ英語でレドメ書いてるの？
英語勉強中です

察してください

## 英語間違ってるよ
こっそり教えてください