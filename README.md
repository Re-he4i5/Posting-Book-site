# Booker1の作成

## 環境構築

```
gem install rails -v 5.2.5
```

## アプリケーションに必要なファイルの準備

rails new アプリケーション名で雛形作成．

rails g model モデル名　でモデル作成．

rails db:migrateでデータベースに反映させる．

homes,booksコントローラの作成

ターミナル

```ruby
rails new Booker
cd Booker
rails g model Book title:string body:text
rails db:migrate
rails g controller homes
rails g controller books
```

### Viewファイルの作成

Booker/app/views/コントローラ名　下に表示させる必要のあるページを作成

homes/top

books/edit,show,index

## ファイルの設定

### ルーティングの作成

トップ画面を「/」（例:https://...amazonaws.com/ ）で表示できるようにする．一番上の階層のことをルートディレクトリという．
各種ルートパスの設定

```ruby:routes.rb
root 'homes#top'
resources :books
```

## ファイルの記述・CRUDの実装

### topページのレイアウト作成

基本的にはディベロッパーツールをコピペ

最後のlink_toだけ修正する．

```ruby:top.html.erb
<h1>ようこそ <strong>Bookers</strong>  へ！</h1>
<p><strong>Bookers</strong>  では、さまざまな書籍に関するあなたの意見や</p><p>印象を共有し交換することができます</p>
<p><%= link_to "start", books_path %></p>
```

### indexページのレイアウト作成

```ruby:index.html.erb
<h1>Books</h1>

<table>
  <thead>
    <tr>
      <th>Title</th>
      <th>Body</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
  
  </tbody>
</table>


<h2>New book</h2>
```

### Bookの新規登録機能の作成1

```ruby:index.html.erb
<%= form_with model:@book, local:true do |f| %>
<div class="field">
    <%= f.label :title %>
    <%= f.text_field :title %>
  </div>

  <div class="field">
    <%= f.label :body %>
    <%= f.text_area :body %>
  </div>

  <div class="actions">
    <%= f.submit %>
<% end %>
```

```ruby:books_controller.rb
  def index
    @book = Book.new
  end
```

### Bookの新規登録機能の作成2

```ruby:books_controller.rb
  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:notice] = "Book was successfully created."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      render :index
    end
  end
  
 private

 def book_params
   params.require(:book).permit(:title, :body)
 end
```

```ruby:index.html.erb
<% @books.each do |book| %>
      <tr>
        <td><%= book.title %></td>
        <td><%= book.body %></td>
        <td><%= link_to 'Show', book, class: "show_#{book.id}" %></td>
      </tr>
<% end %>
```

### bookのindexページの作成

```ruby:books_controller.rb
  def index
    @books = Book.all
    @book = Book.new
  end
```

```ruby:index.html.erb
    <% @books.each do |book| %>
        <td><%= book.title %></td>
        <td><%= book.body %></td>
        <td><%= link_to 'Show', book, class: "show_#{book.id}" %></td>
        <td><%= link_to 'Edit', edit_book_path(book), class: "edit_#{book.id}" %></td>
        <td><%= link_to 'Destroy', book, method: :delete, data: { confirm: 'Are you sure?' }, class: "destroy_#{book.id}" %></td>
    <% end %>
```

### Bookのshowページ作成

```ruby:books_controller.rb
def show
   @book = Book.find(params[:id])
end
```

```
<p><strong>Title: </strong><%= @book.title %></p>
<p><strong>Body: </strong><%= @book.body %></p>

<%= link_to 'Edit', edit_book_path(@book), class: "edit_#{@book.id}" %> |
<%= link_to 'Back', books_path, class: "back" %>
```

### Bookのeditページの作成

```
<h1>Editing Book</h1>

<%= render 'form', book: @book %>
<%= link_to 'Show', @book, class: "show_#{@book.id}" %> |
<%= link_to 'Back', books_path, class: "back" %>
```

```ruby:books_controller.rb
  def edit
    @book = Book.find(params[:id])
  end
```

### Bookのupdate機能の作成

```ruby:books_controller.rb
 def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end
```

### Bookのdestroy機能の作成

```ruby:books_controller.rb
  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end
```
## フラッシュメッセージの実装

### createが成功した時

```ruby:books_controller.rb
flash[:notice] = "Book was successfully created."
```

### updateが成功した時

```ruby:books_controller.rb
flash[:notice] = "Book was successfully updated."
```

## バリデーションの設定

### createが失敗した時

```ruby:book.rb
  validates :title, presence: true
  validates :body, presence: true
```

### updateが失敗した時

## RSpecのテスト

### RSpecのテストファイル準備

カリキュラムからテストファイルspecをダウンロード，解凍

Gemfileの以下の指定箇所に追加

```
group :test do
  gem 'capybara', '>= 2.15'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end
```

ターミナルgemfileの読み込み

```
bundle install
```

config/environmentsフォルダのtest.rbファイルを開き、最後の方に以下を編集

＝の右側にある、:stderrを:silenceに変更．

```
config.active_support.deprecation = :silence
```

テスト用のデータベースを作成する

```
rails db:migrate RAILS_ENV=test
```

### RSpecのテスト実施

```
bundle exec rspec spec/ --format documentation
```
