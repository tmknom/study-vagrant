Vagrantの基本コマンドと設定
===============

最低限知っておくべきVagrantの設定とコマンドを紹介するよ！

## 事前準備

とりあえずVagrantの設定を始められるように準備。

study1で作成したファイルを使用するってのでもOK。

```bash
$ mkdir study2
$ cd study2
$ vagrant init precise64 http://files.vagrantup.com/precise64.box    
$ vagrant up
```

## 最小限抑えておくべきコマンド

### 状態の確認

まぁ、よくある書き方だ。

```bash
$ vagrant status
```

するとこんな感じで表示されるはずだ！

```bash
Current machine states:

default                   running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.
```

*running (virtualbox)* となってるので、現在快調に動作中だよ！


### Vagrantの終了方法

#### サスペンド
一時停止。メモリの状態も含めて復元可能。

```bash
$ vagrant suspend
```

確認してみよう。

```bash
$ vagrant status
Current machine states:
    
default                   saved (virtualbox)

To resume this VM, simply run `vagrant up`.
```

* 特徴
 * ディスク超食う。ゲストマシンのハードディスク＋RAM領域分。


#### 停止
シャットダウン。再開時は通常のブートプロセスを経ることになる。

```bash
$ vagrant halt
```

確認してみよう。

```bash
$ vagrant status
Current machine states:
    
default                   poweroff (virtualbox)
    
The VM is powered off. To restart the VM, simply run `vagrant up`
```

正常終了しなかった場合、強制終了も可能。物理的に電源切るのと同じ。

```bash
$ vagrant halt --force
```
 
* 特徴
 * ディスク食う。ゲストマシンのハードディスク領域分。


#### 破棄
[全てを無に返す者。](http://d.hatena.ne.jp/keyword/%C1%B4%A4%C6%A4%F2%CC%B5%A4%CB%CA%D6%A4%B9%BC%D4)

```bash
$ vagrant destroy
Are you sure you want to destroy the 'default' VM? [y/N] y
```

destroy時には本当に実行していいか聞いてくる。気にせず *y* と入力しよう。

確認してみよう。

```bash
Current machine states:

default                   not created (virtualbox)

The environment has not yet been created. Run `vagrant up` to
create the environment. If a machine is not created, only the
default provider will be shown. So if a provider is not listed,
then the machine is not created for that environment.
```


いちいち確認されるのがウザければ

```bash
$ vagrant destroy --force
```

で、有無を言わさず破棄できる。

* 特徴
 * ディスク食わない。
 * 全部消しちゃうので、再開時は時間がかかる。


### Vagrantの再開方法

初回起動時と同じでOK。

```bash
$ vagrant up
```

### 仮想マシンへのログイン

紹介済みだけど改めて。

```bash
$ vagrant ssh
```


## Vagrantfile事始め

### 設定の記述方法

Vagrantの設定は **Vagrantfile** に記述。

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Setting Here!
end
```

ちなみに、Vagrantfileがあるディレクトリを**プロジェクトディレクトリ**って言ったりするから覚えておこう。

### 設定の反映方法

設定を修正したら、それを反映しよう。

```bash
$ vagrant reload
```

設定ファイルだけ修正して終わった気になって、このコマンドを打つのをよく忘れるので注意！



### ファイル共有

デフォルトでは、プロジェクトディレクトリを、仮想マシンの */vagrant* ディレクトリと共有するよ。

まずはホスト側で適当にファイルを作って、仮想マシンにログインして確認してみよう。

この例では現時刻をファイルに書き込んで、それを共有してみた。

```bash
$ date > synced_file
$ cat synced_file
2014年 3月 7日 金曜日 08時26分33秒 JST
$ vagrant ssh
vagrant@precise64:~$ ls /vagrant/
synced_file  Vagrantfile
vagrant@precise64:~$ cat /vagrant/synced_file
2014年 3月 7日 金曜日 08時26分33秒 JST
```

確かに共有されてるね！

もちろん、任意のディレクトリに設定を変更可能。

まずは下ごしらえ。

```bash
$ mkdir host_dir
$ echo "hello, guest" > host_dir/from_host.txt
```

次にVagrantfileを適当なテキストエディタで開いて

```ruby
config.vm.synced_folder "host_dir/", "/guest_dir"
```

を追記。じゃあ、確認してみよう。

```bash
$ vagrant reload
$ vagrant ssh
vagrant@precise64:/$ ls /
bin   dev  guest_dir  initrd.img  lib64       media  opt   root  sbin     srv  tmp  vagrant  vmlinuz
boot  etc  home       lib         lost+found  mnt    proc  run   selinux  sys  usr  var
vagrant@precise64:/$ ls /guest_dir/
from_host.txt
vagrant@precise64:/guest_dir$ cat /guest_dir/from_host.txt
hello, guest
```

もちろん、ゲスト側からホスト側へもファイルは共有できる。

```bash
vagrant@precise64:~$ echo "hello, host" > /guest_dir/from_guest.txt
vagrant@precise64:~$ ls /guest_dir/
from_guest.txt  from_host.txt
vagrant@precise64:~$ exit
$ ls host_dir
from_guest.txt	from_host.txt
$ cat host_dir/from_guest.txt
hello, host
```

この機能を使えば、ソースの修正はいつも使ってるエディタでやって、動作の確認は仮想マシンで、なーんてのも楽勝だよね。

さて、２点ほど注意点。

* ホスト側のディレクトリは作成済みであること
* ゲスト側のディレクトリは絶対パスのみ記述可能

これを守らないと、Vagrantさんは激おこなのだ。



### 基本的なネットワーク設定

ネットワーク設定も簡単。

```ruby
config.vm.network :forwarded_port, guest: 80, host: 8080
```

これで、ゲストの80ポートをホストの8080ポートに、フォワードしてくれる。

確認してみよう。

```bash
$ vagrant reload
$ echo "Hello, Vagrant." > index.html
$ vagrant ssh
vagrant@precise64:~$ cd /vagrant
vagrant@precise64:~/vagrant$ sudo python -m SimpleHTTPServer 80
Serving HTTP on 0.0.0.0 port 80 ...
```

ホスト側でブラウザを立ち上げて、<http://localhost:8080/>を開いてみよう。

「Hello, Vagrant.」って表示されれば完璧！

ネットワークの設定は後で、もう少し詳しい内容をやるよ。

