自動プロビジョニングに挑戦！
===========================

自動プロビジョニングにチャレンジするよ！

## 事前準備

study2で作成したファイルを流用するってのでもOK。

```bash
$ mkdir study3
$ cd study3
$ vagrant init precise64 http://files.vagrantup.com/precise64.box
```

Vagrantfileを下ごしらえ。初期状態との違いは、ネットワーク設定が入っている箇所だけだ。

これは後でApacheをインストールするときに使うことになる設定だよ。

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :forwarded_port, guest: 80, host: 8080
end
```

んで、あとはいつものごとく

```bash
$ vagrant up
```

これで準備は整った。


## 手動でApacheをセットアップ

まずは手動でApacheを設定してみよう。

なお、この手順はぜひコピペではなく、ぜひ自分で手打ちして欲しい。

そのほうが、自動化した時の嬉しさが跳ね上がるのだ！（・∀・）

```bash
$ vagrant ssh
vagrant@precise64:~$ sudo apt-get install -y apache2
vagrant@precise64:~$ sudo rm -rf /var/www
vagrant@precise64:~$ sudo ln -fs /vagrant /var/www
vagrant@precise64:~$ exit
$ echo "Hello, Manual Provisioning." > index.html
```

ここでやってることを軽く解説。

1. *apt-get*コマンドでApache2をインストール
1. Apache2のルートディレクトリの*/var/www*に対し、ゲスト側のデフォルト共有ディレクトリである*/vagrant*からシンボリックリンクを張る
1. 共有ディレクトリに動作確認用のHTMLファイルを作成

んでは、確認のためにブラウザで<http://localhost:8080/>を開いてみよう。

「Hello, Manual Provisioning.」って表示されてれば成功だ！


## 自動プロビジョニングでApacheをセットアップ

ちゃんと、自分でコマンドを打ってセットアップしてみたかな？

OK、今度は手動設定した内容を完全自動化するよ！

まずは、*provision.sh*という名前のファイルにさっきの内容を記述しよう。

```bash
#!/usr/bin/env bash

echo "Apache provisioning start ..."
apt-get install -y apache2
rm -rf /var/www
ln -fs /vagrant /var/www
echo "Hello, Auto Provisioning." > /vagrant/index.html
echo "Apache provisioning end ..."
```

さっきと違い*sudo*がないのは、Vagrantはこのスクリプトをrootとして実行するからだよ。

また、indexファイルの出力先は*/vagrant*ディレクトリ配下にしてることに注意。

ちなみに最初と最後の*echo*コマンドはなくても全然構わないけど、雰囲気が出るので入れてみたよ！

これで、シェルスクリプトが準備できたので、Vagrantfileのどこかに↓を追記しよう。

```ruby
config.vm.provision :shell, path: "provision.sh"
```

Vagrantfileは最終的にこんな感じになる。

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.provision :shell, path: "provision.sh"
end
```

では、確認！の前に、一旦クリーンな状態に戻しておこう。

```bash
$ vagrant destroy --force
```

さあ、全ての準備は整った。

最後に正座して、いつものコマンドを叩こう。

```bash
$ vagrant up
```

手動で設定した時と同様に、ブラウザで<http://localhost:8080/>を開いてみよう。

「Hello, Auto Provisioning.」が表示されれば成功だ！さあ、祝杯をあげよう！！

<span style="font-family: IPAMonaPGothic,'ＭＳ Ｐゴシック',sans-serif;font-size:16px;line-height:18px;">
　　　☆ *　. 　☆ <br>
　　☆　. ∧＿∧　∩　* ☆ <br>
ｷﾀ━━━( ・∀・)/ . ━━━！！<br>
　　　. ⊂　　 ノ* ☆ <br>
　　☆ * (つ ノ .☆ <br>
　　　　 (ノ<br>
</span>


これで僕たちは開発環境のセットアップを完全に自動化する能力を手に入れたことになるぞ！

プロジェクトに新しいメンバーが来た時にやることは、*git clone*して、*vagrant up*するだけだ！

メンバー間の環境差異で謎のエラーが起きるなんてことはもはや存在しないのだ！！

そう、Vagrantならね(｀･ω･´) ｂ　　ﾋﾞｼｯ！！ 



