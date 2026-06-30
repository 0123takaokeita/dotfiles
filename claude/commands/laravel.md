# Laravel 実装ガイドライン

Laravelでコードを実装・レビュー・リファクタリングするときは、以下のルールに従ってください。

---

## Controller は薄く保つ

Controller の責務は以下の3つのみとする。それ以外のロジックは Service に委譲すること。

```php
public function index(ReviewFilterRequest $request, string $slug): ReviewCollection
{
    // ① FormRequest でバリデーション（自動）
    // ② Service を呼ぶ
    $result = $this->reviewService->paginate($slug, $request->validated());
    // ③ Resource を返す
    return new ReviewCollection($result);
}
```

- クエリの構築・ビジネスロジック・計算処理を Controller に書かない
- `$request->validate([...])` は使わず FormRequest を使う
- `response()->json([...])` は使わず Resource を返す
- コンストラクタインジェクションで Service を受け取る

---

## FormRequest を使う

バリデーションは必ず `FormRequest` クラスに切り出す。

```php
// app/Http/Requests/ReviewFilterRequest.php
class ReviewFilterRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'page'      => ['nullable', 'integer', 'min:1'],
            'per_page'  => ['nullable', 'integer', 'min:1', 'max:100'],
            'site_id'   => ['nullable', 'integer', 'min:1'],
            'date_from' => ['nullable', 'date'],
            'date_to'   => ['nullable', 'date'],
            'sentiment' => ['nullable', 'in:positive,negative,mixed,neutral'],
        ];
    }
}
```

- 命名規則: `{対象}{操作}Request`（例: `ReviewFilterRequest`, `AuthLoginRequest`）
- Controller のメソッド引数の型を `Request` から `XxxRequest` に変える

---

## Resource を返す

モデルや配列を直接 JSON にせず、必ず Resource クラスで整形する。

```php
// 単体
return new HotelResource($hotel);

// コレクション
return HotelResource::collection($hotels);

// ページネーション付きコレクション（ResourceCollection を継承したクラスを作る）
return new ReviewCollection($paginator);
```

- 命名規則: `{モデル名}Resource`, `{モデル名}Collection`
- ページネーションのメタ構造はLaravelデフォルトに従う（`paginationInformation` は原則オーバーライドしない）

---

## Service にロジックを書く

ビジネスロジック・クエリ構築・計算処理はすべて Service クラスに集約する。

```
app/Services/
  AuthService.php          ← 認証
  ReviewService.php        ← レビュー一覧・検索
  ReviewStatsService.php   ← 統計集計
  HotelService.php         ← ホテル取得
```

- Controller との対応を1対1に近づける
- Service のメソッドは単一責務。1つのメソッドが1つのユースケースを担う
- `firstOrFail()` を使い、ホテル等の存在チェックは Service 内で完結させる
- 404 は `ModelNotFoundException`（`firstOrFail` が自動スロー）、認証失敗は `HttpException` 継承の独自例外でハンドリングする

---

## Model の Local Scope を活用する

Controller や Service に直接 `where` を並べず、Model に Scope として定義して再利用する。

```php
// app/Models/Review.php
public function scopeForHotel(Builder $query, int $hotelId): Builder
{
    return $query->where('hotel_id', $hotelId);
}

public function scopeBySentiment(Builder $query, ?string $sentiment): Builder
{
    if ($sentiment === null) return $query;
    if ($sentiment === 'positive') return $query->whereIn('sentiment', ['positive', 'mixed']);
    if ($sentiment === 'negative') return $query->whereIn('sentiment', ['negative', 'mixed']);
    return $query->where('sentiment', $sentiment);
}
```

- nullable な引数を受け取るスコープは null のとき条件を付与しない設計にする（メソッドチェーンで繋ぎやすくするため）
- 命名規則: `scope{条件名}` → 呼び出しは `->forHotel($id)->bySentiment($s)`

---

## PHPDoc コメントを日本語で書く

新しく作成・変更したクラス・メソッドには必ず日本語の PHPDoc を付ける。

```php
/**
 * 指定ホテルのレビューをフィルタ条件でページングして返す。
 *
 * @param  string $slug    ホテルスラッグ
 * @param  array  $filters バリデーション済みの検索条件（site_id / date_from / date_to / sentiment / per_page）
 * @return LengthAwarePaginator
 *
 * @throws \Illuminate\Database\Eloquent\ModelNotFoundException ホテルが存在しない場合
 */
public function paginate(string $slug, array $filters): LengthAwarePaginator
```

- クラスコメント: そのクラスの責務を1行で説明
- メソッドコメント: 挙動・引数・戻り値・throws を記述
- 仕様上の特記事項（例: mixed を positive/negative 双方にカウントするKPI仕様）はコメントに明記する

---

## ディレクトリ構成の原則

```
app/
├── Exceptions/          独自例外（HttpException 継承で HTTP ステータスを付与）
├── Http/
│   ├── Controllers/Api/ Controller（薄く）
│   ├── Requests/        FormRequest
│   └── Resources/       JsonResource / ResourceCollection
├── Models/              Eloquent モデル + Local Scope
└── Services/            ビジネスロジック
```
