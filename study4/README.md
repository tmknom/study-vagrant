複数サーバを一発で立ち上げる
============================

## 事前準備

study3で作成したファイルを流用するってのでもOK。

```bash
$ mkdir study4
$ cd study4
$ vagrant init precise64 http://files.vagrantup.com/precise64.box
$ vagrant up
```

## プライベートネットワーク

ネットワークの設定っていったら、ひたすら

```ruby
config.vm.network :forwarded_port, guest: 80, host: 8080
```

これだったわけなんだけど、Vagrantのネットワーク設定はこれ以外の方法も存在する。

Vagrantが提供しているネットワーク設定は３種類あって、色々なユースケースに対応できるようになってるんだ。

1. ポートフォワーディング
1. プライベートネットワーク
1. パブリックネットワーク

で、ここではプライベートネットワークの作り方を説明するよ。

```ruby
config.vm.network :private_network, ip: "192.168.33.10"
```

といっても、これをVagrantfileのどこかに追記するだけだ。

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip: "192.168.33.10"
end
```

Vagrantfileは最終的にこんな感じ。

じゃあ、設定を反映しよう。

```bash
$ vagrant reload
```

正しく設定されたかどうか確認してみよう。

```bash
$ ping 192.168.33.10
PING 192.168.33.10 (192.168.33.10): 56 data bytes
64 bytes from 192.168.33.10: icmp_seq=0 ttl=64 time=0.473 ms
64 bytes from 192.168.33.10: icmp_seq=1 ttl=64 time=0.417 ms
64 bytes from 192.168.33.10: icmp_seq=2 ttl=64 time=0.415 ms
...
```

よし、OKだ！

ホストからゲストにアクセスできるだけでなく、ゲストからホストへのアクセスもできる。

ホストのIPアドレスは、ゲストに設定したIPアドレスの最終オクテットを **1** にしたものだ。

このケースでは *192.168.33.1* になるはずだ。確認してみよう。

```bash
$ vagrant ssh
vagrant@precise64:~$ ping 192.168.33.1
PING 192.168.33.1 (192.168.33.1) 56(84) bytes of data.
64 bytes from 192.168.33.1: icmp_req=1 ttl=64 time=0.190 ms
64 bytes from 192.168.33.1: icmp_req=2 ttl=64 time=0.436 ms
64 bytes from 192.168.33.1: icmp_req=3 ttl=64 time=0.281 ms
...
```

プライベートネットワークを使えば、仮想マシン間で直接通信することができるのだ！



## マルチマシン環境

Vagrantでは複数の仮想マシンを立ち上げることもできるぞ。

さて、先に進む前に、一度既存の仮想マシンを破棄しておこう。

```bash
$ vagrant destroy --force
```

準備ができたので、Vagrantfileを次のように修正しよう。

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.define "web_server" do |web|
  end

  config.vm.define "db_server" do |db|
  end
end
```

もう見たまんまなんだけど、*config.vm.define* という設定ディレクティブが複数の仮想マシンを立ち上げるのに必要な記述だ。

確認しよう。

```bash
$ vagrant up
$ vagrant status
Current machine states:

web_server                running (virtualbox)
db_server                 running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

*web_server* と *db_server* の２つの仮想マシンが立ち上がったね！

ここで、例えば *web_server* だけ再起動したい場合はこんなふうにすればいい。

```bash
$ vagrant reload web_server
```

*web_server* と *db_server* 両方を再起動したい時のコマンドは今まで通りだ。

```bash
$ vagrant reload
```

これで僕たちは、複数の仮想マシンを作成できるようになった。やったね！


## 複数の仮想マシン間の通信

次は立ち上げた仮想マシンがお互いに通信できるようにしてみよう。

さっき学んだプライベートネットワークが早速役に立つぞ！

Vagrantfileを次のように修正しよう。

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.define "web_server" do |web|
    web.vm.network :private_network, ip: "192.168.33.10"
  end

  config.vm.define "db_server" do |db|
    db.vm.network :private_network, ip: "192.168.33.11"
  end
end
```

では、設定を反映しよう。

```bash
$ vagrant reload
```

これで、仮想マシン間で通信ができるようになっているはずだ。

早速確認してみよう。


```bash
$ ping 192.168.33.10
PING 192.168.33.10 (192.168.33.10): 56 data bytes
64 bytes from 192.168.33.10: icmp_seq=0 ttl=64 time=0.473 ms
64 bytes from 192.168.33.10: icmp_seq=1 ttl=64 time=0.341 ms
...

$ ping 192.168.33.11
PING 192.168.33.11 (192.168.33.11): 56 data bytes
64 bytes from 192.168.33.11: icmp_seq=0 ttl=64 time=0.447 ms
64 bytes from 192.168.33.11: icmp_seq=1 ttl=64 time=0.411 ms
...
```

正しく設定できたようだね！

仮想マシン間でも通信できることを確認してみよう。

```bash
$ vagrant ssh web_server
vagrant@precise64:~$ ping 192.168.33.11
PING 192.168.33.11 (192.168.33.11) 56(84) bytes of data.
64 bytes from 192.168.33.11: icmp_req=1 ttl=64 time=0.768 ms
64 bytes from 192.168.33.11: icmp_req=2 ttl=64 time=0.407 ms
...
```

OKだ！

これで、僕たちはVagrantの基本を全て学んだことになる。

それじゃ最後に総仕上げといこう。





## WebサーバとDBサーバを一発で立ち上げる！

まずは、プロビジョニング用のシェルスクリプトを用意しよう。

Webサーバ向けに *web_provision.sh* を作成する。

```bash
#!/usr/bin/env bash

apt-get update
apt-get install -y apache2
apt-get install -y mysql-client
rm -rf /var/www
ln -fs /vagrant /var/www
```

ほとんど、study3で作ったものと同じだ。

違いはMySQLクライアントをインストールしたのと、*echo* コマンドを削除したことだけだ。

次にDBサーバ向けに *db_provision.sh* を作成しよう。

```bash
#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y mysql-server
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf
restart mysql
mysql -uroot mysql <<< "GRANT ALL ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;"
```

簡単に説明しておくと

1. 環境変数DEBIAN_FRONTENDを「noninteractive」にして、MySQLサーバインストール時にrootのパスワードを聞かれるのを抑制
1. *apt-get* コマンドでMySQLサーバをインストール
1. リモートマシンがこのサーバに接続できるように、*sed* コマンドを使って、バインドするアドレスをループバックアドレスから、全てのインタフェースを意味する *0.0.0.0* に変更し、MySQLを再起動
1. MySQLに対してrootで任意のアドレスから許可（危ないから本番でやんなよ！）

ってなことをやってる。

プロビジョニング設定ができたので、Vagrantfileを次のように修正。

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.define "web_server" do |web|
    web.vm.network :private_network, ip: "192.168.33.10"
    web.vm.provision :shell, path: "web_provision.sh"
  end

  config.vm.define "db_server" do |db|
    db.vm.network :private_network, ip: "192.168.33.11"
    db.vm.provision :shell, path: "db_provision.sh"
  end
end
```

この例は、クリーンな状態から始めるようにしよう。

```bash
$ vagrant destroy --force
```

じゃあ、いつものコマンドを叩こう！

```bash
$ vagrant up
```

完全にゼロから全てのマシンをプロビジョニングをしているので、数分かかるかもしれない。

一服しながらしばらく待とう。

終わったら最終確認だ！


```bash
$ vagrant ssh web_server
vagrant@precise64:~$ mysql -uroot -h192.168.33.11
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 37
Server version: 5.5.35-0ubuntu0.12.04.2 (Ubuntu)

Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

おめでとう！大成功だ！！

DBサーバとそれにアクセス可能なWebサーバの構築を完全に自動化することができた！

もちろん実際の開発では、もっときちんと設定する必要があると思う。

でも、この簡単な例でも分かる通り、今や僕たちは、もっと複雑で大規模な環境の構築も自由自在だ！

ぜひここで学んだことをベースに、色々試してもらえると嬉しい。

少しでもこれを読んでくれた人の役に立つことを祈るばかりだ！（・∀・）

Enjoy Vagrant!!!!

