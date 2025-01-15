# チーム開発の運用

## push 前にやること

### Lint チェック

push する前にローカル環境で Lint エラーがないか以下のコマンドを実行して Lint エラーがないことを確認して push ください。

```
docker compose exec web bundle exec rubocop
```

### develop の変更分をローカル環境へ

自分が develop から作業ブランチを切った後に develop に merge された内容を pull してから push してください。
作業内容は以下の通りです。(switch は checkout でも可)

```
git switch develop
git pull origin develop
git switch 作業ブランチ
git merge develop
```

## プルリクエストについて

作業者、レビュアー、merge 者の役割は以下の通りです。

| 作業者                                                       | レビュアー                                                                                                                         | merge 者                                                                                          |
| ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| PR を作成し、レビュアー 2 人から LGTM がもらえるまで作業実施 | PR をレビューして問題なければ LGTM、改善点があればその内容をコメント。また 2 人目(@kogoro06さん)の LGTM を出す人は同時に develop ブランチへ merge | develop ブランチが問題なければ mian ブランチへ merge を行う。その際に該当箇所の作業ブランチを削除 |
