# followers-observer
`followers-observer`は、指定されたTwitterユーザーのフォロワーに対して追加されたフォロワーと削除されたフォロワーを監視し、差分を表示するBashスクリプトです。

## 前提条件
- Twitter APIのBearerトークンが必要です。[Twitter Developer Portal](https://developer.twitter.com/)でアプリを作成し、Bearerトークンを取得してください。
- シェル環境がインストールされていることが前提です(Bash、Zshなど)。
- `curl`がインストールされている必要があります。インストールされていない場合は、パッケージマネージャを使ってインストールしてください。

## 使い方
1. このリポジトリをクローンまたはダウンロードして、ローカルマシンに保存します。
```bash
git clone https://github.com/ver-1000000/followers-observer.sh
```
2. `followers-observer.sh`に実行権限を与えます。
```bash
chmod +x followers-observer.sh
```
3. スクリプトを実行します。`--user-id`(または`-u`)オプションでユーザーIDを、`--bearer-token`(または`-t`)オプションでBearerトークンを指定してください。
```bash
./followers-observer.sh --user-id=000000 --bearer-token=XXXXXX
```
または短いオプション名を使用して：
```bash
./followers-observer.sh -u 000000 -t XXXXXX
```

スクリプトを実行すると、追加されたフォロワーと削除されたフォロワーが表示されます。また、`followers.json`という名前のファイルにフォロワーのリストが保存され、以前のフォロワーリストは`followers.backup.yyyyMMdd.json`という形式でバックアップされます。

## ライセンス
このプロジェクトはMITライセンスの下で公開されています。詳細については、[LICENSE](LICENSE)ファイルを参照してください。
