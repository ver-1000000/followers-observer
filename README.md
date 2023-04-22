# followers-observer
`followers-observer`は、指定されたTwitterユーザーのフォロワーに対して追加されたフォロワーと削除されたフォロワーを監視し、差分を表示するCLIプログラムです。
TypeScriptで実装されています。

## 前提条件
- Twitter APIのBearerトークンが必要です。[Twitter Developer Portal](https://developer.twitter.com/)でアプリを作成し、Bearerトークンを取得してください。
- npmが利用できる環境が前提です。

## 使い方
1. このリポジトリをクローンまたはダウンロードして、ローカルマシンに保存します。
```bash
$ git clone https://github.com/ver-1000000/followers-observer
```
2. プロジェクトの依存パッケージをインストールします
```bash
$ npm ci
```
3. スクリプトを実行します。`--user-id`(または`-u`)オプションでユーザーIDを、`--bearer-token`(または`-t`)オプションでBearerトークンを指定してください。
```bash
$ npm start -- --user-id=000000 --bearer-token=XXXXXX
```
または短いオプション名を使用して：
```bash
$ npm start -- -u 000000 -t XXXXXX
```

スクリプトを実行すると、追加されたフォロワーと削除されたフォロワーが表示されます。
そして、`followers.old.json`という名前のファイルにフォロワーのリストが保存されます。
(初回起動以降は、このファイルとAPIで取得したフォロワー情報を突き合わせて情報を計算します。)

## ライセンス
このプロジェクトはMITライセンスの下で公開されています。詳細については、[LICENSE](LICENSE)ファイルを参照してください。
