Vagrant超入門
=============

Vagrant初心者向けに解説するよ！

## 目次

1. [Vagrantの世界へようこそ！](https://github.com/tmknom/study-vagrant/tree/master/study1)
1. [基本コマンドとVagrantfileによる設定](https://github.com/tmknom/study-vagrant/tree/master/study2)
1. [自動プロビジョニングに挑戦しよう](https://github.com/tmknom/study-vagrant/tree/master/study3)
1. [複数サーバを一発で立ち上げる！](https://github.com/tmknom/study-vagrant/tree/master/study4)
1. [プラグインを活用しよう](https://github.com/tmknom/study-vagrant/tree/master/study5)
1. [ボックスを自作する](https://github.com/tmknom/study-vagrant/tree/master/study6)
1. [Vagrant Shareでデモ環境を構築する！](https://github.com/tmknom/study-vagrant/tree/master/study7)


## 事前準備

1.VirtualBoxのインストール
 * <https://www.virtualbox.org/>

2.Vagrantのインストール
 * <http://www.vagrantup.com/>

3.使用する仮想OSのイメージファイル(Box)のダウンロードコマンドの実行
```bash
 $ vagrant box add precise64 http://files.vagrantup.com/precise64.box
```


## 想定環境 

* Mac OS X
* 確認したバージョン
 * Vagrant：1.6.2
 * VirtualBox：4.3.12


## 注意事項

* 紹介しているコマンドや設定は、できればコピペではなく手打ちしよう
 * タイポ等のミスでどんなエラーメッセージが出るのか見るのも勉強になる
 * エラーメッセージを読みながら、デバッグすると、学習効果が飛躍的に高まるぞ！
* セキュリティ？なにそれ美味しいのって感じなので、そのつもりで
 * あくまで勉強用なんだからね！＞＜


## 情報源

* 公式ドキュメント
 * <http://docs.vagrantup.com/v2/>
 * 動かないぞ(ﾟДﾟ)ｺﾞﾙｧ！って場合にはココを確認しよう。英語だけどね :-)
 * だいたいの問題は公式ドキュメントで解決する。あとはググれ。
* 実践 Vagrant
 * <http://www.oreilly.co.jp/books/9784873116655/>
 * 日本語でまとまった情報が読める貴重な書籍。
 * とても分かりやすいので、ぜひ読もう！
