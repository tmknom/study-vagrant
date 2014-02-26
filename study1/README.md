Hello, Vagrant!
===============

まずはVagrantを体験！

初Vagrant
---------
とりあえず、適当なディレクトリを掘って移動。

```bash
$ mkdir study1
$ cd study1
```

そして、おもむろに以下の２つのコマンドを実行。

```bash
$ vagrant init precise64 http://files.vagrantup.com/precise64.box    
$ vagrant up
```

これだけで、仮想マシンがバックグラウンドで動作している。

では、確認。

```bash
$ vagrant ssh
```

そうしたらこんな感じで表示されるはずだ！

```bash
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Fri Sep 14 06:23:18 2012 from 10.0.2.2
vagrant@precise64:~$
```

もうあとは煮るなり焼くなりしてください。

好きなだけ遊んだら

```bash
vagrant@precise64:~$ exit
```

で、仮想マシンからログアウト。

さらに、今作った仮想マシンを華麗に削除。

```bash
$ vagrant destroy
    
Are you sure you want to destroy the 'default' VM? [y/N] y
```

本当に消していいか聞かれるけど気にせず **"y"** を入力

はい、これで綺麗になりました。簡単すぐる！


Vagrantfileを見てみる
---------------------

Vagrantの設定は、**Vagrantfile** に記述していくよ！

実は*vagrant init*コマンドを叩いた時に作成されてるのでとりあず現状を確認。

```bash
$ cat Vagrantfile
```

色々書いてあるけど「**#**」はコメントなので、実質的に設定を記述しているとこだけ抜いてみよう。

```bash
grep -v -e '^\s*#' -e '^\s*$' Vagrantfile
```

するとこんなふうに出力されるはずだ！

```bash
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
end
```

本当にたったこれだけなんだ。ヤベー、シンプルすぎるわー。マジ、シンプルすぎるわー。

ちなみに、設定の記述は、みんな大好きRubyさんだよ。

とはいえ、Rubyの知識がなくても大丈夫…なはず。

とりあえずここでは、**Vagrantfile** に設定を記述するんだなってことだけ覚えておけばOKだ！
