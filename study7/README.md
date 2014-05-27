Vagrant Shareでデモ環境を構築する！
===================================

## Vagrant Cloudにユーザ登録

[Vagrant Cloud](https://vagrantcloud.com/)のページにアクセスして、まずはユーザ登録しよう。

迷うことはないと思うけど、「JOIN VAGRANT CLOUD」ってボタンをクリックすれば登録ページに飛べる。

![Join Vagrant Cloud](http://cdn-ak.f.st-hatena.com/images/fotolife/t/tmknom/20140311/20140311213529.png "Join Vagrant Cloud")

次に、ユーザ名、メールアドレス、パスワードを入力したらユーザ登録は完了だ。

![Vagrant Cloud Sign Up](http://cdn-ak.f.st-hatena.com/images/fotolife/t/tmknom/20140311/20140311213608.png "Vagrant Cloud Sign Up")


## Vagrant Shareでデモ環境を構築

HTTPサーバが必要なので、Vagrantfileにその設定を記述しよう。

ついでに、ここでは確認用のindex.htmlも作ってるよ。

```bash
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.provision "shell", inline: <<-EOT
    apt-get update
    apt-get install -y apache2
    rm -rf /var/www
    ln -fs /vagrant /var/www
    echo "Hello, Vagrant Cloud." > /vagrant/index.html
  EOT
end
```

Vagrantfileを作成したら、いつも通り

```bash
$ vagrant up
```

次に[Vagrant Cloud](https://vagrantcloud.com/)に登録したアカウントでログインする。

```bash
$ vagrant login
......
If you don't have a Vagrant Cloud account, sign up at vagrantcloud.com

Username or Email: ＜ユーザ名入力＞
Password (will be hidden):＜パスワード入力＞
You're now logged in!
```

ユーザ名とパスワードを入力し、*You're now logged in!* って表示されてればログインOKだ！

すべての準備が整ったので、実際にシェアしてみよう。

```bash
$ vagrant share
......
==> default: Checking authentication and authorization...
==> default: Creating Vagrant Share session...
    default: Share will be at: lively-bunny-1387
==> default: Your Vagrant Share is running! Name: lively-bunny-1387
==> default: URL: http://lively-bunny-1387.vagrantshare.com
==> default:
==> default: You're sharing your Vagrant machine in "restricted" mode. This
==> default: means that only the ports listed above will be accessible by
==> default: other users (either via the web URL or using `vagrant connect`).
```

なんか色々出てくると思うけど、一番下の方にURLが書いてあるはずだ。

この例だと *http://lively-bunny-1387.vagrantshare.com* がそれだね。

このURLは毎回変わるので、試すときは、実際に手元で表示されてるURLを使ってほしい。


## 構築したデモを試してみる

じゃあ、表示されたURLをコピってブラウザで表示してみよう。

「Hello, Vagrant Cloud.」って表示されてれば成功だ！

最後に、いらなくなったら停止しよう。

```bash
Ctrl + C
```

これで、さっきのURLにアクセスしても何も出なくなるはずだ。簡単だね！

Vagrant Shareを使うと、スマホとかからもアクセスできて超絶便利なので、どんどん活用しよう！！

