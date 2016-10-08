# Chinachu with Mirakurun Sleep Scripts (β)

## Overview

Chinachu with Mirakurun なサーバ向け自動休止スクリプト群。

「[Chinachu Sleep Scripts (β)](https://github.com/gcch/Chinachu-Sleep-Scripts "GitHub - gcch/Chinachu-Sleep-Scripts")」の改良 (劣化？) 版。

ちゃんと動かない可能性あり。


## Description

「[Chinachu Sleep Scripts (β)](https://github.com/gcch/Chinachu-Sleep-Scripts "GitHub - gcch/Chinachu-Sleep-Scripts")」と基本動作は同じ。全体的に荒削りだったスクリプトを書き直し、Mirakurun チェック部分を加えた。

API を叩くスクリプトをすべてシェルスクリプトで書き直したため、Python 3 は不要となった。 (※ curl で API 経由の情報取得を行っている。)

そんなこんなで色々とコード的に変更点が多いので、「[Chinachu Sleep Scripts (β)](https://github.com/gcch/Chinachu-Sleep-Scripts "GitHub - gcch/Chinachu-Sleep-Scripts")」とは別リポジトリとした。


## Test environment

### Hardware & operating system

* FUJITSU Server PRIMERGY TX1310 M1 (Pentium G3420, 4 GB RAM) + Earthsoft PT3 Rev.A

```
$ cat /etc/centos-release
CentOS Linux release 7.2.1511 (Core)
```

CentOS 7 がテスト環境であるが、公式推奨の Debian とか、その派生の Ubuntu とかでも動かせないことはないはず。

### Software

- Mirakurun with Rivarun on Chinachu Beta
 - [Chinachu Beta](https://github.com/Chinachu/Chinachu "GitHub - Chinachu/Chinachu: Most Lovely DVR Software in Japan.")
 - [Rivarun](https://github.com/Chinachu/Rivarun "GitHub - Chinachu/Rivarun: A Simple Mirakurun Client Implementation like recpt1.") (v1.2.0)
 - [Mirakurun](https://github.com/Chinachu/Mirakurun "GitHub - Chinachu/Mirakurun: A Modern DTV Tuner Server Service.") (v2.0.0 beta 0)


## Components

Chinachu with Mirakurun Sleep Script を構成ファイルたち。[] は、フォルダ内のファイルがインストール後に配置される場所を表している。

- main/
  - cron/ [/etc/cron.d]
    - chinachu-mirakurun-ss-cron (スリープ移行確認ジョブ用 cron。)
  - etc/ [/usr/local/etc/chinachu-mirakurun-ss]
    - config (設定ファイル。すべての設定はココに。各 lib 内スクリプトが読み込みに行く。)
  - lib/ [/usr/local/lib/chinachu-mirakurun-ss]
    - chinachu-api-count-connection (Chinachu WUI 接続中のユーザ数をカウントするスクリプト。)
    - chinachu-api-get-top-reserve-time (近々の録画予約開始時間出力スクリプト。)
    - chinachu-api-is-recording (Chinachu の録画状況取得スクリプト。)
    - chinachu-mirakurun-sleep (電源管理マネージャ用のスクリプト。起動および停止移行時に実行される。次回起動タイマー設定が主な目的。)
    - chkstatus (スリープ移行可能状況確認スクリプト。確認項目を増やしたい場合には、ココを編集。cron のジョブで参照。)
    - mirakurun-api-sum-stream-count (Mirakurun がストリーム処理中かを確認するスクリプト。)
    - sleepcmd (電源管理マネージャに合わせた、休止 or シャットダウンコマンド実行スクリプト。cron のジョブで参照。)
  - install.sh (インストールスクリプト。)
  - uninstall.sh (アンインストールスクリプト。)
- extra/
  - recpt1test.sh (おまけ1。recpt1 録画テストスクリプト。)
  - rivaruntest.sh (おまけ2。rivarun 録画テストスクリプト。)
  - update-mirakurun.sh (おまけ3。Mirakurun & Rivarun 更新スクリプト。)
- README.md (このファイル。)
- LICENSE.md (ライセンスファイル。)


## Usage

### Install

pm-utils のインストール。systemd (RHEL / CentOS 7 以降) 環境であれば、正直不要。

```
# yum install pm-utils        # for RHEL / CentOS users
# apt-get install pm-utils    # for Debian / Ubuntu users
```

作業フォルダに移動。

```
# cd /usr/local/src
```

クローン。

```
# git clone --depth 1 https://github.com/gcch/Chinachu-Mirakurun-SS.git ./chinachu-mirakurun-ss
```

移動。

```
# cd chinachu-mirakurun-ss/main/
```

インストールを開始する。エラーが出なければ問題なし。

```
# chmod +x install.sh
# ./install.sh
```

設定ファイルを弄る。 (詳細は中身を参照。Chinachu と Mirakurun のホスト名とポート番号は少なくとも編集が必要かと。)

```
# vi /usr/local/etc/chinachu-mirakurun-ss/config
```

これで準備完了。/etc/cron.d 配下に定期監視スクリプトが入っていること、/usr/local/lib/chinachu-mirakurun-ss 配下に状況チェック用のスクリプトが入っていれば問題ないはず。

### Uninstall

不要になったら、アンインストールスクリプトを叩けばOK。

```
# chmod +x uninstall.sh
# ./uninstall.sh
```

## License
This script is released under the MIT license. See the LICENSE file.


## Author
* tag (Twitter: [@tag_ism](https://twitter.com/tag_ism "tag (@tag_ism) | Twitter") / Blog: http://karat5i.blogspot.jp/)
