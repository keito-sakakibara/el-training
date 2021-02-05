# テーブルスキーマ

## Taskモデル
- id : integer
- created_at : datetime
- updated_at : datetime
- title : string
- detail : text
- deadline : datetime
- user_id : integer
- status_id : integer
- priority_id : integer

## Userモデル
- id : integer
- name : string
- password : string
- admin : boolean

## Statusモデル
- id : integer
- status : integer

## Priorityモデル
- id : integer
- priority : integer

## Labelモデル
- id : integer
- name : string

## TaskLabelRelationship
- id         : integer
- task_id :integer
- label_id : integer

# Ruby on Rails on Docker

## Ruby version
 - [.ruby-version](https://github.com/hihats/ruby-on-rails-pg-on-docker/blob/master/.ruby-version)


## Gem versions
- Ruby on Rails [![Gem Version](https://badge.fury.io/rb/rails.svg)](https://badge.fury.io/rb/rails)

- rubocop [![Gem Version](https://badge.fury.io/rb/rubocop.svg)](https://badge.fury.io/rb/rubocop)

# Setup Dockerized development environment
- Docker環境をローカルマシンに作成
- bundlerでFWなどのパッケージを導入して使用する想定
- RDBMSはPostgreSQLとする

## Installation

[Docker for Mac, Docker for Windows](https://www.docker.com/products/docker-desktop)

dockerコマンド、docker-machineコマンド、docker-composeコマンド全部入り

In case of Mac, You can also use Homebrew
```bash
$ brew install docker
$ brew cask install docker
```

## Initial Setting

### Launch Docker Host OS（docker-machineをつかう場合だけ必要）
```bash
$ docker-machine create --driver virtualbox myrailsapp
$ docker-machine start myrailsapp
```
#### 起動を確認
```bash
$ docker-machine ls
```
#### 接続
```bash
$ docker-machine env myrailsapp
```
`# Run this command to configure your shell:`と出力されるので従う


## Gemfile確認
DefaultではRuby on Rails最低限のGemのみ記載
この上に必要なGemを追加していきます。


## Docker Container build
docker-composeコマンドを使い、複数コンテナをbuild〜起動していく

### コンテナ構成
- app
- db
- node（初期は使わないので削除してもよい）

(設定は`docker-compose.yml`)
```
$ docker-compose build
Successfully built.
```

## Generation packages by rails new
```
$ docker-compose run --rm app rails new . -d postgresql --skip-bundle --skip-turbolinks --skip-test --skip
```

## 起動
```
$ docker-compose up -d
```

コンテナの起動確認
```
$ docker ps
```

## データベースのConnection設定
生成された`config/database.yml`の `development:` 配下に
```
database: <%= ENV['PG_DATABASE'] %>
username: <%= ENV['PG_USER'] %>
password: <%= ENV['PG_PASSWORD'] %>
host: db
```
を追加修正
** postgresのdockerイメージは起動時に初期DBや初期ユーザをよしなに作成してくれることを留意しておく **

[postgresイメージに渡せる環境変数の参照](https://hub.docker.com/_/postgres)

### 設定変更後はコンテナを再起動する
```
$ docker-compose restart app
```

## ブラウザでRailsの起動確認
```
$ open http://0.0.0.0
```
docker-machineの場合
```
$ open http://$(docker-machine ip myrailsapp)
```
Railsの初期画面が表示されればSetup Complete



## Gemfileに変更があった場合
変更をローカルにマージ後

```
$ docker-composer build
```
buildし直すことで、DockerfileのAddがGemfile&Gemfile.lockのキャッシュから更新があったときのみ検知してbundle install が走る


## 既存問題点

###  Docker machine のホスト時刻がずれて、Railsの更新が反映されない問題

http://qiita.com/pocari/items/456052a291381895f8b3

Dockerマシンの中に入って
```bash
$ docker-machine ssh ****
```

VirualBoxの設定変更
```bash
$ sudo VBoxControl guestproperty set "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold" 5000
```



###  Docker inorify issue

 `reach limit of inotify count in rails console` Error Message

[Increasing the amount of inotify watchers](https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers)

```bash
$ echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p
$ cat /proc/sys/fs/inotify/max_user_watches
```
Dockerfileに組み込みたいが、Privilegedで起動扠せねばならぬ問題があるため、起動時に叩くシェルを作るか
