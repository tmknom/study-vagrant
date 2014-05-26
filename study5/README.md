プラグインを活用しよう
======================

## プラグインの基礎知識

Vagrantはプラグインで機能拡張ができる。

便利なプラグインが色々公開されているので、ぜひ活用していこう。

簡単ではあるけど、プラグインの基本コマンドを確認しよう。


### インストール／アンインストール

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

もちろん、ここで紹介した以外にも色々なプラグインが公開されてるので、積極的に探してみよう。

ここでは紹介しないけど、自分でプラグインを自作することもできるぞ！

興味のある人は[実践 Vagrant](http://www.oreilly.co.jp/books/9784873116655/)を読んでみるといい。

