ボックスを自作する
==================

## ボックスって何だ？

ボックスは、Vagrantが作成する環境のベースになるイメージだ。

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


## ボックスの自作にチャレンジ

ではボックスを自分で作ってみよう。

まずはいつも通りの下準備から。

```bash
$ mkdir study6
$ cd study6
$ vagrant init precise64 http://files.vagrantup.com/precise64.box
$ vagrant up
```

ここでは、study5同様 *sl* コマンドをインストールしたボックスを作成してみよう。

では、ゲスト側にログインして、サクッと *sl* コマンドをインストール。

```bash
$ vagrant ssh
vagrant@precise64:~$ sudo apt-get install sl
vagrant@precise64:~$ exit
```

ベースとなるOSが完成したので、ボックスを作成してみよう。といっても、やることは

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

よし、OKだ！これでいつでも *sl* コマンドを堪能することできる。最高だね！！

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


