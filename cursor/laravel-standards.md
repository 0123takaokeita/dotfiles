---
created: 2026-02-28T12:14
updated: 2026-03-01T11:54
---
# Laravel コーディング規約

## 概要

- DDD や厳格なクリーンアーキテクチャはオーバースペック。`app/UseCases` を切り、ドメインごとに単一責務のクラスを置く。
- Repository パターンを無理に導入せず、**UseCase で Eloquent Model を使うことを許容する**。
- Controller は薄く、Form Request / Policy / Resource で責務を分ける。**例外処理は Handler で共通化し、Controller で try-catch を書きまくらない。**
- **基本は Laravel の仕組みに合わせて実装する**（通知・決済・認証に限らない。後述）。
- **開発は TDD を基本とする**。実装前にテストを書く（または既存テストを更新する）。詳細は「テスト」の節を参照。

---

## ディレクトリ構成

**参考（どこに何を置くか）:**

```
app/
├── Exceptions/
│   └── Handler.php              # ドメイン例外 → HTTP の変換をここに集約
├── Http/
│   ├── Controllers/             # 薄く。UseCase 呼び出しと Resource 返却だけ
│   ├── Requests/                # Form Request（ドメイン/アクションごとに分ける）
│   │   └── Post/
│   │       ├── StoreRequest.php
│   │       └── UpdateRequest.php
│   ├── Resources/               # API レスポンス整形
│   └── Middleware/
├── Enums/                       # 固定値の列挙（status, type など）。PHP 8.1 enum
├── Models/                      # Eloquent Model。リレーションと @property 程度
├── Policies/                    # 認可
├── Providers/
├── Services/                    # インフラ層（S3 など）。ドメインロジックは UseCases へ
└── UseCases/
    └── Post/
        ├── StoreAction.php      # 1 アクション 1 クラス、__invoke
        ├── UpdateAction.php
        └── Exceptions/
            └── PostLimitExceededException.php
```

**テストの配置（参考）:**

```
tests/
├── Feature/                    # HTTP で叩く E2E。エンドポイント単位で「つながり」を確認
│   └── PostControllerTest.php
├── Unit/
│   ├── UseCases/               # UseCase のテスト（中心に書く）
│   │   └── Post/
│   │       └── StoreActionTest.php
│   └── Models/                 # リレーション・スコープなど Model にロジックがある場合
│       └── PostTest.php
└── TestCase.php
```

- **ドメインサービス**: ほぼ `app/UseCases` で解決。インフラは `app/Services`。

---

## どこに何を書くか（サンプル）

**Controller（薄く。try-catch は書かない）**

```php
// app/Http/Controllers/PostController.php
public function store(StoreRequest $request, StoreAction $action, Community $community): PostResource
{
    $post = $request->makePost();
    return new PostResource($action($request->user(), $community, $post));
}
```

**UseCase（1 アクション 1 クラス、__invoke。ドメイン例外は throw するだけ）**

```php
// app/UseCases/Post/StoreAction.php
public function __invoke(User $user, Community $community, Post $post): Post
{
    assert($user->exists && $community->exists && !$post->exists);
    // ドメインバリデーション。NG なら PostLimitExceededException などを throw
    $post->user()->associate($user);
    $post->community()->associate($community);
    $post->save();
    return $post;
}
```

**Form Request（バリデーション・認可。作成と更新は別クラスでコピペ）**

```php
// app/Http/Requests/Post/StoreRequest.php
public function rules(): array { return ['title' => 'required|string|max:30', 'body' => 'required|string']; }
public function makePost(): Post { return new Post($this->validated()); }
```

**Handler（ドメイン例外 → HTTP にまとめて変換）**

```php
// app/Exceptions/Handler.php の render 内など
if ($e instanceof PostLimitExceededException) {
    return response()->json(['message' => $e->getMessage()], 429);
}
```

**Resource（属性を列挙。parent::toArray() は使わない）**

```php
// app/Http/Resources/PostResource.php
public function toArray($request): array
{
    return [
        'id' => $this->id,
        'title' => $this->title,
        'body' => $this->body,
        'created_at' => $this->created_at,
    ];
}
```

---

## Controller の役割

薄く保つ。次のオーケストレーションのみ行う。

1. Form Request でリクエストを受け取る（バリデーション・認可は Form Request / Policy に委譲）
2. UseCase を呼び出す
3. API Resource でレスポンスを返す

ドメイン例外の扱いは **Handler で共通化** し、Controller で try-catch を書かない（後述の「例外処理」を参照）。

---

## 例外処理

- **`app/Exceptions/Handler.php` で共通化する**。ドメイン例外（例: `PostLimitExceededException`）を HTTP 例外やレスポンスに変換する処理は、Handler の `register()` や `render()` にまとめる。
- **Controller で try-catch を書きまくらない**。各アクションごとに `try { ... } catch (SomeException $e) { ... }` を繰り返さず、例外と HTTP ステータス・メッセージの対応を Handler に一括で定義する。Controller は UseCase を呼び出して結果を返すだけに留める。
- **DB やシステム由来の例外は、そのメッセージをそのままクライアントに返さない**。Handler では「サーバーエラーが発生しました」などの**定型文**を返し、実メッセージはログにだけ出力する。クライアントには定型文だけ返す仕組みにすると、情報漏れと表示のばらつきを防げる。

---

## Form Request

- フォーマットバリデーションと認可（必要なら）を行う。認可はフォーマットバリデーションより前に実行する。
- **作成処理と更新処理で Form Request を共通化しない**。コピペで分けておく（後から条件分岐で可読性が下がるのを防ぐ）。
- フォームリクエストにロジックを書きすぎない。受け渡しを補助する程度に留める。

---

## Policy

認可処理を切り出す場合に利用する。典型的な権限判定はポリシーに寄せる。認可とドメインバリデーションの境界はケースバイケースなので、チームで議論して決める。

---

## API Resource

レスポンス整形に使用する。**`parent::toArray()` は使わず、属性をすべて列挙する**。API 仕様がひと目で分かるようにする。

---

## Local scope と Builder

- **少ない・単純な条件**は **local scope**（`scopeXxx`）で Model に書いてよい。UseCase や Controller からは `Post::query()->published()->forUser($user)` のようにチェーンして使う。
- **スコープが増えて Model が肥大化してきたら**、クエリ条件の組み立てを **カスタム Builder** に移す。Model で `newEloquentBuilder()` をオーバーライドし、専用の Builder クラスを返す。Model はリレーションと属性に集中し、クエリの組み立ては Builder に寄せる。
- どちらの場合も、複雑なロジックや複数テーブルにまたがる条件は UseCase に書いてもよい（Eloquent のスコープ・Builder は「よく使う条件」の再利用用と割り切る）。

---

## Enums

- **PHP 8.1 の enum** を使う。ステータス・種別・権限など、**取りうる値が決まっているもの**は enum で定義する。
- **置き場所**: `app/Enums/`。例: `PostStatus.php`, `UserRole.php`。ドメインごとにサブディレクトリを切ってもよい（`Enums/Post/Status.php` など）。
- **Model**: カラムを enum にキャストする。`protected $casts = ['status' => PostStatus::class];`（Laravel 9+）。DB には string/int で保存し、取得時に enum になる。
- **Form Request**: バリデーションで `Rule::enum(PostStatus::class)` や `in:enum(PostStatus::class)` を使い、入力値を enum に縛る。
- **命名**: PascalCase、意味が分かる名前。`PostStatus`, `UserRole`。case 名は UPPER_SNAKE または PascalCase（Laravel 慣習に合わせる）。
- UseCase や Controller では enum をそのまま引数・戻り値に使ってよい。比較は `$model->status === PostStatus::Published` のようにする。
- **Enum に振る舞い（メソッド）を持たせてよい**。その場合 `$model->status->canAccess()` のように書ける。判定ロジックを enum に集約すると呼び出し側が読みやすくなる。例: `PostStatus::Published->label()`、`$model->status->canEdit()`。

---

## テスト

**TDD を基本とする。** 新規・変更時はまずテストを追加・更新し、その後に実装する。

**どこに何を書くか**

| 対象           | 置き場所                                          | 方針                                                                                                                              |
| -------------- | ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **UseCase**    | `tests/Unit/UseCases/{ドメイン}/{Action}Test.php` | **中心に書く**。ドメインロジック・例外・DB 副作用を `RefreshDatabase` で検証。                                                    |
| **Model**      | `tests/Unit/Models/{Model}Test.php`               | リレーション・スコープ・アクセサなど、Model にロジックがある場合だけ。単純な CRUD は UseCase テストに含まれるので必須ではない。   |
| **Controller** | 単体テストは書かない                              | 薄いので不要。**Feature**（`tests/Feature/`）で HTTP リクエストから叩き、ルート〜Controller〜UseCase のつながりを確認すれば十分。 |

**Model のテスト + UseCase のテストで十分。** Controller は Feature でカバーし、Controller 専用のユニットテストは書かない。

- ユニットテストは DB をモックせず、**機能テスト**（`RefreshDatabase`）で書く。UseCase が Eloquent に依存する前提でよい。
- データベース以外（外部 API、イベントのディスパッチなど）はモックする。
- クエリスナップショットテスト（`DB::enableQueryLog()`）が UseCase の安全性確認に有用。

---

## 命名規則

| 対象             | 規則                                             | 例                                                            |
| ---------------- | ------------------------------------------------ | ------------------------------------------------------------- |
| **Model クラス** | 単数形・PascalCase                               | `User`, `PostComment`                                         |
| **テーブル**     | 複数形・snake_case                               | `users`, `post_comments`                                      |
| **カラム**       | snake_case                                       | `created_at`, `user_id`                                       |
| **UseCase**      | `{アクション}Action`                             | `StoreAction`, `UpdateAction`, `DestroyAction`                |
| **Form Request** | `{アクション}Request`。ディレクトリはドメイン    | `Post/StoreRequest.php`, `Post/UpdateRequest.php`             |
| **Controller**   | `{リソース}Controller`。メソッドは resource 慣習 | `PostController::store`, `index`, `show`, `update`, `destroy` |
| **Policy**       | `{Model}Policy`                                  | `PostPolicy`                                                  |
| **Resource**     | `{Model}Resource`                                | `PostResource`                                                |
| **ドメイン例外** | 意味が分かる名前 + `Exception`                   | `PostLimitExceededException`                                  |
| **local scope**  | `scopeXxx`。呼び出しは `xxx()`                   | `scopePublished()` → `Post::published()`                      |
| **Enum**         | 意味が分かる名前。`app/Enums/` に配置            | `PostStatus`, `UserRole`                                      |

- 変数・メソッド・プロパティは **camelCase**。PSR-12 に従う。
- ルート名・URL は Laravel の resource 慣習（複数形・kebab-case など）に合わせる。

---

## Laravel の仕組みに乗る

**基本は Laravel の標準機能・公式・定番パッケージに合わせて実装する**。通知や決済に限らず、フレームワークが用意している導線があればそれに乗り、独自に作り込まない。カスタムが必要なときは Laravel の拡張ポイントの範囲で行う。

例（いずれも Laravel の仕組みを優先する）:

| 用途       | Laravel 側の仕組み                                                                                                                                                      |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **通知**   | [Notifications](https://laravel.com/docs/notifications)（メール・DB・Slack など）                                                                                       |
| **決済**   | [Laravel Cashier](https://laravel.com/docs/billing)（Stripe / Paddle）など                                                                                              |
| **認証**   | [Sanctum](https://laravel.com/docs/sanctum) / [Breeze](https://laravel.com/docs/starter-kits) / [Fortify](https://laravel.com/docs/fortify)。API・SPA は Sanctum を優先 |
| **その他** | イベント（Event / Listener）、キュー（Queue）、ストレージ（Storage）、スケジュール（Scheduler）なども Laravel 標準を優先                                                |

必要に応じて公式ドキュメントを参照する。

---

## その他

- **PSR-12** に従う。詳細は [PSR-12](https://www.php-fig.org/psr/psr-12/) を参照。
- 型チェック・Linter（**PHPStan** / **Laravel Pint**）を導入し、規約違反を検出しやすくする。

---

## 参考リンク

- [なんちゃってクリーンアーキテクチャ（Zenn）](https://zenn.dev/yumemi_inc/articles/ce7d09eb6d8117)
- [Laravel 公式ドキュメント](https://laravel.com/docs)
- [PSR-12](https://www.php-fig.org/psr/psr-12/)
