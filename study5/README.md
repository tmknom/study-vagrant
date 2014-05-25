プラグインとボックス
============================

## プラグインの基礎知識

Vagrantはプラグインで機能拡張ができる。

便利なプラグインが色々公開されているので、ぜひ活用していこう。

簡単ではあるけど、プラグインの基本コマンドを確認しよう。


### プラグインのインストール／アンインストール

コマンドはたったこれだけ。

```bash
$ vagrant plugin install <plugin_name>
$ vagrant plugin uninstall <plugin_name>
```

### インストール済みのプラグインの確認

何入れてたっけなーって思ったらコレ。

```bash
$ vagrant plugin list
```

では、基本を抑えたところで、実際にプラグインを使ってみよう！


## sahara プラグインを試してみる

Vagrantの設定を試行錯誤していると、あーなんかおかしくなったー！ってなる時あるよね。

そんな時にsaharaプラグインを使うと、以前の状態までロールバックができるぞ！！

早速プラグインをインストールしてみよう。

```bash
$ vagrant plugin install sahara
```

これで完了だ。

では、saharaを試してみるべく、いつものヤツを実行して下準備をしておこう。

```bash
$ mkdir study5
$ cd study5
$ vagrant init precise64 http://files.vagrantup.com/precise64.box
$ vagrant up
```

では、saharaを起動してみよう。

```bash
$ vagrant sandbox on
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
```

ステータスを確認してみよう。

```bash
$ vagrant sandbox status
[default] Sandbox mode is on
```

OK。正常に動いているようだね！

では、ゲストOSにログインして、適当なコマンドをインストールしてみよう。

ここでは、全世界の開発者が愛してやまない *sl* コマンドをインストールするよ！

```bash
$ vagrant ssh
vagrant@precise64:~$ sudo apt-get install sl
vagrant@precise64:~$ sl
vagrant@precise64:~$ exit
```

これで、ぼくらの大好きな *sl* コマンドがインストールされた最強の環境ができた！

この幸せは絶対に失いたくないよね！！

では、コミットして変更を保存しよう。

```bash
$ vagrant sandbox commit
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100% 
```

次に、断腸の思いではあるけども、 *sl* コマンドを削除してみよう。

```bash
$ vagrant ssh
vagrant@precise64:~$ which sl
/usr/games/sl
vagrant@precise64:~$ sudo rm /usr/games/sl
vagrant@precise64:~$ sl
The program 'sl' is currently not installed.  You can install it by typing:
sudo apt-get install sl
vagrant@precise64:~$ exit
```

あーん！スト様が死んだ！

自分でやったこととはいえ、悲しすぎるだろ、常識的に考えて。。。

涙でディスプレイがよく見えないかもしれないけども、頑張ってこのコマンドを叩こう！


```bash
$ vagrant sandbox rollback
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
```

本当に戻ってくれたかな？確認してみよう。

```bash
$ vagrant ssh
vagrant@precise64:~$ sl
```

＼(((￣(￣(￣▽￣)￣)￣)))／ﾔｯﾀｰ!!

見事元通りになってくれた！

saharaプラグインさえあれば、 *sl* コマンドを二度と失わずに済むことが「言葉」でなく「心」で理解できた！！


## オススメのプラグイン

sahara以外の特に便利なプラグインを紹介するぞ！

これさえ入れておけば、Vagrantでのワンダフルライフは約束されたも同然だ！！

* vagrant-omnibus
 * Vagrant起動時に自動でChefをインストールしてくれる。
 * Vagrant×Chefの組み合わせで使う場合にはマストアイテムだ！
* vagrant-cachier
 * *yum* コマンドや *apt-get* コマンドなどで取得してきたモジュールをローカルにキャッシュしてくれる。
 * 仮想環境を何度も作って壊してを繰り返す場合（Chef弄ってる時とか）、これを入れておけば多少高速化してくれるぞ。
* vagrant-vbguest
 * *vagrant up* をしたときにVirtualBoxのGuest Additionが古いってwarningが出た時に。
 * これを使うと、Guest Additionを新しくしてウザいwarningを消してくれる。



## ボックス

ボックスは、Vagrantが作成する環境のベースになるイメージだ。

必ずインストールするモノがある場合は、*vagrant up* をするたびにインストールするのではなく、
事前にインストールが完了しているイメージファイルを作成することで、 *vagrant up* の時間を短縮できるぞ！

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

ここでは、先ほど作成した *sl* コマンドインストール済みのボックスを作成してみよう。といっても、やることは


```bash
$ vagrant package
```

これだけだ。簡単だね！

この処理は結構時間がかかるので気長に待とう。

しばらく待てば、*package.box* というファイルができているはずだ。

```bash
$ ls
Vagrantfile	package.box
```

バッチリだ！

次にボックスを追加してみよう。

```bash
$ vagrant box add i-love-sl package.box
...
==> box: Successfully added box 'i-love-sl' (v0) for 'virtualbox'!
```

ここでは *i-love-sl* って名前のボックスを作ってみたよ。

確認しよう。


```bash
$ vagrant box list
i-love-sl           (virtualbox, 0)
precise64           (virtualbox, 0)
```

ボックスが追加されてるね！

では、このタイミングで後始末をしておこう。

*du* コマンドで確認すると分かるけど、*package.box* はサイズが大きいので、忘れないうちに削除してしまおう。

```bash
$ du -h package.box
340M    package.box
$ rm package.box
```

新しく作ったボックスを試す前に、一旦クリーンアップしておこう。


```bash
$ vagrant destroy --force
$ rm Vagrantfile
```

では、先ほど作ったボックスを使ってみよう。

ここでのポイントは、*vagrant init* の引数に、さっき作ったボックスを指定することだ！


```bash
$ vagrant init i-love-sl
$ vagrant up
$ vagrant ssh
vagrant@precise64:~$ sl
```

よし、OKだ！これでいつでも *sl* コマンド堪能することできる。最高だね！！

最後に、ボックスの削除方法だけど


```bash
$ vagrant box remove i-love-sl
...
default (ID: 9104a6f794ba4913af22367bcceeaea2)

Are you sure you want to remove this box? [y/N] y
```

こうすれば、削除される。確認しよう。

```bash
$ vagrant box list
precise64 (virtualbox)
```

削除できた。

ボックスは小さいものでも数百メガとかあって、ディスク領域の無駄なので、使わないものは削除しよう。


