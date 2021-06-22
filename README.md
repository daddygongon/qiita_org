

# QiitaOrg

![img](https://img.shields.io/badge/MacOSX-10.13.3-brightgreen.svg) ![img](https://img.shields.io/badge/ruby-2.7.0p0-brightgree.svg) 
![img](https://img.shields.io/badge/qiitaorg-0.1.8-brightgreen.svg)


## 概要

qiita\_orgはqiitaへの投稿にあたって，テキストの作成から投稿までを
terminal上で一括で行いたいというコンセプトでできたgemです．

emacs org-modeで作成したテキストをCUIでqiitaに投稿します．

注意点:command\_lineを使用しているのでrubyのバージョンは2.4.0以上にしてください．
また，emacsのバージョンは26.3以上をお勧めします．


## 使用例

まず，org-modeの投稿用テンプレートを取得します．
'qiita template'とコマンドを打ち，環境を書き込むかを決めtemplate.orgを作成します．
![img](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/612049/76dc9d92-3a77-5523-7a21-571f691402bb.png)

すると，このようなorgが作成されます．
![img](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/612049/4a38e62f-9cae-1bf1-ee51-080706c64f6f.png)

ここのtitle,tagをqiitaに載せる用のものに変更してあとは従来通り本文を書くだけ．

本文が作成できたら，あとは投稿用のコマンドを実行するだけ．
試しに限定共有投稿へ投稿してみるとこんな感じ．
![img](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/612049/3f7179f4-e150-7a63-b8ba-e936b925d7be.png)

ズラズラーっと出ますが，設定がちゃんとできていれば投稿が完了し，
Safariで投稿したページが開きます．

投稿した記事にはSouceとしてどこのディレクトリに元のorgテキストがあるか
表示されるので，少し前の記事を編集したい時でも便利なはず．．．


## インストール

    gem install qiita_org

get commandにpandocを使っているのでインストールしてください．
macなら

    brew install pandoc

ubuntuなら

    sudo apt update
    sudo apt install pandoc


## 設定ファイルの作成

    qiita config global

とし，設定ファイルをホームディレクトリに作成する．


### Qiitaのアクセストークンの作成方法と設定ファイルへの書き込み

[<https://qiita.com/settings/applications>](<https://qiita.com/settings/applications>)にて

個人用アクセストークンの'新しくトークンを発行する'をクリック．
![img](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/612049/de93b61e-b42d-8364-7282-ee1bdbd572ad.png)

アクセストークンの説明を書き，スコープのところは画像のように全てにチェックを入れる．その後発行をおす．
![img](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/612049/7012077d-fba8-e823-d29c-dc93939b4d6b.png)

ページが移動すると個人用アクセストークンのところにアクセストークンが表示されているので，
コピーしてください．（この文字列はページを移動すると再表示できなくなるので注意してください．）

ターミナルに戻り，以下のように実行．

    qiita config global access_token 'your accesstoken'

'your accesstoken'のところには先ほどコピーしたアクセストークンをペーストしてください．


### 名前の登録

    qiita config global name 'your name'


### メールアドレスの登録

    qiita config global email 'your email'


### QiitaTeamURLの登録

'teams'というoptionを使うために必要なので，
所属しているQiitaTeamがあるのならこの設定を行なってください．
なければ設定しなくて大丈夫です．

    qiita config global teams_url 'https://foge.qiita.com/'

URLは最後に'/'をつけるのを忘れないように注意してください．


### localの設定ファイルを作る方法

複数のTeamに所属している場合や，ディレクトリごとにメールアドレスを設定したい場合が
あればlocalの設定ファイルを指定できます．

設定ファイルを作りたいディレクトリにて，

    qiita config local set

とし，上記の初期設定のglobalをlocalに変えて
そのほかを同じように書き込んでいくとできます．


# コマンド一覧

-   qiita all
-   qiita config [global/local] [option] [input]
-   qiita get [qiita/teams] [記事のID]
-   qiita list [qiita/teams]
-   qiita post [FILE] [private/public/teams]
-   qiita template


## qiita all

カレントディレクトリ内の全てのorgファイルをqiitaに投稿するコマンドです．

orgファイル内にidの記載のあるものは記事の更新，id記載のないものに関しては
全て限定共有投稿に投稿されます．


## qiita config

qiita\_orgの設定ファイルの作成と確認を行うコマンドです．

設定方法については上記の通りです．


## qiita get

Qiitaの記事を取得するためのコマンドです．


## 特定記事の取得方法

qiita get [qiita/teams] [記事のID]

実行することで指定した記事をid.orgとしてディレクトリ内に作成します．


## 複数記事の取得方法

自分のQiitaもしくはQiitaTeamの記事を最新から100個まで表示し取得できます．

qiita get [qiita/teams]

実行するとタイトルが表示されるので，保存したければ'y'いらなければ'n'を入力する．
終了は'e'


## qiita list

自分のQiitaもしくはQiitaTeamの記事を最新から100個まで
terminal上に表示するコマンドです．

qiita list [qiita/teams]

実行するとオプションがqiitaならtitle, URL, 記事の元となったorgファイルの場所
が表示されます．

teamsの方ではさらに誰の記事かが表示されます．


## qiita post

Qiitaにorg-modeで書いたテキストを投稿するためのコマンドです．

qiita post [FILE] [private/public/teams]

FILEには投稿したいorgファイルを，
privateは限定共有投稿，publicは公開記事，teamsはQiitaTeamに投稿されます．

例:

    qiita post example.org private

と実行すると限定共有記事にexample.orgの内容が投稿されます．


## qiita template

qiita\_orgで投稿するためのヘッダーがついたorgファイルを取得するコマンドです．

カレントディレクトリにtemplate.orgを作成します．
すでにtemplate.orgがある場合は作成されません．


# future features

-   qiita post => refactoring

-   configに登録する、git edit global. editor, mail, users&#x2026;
-   qiita config access\_token hogehoge
-   qiita config teams hogehoge
-   giita config =>  configを表示

-   cui, 変数名を適切に選ぶ，teams\_path -> teams\_url
-   qiita getの実装，

