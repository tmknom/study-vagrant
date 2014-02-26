プラグインとボックス
============================

## プラグイン

Vagrantはプラグインで機能拡張ができる。

便利なプラグインが色々公開されているので、ぜひ活用していこう。

もちろん、プラグインを自作することだってできるのだ！（ここではやらないけどねｗ


## vagrant-vbguest プラグインを試してみる

*vagrant up* コマンドを叩いた時に、こんな表示が出る場合がないだろうか？

```bash
$ vagrant up
...
[default] Machine booted and ready!
[default] The guest additions on this VM do not match the installed version of
VirtualBox! In most cases this is fine, but in rare cases it can
prevent things such as shared folders from working properly. If you see
shared folder errors, please make sure the guest additions within the
virtual machine match the version of VirtualBox you have installed on
your host and reload your VM.

Guest Additions Version: 4.2.0
VirtualBox Version: 4.3
...
```

これは利用しているVirtualBoxのバージョンと、ゲストOSの *Guest Addition* のバージョンがずれていることが原因だ。

外部で拾ってきたOSを使うと、まれによくある現象なのだ！

この問題は *vagrant-vbguest* プラグインを使えば解決できる。

早速プラグインをインストールしてみよう。

```bash
$ vagrant plugin install vagrant-vbguest
```

これで完了だ。

で、このプラグインをこのまま使うと、仮想マシン起動時に、自動で *Guest Addition* を最新にしようとして、それはそれで鬱陶しいので、自動更新を抑制する設定を書いておこう。

*~/.vagrant.d/Vagrantfile* に次の内容を書いておこう。

ちなみに、ファイルがない場合は作成してね。（*~/.vagrant.d/* ディレクトリはあるはずだ）

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vbguest.auto_update = false
end
```

では、*vagrant-vbguest* プラグインを試してみよう。

```bash
$ vagrant vbguest --status
...
GuestAdditions versions on your host (4.3.6) and guest (4.2.0) do not match.
```

もし、こんな感じで表示されたら、*Guest Addition* が古いので更新してみよう。

```bash
$ vagrant vbguest --do install
```

次に、仮想マシンに反映しよう。

```bash
$ vagrant reload
```

それじゃ、確認だ。

```bash
$ vagrant vbguest --status
...
GuestAdditions 4.3.6 running --- OK.
```

こんな感じの表示がされればOKだ！



## ボックス

ボックスは、Vagrantが作成する環境のベースになるイメージだ。

必ずインストールするソフトウェアがあったり、必ず設定する項目があったりする場合は、*vagrant up* をするたびに毎回実行するのではなく、実行済のイメージファイルを作成することができる。

例えば、必ずJavaを使うのであれば、予め、Javaをインストールしたボックスを作っておくと、*vagrant up* の時間を短縮できるぞ。

実は、僕たちはすでにボックスを使用している。確認しよう。

```bash
$ vagrant box list
precise64 (virtualbox)
```

*precise64 (virtualbox)* ってボックスがダウンロード済ってことだね。

```bash
$ vagrant init precise64 http://files.vagrantup.com/precise64.box 
```

今までオマジナイ的に叩いてきたこのコマンドの正体がコレだ。

今度はボックスを自分で作ってみよう。

ここでは、全世界の開発者が愛してやまない *sl* コマンドをインストールしたボックスを作成するよ！

```bash
$ vagrant init precise64 http://files.vagrantup.com/precise64.box
$ vagrant up
$ vagrant ssh
vagrant@precise64:~$ sudo apt-get install sl
vagrant@precise64:~$ sl
vagrant@precise64:~$ exit
```

これで、ぼくらの大好きな *sl* コマンドがインストールされた最強のOSができた！

この幸せをいつでも堪能したいよね！！

じゃあ、ボックスを作成してみよう。といっても、やることは


```bash
$ vagrant package
```

これだけだ。簡単だね。

この処理は結構時間がかかるので気長に待とう。

しばらく待てば、*package.box* というファイルができているはずだ。

```bash
$ du -h package.box
340M	package.box
```

バッチリだ！

次にボックスに追加しよう。

```bash
$ vagrant box add local-precise64 package.box
...
Successfully added box 'local-precise64' with provider 'virtualbox'!
```

ここでは *local-precise64* って名前のボックスを作ってみたよ。

確認しよう。


```bash
$ vagrant box list
local-precise64 (virtualbox)
precise64       (virtualbox)
```

ボックスが追加されてるね！

さっき *du* コマンドで確認したとおり、*package.box* はサイズが大きいので、このタイミングで削除してしまおう。

```bash
$ rm package.box
```

じゃあ、早速新しく作ったボックスを使ってみよう。

Vagrantfileができてると思うので、一旦削除して、いつもの手順でいってみよう。

ただし、*vagrant init* で指定するのは、さっき作成したボックスファイルだ！


```bash
$ rm Vagrantfile
$ vagrant init local-precise64
$ vagrant up
$ vagrant ssh
vagrant@precise64:~$ sl
```

よし、OKだ！これでいつでも *sl* コマンドの恩恵を得ることできる。最高だね！！

最後に、ボックスの削除方法だけど


```bash
$ vagrant box remove local-precise64 virtualbox
```

こうすれば、削除される。確認しよう。

```bash
$ vagrant box list
precise64 (virtualbox)
```

削除できた。

ボックスは小さいものでも数百メガとかあって、ディスク領域の無駄なので、使わないものは削除しよう。


