# DeadStockManager-Spec

複数店舗の薬局で、不動在庫・期限切迫品・経過措置品を一元管理するシステム（Google スプレッドシート＋Google Apps Script）の**シート定義書（公開版）**。

法人内での店舗間移動を優先し、成立しなければ外部の薬局へ譲渡する。その判断から見積・価格確定・引渡・代金受領・譲渡記録までを追跡するための、シート構成・列定義・ステータス遷移・権限設計をまとめている。

## 収録物

| ファイル | 内容 |
| --- | --- |
| [シート定義書.md](シート定義書.md) | 定義書の本文（Markdown） |
| [シート定義書.pdf](シート定義書.pdf) | 同じ内容の PDF（A4） |
| [status-transition.svg](status-transition.svg) | ステータス遷移図（13状態） |
| [tools/](tools/) | PDF 生成スクリプトとスタイル |

## 公開にあたっての注意

- 社名・店舗名・取引先名・地域名・作成者名は伏せ字（○○、△△）に置き換えている。
- 掛率・日数などの数値は検討段階の仮置きで、実運用の条件を示すものではない。
- 規制区分（向精神薬・毒薬・劇薬など）の扱いは未確定。法令上の要件は所管の保健所や関係法令で確認すること。

## PDF の再生成

必要なもの: [pandoc](https://pandoc.org/)、Microsoft Edge または Google Chrome（ヘッドレス印刷に使用）

```bash
bash tools/build-pdf.sh
```

既定では Edge（`C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe`）を使う。別のブラウザを使う場合は環境変数 `BROWSER` にパスを指定する。

```bash
BROWSER="/c/Program Files/Google/Chrome/Application/chrome.exe" bash tools/build-pdf.sh
```

## トリガー

なし（文書のみのリポジトリ）。
